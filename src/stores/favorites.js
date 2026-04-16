import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from './auth'

export const useFavoritesStore = defineStore('favorites', () => {
  const favorites = ref([])   // Full recipe objects
  const favoriteIds = ref(new Set())
  const loading = ref(false)
  const error = ref(null)

  async function fetchFavorites() {
    const auth = useAuthStore()
    if (!auth.user) return
    loading.value = true
    error.value = null

    const { data, error: err } = await supabase
      .from('recipe_user')
      .select(`
        recipe_id, created_at,
        recipes (
          recipe_id, title, description, meal_type, cuisine,
          cook_time_minutes, prep_time_minutes, difficulty, servings, thumbnail,
          recipe_rating (rating)
        )
      `)
      .eq('user_id', auth.user.id)
      .eq('created_or_saved', 'S')
      .order('created_at', { ascending: false })

    if (err) {
      error.value = err.message
    } else {
      favorites.value = data.map(row => {
        const recipe = row.recipes
        const avgRating = recipe.recipe_rating.length > 0
          ? recipe.recipe_rating.reduce((sum, r) => sum + r.rating, 0) / recipe.recipe_rating.length
          : null
        return {
          ...recipe,
          recipe_rating: undefined,
          avgRating: avgRating ? parseFloat(avgRating.toFixed(1)) : null,
          ratingCount: recipe.recipe_rating.length,
          savedAt: row.created_at
        }
      })
      favoriteIds.value = new Set(favorites.value.map(r => r.recipe_id))
    }
    loading.value = false
  }

  async function addFavorite(recipeId) {
    const auth = useAuthStore()
    if (!auth.user) return
    const { error: err } = await supabase.from('recipe_user').insert({
      user_id: auth.user.id,
      recipe_id: recipeId,
      created_or_saved: 'S'
    })
    if (err) throw err
    favoriteIds.value = new Set([...favoriteIds.value, recipeId])
    await fetchFavorites()
  }

  async function removeFavorite(recipeId) {
    const auth = useAuthStore()
    if (!auth.user) return
    const { error: err } = await supabase
      .from('recipe_user')
      .delete()
      .eq('user_id', auth.user.id)
      .eq('recipe_id', recipeId)
      .eq('created_or_saved', 'S')
    if (err) throw err
    favoriteIds.value.delete(recipeId)
    favorites.value = favorites.value.filter(r => r.recipe_id !== recipeId)
  }

  async function toggleFavorite(recipeId) {
    if (favoriteIds.value.has(recipeId)) {
      await removeFavorite(recipeId)
    } else {
      await addFavorite(recipeId)
    }
  }

  function isFavorite(recipeId) {
    return favoriteIds.value.has(recipeId)
  }

  return {
    favorites,
    favoriteIds,
    loading,
    error,
    fetchFavorites,
    addFavorite,
    removeFavorite,
    toggleFavorite,
    isFavorite
  }
})
