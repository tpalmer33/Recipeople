<template>
  <div class="flex items-center gap-0.5">
    <button
      v-for="star in 5"
      :key="star"
      :disabled="!interactive"
      @click="interactive && $emit('rate', star)"
      @mouseenter="interactive && (hovered = star)"
      @mouseleave="interactive && (hovered = 0)"
      :class="[
        'text-xl leading-none transition-transform',
        interactive ? 'cursor-pointer hover:scale-110 active:scale-95' : 'cursor-default',
        getStarFill(star) ? 'text-amber-400' : 'text-gray-200'
      ]"
    >
      ★
    </button>
    <span v-if="showCount && ratingCount != null" class="text-xs text-gray-400 ml-1">
      {{ ratingCount > 0 ? `(${ratingCount})` : 'No ratings' }}
    </span>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  modelValue: { type: Number, default: 0 },  // current user rating or avg
  ratingCount: { type: Number, default: null },
  interactive: { type: Boolean, default: false },
  showCount: { type: Boolean, default: true }
})
defineEmits(['rate'])

const hovered = ref(0)

function getStarFill(star) {
  const active = props.interactive ? (hovered.value || props.modelValue) : props.modelValue
  return star <= Math.round(active)
}
</script>
