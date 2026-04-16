<template>
  <div class="page-container pb-28">
    <!-- Loading -->
    <div v-if="initialLoading" class="pt-8 space-y-4 animate-pulse">
      <div class="h-10 bg-gray-200 rounded-2xl w-2/3" />
      <div class="h-40 bg-gray-100 rounded-3xl" />
      <div class="h-40 bg-gray-100 rounded-3xl" />
    </div>

    <!-- Error loading recipe -->
    <div v-else-if="loadError" class="text-center pt-16">
      <p class="text-gray-500">{{ loadError }}</p>
      <button @click="$router.back()" class="btn-secondary mt-4">Go back</button>
    </div>

    <template v-else>
      <!-- Back + title row -->
      <div class="flex items-center gap-3 mb-5">
        <button
          @click="$router.back()"
          class="w-9 h-9 rounded-full bg-gray-100 flex items-center justify-center hover:bg-gray-200 transition-colors flex-shrink-0"
        >
          <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 19l-7-7 7-7"/>
          </svg>
        </button>
        <div>
          <p class="text-xs font-semibold uppercase tracking-widest text-brand-500">Edit Recipe</p>
          <h1 class="text-xl font-bold text-gray-900 leading-tight truncate">{{ form.title || 'Untitled' }}</h1>
        </div>
      </div>

      <form @submit.prevent="onSave" class="space-y-4">
        <!-- Overview -->
        <section class="card p-5 space-y-4">
          <h2 class="text-base font-bold text-gray-900">Overview</h2>

          <div>
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5 block">Title</label>
            <input v-model.trim="form.title" type="text" maxlength="120" class="input-field" placeholder="Smoky Tomato Pasta" />
          </div>

          <div>
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5 block">Description</label>
            <textarea
              v-model.trim="form.description"
              rows="3"
              maxlength="240"
              class="input-field min-h-[96px]"
              placeholder="A short, inviting description."
            />
          </div>

          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5 block">Meal type</label>
              <select v-model="form.meal_type" class="input-field">
                <option value="">Select</option>
                <option v-for="item in mealTypes" :key="item" :value="item">{{ item }}</option>
              </select>
            </div>
            <div>
              <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5 block">Difficulty</label>
              <select v-model="form.difficulty" class="input-field">
                <option value="">Select</option>
                <option value="easy">Easy</option>
                <option value="medium">Medium</option>
                <option value="hard">Hard</option>
              </select>
            </div>
            <div>
              <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5 block">Cuisine</label>
              <select v-model="form.cuisine" class="input-field">
                <option value="">Select</option>
                <option v-for="item in cuisineTypes" :key="item" :value="item">{{ item }}</option>
              </select>
            </div>
            <div>
              <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5 block">Servings</label>
              <input v-model.number="form.servings" type="number" min="1" max="24" class="input-field" placeholder="4" />
            </div>
            <div>
              <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5 block">Prep time (min)</label>
              <input v-model.number="form.prep_time_minutes" type="number" min="0" class="input-field" placeholder="15" />
            </div>
            <div>
              <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5 block">Cook time (min)</label>
              <input v-model.number="form.cook_time_minutes" type="number" min="0" class="input-field" placeholder="20" />
            </div>
          </div>
        </section>

        <!-- Cover photo -->
        <section class="card p-5 space-y-4">
          <div class="flex items-center justify-between gap-3">
            <div>
              <h2 class="text-base font-bold text-gray-900">Cover photo</h2>
              <p class="text-sm text-gray-500">Replace the current photo or upload a new one.</p>
            </div>
            <label class="btn-secondary text-sm cursor-pointer">
              <input type="file" accept="image/*" class="hidden" @change="onThumbnailChange" />
              Choose image
            </label>
          </div>

          <div class="rounded-3xl border border-dashed border-brand-200 bg-gradient-to-br from-brand-50 to-amber-50 p-4">
            <div v-if="thumbnailPreview" class="overflow-hidden rounded-2xl">
              <img :src="thumbnailPreview" alt="Recipe thumbnail preview" class="h-48 w-full object-cover" />
            </div>
            <div v-else class="flex h-40 flex-col items-center justify-center rounded-2xl bg-white text-center">
              <div class="w-12 h-12 rounded-2xl bg-brand-100 text-brand-600 flex items-center justify-center mb-3">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-8h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
              <p class="text-sm font-medium text-gray-600">No photo selected</p>
            </div>

            <div class="mt-3 flex items-center justify-between gap-3">
              <p class="text-xs text-gray-500">
                {{ newThumbnailName || 'JPG, PNG, or WEBP.' }}
              </p>
              <button
                v-if="thumbnailPreview"
                type="button"
                @click="clearThumbnail"
                class="text-xs font-semibold text-red-500 hover:underline"
              >
                Remove
              </button>
            </div>
          </div>
        </section>

        <!-- Error -->
        <p v-if="saveError" class="text-sm font-medium text-red-500 text-center px-4">{{ saveError }}</p>

        <!-- Actions -->
        <div class="space-y-3">
          <button
            type="submit"
            :disabled="recipes.loading || !form.title"
            class="btn-primary w-full flex items-center justify-center gap-2"
          >
            <svg v-if="recipes.loading" class="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"/>
            </svg>
            <span>{{ recipes.loading ? 'Saving…' : 'Save changes' }}</span>
          </button>

          <button
            type="button"
            @click="showDeleteConfirm = true"
            class="w-full py-3 rounded-2xl border border-red-200 text-red-500 font-semibold text-sm bg-red-50 hover:bg-red-100 transition-colors"
          >
            Delete recipe
          </button>
        </div>
      </form>

      <!-- Delete confirmation modal -->
      <AppModal v-model="showDeleteConfirm">
        <div class="p-6 space-y-4">
          <h3 class="text-lg font-bold text-gray-900">Delete recipe?</h3>
          <p class="text-sm text-gray-600">
            "<span class="font-semibold">{{ form.title }}</span>" will be permanently removed. This cannot be undone.
          </p>
          <div class="flex gap-3">
            <button @click="showDeleteConfirm = false" class="btn-secondary flex-1">Cancel</button>

            <button
              @click="onDelete"
              :disabled="deleting"
              class="flex-1 font-semibold py-2.5 rounded-xl bg-red-500 text-white hover:bg-red-600 disabled:opacity-50 transition-colors"
            >
              {{ deleting ? 'Deleting…' : 'Delete' }}
            </button>
          </div>
        </div>
      </AppModal>
    </template>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted, onBeforeUnmount } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useRecipesStore } from '@/stores/recipes'
import { getRecipeImageUrl } from '@/lib/recipeImages'
import AppModal from '@/components/ui/AppModal.vue'

const route = useRoute()
const router = useRouter()
const recipes = useRecipesStore()

const initialLoading = ref(true)
const loadError = ref('')
const saveError = ref('')
const showDeleteConfirm = ref(false)
const deleting = ref(false)

const thumbnailPreview = ref('')
const newThumbnailFile = ref(null)
const newThumbnailName = ref('')

const mealTypes = [
  'Breakfast', 'Lunch', 'Dinner', 'Appetizer/Starter',
  'Soup', 'Salad', 'Side Dish', 'Main Course', 'Dessert', 'Beverage'
]

const cuisineTypes = [
  'Italian', 'Chinese', 'Thai', 'Indian', 'French', 'Japanese',
  'Mexican', 'American', 'Greek', 'Mediterranean', 'Spanish',
  'Korean', 'Vietnamese', 'Middle Eastern'
]

const form = reactive({
  title: '',
  description: '',
  meal_type: '',
  cuisine: '',
  difficulty: '',
  servings: '',
  prep_time_minutes: '',
  cook_time_minutes: ''
})

function revokePreview() {
  if (thumbnailPreview.value?.startsWith('blob:')) {
    URL.revokeObjectURL(thumbnailPreview.value)
  }
}

function onThumbnailChange(event) {
  const file = event.target.files?.[0]
  if (!file) return
  newThumbnailFile.value = file
  newThumbnailName.value = file.name
  revokePreview()
  thumbnailPreview.value = URL.createObjectURL(file)
  event.target.value = ''
}

function clearThumbnail() {
  newThumbnailFile.value = null
  newThumbnailName.value = ''
  revokePreview()
  thumbnailPreview.value = ''
}

async function onSave() {
  saveError.value = ''
  if (!form.title) { saveError.value = 'Title is required.'; return }

  try {
    await recipes.updateRecipe(route.params.id, {
      ...form,
      thumbnailFile: newThumbnailFile.value
    })
    router.push({ name: 'my-recipes' })
  } catch (err) {
    saveError.value = err.message || 'Failed to save changes.'
  }
}

async function onDelete() {
  deleting.value = true
  try {
    await recipes.deleteRecipe(route.params.id)
    router.push({ name: 'my-recipes' })
  } catch (err) {
    saveError.value = err.message || 'Failed to delete recipe.'
    showDeleteConfirm.value = false
  } finally {
    deleting.value = false
  }
}

onMounted(async () => {
  try {
    await recipes.fetchRecipeById(route.params.id)
    const r = recipes.currentRecipe
    if (!r) { loadError.value = 'Recipe not found.'; return }

    form.title = r.title ?? ''
    form.description = r.description ?? ''
    form.meal_type = r.meal_type ?? ''
    form.cuisine = r.cuisine ?? ''
    form.difficulty = r.difficulty ?? ''
    form.servings = r.servings ?? ''
    form.prep_time_minutes = r.prep_time_minutes ?? ''
    form.cook_time_minutes = r.cook_time_minutes ?? ''

    const existingImage = getRecipeImageUrl(r)
    if (existingImage) thumbnailPreview.value = existingImage
  } catch (err) {
    loadError.value = err.message || 'Could not load recipe.'
  } finally {
    initialLoading.value = false
  }
})

onBeforeUnmount(revokePreview)
</script>
