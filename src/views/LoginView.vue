<template>
  <div class="min-h-screen bg-gradient-to-b from-brand-500 to-brand-700 flex flex-col items-center justify-center px-4 py-12">
    <div class="w-full max-w-sm">
      <!-- Logo -->
      <div class="text-center mb-8">
        <div class="text-6xl mb-3">🍽️</div>
        <h1 class="text-3xl font-bold text-white">Recipeople</h1>
        <p class="text-brand-200 mt-1 text-sm">Cook with what you have</p>
      </div>

      <!-- Card -->
      <div class="bg-white rounded-3xl p-6 shadow-2xl">
        <h2 class="text-xl font-bold text-gray-900 mb-5">Welcome back</h2>

        <form @submit.prevent="onLogin" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
            <input
              v-model="form.email"
              type="email"
              required
              autocomplete="email"
              placeholder="you@example.com"
              class="input-field"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
            <div class="relative">
              <input
                v-model="form.password"
                :type="showPassword ? 'text' : 'password'"
                required
                autocomplete="current-password"
                placeholder="••••••••"
                class="input-field pr-10"
              />
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600 transition-colors"
                :aria-label="showPassword ? 'Hide password' : 'Show password'"
              >
                <!-- Eye open -->
                <svg v-if="showPassword" class="w-4.5 h-4.5 w-[18px] h-[18px]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                </svg>
                <!-- Eye closed -->
                <svg v-else class="w-[18px] h-[18px]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/>
                </svg>
              </button>
            </div>
          </div>

          <div v-if="errorMsg" class="bg-red-50 text-red-600 text-sm rounded-xl px-3 py-2.5">
            {{ errorMsg }}
          </div>

          <button type="submit" :disabled="loading" class="btn-primary w-full flex items-center justify-center gap-2">
            <LoadingSpinner v-if="loading" size="sm" color="white" />
            <span>{{ loading ? 'Signing in…' : 'Sign In' }}</span>
          </button>
        </form>

        <p class="text-center text-sm text-gray-500 mt-5">
          Don't have an account?
          <RouterLink to="/signup" class="text-brand-600 font-semibold hover:underline">Sign up</RouterLink>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter, RouterLink } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'

const auth = useAuthStore()
const router = useRouter()

const form = reactive({ email: '', password: '' })
const showPassword = ref(false)
const loading = ref(false)
const errorMsg = ref('')

async function onLogin() {
  errorMsg.value = ''
  loading.value = true
  try {
    await auth.login(form.email, form.password)
    router.push('/feed')
  } catch (err) {
    errorMsg.value = err.message ?? 'Invalid email or password.'
  } finally {
    loading.value = false
  }
}
</script>
