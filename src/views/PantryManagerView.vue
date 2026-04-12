<template>
  <div class="page-container">
    <div class="mb-5">
      <h1 class="text-2xl font-bold text-gray-900">My Pantry</h1>
      <p class="text-gray-500 text-sm mt-0.5">Track ingredients you have on hand</p>
    </div>

    <!-- Search / Add -->
    <div class="mb-6">
      <label class="block text-sm font-semibold text-gray-700 mb-2">Add an ingredient</label>
      <IngredientSearch
        placeholder="Search for an ingredient to add…"
        @select="onAddIngredient"
      />
    </div>

    <!-- Loading skeleton -->
    <div v-if="pantry.loading" class="space-y-2">
      <div v-for="i in 6" :key="i" class="h-14 bg-gray-100 rounded-xl animate-pulse" />
    </div>

    <!-- Empty state -->
    <div v-else-if="pantry.pantryItems.length === 0" class="text-center py-12">
      <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-gray-100 flex items-center justify-center">
        <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
        </svg>
      </div>
      <h3 class="font-bold text-gray-700 text-lg">Your pantry is empty</h3>
      <p class="text-gray-400 text-sm mt-1">Start adding ingredients using the search above</p>
    </div>

    <!-- Ingredient list grouped by category -->
    <div v-else class="space-y-5">
      <div v-for="(group, category) in groupedPantry" :key="category">
        <h2 class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-2">
          {{ category === 'null' ? 'Other' : category }}
        </h2>
        <div class="card divide-y divide-gray-50">
          <TransitionGroup name="slide">
            <div
              v-for="item in group"
              :key="item.ingredient_id"
              class="flex items-center px-4 py-3 gap-3"
            >
              <div class="w-8 h-8 rounded-full bg-brand-100 flex items-center justify-center text-brand-500 text-sm font-bold flex-shrink-0">
                {{ item.name[0].toUpperCase() }}
              </div>
              <div class="flex-1 min-w-0">
                <p class="font-medium text-gray-800 text-sm">{{ item.name }}</p>
                <p v-if="item.calories" class="text-xs text-gray-400">{{ item.calories }} kcal / serving</p>
              </div>
              <button
                @click="onRemove(item)"
                class="text-gray-300 hover:text-red-400 transition-colors p-1.5 rounded-lg hover:bg-red-50"
                :aria-label="`Remove ${item.name}`"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
          </TransitionGroup>
        </div>
      </div>

      <!-- Total count badge -->
      <p class="text-center text-xs text-gray-400 pt-2">
        {{ pantry.pantryItems.length }} ingredient{{ pantry.pantryItems.length !== 1 ? 's' : '' }} in your pantry
      </p>
    </div>

    <!-- Error toast -->
    <Transition name="fade">
      <div
        v-if="errorMsg"
        class="fixed bottom-24 left-1/2 -translate-x-1/2 bg-red-500 text-white text-sm font-medium px-4 py-2.5 rounded-xl shadow-lg z-50"
      >
        {{ errorMsg }}
      </div>
    </Transition>

    <!-- Success toast -->
    <Transition name="fade">
      <div
        v-if="successMsg"
        class="fixed bottom-24 left-1/2 -translate-x-1/2 bg-green-500 text-white text-sm font-medium px-4 py-2.5 rounded-xl shadow-lg z-50"
      >
        {{ successMsg }}
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { usePantryStore } from '@/stores/pantry'
import IngredientSearch from '@/components/pantry/IngredientSearch.vue'

const pantry = usePantryStore()
const errorMsg   = ref('')
const successMsg = ref('')

const groupedPantry = computed(() => {
  const groups = {}
  for (const item of pantry.pantryItems) {
    const cat = item.category ?? 'null'
    if (!groups[cat]) groups[cat] = []
    groups[cat].push(item)
  }
  return Object.fromEntries(
    Object.entries(groups).sort(([a], [b]) => {
      if (a === 'null') return 1
      if (b === 'null') return -1
      return a.localeCompare(b)
    })
  )
})

async function onAddIngredient(ingredient) {
  try {
    await pantry.addIngredient(ingredient.ingredient_id)
    showSuccess(`${ingredient.name} added to pantry`)
  } catch (err) {
    showError(err.message)
  }
}

async function onRemove(item) {
  try {
    await pantry.removeIngredient(item.ingredient_id)
    showSuccess(`${item.name} removed`)
  } catch (err) {
    showError(err.message)
  }
}

function showSuccess(msg) {
  successMsg.value = msg
  setTimeout(() => successMsg.value = '', 2500)
}
function showError(msg) {
  errorMsg.value = msg
  setTimeout(() => errorMsg.value = '', 3000)
}

onMounted(() => pantry.fetchPantry())
</script>

<style scoped>
.slide-enter-active, .slide-leave-active { transition: all 0.2s ease; }
.slide-enter-from { opacity: 0; transform: translateX(-10px); }
.slide-leave-to   { opacity: 0; transform: translateX(10px); }
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
