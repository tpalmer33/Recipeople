<template>
  <RouterLink :to="`/recipe/${recipe.recipe_id}`" class="card block hover:shadow-md transition-shadow duration-150 active:scale-[0.98] transition-transform">
    <!-- Banner -->
    <div class="relative h-36 overflow-hidden"
         :class="imageUrl && !imageError ? '' : 'bg-gradient-to-br from-brand-400 to-brand-600'">
      <!-- Food photo -->
      <img
        v-if="imageUrl && !imageError"
        :src="imageUrl"
        :alt="recipe.title"
        class="w-full h-full object-cover"
        @error="imageError = true"
      />
      <!-- Darkening overlay so text badges stay readable -->
      <div v-if="imageUrl && !imageError" class="absolute inset-0 bg-gradient-to-t from-black/55 via-black/10 to-transparent" />

      <!-- Meal type watermark (keep per design) -->
      <span class="absolute inset-0 flex items-center justify-center text-6xl select-none pointer-events-none"
            :class="imageUrl && !imageError ? 'opacity-10' : 'opacity-30'">
        {{ mealIcon }}
      </span>

      <!-- Badges -->
      <div class="absolute inset-0 flex items-end p-3">
        <div class="flex flex-wrap gap-1.5">
          <span v-if="recipe.meal_type" class="badge bg-white/20 text-white backdrop-blur-sm">
            {{ recipe.meal_type }}
          </span>
          <span v-if="recipe.cuisine" class="badge bg-white/20 text-white backdrop-blur-sm">
            {{ recipe.cuisine }}
          </span>
          <span v-if="recipe.difficulty" :class="difficultyBadge">
            {{ recipe.difficulty }}
          </span>
        </div>
      </div>

      <!-- Favorite button -->
      <button
        v-if="showFavorite"
        @click.prevent="onToggleFavorite"
        :disabled="favoriteLoading"
        class="absolute top-3 right-3 w-8 h-8 rounded-full bg-black/20 backdrop-blur-sm flex items-center justify-center hover:bg-black/30 transition-colors"
        :class="isFav ? 'text-red-400' : 'text-white'"
      >
        <!-- Filled heart -->
        <svg v-if="isFav" class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
          <path d="M3.172 5.172a4 4 0 015.656 0L12 8.343l3.172-3.171a4 4 0 115.656 5.656L12 19.657l-8.828-8.829a4 4 0 010-5.656z"/>
        </svg>
        <!-- Outline heart -->
        <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
        </svg>
      </button>
    </div>

    <!-- Content -->
    <div class="p-4">
      <h3 class="font-bold text-gray-900 text-base leading-snug mb-1 line-clamp-2">{{ recipe.title }}</h3>

      <p v-if="recipe.description" class="text-gray-500 text-sm line-clamp-2 mb-3">
        {{ recipe.description }}
      </p>

      <div class="flex items-center justify-between">
        <div class="flex items-center gap-3 text-xs text-gray-500">
          <span v-if="recipe.cook_time_minutes" class="flex items-center gap-1">
            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            {{ recipe.cook_time_minutes }}m
          </span>
          <span v-if="recipe.servings" class="flex items-center gap-1">
            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/>
            </svg>
            {{ recipe.servings }}
          </span>
        </div>
        <StarRating
          :model-value="recipe.avgRating ?? 0"
          :rating-count="recipe.ratingCount"
          :show-count="true"
        />
      </div>

      <!-- Match bar (only shown on feed) -->
      <div v-if="recipe.matchPct != null" class="mt-3">
        <div class="flex items-center justify-between text-xs mb-1">
          <span class="text-gray-500 font-medium">Pantry match</span>
          <span :class="matchColor" class="font-semibold">{{ recipe.matchPct }}%</span>
        </div>
        <div class="h-1.5 bg-gray-100 rounded-full overflow-hidden">
          <div
            :style="{ width: `${recipe.matchPct}%` }"
            :class="matchBarColor"
            class="h-full rounded-full transition-all duration-300"
          />
        </div>
      </div>
    </div>
  </RouterLink>
</template>

<script setup>
import { ref, computed } from 'vue'
import { RouterLink } from 'vue-router'
import StarRating from './StarRating.vue'
import { useFavoritesStore } from '@/stores/favorites'
import { getRecipeImageUrl } from '@/lib/recipeImages'

const props = defineProps({
  recipe: { type: Object, required: true },
  showFavorite: { type: Boolean, default: true }
})

const favStore = useFavoritesStore()
const favoriteLoading = ref(false)
const imageError = ref(false)
const isFav = computed(() => favStore.isFavorite(props.recipe.recipe_id))
const imageUrl = computed(() => getRecipeImageUrl(props.recipe.recipe_id))

const mealTypeIcons = {
  breakfast: '🥞', lunch: '🥗', dinner: '🍝',
  snack: '🍎', dessert: '🍰', brunch: '🥐',
  drink: '🧋', appetizer: '🥟'
}

const mealIcon = computed(() =>
  mealTypeIcons[props.recipe.meal_type?.toLowerCase()] ?? '🍽️'
)

const difficultyBadge = computed(() => {
  const map = {
    easy:   'badge bg-green-100/80 text-green-700',
    medium: 'badge bg-yellow-100/80 text-yellow-700',
    hard:   'badge bg-red-100/80 text-red-600'
  }
  return map[props.recipe.difficulty?.toLowerCase()] ?? 'badge bg-gray-100 text-gray-600'
})

const matchColor = computed(() => {
  const p = props.recipe.matchPct ?? 0
  if (p >= 75) return 'text-green-600'
  if (p >= 40) return 'text-amber-500'
  return 'text-gray-400'
})

const matchBarColor = computed(() => {
  const p = props.recipe.matchPct ?? 0
  if (p >= 75) return 'bg-green-500'
  if (p >= 40) return 'bg-amber-400'
  return 'bg-gray-300'
})

async function onToggleFavorite() {
  favoriteLoading.value = true
  try {
    await favStore.toggleFavorite(props.recipe.recipe_id)
  } finally {
    favoriteLoading.value = false
  }
}
</script>
