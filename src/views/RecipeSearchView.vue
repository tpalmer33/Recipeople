<template>
  <div class="page-container">
    <h1 class="text-2xl font-bold text-gray-900 mb-4">Search Recipes</h1>

    <!-- Search bar -->
    <div class="relative mb-4">
      <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
        </svg>
      </span>
      <input
        v-model="query"
        type="search"
        placeholder="Search by name or description…"
        class="input-field pl-9"
        @input="onSearch"
        @keydown.enter="onSearch"
      />
    </div>

    <!-- Filters toggle -->
    <button
      @click="showFilters = !showFilters"
      class="flex items-center gap-1.5 text-sm text-brand-600 font-semibold mb-3"
    >
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2a1 1 0 01-.293.707l-6.414 6.414A1 1 0 0014 13.414V19a1 1 0 01-.553.894l-4 2A1 1 0 018 21v-7.586a1 1 0 00-.293-.707L1.293 6.707A1 1 0 011 6V4z"/>
      </svg>
      {{ showFilters ? 'Hide filters' : 'Filters' }}
      <span :class="activeFilterCount > 0 ? 'badge bg-brand-100 text-brand-600' : 'hidden'">
        {{ activeFilterCount }}
      </span>
    </button>

    <!-- Filter panel -->
    <Transition
      enter-active-class="transition-all duration-200 overflow-hidden"
      enter-from-class="max-h-0 opacity-0"
      enter-to-class="max-h-96 opacity-100"
      leave-active-class="transition-all duration-200 overflow-hidden"
      leave-from-class="max-h-96 opacity-100"
      leave-to-class="max-h-0 opacity-0"
    >
      <div v-if="showFilters" class="card p-4 mb-4 space-y-3">
        <div class="grid grid-cols-2 gap-3">
          <div>
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1 block">Meal type</label>
            <select v-model="filters.meal_type" class="input-field text-sm" @change="onSearch">
              <option value="">Any</option>
              <option v-for="t in mealTypes" :key="t" :value="t">{{ t }}</option>
            </select>
          </div>
          <div>
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1 block">Difficulty</label>
            <select v-model="filters.difficulty" class="input-field text-sm" @change="onSearch">
              <option value="">Any</option>
              <option value="easy">Easy</option>
              <option value="medium">Medium</option>
              <option value="hard">Hard</option>
            </select>
          </div>
          <div>
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1 block">Cuisine</label>
            <select v-model="filters.cuisine" class="input-field text-sm" @change="onSearch">
              <option value="">Any</option>
              <option v-for="c in cuisines" :key="c" :value="c">{{ c }}</option>
            </select>
          </div>
          <div>
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1 block">Max cook time</label>
            <select v-model="filters.max_time" class="input-field text-sm" @change="onSearch">
              <option value="">Any</option>
              <option :value="15">15 min</option>
              <option :value="30">30 min</option>
              <option :value="45">45 min</option>
              <option :value="60">1 hour</option>
              <option :value="90">1.5 hours</option>
            </select>
          </div>
        </div>
        <button @click="clearFilters" class="text-xs text-gray-400 hover:text-red-500 transition-colors font-medium">
          Clear all filters
        </button>
      </div>
    </Transition>

    <!-- Results count -->
    <p v-if="!recipes.loading && hasSearched" class="text-sm text-gray-400 mb-3">
      {{ recipes.searchResults.length }} recipe{{ recipes.searchResults.length !== 1 ? 's' : '' }} found
      <span v-if="recipes.searchResults.length > 0"> · sorted by rating</span>
    </p>

    <!-- Loading -->
    <div v-if="recipes.loading" class="space-y-4">
      <div v-for="i in 4" :key="i" class="card animate-pulse">
        <div class="h-36 bg-gray-200 rounded-t-2xl" />
        <div class="p-4 space-y-2">
          <div class="h-4 bg-gray-200 rounded w-3/4" />
          <div class="h-3 bg-gray-100 rounded w-1/2" />
        </div>
      </div>
    </div>

    <!-- Empty initial state -->
    <div v-else-if="!hasSearched" class="text-center py-16">
      <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-brand-50 flex items-center justify-center">
        <svg class="w-8 h-8 text-brand-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
        </svg>
      </div>
      <h3 class="font-bold text-gray-700 text-lg">Discover recipes</h3>
      <p class="text-gray-400 text-sm mt-1">Search by name, cuisine, or use the filters above</p>
    </div>

    <!-- No results -->
    <div v-else-if="recipes.searchResults.length === 0" class="text-center py-12">
      <div class="w-14 h-14 mx-auto mb-3 rounded-full bg-gray-100 flex items-center justify-center">
        <svg class="w-7 h-7 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
      </div>
      <p class="text-gray-500 font-medium">No recipes match your search</p>
      <button @click="clearAll" class="text-brand-500 text-sm font-medium mt-2 hover:underline">
        Clear search
      </button>
    </div>

    <!-- Results -->
    <div v-else class="space-y-4">
      <RecipeCard
        v-for="recipe in recipes.searchResults"
        :key="recipe.recipe_id"
        :recipe="recipe"
        show-favorite
      />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRecipesStore } from '@/stores/recipes'
import { useFavoritesStore } from '@/stores/favorites'
import RecipeCard from '@/components/recipe/RecipeCard.vue'

const recipes  = useRecipesStore()
const favStore = useFavoritesStore()

const query   = ref('')
const showFilters = ref(false)
const hasSearched = ref(false)

const filters = ref({
  meal_type:  '',
  difficulty: '',
  cuisine:    '',
  max_time:   ''
})

const mealTypes = ['Breakfast', 'Brunch', 'Lunch', 'Dinner', 'Snack', 'Dessert', 'Drink', 'Appetizer']
const cuisines  = ['American', 'Italian', 'Mexican', 'Asian', 'Indian', 'Mediterranean', 'French', 'Greek', 'Japanese', 'Chinese']

const activeFilterCount = computed(() =>
  Object.values(filters.value).filter(v => v !== '').length
)

let debounce = null
function onSearch() {
  clearTimeout(debounce)
  debounce = setTimeout(runSearch, 350)
}

async function runSearch() {
  hasSearched.value = true
  const activeFilters = Object.fromEntries(
    Object.entries(filters.value).filter(([, v]) => v !== '')
  )
  await recipes.searchRecipes(query.value, activeFilters)
}

function clearFilters() {
  filters.value = { meal_type: '', difficulty: '', cuisine: '', max_time: '' }
  if (hasSearched.value) runSearch()
}

function clearAll() {
  query.value = ''
  clearFilters()
  hasSearched.value = false
  recipes.searchResults = []
}

onMounted(() => favStore.fetchFavorites())
</script>
