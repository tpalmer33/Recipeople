<template>
  <div class="page-container pb-28">
    <!-- Header banner -->
    <div class="relative overflow-hidden rounded-[32px] bg-gradient-to-br from-brand-700 via-brand-500 to-amber-300 p-6 text-white shadow-xl mb-5">
      <div class="absolute -right-8 -top-10 h-28 w-28 rounded-full bg-white/10 blur-2xl" />
      <div class="absolute -bottom-12 left-12 h-32 w-32 rounded-full bg-amber-100/20 blur-2xl" />
      <p class="text-xs uppercase tracking-[0.32em] text-white/70 mb-2">My Kitchen</p>
      <h1 class="text-3xl font-bold leading-tight">Recipes you've created.</h1>
      <p class="text-sm text-white/85 mt-2">Edit the details, swap the photo, or remove recipes you no longer want to share.</p>
    </div>

    <!-- Loading skeleton -->
    <div v-if="recipes.loading" class="space-y-3">
      <div v-for="i in 3" :key="i" class="card p-4 animate-pulse">
        <div class="flex gap-4">
          <div class="w-20 h-20 bg-gray-200 rounded-2xl flex-shrink-0" />
          <div class="flex-1 space-y-2 py-1">
            <div class="h-4 bg-gray-200 rounded w-3/4" />
            <div class="h-3 bg-gray-100 rounded w-1/2" />
            <div class="h-3 bg-gray-100 rounded w-2/3" />
          </div>
        </div>
      </div>
    </div>

    <!-- Error -->
    <div v-else-if="recipes.error" class="text-center pt-10">
      <p class="text-gray-500">{{ recipes.error }}</p>
      <button @click="load" class="btn-secondary mt-4">Retry</button>
    </div>

    <!-- Empty state -->
    <div v-else-if="recipes.userRecipes.length === 0" class="text-center pt-12">
      <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-brand-50 flex items-center justify-center">
        <svg class="w-8 h-8 text-brand-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 6v12M6 12h12"/>
        </svg>
      </div>
      <h2 class="text-lg font-bold text-gray-800">No recipes yet</h2>
      <p class="text-sm text-gray-500 mt-1 mb-5">Head to Create to share your first one.</p>
      <RouterLink to="/create" class="btn-primary inline-block">Create a recipe</RouterLink>
    </div>

    <!-- Recipe list -->
    <div v-else class="space-y-3">
      <div
        v-for="recipe in recipes.userRecipes"
        :key="recipe.recipe_id"
        class="card p-4"
      >
        <div class="flex gap-4">
          <!-- Thumbnail -->
          <div class="w-20 h-20 flex-shrink-0 rounded-2xl overflow-hidden bg-gradient-to-br from-brand-100 to-amber-50">
            <img
              v-if="getImageUrl(recipe)"
              :src="getImageUrl(recipe)"
              :alt="recipe.title"
              class="w-full h-full object-cover"
            />
            <div v-else class="w-full h-full flex items-center justify-center text-3xl">
              {{ mealIcon(recipe.meal_type) }}
            </div>
          </div>

          <!-- Info -->
          <div class="flex-1 min-w-0">
            <h3 class="font-bold text-gray-900 text-base leading-tight truncate">{{ recipe.title }}</h3>
            <div class="flex flex-wrap gap-1.5 mt-1.5">
              <span v-if="recipe.meal_type" class="badge bg-brand-50 text-brand-700">{{ recipe.meal_type }}</span>
              <span v-if="recipe.cuisine" class="badge bg-amber-50 text-amber-700">{{ recipe.cuisine }}</span>
              <span v-if="recipe.difficulty" :class="difficultyClass(recipe.difficulty)" class="badge">{{ recipe.difficulty }}</span>
            </div>
            <p class="text-xs text-gray-400 mt-1.5">
              <span v-if="recipe.avgRating">★ {{ recipe.avgRating }}</span>
              <span v-if="recipe.avgRating && (recipe.cook_time_minutes || recipe.prep_time_minutes)"> · </span>
              <span v-if="recipe.cook_time_minutes || recipe.prep_time_minutes">
                {{ (recipe.prep_time_minutes || 0) + (recipe.cook_time_minutes || 0) }} min
              </span>
            </p>
          </div>
        </div>

        <!-- Actions -->
        <div class="flex gap-2 mt-3 pt-3 border-t border-gray-100">
          <RouterLink
            :to="{ name: 'recipe-edit', params: { id: recipe.recipe_id } }"
            class="btn-secondary flex-1 text-center text-sm py-2"
          >
            Edit recipe
          </RouterLink>
          <button
            @click="confirmDelete(recipe)"
            class="flex-1 text-sm font-semibold py-2 rounded-xl border border-red-200 text-red-500 bg-red-50 hover:bg-red-100 transition-colors"
          >
            Delete
          </button>
        </div>
      </div>
    </div>

    <!-- Delete confirmation modal -->
    <AppModal v-model="showDeleteModal">
      <div class="p-6 space-y-4">
        <h3 class="text-lg font-bold text-gray-900">Delete recipe?</h3>
        <p class="text-sm text-gray-600">
          "<span class="font-semibold">{{ deleteTarget.title }}</span>" will be permanently removed. This cannot be undone.
        </p>
        <div class="flex gap-3">
          <button @click="showDeleteModal = false; deleteTarget = null" class="btn-secondary flex-1">Cancel</button>
          <button
            @click="onDelete"
            :disabled="deleting"
            class="flex-1 font-semibold py-2.5 rounded-xl bg-red-500 text-white hover:bg-red-600 disabled:opacity-50 transition-colors"
          >
            {{ deleting ? 'Deleting…' : 'Delete' }}
          </button>
        </div>
      </div>
    </AppModal>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import { useRecipesStore } from '@/stores/recipes'
import { getRecipeImageUrl } from '@/lib/recipeImages'
import AppModal from '@/components/ui/AppModal.vue'

const recipes = useRecipesStore()

const deleteTarget = ref(null)
const showDeleteModal = ref(false)
const deleting = ref(false)

function getImageUrl(recipe) {
  return getRecipeImageUrl(recipe)
}

function mealIcon(type) {
  const icons = {
    Breakfast: '🍳', Lunch: '🥗', Dinner: '🍽️',
    Dessert: '🍰', Beverage: '🥤', Soup: '🥣',
    Salad: '🥗', 'Side Dish': '🥦', Appetizer: '🥨',
    'Main Course': '🍽️', 'Appetizer/Starter': '🥨'
  }
  return icons[type] ?? '🍴'
}

function difficultyClass(d) {
  if (d === 'easy')   return 'bg-green-50 text-green-700'
  if (d === 'medium') return 'bg-amber-50 text-amber-700'
  if (d === 'hard')   return 'bg-red-50 text-red-600'
  return 'bg-gray-50 text-gray-600'
}

function confirmDelete(recipe) {
  deleteTarget.value = recipe
  showDeleteModal.value = true
}

async function onDelete() {
  if (!deleteTarget.value) return
  deleting.value = true
  try {
    await recipes.deleteRecipe(deleteTarget.value.recipe_id)
    deleteTarget.value = null
    showDeleteModal.value = false
  } finally {
    deleting.value = false
  }
}

async function load() {
  await recipes.fetchUserRecipes()
}

onMounted(load)
</script>
