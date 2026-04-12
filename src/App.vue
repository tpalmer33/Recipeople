<template>
  <div class="min-h-screen flex flex-col">
    <!-- Global loading overlay during auth init -->
    <div v-if="auth.loading" class="fixed inset-0 bg-white flex items-center justify-center z-50">
      <div class="text-center">
        <div class="text-5xl mb-4">🍽️</div>
        <p class="text-brand-500 font-semibold text-lg">Recipeople</p>
        <LoadingSpinner class="mt-4 mx-auto" />
      </div>
    </div>

    <template v-else>
      <AppHeader v-show="auth.isAuthenticated" />
      <main class="flex-1">
        <RouterView />
      </main>
      <BottomNav v-show="auth.isAuthenticated" />
    </template>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { RouterView } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import AppHeader from '@/components/layout/AppHeader.vue'
import BottomNav from '@/components/layout/BottomNav.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'

const auth = useAuthStore()

onMounted(() => auth.init())
</script>
