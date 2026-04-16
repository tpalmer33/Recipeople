import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from './auth'

// USDA FoodData Central food-category → app ingredient category
const USDA_CATEGORY_MAP = {
  'Vegetables and Vegetable Products': 'Produce',
  'Fruits and Fruit Juices':           'Produce',
  'Poultry Products':                  'Protein',
  'Beef Products':                     'Protein',
  'Pork Products':                     'Protein',
  'Lamb, Veal, and Game Products':     'Protein',
  'Finfish and Shellfish Products':    'Protein',
  'Legumes and Legume Products':       'Protein',
  'Nut and Seed Products':             'Protein',
  'Dairy and Egg Products':            'Dairy',
  'Cereal Grains and Pasta':           'Grains',
  'Baked Products':                    'Grains',
  'Breakfast Cereals':                 'Grains',
  'Fats and Oils':                     'Pantry',
  'Beverages':                         'Pantry',
  'Sweets':                            'Pantry',
  'Soups, Sauces, and Gravies':        'Pantry',
  'Snacks':                            'Pantry',
  'Spices and Herbs':                  'Spices',
}

// Fetch category + kcal/100 g from USDA FoodData Central.
// Always resolves — returns nulls on any failure so the insert still succeeds.
async function fetchIngredientNutrition(name) {
  try {
    const apiKey = (typeof import.meta !== 'undefined' && import.meta.env?.VITE_USDA_API_KEY) || 'DEMO_KEY'
    const url =
      `https://api.nal.usda.gov/fdc/v1/foods/search` +
      `?query=${encodeURIComponent(name)}` +
      `&api_key=${encodeURIComponent(apiKey)}` +
      `&pageSize=1` +
      `&dataType=Foundation,SR%20Legacy`

    const res = await fetch(url)
    if (!res.ok) return { category: null, calories: null }

    const data = await res.json()
    const food = data.foods?.[0]
    if (!food) return { category: null, calories: null }

    const category = USDA_CATEGORY_MAP[food.foodCategory] ?? null

    // USDA nutrient ID 1008 = Energy (kcal per 100 g)
    const energyEntry = food.foodNutrients?.find(
      n => n.nutrientId === 1008 || n.nutrientName === 'Energy'
    )
    const calories = energyEntry?.value != null ? Math.round(energyEntry.value) : null

    return { category, calories }
  } catch {
    return { category: null, calories: null }
  }
}

const MEAL_TYPES = new Set([
  'Breakfast',
  'Lunch',
  'Dinner',
  'Appetizer/Starter',
  'Soup',
  'Salad',
  'Side Dish',
  'Main Course',
  'Dessert',
  'Beverage'
])

const CUISINES = new Set([
  'Italian',
  'Chinese',
  'Thai',
  'Indian',
  'French',
  'Japanese',
  'Mexican',
  'American',
  'Greek',
  'Mediterranean',
  'Spanish',
  'Korean',
  'Vietnamese',
  'Middle Eastern'
])

const UNITS = new Set([
  'g',
  'kg',
  'oz',
  'lb',
  'mL',
  'L',
  'tsp',
  'tbsp',
  'cup',
  'pt',
  'qt',
  'gal',
  'each',
  'bunch',
  'slice',
  'clove',
  'pinch'
])

function normalizeLookupText(value) {
  return value
    .toLowerCase()
    .replace(/[^a-z0-9]/g, '')
}

function levenshteinDistance(a, b) {
  const rows = a.length + 1
  const cols = b.length + 1
  const dp = Array.from({ length: rows }, () => Array(cols).fill(0))

  for (let i = 0; i < rows; i += 1) dp[i][0] = i
  for (let j = 0; j < cols; j += 1) dp[0][j] = j

  for (let i = 1; i < rows; i += 1) {
    for (let j = 1; j < cols; j += 1) {
      const cost = a[i - 1] === b[j - 1] ? 0 : 1
      dp[i][j] = Math.min(
        dp[i - 1][j] + 1,
        dp[i][j - 1] + 1,
        dp[i - 1][j - 1] + cost
      )
    }
  }

  return dp[a.length][b.length]
}

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
          cook_time_minutes, prep_time_minutes, difficulty, servings, thumbnail,
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
          cook_time_minutes, prep_time_minutes, difficulty, servings, thumbnail,
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

  function normalizeIngredientName(name) {
    return name
      .trim()
      .replace(/\s+/g, ' ')
      .split(' ')
      .map(part => part.charAt(0).toUpperCase() + part.slice(1).toLowerCase())
      .join(' ')
  }

  async function fetchIngredientDirectory() {
    const { data, error: fetchError } = await supabase
      .from('ingredients')
      .select('ingredient_id, name, category, calories')
      .order('name')
      .limit(500)

    if (fetchError) throw fetchError
    return data ?? []
  }

  async function searchIngredientSuggestions(query) {
    const trimmed = query?.trim()
    if (!trimmed || trimmed.length < 2) return []

    const { data, error: searchError } = await supabase
      .from('ingredients')
      .select('ingredient_id, name, category, calories')
      .ilike('name', `%${trimmed}%`)
      .order('name')
      .limit(8)

    if (searchError) throw searchError
    if (data?.length) return data

    const lookup = normalizeLookupText(trimmed)
    const directory = await fetchIngredientDirectory()

    return directory
      .map(item => {
        const normalized = normalizeLookupText(item.name)
        const distance = levenshteinDistance(lookup, normalized)
        const startsClose = normalized.startsWith(lookup.slice(0, Math.max(1, lookup.length - 1)))
        return { ...item, distance, startsClose }
      })
      .filter(item => item.distance <= 2 || item.startsClose)
      .sort((a, b) => a.distance - b.distance || a.name.localeCompare(b.name))
      .slice(0, 8)
      .map(({ distance, startsClose, ...item }) => item)
  }

  async function resolveIngredientMatch(name) {
    const normalizedName = normalizeIngredientName(name)

    const { data: exact, error: exactError } = await supabase
      .from('ingredients')
      .select('ingredient_id, name, category, calories')
      .ilike('name', normalizedName)
      .limit(1)

    if (exactError) throw exactError
    if (exact?.[0]) return { ingredient: exact[0], inferred: exact[0].name !== normalizedName }

    const directory = await fetchIngredientDirectory()
    const lookup = normalizeLookupText(normalizedName)

    let bestMatch = null
    for (const item of directory) {
      const candidate = normalizeLookupText(item.name)
      const distance = levenshteinDistance(lookup, candidate)

      // Only auto-correct typos: the normalized strings must differ by at most 1 character
      // (a single insertion, deletion, or substitution). This prevents "Garlic Paste" → "Garlic".
      if (distance > 1) continue

      if (!bestMatch || distance < bestMatch.distance) {
        bestMatch = { ingredient: item, distance }
      }
    }

    if (!bestMatch) return { ingredient: null, inferred: false }
    return { ingredient: bestMatch.ingredient, inferred: true }
  }

  async function ensureIngredient(name) {
    const normalized = normalizeIngredientName(name)
    const { ingredient: existing } = await resolveIngredientMatch(normalized)
    if (existing) return existing

    const { category, calories } = await fetchIngredientNutrition(normalized)

    const row = { name: normalized }
    if (category  != null) row.category = category
    if (calories  != null) row.calories = calories

    const { data: inserted, error: insertError } = await supabase
      .from('ingredients')
      .insert(row)
      .select('ingredient_id, name, category, calories')
      .single()

    if (insertError) throw insertError
    return inserted
  }

  async function uploadRecipeThumbnail(recipeId, file) {
    const ext = file.name.split('.').pop()
    const path = `thumbnails/${recipeId}.${ext}`

    const { error: uploadError } = await supabase.storage
      .from('thumbnails')
      .upload(path, file, { upsert: true })

    if (uploadError) {
      // eslint-disable-next-line no-console
      console.error('Thumbnail upload error:', uploadError)
      throw uploadError
    }

    const { data: urlData } = supabase.storage.from('thumbnails').getPublicUrl(path)
    return urlData.publicUrl
  }

  async function createRecipe(payload) {
    const auth = useAuthStore()
    if (!auth.user) throw new Error('You must be logged in to create a recipe.')
    if (!MEAL_TYPES.has(payload.meal_type)) throw new Error('Invalid meal type.')
    if (payload.cuisine && !CUISINES.has(payload.cuisine)) throw new Error('Invalid cuisine.')
    if (payload.ingredients.some(item => item.unit && !UNITS.has(item.unit))) {
      throw new Error('Invalid ingredient unit.')
    }

    loading.value = true
    error.value = null

    try {
      const recipeInsert = {
        title: payload.title.trim(),
        description: payload.description?.trim() || null,
        meal_type: payload.meal_type || null,
        cuisine: payload.cuisine?.trim() || null,
        cook_time_minutes: payload.cook_time_minutes || null,
        prep_time_minutes: payload.prep_time_minutes || null,
        difficulty: payload.difficulty || null,
        servings: payload.servings || null,
        instructions: {
          instructions: payload.instructions.map((step, index) => ({
            step: index + 1,
            instruction: step.instruction.trim(),
            ingredients: step.ingredients?.length
              ? step.ingredients.map(name => ({ name: normalizeIngredientName(name) }))
              : undefined
          }))
        }
      }

      const { data: recipe, error: recipeError } = await supabase
        .from('recipes')
        .insert(recipeInsert)
        .select('recipe_id')
        .single()

      if (recipeError) throw recipeError

      const unresolvedIngredientNames = payload.ingredients
        .filter(item => !item.ingredient_id)
        .map(item => item.name)

      const uniqueNames = [...new Set([
        ...unresolvedIngredientNames,
        ...payload.instructions.flatMap(step => step.ingredients ?? [])
      ]
        .filter(Boolean)
        .map(normalizeIngredientName)
      )]

      const ingredientRows = await Promise.all(uniqueNames.map(ensureIngredient))
      const ingredientMap = new Map(ingredientRows.map(item => [item.name, item.ingredient_id]))

      // Insert recipe_user FIRST so the RLS policy on recipe_ingredient
      // can find the ownership row when it runs its sub-select.
      const { error: ownerError } = await supabase
        .from('recipe_user')
        .insert({
          user_id: auth.user.id,
          recipe_id: recipe.recipe_id,
          created_or_saved: 'C'
        })

      if (ownerError) throw ownerError

      const recipeIngredients = payload.ingredients.map(item => ({
        recipe_id: recipe.recipe_id,
        ingredient_id: item.ingredient_id ?? ingredientMap.get(normalizeIngredientName(item.name)),
        quantity: item.quantity === '' || item.quantity == null ? null : Number(item.quantity),
        unit: item.unit?.trim() || null
      }))

      const { error: joinError } = await supabase
        .from('recipe_ingredient')
        .insert(recipeIngredients)

      if (joinError) throw joinError

      if (payload.thumbnail) {
        const thumbnailUrl = await uploadRecipeThumbnail(recipe.recipe_id, payload.thumbnail)
        const { error: thumbUpdateError } = await supabase
          .from('recipes')
          .upsert({ recipe_id: recipe.recipe_id, thumbnail: thumbnailUrl })
        if (thumbUpdateError) throw thumbUpdateError
      }

      return recipe.recipe_id
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  const userRecipes = ref([])

  async function fetchUserRecipes() {
    const auth = useAuthStore()
    if (!auth.user) return

    loading.value = true
    error.value = null

    try {
      const { data, error: err } = await supabase
        .from('recipe_user')
        .select(`
          recipes (
            recipe_id, title, description, meal_type, cuisine,
            cook_time_minutes, prep_time_minutes, difficulty, servings, thumbnail,
            recipe_rating (rating)
          )
        `)
        .eq('user_id', auth.user.id)
        .eq('created_or_saved', 'C')

      if (err) throw err

      userRecipes.value = (data ?? [])
        .map(row => row.recipes)
        .filter(Boolean)
        .map(recipe => {
          const avgRating = recipe.recipe_rating?.length > 0
            ? recipe.recipe_rating.reduce((sum, r) => sum + r.rating, 0) / recipe.recipe_rating.length
            : null
          return {
            ...recipe,
            recipe_rating: undefined,
            avgRating: avgRating ? parseFloat(avgRating.toFixed(1)) : null,
            ratingCount: recipe.recipe_rating?.length ?? 0
          }
        })
    } catch (err) {
      error.value = err.message
    } finally {
      loading.value = false
    }
  }

  async function updateRecipe(recipeId, payload) {
    loading.value = true
    error.value = null

    try {
      const updateData = {
        title: payload.title?.trim(),
        description: payload.description?.trim() || null,
        meal_type: payload.meal_type || null,
        cuisine: payload.cuisine?.trim() || null,
        cook_time_minutes: payload.cook_time_minutes || null,
        prep_time_minutes: payload.prep_time_minutes || null,
        difficulty: payload.difficulty || null,
        servings: payload.servings || null
      }

      if (payload.thumbnailFile) {
        const thumbnailUrl = await uploadRecipeThumbnail(recipeId, payload.thumbnailFile)
        updateData.thumbnail = thumbnailUrl
      }

      const { error: updateError } = await supabase
        .from('recipes')
        .update(updateData)
        .eq('recipe_id', recipeId)

      if (updateError) throw updateError
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  async function deleteRecipe(recipeId) {
    loading.value = true
    error.value = null

    try {
      const { error: deleteError } = await supabase
        .from('recipes')
        .delete()
        .eq('recipe_id', recipeId)

      if (deleteError) throw deleteError

      userRecipes.value = userRecipes.value.filter(r => r.recipe_id !== recipeId)
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    feedRecipes,
    searchResults,
    currentRecipe,
    userRecipes,
    loading,
    error,
    fetchFeedRecipes,
    searchRecipes,
    fetchRecipeById,
    rateRecipe,
    getUserRating,
    createRecipe,
    fetchUserRecipes,
    updateRecipe,
    deleteRecipe,
    searchIngredientSuggestions,
    resolveIngredientMatch,
    ensureIngredient
  }
})
