<template>
  <Teleport to="body">
    <Transition
      enter-active-class="transition-opacity duration-200"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition-opacity duration-150"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="modelValue"
        class="fixed inset-0 z-50 flex items-end sm:items-center justify-center"
        @click.self="$emit('update:modelValue', false)"
      >
        <div class="absolute inset-0 bg-black/40 backdrop-blur-sm" @click="$emit('update:modelValue', false)" />

        <Transition
          enter-active-class="transition-transform duration-200"
          enter-from-class="translate-y-4 sm:translate-y-0 sm:scale-95"
          enter-to-class="translate-y-0 sm:scale-100"
          leave-active-class="transition-transform duration-150"
          leave-from-class="translate-y-0 sm:scale-100"
          leave-to-class="translate-y-4 sm:translate-y-0 sm:scale-95"
        >
          <div
            v-if="modelValue"
            class="relative bg-white rounded-t-3xl sm:rounded-2xl w-full sm:max-w-md mx-0 sm:mx-4 shadow-2xl"
          >
            <div class="p-6">
              <div class="flex items-center justify-between mb-4">
                <h2 class="text-lg font-bold text-gray-900">{{ title }}</h2>
                <button
                  @click="$emit('update:modelValue', false)"
                  class="w-8 h-8 rounded-full bg-gray-100 hover:bg-gray-200 flex items-center justify-center text-gray-500 transition-colors"
                >
                  ✕
                </button>
              </div>
              <slot />
            </div>
          </div>
        </Transition>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
defineProps({
  modelValue: Boolean,
  title: { type: String, default: '' }
})
defineEmits(['update:modelValue'])
</script>
