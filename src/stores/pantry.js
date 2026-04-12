import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from './auth'

export const usePantryStore = defineStore('pantry', () => {
  const pantryItems = ref([])   // [{ ingredient_id, name, category, calories }]
  const loading = ref(false)
  const error = ref(null)

  async function fetchPantry() {
    const auth = useAuthStore()
    if (!auth.user) return
    loading.value = true
    error.value = null

    const { data, error: err } = await supabase
      .from('pantry')
      .select(`
        ingredient_id,
        ingredients (ingredient_id, name, category, calories)
      `)
      .eq('user_id', auth.user.id)
      .order('ingredients(name)')

    if (err) {
      error.value = err.message
    } else {
      pantryItems.value = data.map(row => row.ingredients)
    }
    loading.value = false
  }

  async function addIngredient(ingredientId) {
    const auth = useAuthStore()
    if (!auth.user) return
    const { error: err } = await supabase.from('pantry').insert({
      user_id: auth.user.id,
      ingredient_id: ingredientId
    })
    if (err) throw err
    await fetchPantry()
  }

  async function removeIngredient(ingredientId) {
    const auth = useAuthStore()
    if (!auth.user) return
    const { error: err } = await supabase
      .from('pantry')
      .delete()
      .eq('user_id', auth.user.id)
      .eq('ingredient_id', ingredientId)
    if (err) throw err
    pantryItems.value = pantryItems.value.filter(i => i.ingredient_id !== ingredientId)
  }

  async function searchIngredients(query) {
    if (!query || query.length < 2) return []
    const { data, error: err } = await supabase
      .from('ingredients')
      .select('ingredient_id, name, category, calories')
      .ilike('name', `%${query}%`)
      .order('name')
      .limit(20)
    if (err) throw err
    return data
  }

  function isPantryItem(ingredientId) {
    return pantryItems.value.some(i => i.ingredient_id === ingredientId)
  }

  return {
    pantryItems,
    loading,
    error,
    fetchPantry,
    addIngredient,
    removeIngredient,
    searchIngredients,
    isPantryItem
  }
})
