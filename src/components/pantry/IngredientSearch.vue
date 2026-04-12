<template>
  <div class="relative">
    <div class="relative">
      <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
        </svg>
      </span>
      <input
        v-model="query"
        type="text"
        :placeholder="placeholder"
        class="input-field pl-9 pr-4"
        @input="onInput"
        @keydown.escape="clear"
      />
      <button
        v-if="query"
        @click="clear"
        class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
      >
        ✕
      </button>
    </div>

    <!-- Results dropdown -->
    <div
      v-if="results.length > 0 || (query.length >= 2 && !loading && results.length === 0)"
      class="absolute top-full left-0 right-0 mt-1 bg-white rounded-xl border border-gray-200 shadow-lg z-30 max-h-60 overflow-y-auto"
    >
      <div v-if="loading" class="p-3 text-center">
        <LoadingSpinner size="sm" color="gray" />
      </div>
      <div v-else-if="results.length === 0" class="p-3 text-sm text-gray-400 text-center">
        No ingredients found
      </div>
      <button
        v-for="item in results"
        :key="item.ingredient_id"
        @click="selectItem(item)"
        class="w-full px-4 py-2.5 text-left hover:bg-brand-50 transition-colors flex items-center justify-between group"
        :disabled="isAlreadyAdded(item.ingredient_id)"
      >
        <div>
          <p class="text-sm font-medium text-gray-800">{{ item.name }}</p>
          <p v-if="item.category" class="text-xs text-gray-400">{{ item.category }}</p>
        </div>
        <span v-if="isAlreadyAdded(item.ingredient_id)" class="text-xs text-green-500 font-medium">In pantry</span>
        <span v-else class="text-brand-400 opacity-0 group-hover:opacity-100 text-xs font-medium transition-opacity">Add +</span>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import { usePantryStore } from '@/stores/pantry'

const props = defineProps({
  placeholder: { type: String, default: 'Search ingredients…' }
})
const emit = defineEmits(['select'])

const pantry = usePantryStore()
const query = ref('')
const results = ref([])
const loading = ref(false)
let debounceTimer = null

function onInput() {
  clearTimeout(debounceTimer)
  if (query.value.length < 2) {
    results.value = []
    return
  }
  debounceTimer = setTimeout(async () => {
    loading.value = true
    try {
      results.value = await pantry.searchIngredients(query.value)
    } finally {
      loading.value = false
    }
  }, 300)
}

function selectItem(item) {
  if (isAlreadyAdded(item.ingredient_id)) return
  emit('select', item)
  clear()
}

function clear() {
  query.value = ''
  results.value = []
}

function isAlreadyAdded(id) {
  return pantry.isPantryItem(id)
}
</script>
