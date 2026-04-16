<template>
  <div class="page-container">
    <!-- Header -->
    <div class="mb-5">
      <h1 class="text-2xl font-bold text-gray-900">
        Hey, {{ auth.profile?.fname ?? 'Chef' }}
      </h1>
      <p class="text-gray-500 text-sm mt-0.5">
        {{ pantry.pantryItems.length > 0 ? 'Here\'s what you can make with your pantry' : 'Browse recipes and add pantry items to get personalized matches' }}
      </p>
    </div>

    <!-- Pantry summary chip -->
    <RouterLink
      to="/pantry"
      class="flex items-center gap-3 bg-brand-50 border border-brand-100 rounded-2xl px-4 py-3 mb-5 hover:bg-brand-100 transition-colors"
    >
      <svg class="w-5 h-5 text-brand-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
      </svg>
      <div class="flex-1 min-w-0">
        <p class="text-sm font-semibold text-brand-700">Your Pantry</p>
        <p class="text-xs text-brand-500 truncate">{{ pantryCountText }}</p>
      </div>
      <svg class="w-4 h-4 text-brand-400 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
      </svg>
    </RouterLink>

    <!-- Empty pantry nudge (non-blocking) -->
    <div v-if="!pantry.loading && pantry.pantryItems.length === 0" class="rounded-2xl bg-amber-50 border border-amber-100 px-4 py-3 mb-5 text-sm text-amber-800">
      Add ingredients to your pantry and we’ll sort recipes by how many you already have.
    </div>

    <!-- Loading skeleton -->
    <div v-if="recipes.loading" class="space-y-4">
      <div v-for="i in 3" :key="i" class="card animate-pulse">
        <div class="h-36 bg-gray-200 rounded-t-2xl" />
        <div class="p-4 space-y-2">
          <div class="h-4 bg-gray-200 rounded w-3/4" />
          <div class="h-3 bg-gray-100 rounded w-full" />
          <div class="h-3 bg-gray-100 rounded w-1/2" />
        </div>
      </div>
    </div>

    <!-- Error state -->
    <div v-else-if="recipes.error" class="text-center py-12">
      <div class="w-14 h-14 mx-auto mb-3 rounded-full bg-red-50 flex items-center justify-center">
        <svg class="w-7 h-7 text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
        </svg>
      </div>
      <p class="text-gray-500 text-sm">{{ recipes.error }}</p>
      <button @click="loadFeed" class="btn-secondary mt-3 text-sm">Try again</button>
    </div>

    <!-- No recipes found -->
    <div v-else-if="recipes.feedRecipes.length === 0" class="text-center py-12">
      <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-gray-100 flex items-center justify-center">
        <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
        </svg>
      </div>
      <h3 class="font-bold text-gray-700 text-lg">No recipes yet</h3>
      <p class="text-gray-400 text-sm mt-1 mb-4">Be the first to create one!</p>
      <RouterLink to="/create" class="btn-primary inline-flex">Create a Recipe</RouterLink>
    </div>

    <!-- Recipe list -->
    <div v-else class="space-y-4">
      <template v-for="section in sections" :key="section.label">
        <div v-if="section.items.length > 0">
          <div class="flex items-center gap-2 mb-3">
            <span class="w-2.5 h-2.5 rounded-full flex-shrink-0" :class="section.dotColor"></span>
            <h2 class="text-sm font-bold text-gray-600 uppercase tracking-wide">{{ section.label }}</h2>
            <span class="badge bg-gray-100 text-gray-500">{{ section.items.length }}</span>
          </div>
          <div class="space-y-4">
            <RecipeCard
              v-for="recipe in section.items"
              :key="recipe.recipe_id"
              :recipe="recipe"
              show-favorite
            />
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { usePantryStore } from '@/stores/pantry'
import { useRecipesStore } from '@/stores/recipes'
import { useFavoritesStore } from '@/stores/favorites'
import RecipeCard from '@/components/recipe/RecipeCard.vue'

const auth     = useAuthStore()
const pantry   = usePantryStore()
const recipes  = useRecipesStore()
const favStore = useFavoritesStore()

const pantryCountText = computed(() => {
  const n = pantry.pantryItems.length
  if (n === 0) return 'No ingredients added yet'
  return `${n} ingredient${n !== 1 ? 's' : ''} tracked`
})

const sections = computed(() => [
  {
    label: 'Perfect match',
    dotColor: 'bg-green-400',
    items: recipes.feedRecipes.filter(r => r.matchPct >= 80)
  },
  {
    label: 'Good match',
    dotColor: 'bg-amber-400',
    items: recipes.feedRecipes.filter(r => r.matchPct >= 50 && r.matchPct < 80)
  },
  {
    label: 'Partial match',
    dotColor: 'bg-orange-300',
    items: recipes.feedRecipes.filter(r => r.matchPct > 0 && r.matchPct < 50)
  },
  {
    label: 'Missing ingredients',
    dotColor: 'bg-gray-300',
    items: recipes.feedRecipes.filter(r => r.matchPct === 0)
  }
])

async function loadFeed() {
  await pantry.fetchPantry()
  const ids = pantry.pantryItems.map(i => i.ingredient_id)
  await recipes.fetchFeedRecipes(ids)
}

onMounted(async () => {
  await loadFeed()
  await favStore.fetchFavorites()
})
</script>
