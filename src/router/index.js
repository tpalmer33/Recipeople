import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes = [
  {
    path: '/',
    redirect: '/feed'
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/LoginView.vue'),
    meta: { requiresGuest: true }
  },
  {
    path: '/signup',
    name: 'signup',
    component: () => import('@/views/SignupView.vue'),
    meta: { requiresGuest: true }
  },
  {
    path: '/feed',
    name: 'feed',
    component: () => import('@/views/RecipeFeedView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/search',
    name: 'search',
    component: () => import('@/views/RecipeSearchView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/pantry',
    name: 'pantry',
    component: () => import('@/views/PantryManagerView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/recipe/:id',
    name: 'recipe',
    component: () => import('@/views/RecipeInstructionsView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/favorites',
    name: 'favorites',
    component: () => import('@/views/FavoritesView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/create',
    name: 'create',
    component: () => import('@/views/CreateRecipeView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/settings',
    name: 'settings',
    component: () => import('@/views/SettingsView.vue'),
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior: () => ({ top: 0 })
})

router.beforeEach(async (to) => {
  const auth = useAuthStore()

  // Wait for the initial auth check to finish before deciding
  if (auth.loading) {
    await new Promise(resolve => {
      const timer = setInterval(() => {
        if (!auth.loading) { clearInterval(timer); resolve() }
      }, 20)
    })
  }

  if (to.meta.requiresAuth && !auth.isAuthenticated) return { name: 'login' }
  if (to.meta.requiresGuest && auth.isAuthenticated) return { name: 'feed' }
})

export default router
