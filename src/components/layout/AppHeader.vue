<template>
  <header class="sticky top-0 z-40 bg-white border-b border-gray-100 shadow-sm">
    <div class="max-w-lg mx-auto px-4 h-14 flex items-center justify-between">
      <RouterLink to="/feed" class="flex items-center gap-2">
        <span class="text-2xl">🍽️</span>
        <span class="font-bold text-brand-600 text-lg tracking-tight">Recipeople</span>
      </RouterLink>

      <RouterLink to="/settings" class="flex items-center gap-2 group">
        <div class="w-8 h-8 rounded-full overflow-hidden bg-brand-100 flex items-center justify-center ring-2 ring-transparent group-hover:ring-brand-300 transition-all">
          <img
            v-if="auth.profile?.avatar"
            :src="auth.profile.avatar"
            :alt="auth.profile?.username"
            class="w-full h-full object-cover"
          />
          <span v-else class="text-brand-600 font-bold text-sm">
            {{ initials }}
          </span>
        </div>
      </RouterLink>
    </div>
  </header>
</template>

<script setup>
import { computed } from 'vue'
import { RouterLink } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const auth = useAuthStore()

const initials = computed(() => {
  if (!auth.profile) return '?'
  return `${auth.profile.fname?.[0] ?? ''}${auth.profile.lname?.[0] ?? ''}`.toUpperCase()
})
</script>
