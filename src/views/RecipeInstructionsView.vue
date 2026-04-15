<template>
  <div>
    <!-- Loading -->
    <div v-if="recipes.loading" class="page-container pt-8">
      <div class="animate-pulse space-y-4">
        <div class="h-48 bg-gray-200 rounded-2xl" />
        <div class="h-6 bg-gray-200 rounded w-3/4" />
        <div class="h-4 bg-gray-100 rounded w-full" />
        <div class="h-4 bg-gray-100 rounded w-5/6" />
      </div>
    </div>

    <!-- Error -->
    <div v-else-if="recipes.error" class="page-container text-center pt-16">
      <div class="w-14 h-14 mx-auto mb-3 rounded-full bg-red-50 flex items-center justify-center">
        <svg class="w-7 h-7 text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
        </svg>
      </div>
      <p class="text-gray-500">{{ recipes.error }}</p>
      <button @click="$router.back()" class="btn-secondary mt-4">Go back</button>
    </div>

    <!-- Recipe content -->
    <div v-else-if="recipe">
      <!-- Hero banner -->
      <div class="relative h-52 overflow-hidden"
           :class="imageUrl && !imageError ? '' : 'bg-gradient-to-br from-brand-400 to-brand-700'">
        <!-- Food photo -->
        <img
          v-if="imageUrl && !imageError"
          :src="imageUrl"
          :alt="recipe.title"
          class="w-full h-full object-cover"
          @error="imageError = true"
        />
        <div v-if="imageUrl && !imageError" class="absolute inset-0 bg-gradient-to-t from-black/60 via-black/20 to-black/30" />

        <!-- Meal type watermark (keep per design) -->
        <span class="absolute inset-0 flex items-center justify-center text-8xl select-none pointer-events-none"
              :class="imageUrl && !imageError ? 'opacity-10' : 'opacity-20'">
          {{ mealIcon }}
        </span>

        <!-- Back button -->
        <button
          @click="$router.back()"
          class="absolute top-4 left-4 w-9 h-9 rounded-full bg-black/25 backdrop-blur-sm text-white flex items-center justify-center hover:bg-black/35 transition-colors"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 19l-7-7 7-7"/>
          </svg>
        </button>

        <!-- Favorite button -->
        <button
          @click="onToggleFavorite"
          class="absolute top-4 right-4 w-9 h-9 rounded-full bg-black/25 backdrop-blur-sm flex items-center justify-center hover:bg-black/35 transition-colors"
          :class="isFav ? 'text-red-400' : 'text-white'"
        >
          <svg v-if="isFav" class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
            <path d="M3.172 5.172a4 4 0 015.656 0L12 8.343l3.172-3.171a4 4 0 115.656 5.656L12 19.657l-8.828-8.829a4 4 0 010-5.656z"/>
          </svg>
          <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
          </svg>
        </button>

        <!-- Badges -->
        <div class="absolute bottom-4 left-4 flex flex-wrap gap-2">
          <span v-if="recipe.meal_type" class="badge bg-white/20 text-white backdrop-blur-sm">{{ recipe.meal_type }}</span>
          <span v-if="recipe.cuisine"   class="badge bg-white/20 text-white backdrop-blur-sm">{{ recipe.cuisine }}</span>
          <span v-if="recipe.difficulty" :class="difficultyBadge">{{ recipe.difficulty }}</span>
        </div>
      </div>

      <div class="max-w-lg mx-auto px-4 pb-24">
        <!-- Title & rating -->
        <div class="pt-5 pb-4 border-b border-gray-100">
          <h1 class="text-2xl font-bold text-gray-900 leading-tight">{{ recipe.title }}</h1>
          <p v-if="recipe.description" class="text-gray-500 text-sm mt-2">{{ recipe.description }}</p>

          <div class="mt-3 space-y-1.5">
            <!-- Community average -->
            <div class="flex items-center gap-2">
              <StarRating
                :model-value="recipe.avgRating ?? 0"
                :rating-count="recipe.ratingCount"
                show-count
              />
              <span class="text-xs text-gray-400">community</span>
            </div>
            <!-- Personal rating -->
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-2">
                <StarRating
                  v-if="userRating"
                  :model-value="userRating"
                  :show-count="false"
                />
                <span class="text-xs text-gray-400">
                  {{ userRating ? 'your rating' : 'You haven\'t rated this yet' }}
                </span>
              </div>
              <button
                @click="showRatingModal = true"
                class="text-xs text-brand-600 font-semibold hover:underline"
              >
                {{ userRating ? 'Change' : 'Rate this recipe' }}
              </button>
            </div>
          </div>
        </div>

        <!-- Meta grid -->
        <div class="grid grid-cols-3 gap-3 py-4 border-b border-gray-100">
          <div v-if="recipe.prep_time_minutes" class="text-center">
            <div class="flex justify-center mb-1">
              <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
            </div>
            <p class="text-xs text-gray-400">Prep</p>
            <p class="text-sm font-bold text-gray-700">{{ recipe.prep_time_minutes }}m</p>
          </div>
          <div v-if="recipe.cook_time_minutes" class="text-center">
            <div class="flex justify-center mb-1">
              <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17.657 18.657A8 8 0 016.343 7.343S7 9 9 10c0-2 .5-5 2.986-7C14 5 16.09 5.777 17.656 7.343A7.975 7.975 0 0120 13a7.975 7.975 0 01-2.343 5.657z"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.879 16.121A3 3 0 1012.015 11L11 14H9c0 .768.293 1.536.879 2.121z"/>
              </svg>
            </div>
            <p class="text-xs text-gray-400">Cook</p>
            <p class="text-sm font-bold text-gray-700">{{ recipe.cook_time_minutes }}m</p>
          </div>
          <div v-if="recipe.servings" class="text-center">
            <div class="flex justify-center mb-1">
              <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/>
              </svg>
            </div>
            <p class="text-xs text-gray-400">Serves</p>
            <p class="text-sm font-bold text-gray-700">{{ recipe.servings }}</p>
          </div>
        </div>

        <!-- Ingredients -->
        <div class="py-4 border-b border-gray-100">
          <h2 class="text-base font-bold text-gray-900 mb-3">Ingredients</h2>
          <ul class="space-y-2">
            <li
              v-for="ri in recipe.recipe_ingredient"
              :key="ri.ingredients.ingredient_id"
              class="flex items-center gap-3 text-sm"
            >
              <span
                class="w-2 h-2 rounded-full flex-shrink-0"
                :class="isInPantry(ri.ingredients.ingredient_id) ? 'bg-green-400' : 'bg-gray-200'"
              />
              <span class="text-gray-700">
                <span v-if="ri.quantity" class="font-medium">{{ ri.quantity }}</span>
                <span v-if="ri.unit" class="font-medium"> {{ ri.unit }}</span>
                {{ ri.ingredients.name }}
              </span>
              <span
                v-if="isInPantry(ri.ingredients.ingredient_id)"
                class="ml-auto text-xs text-green-500 font-medium"
              >In pantry</span>
            </li>
          </ul>
        </div>

        <!-- Instructions -->
        <div class="pt-4">
          <h2 class="text-base font-bold text-gray-900 mb-4">Instructions</h2>
          <div class="space-y-4">
            <div
              v-for="step in parsedInstructions"
              :key="step.step"
              class="flex gap-4"
              :class="{ 'opacity-50': completedSteps.has(step.step) }"
            >
              <button
                @click="toggleStep(step.step)"
                class="flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center font-bold text-sm transition-colors"
                :class="completedSteps.has(step.step)
                  ? 'bg-green-500 text-white'
                  : 'bg-brand-100 text-brand-600'"
              >
                <svg v-if="completedSteps.has(step.step)" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"/>
                </svg>
                <span v-else>{{ step.step }}</span>
              </button>

              <div class="flex-1 pt-1">
                <p class="text-gray-800 text-sm leading-relaxed" :class="completedSteps.has(step.step) ? 'line-through text-gray-400' : ''">
                  {{ step.instruction }}
                </p>
                <div v-if="step.ingredients?.length" class="flex flex-wrap gap-1.5 mt-2">
                  <span
                    v-for="ing in step.ingredients"
                    :key="ing.name"
                    class="badge bg-brand-50 text-brand-600 border border-brand-100"
                  >
                    {{ ing.name }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Complete all / reset -->
          <div class="flex gap-2 mt-6">
            <button @click="markAllComplete" class="btn-primary flex-1 text-sm">
              Mark all done
            </button>
            <button @click="completedSteps.clear()" class="btn-secondary text-sm px-3">
              Reset
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Rating modal -->
    <AppModal v-model="showRatingModal" title="Rate this recipe">
      <p class="text-gray-500 text-sm mb-4">How would you rate <strong>{{ recipe?.title }}</strong>?</p>
      <div class="flex justify-center mb-5">
        <StarRating
          :model-value="pendingRating"
          :interactive="true"
          :show-count="false"
          @rate="pendingRating = $event"
        />
      </div>
      <div class="flex gap-2">
        <button @click="showRatingModal = false" class="btn-secondary flex-1">Cancel</button>
        <button @click="submitRating" :disabled="!pendingRating || ratingLoading" class="btn-primary flex-1 flex items-center justify-center gap-2">
          <LoadingSpinner v-if="ratingLoading" size="sm" color="white" />
          <span>Submit</span>
        </button>
      </div>
    </AppModal>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useRecipesStore } from '@/stores/recipes'
import { usePantryStore } from '@/stores/pantry'
import { useFavoritesStore } from '@/stores/favorites'
import StarRating from '@/components/recipe/StarRating.vue'
import AppModal from '@/components/ui/AppModal.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import { getRecipeImageUrl } from '@/lib/recipeImages'

const route    = useRoute()
const recipes  = useRecipesStore()
const pantry   = usePantryStore()
const favStore = useFavoritesStore()

const recipe     = computed(() => recipes.currentRecipe)
const isFav      = computed(() => recipe.value ? favStore.isFavorite(recipe.value.recipe_id) : false)
const userRating = computed(() => recipe.value ? recipes.getUserRating(recipe.value.recipe_id) : null)
const imageError = ref(false)
const imageUrl   = computed(() => recipe.value ? getRecipeImageUrl(recipe.value.recipe_id) : null)

const completedSteps  = ref(new Set())
const showRatingModal = ref(false)
const pendingRating   = ref(0)
const ratingLoading   = ref(false)

const mealTypeIcons = {
  breakfast: '🥞', lunch: '🥗', dinner: '🍝',
  snack: '🍎', dessert: '🍰', brunch: '🥐',
  drink: '🧋', appetizer: '🥟'
}
const mealIcon = computed(() =>
  mealTypeIcons[recipe.value?.meal_type?.toLowerCase()] ?? '🍽️'
)

const difficultyBadge = computed(() => {
  const map = {
    easy:   'badge bg-green-100/80 text-green-700',
    medium: 'badge bg-yellow-100/80 text-yellow-700',
    hard:   'badge bg-red-100/80 text-red-600'
  }
  return map[recipe.value?.difficulty?.toLowerCase()] ?? 'badge bg-gray-100 text-gray-600'
})

const parsedInstructions = computed(() => {
  try { return recipe.value?.instructions?.instructions ?? [] }
  catch { return [] }
})

function isInPantry(ingredientId) { return pantry.isPantryItem(ingredientId) }

function toggleStep(step) {
  if (completedSteps.value.has(step)) completedSteps.value.delete(step)
  else completedSteps.value.add(step)
}

function markAllComplete() {
  parsedInstructions.value.forEach(s => completedSteps.value.add(s.step))
}

async function onToggleFavorite() {
  if (!recipe.value) return
  await favStore.toggleFavorite(recipe.value.recipe_id)
}

async function submitRating() {
  if (!pendingRating.value || !recipe.value) return
  ratingLoading.value = true
  try {
    await recipes.rateRecipe(recipe.value.recipe_id, pendingRating.value)
    showRatingModal.value = false
  } finally {
    ratingLoading.value = false
  }
}

onMounted(async () => {
  await Promise.all([
    recipes.fetchRecipeById(route.params.id),
    pantry.fetchPantry(),
    favStore.fetchFavorites()
  ])
  pendingRating.value = userRating.value ?? 0
})
</script>
