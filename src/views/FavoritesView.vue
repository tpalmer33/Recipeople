<template>
  <div class="page-container">
    <div class="mb-5">
      <h1 class="text-2xl font-bold text-gray-900">Favorites</h1>
      <p class="text-gray-500 text-sm mt-0.5">Your saved recipes, all in one place</p>
    </div>

    <!-- Loading -->
    <div v-if="favStore.loading" class="space-y-4">
      <div v-for="i in 3" :key="i" class="card animate-pulse">
        <div class="h-36 bg-gray-200 rounded-t-2xl" />
        <div class="p-4 space-y-2">
          <div class="h-4 bg-gray-200 rounded w-3/4" />
          <div class="h-3 bg-gray-100 rounded w-1/2" />
        </div>
      </div>
    </div>

    <!-- Empty state -->
    <div v-else-if="favStore.favorites.length === 0" class="text-center py-16">
      <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-red-50 flex items-center justify-center">
        <svg class="w-8 h-8 text-red-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
        </svg>
      </div>
      <h3 class="font-bold text-gray-700 text-xl">No favorites yet</h3>
      <p class="text-gray-400 text-sm mt-2 mb-5">
        Tap the heart icon on any recipe to save it here
      </p>
      <RouterLink to="/search" class="btn-primary inline-flex">Browse Recipes</RouterLink>
    </div>

    <!-- Favorites list -->
    <div v-else class="space-y-4">
      <p class="text-xs text-gray-400 font-medium">{{ favStore.favorites.length }} saved recipe{{ favStore.favorites.length !== 1 ? 's' : '' }}</p>
      <RecipeCard
        v-for="recipe in favStore.favorites"
        :key="recipe.recipe_id"
        :recipe="recipe"
        show-favorite
      />
    </div>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import { useFavoritesStore } from '@/stores/favorites'
import RecipeCard from '@/components/recipe/RecipeCard.vue'

const favStore = useFavoritesStore()

onMounted(() => favStore.fetchFavorites())
</script>
