<template>
  <div :class="['inline-block', sizeClass]">
    <svg
      class="animate-spin"
      :class="colorClass"
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      aria-label="Loading"
    >
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
      <path class="opacity-75" fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
    </svg>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  size: { type: String, default: 'md' },   // sm | md | lg
  color: { type: String, default: 'brand' } // brand | white | gray
})

const sizeClass = computed(() => ({
  sm: 'w-4 h-4',
  md: 'w-6 h-6',
  lg: 'w-10 h-10'
}[props.size] ?? 'w-6 h-6'))

const colorClass = computed(() => ({
  brand: 'text-brand-500',
  white: 'text-white',
  gray:  'text-gray-400'
}[props.color] ?? 'text-brand-500'))
</script>
