import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from './auth'

export const useRecipesStore = defineStore('recipes', () => {
  const feedRecipes = ref([])
  const searchResults = ref([])
  const currentRecipe = ref(null)
  const loading = ref(false)
  const error = ref(null)

  // Fetches recipes ordered by how many pantry ingredients they match
  async function fetchFeedRecipes(pantryIngredientIds) {
    loading.value = true
    error.value = null

    try {
      // Fetch all recipes with their ingredients and ratings
      const { data: recipes, error: recipeErr } = await supabase
        .from('recipes')
        .select(`
          recipe_id, title, description, meal_type, cuisine,
          cook_time_minutes, prep_time_minutes, difficulty, servings,
          recipe_ingredient (ingredient_id),
          recipe_rating (rating)
        `)

      if (recipeErr) throw recipeErr

      const pantrySet = new Set(pantryIngredientIds)

      feedRecipes.value = recipes
        .map(recipe => {
          const recipeIngredientIds = recipe.recipe_ingredient.map(ri => ri.ingredient_id)
          const matchCount = recipeIngredientIds.filter(id => pantrySet.has(id)).length
          const matchPct = recipeIngredientIds.length > 0
            ? Math.round((matchCount / recipeIngredientIds.length) * 100)
            : 0
          const avgRating = recipe.recipe_rating.length > 0
            ? recipe.recipe_rating.reduce((sum, r) => sum + r.rating, 0) / recipe.recipe_rating.length
            : null

          return {
            ...recipe,
            recipe_ingredient: undefined,
            recipe_rating: undefined,
            matchCount,
            matchPct,
            totalIngredients: recipeIngredientIds.length,
            avgRating: avgRating ? parseFloat(avgRating.toFixed(1)) : null,
            ratingCount: recipe.recipe_rating.length
          }
        })
        .sort((a, b) => b.matchCount - a.matchCount || b.matchPct - a.matchPct)
    } catch (err) {
      error.value = err.message
    } finally {
      loading.value = false
    }
  }

  // Search recipes by title/description, ordered by average rating
  async function searchRecipes(query, filters = {}) {
    loading.value = true
    error.value = null

    try {
      let queryBuilder = supabase
        .from('recipes')
        .select(`
          recipe_id, title, description, meal_type, cuisine,
          cook_time_minutes, prep_time_minutes, difficulty, servings,
          recipe_rating (rating)
        `)

      if (query && query.trim()) {
        queryBuilder = queryBuilder.or(
          `title.ilike.%${query.trim()}%,description.ilike.%${query.trim()}%`
        )
      }
      if (filters.meal_type) queryBuilder = queryBuilder.eq('meal_type', filters.meal_type)
      if (filters.cuisine)   queryBuilder = queryBuilder.eq('cuisine', filters.cuisine)
      if (filters.difficulty) queryBuilder = queryBuilder.eq('difficulty', filters.difficulty)
      if (filters.max_time)  queryBuilder = queryBuilder.lte('cook_time_minutes', filters.max_time)

      const { data, error: err } = await queryBuilder.limit(50)
      if (err) throw err

      searchResults.value = data
        .map(recipe => {
          const avgRating = recipe.recipe_rating.length > 0
            ? recipe.recipe_rating.reduce((sum, r) => sum + r.rating, 0) / recipe.recipe_rating.length
            : null
          return {
            ...recipe,
            recipe_rating: undefined,
            avgRating: avgRating ? parseFloat(avgRating.toFixed(1)) : null,
            ratingCount: recipe.recipe_rating.length
          }
        })
        .sort((a, b) => (b.avgRating ?? 0) - (a.avgRating ?? 0))
    } catch (err) {
      error.value = err.message
    } finally {
      loading.value = false
    }
  }

  async function fetchRecipeById(id) {
    loading.value = true
    error.value = null
    currentRecipe.value = null

    try {
      const { data, error: err } = await supabase
        .from('recipes')
        .select(`
          *,
          recipe_ingredient (
            quantity, unit,
            ingredients (ingredient_id, name, category)
          ),
          recipe_rating (rating, user_id)
        `)
        .eq('recipe_id', id)
        .single()

      if (err) throw err

      const avgRating = data.recipe_rating.length > 0
        ? data.recipe_rating.reduce((sum, r) => sum + r.rating, 0) / data.recipe_rating.length
        : null

      currentRecipe.value = {
        ...data,
        avgRating: avgRating ? parseFloat(avgRating.toFixed(1)) : null,
        ratingCount: data.recipe_rating.length
      }
    } catch (err) {
      error.value = err.message
    } finally {
      loading.value = false
    }
  }

  async function rateRecipe(recipeId, rating) {
    const auth = useAuthStore()
    if (!auth.user) return

    const { error: err } = await supabase
      .from('recipe_rating')
      .upsert({ user_id: auth.user.id, recipe_id: recipeId, rating }, { onConflict: 'user_id,recipe_id' })

    if (err) throw err

    // Refresh current recipe ratings if it's open
    if (currentRecipe.value?.recipe_id === recipeId) {
      await fetchRecipeById(recipeId)
    }
  }

  function getUserRating(recipeId) {
    const auth = useAuthStore()
    if (!auth.user || !currentRecipe.value) return null
    const ratingRow = currentRecipe.value.recipe_rating?.find(r => r.user_id === auth.user.id)
    return ratingRow?.rating ?? null
  }

  return {
    feedRecipes,
    searchResults,
    currentRecipe,
    loading,
    error,
    fetchFeedRecipes,
    searchRecipes,
    fetchRecipeById,
    rateRecipe,
    getUserRating
  }
})
