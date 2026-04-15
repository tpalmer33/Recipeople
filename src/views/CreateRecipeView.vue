<template>
  <div class="page-container pb-32">
    <div class="relative overflow-hidden rounded-[32px] bg-gradient-to-br from-brand-700 via-brand-500 to-amber-300 p-6 text-white shadow-xl mb-5">
      <div class="absolute -right-8 -top-10 h-28 w-28 rounded-full bg-white/10 blur-2xl" />
      <div class="absolute -bottom-12 left-12 h-32 w-32 rounded-full bg-amber-100/20 blur-2xl" />
      <div class="absolute inset-x-0 bottom-0 h-px bg-white/20" />
      <p class="text-xs uppercase tracking-[0.32em] text-white/70 mb-2">New Recipe</p>
      <h1 class="text-3xl font-bold leading-tight">Share a recipe people will want to make tonight.</h1>
      <p class="text-sm text-white/85 mt-2 max-w-sm">
        Start with the basics, add the ingredients, then walk people through each step.
      </p>

      <div class="grid grid-cols-3 gap-2 mt-5">
        <div class="rounded-2xl bg-white/12 px-3 py-2 backdrop-blur-sm">
          <p class="text-[11px] uppercase tracking-wide text-white/65">Details</p>
          <p class="text-sm font-semibold">Name it</p>
        </div>
        <div class="rounded-2xl bg-white/12 px-3 py-2 backdrop-blur-sm">
          <p class="text-[11px] uppercase tracking-wide text-white/65">Ingredients</p>
          <p class="text-sm font-semibold">List it</p>
        </div>
        <div class="rounded-2xl bg-white/12 px-3 py-2 backdrop-blur-sm">
          <p class="text-[11px] uppercase tracking-wide text-white/65">Method</p>
          <p class="text-sm font-semibold">Teach it</p>
        </div>
      </div>
    </div>

    <form @submit.prevent="submitRecipe" class="space-y-4">
      <section class="card p-5 space-y-4">
        <div class="flex items-start justify-between gap-3">
          <div>
            <h2 class="text-base font-bold text-gray-900">Overview</h2>
            <p class="text-sm text-gray-500">Give your recipe a clear title and a few quick details.</p>
          </div>
          <div class="rounded-full bg-brand-50 px-3 py-1 text-xs font-semibold text-brand-700 whitespace-nowrap">
            Start here
          </div>
        </div>

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
            placeholder="A cozy weeknight pasta with garlic, tomatoes, and a silky finish."
          />
          <p class="text-xs text-gray-400 mt-1">A short, inviting description helps people decide to click.</p>
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
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5 block">Prep time</label>
            <input v-model.number="form.prep_time_minutes" type="number" min="0" class="input-field" placeholder="15" />
          </div>
          <div>
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5 block">Cook time</label>
            <input v-model.number="form.cook_time_minutes" type="number" min="0" class="input-field" placeholder="20" />
          </div>
        </div>
      </section>

      <section class="card p-5 space-y-4">
        <div class="flex items-center justify-between gap-3">
          <div>
            <h2 class="text-base font-bold text-gray-900">Cover photo</h2>
            <p class="text-sm text-gray-500">Optional, but a great photo makes the recipe feel finished.</p>
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
            <p class="text-sm font-medium text-gray-600">No photo selected yet</p>
            <p class="text-xs text-gray-400 mt-1">Bright, close-up food photos usually work best.</p>
          </div>

          <div class="mt-3 flex items-center justify-between gap-3">
            <p class="text-xs text-gray-500">
              {{ thumbnailName ? thumbnailName : 'Upload a JPG, PNG, or WEBP image.' }}
            </p>
            <button
              v-if="form.thumbnail"
              type="button"
              @click="clearThumbnail"
              class="text-xs font-semibold text-red-500 hover:underline"
            >
              Remove
            </button>
          </div>
        </div>
      </section>

      <section class="card p-5 space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-base font-bold text-gray-900">Ingredients</h2>
            <p class="text-sm text-gray-500">List everything someone needs before they start cooking.</p>
          </div>
          <button type="button" @click="addIngredient" class="btn-secondary text-sm">Add ingredient</button>
        </div>

        <div class="rounded-2xl bg-amber-50 text-amber-800 px-4 py-3 text-sm">
          Keep ingredient names simple and recognizable, like “Garlic” or “Olive Oil.”
        </div>

        <div class="space-y-3">
          <div
            v-for="(ingredient, index) in form.ingredients"
            :key="ingredient.id"
            class="rounded-2xl border border-gray-100 bg-gray-50/80 p-3 shadow-sm"
          >
            <div class="grid grid-cols-12 gap-2">
              <div class="col-span-6 relative">
                <label class="text-[11px] font-semibold uppercase tracking-wide text-gray-500 mb-1 block">Name</label>
                <input
                  v-model.trim="ingredient.name"
                  type="text"
                  class="input-field text-sm"
                  placeholder="Garlic"
                  autocomplete="off"
                  @input="onIngredientInput(ingredient)"
                  @focus="onIngredientFocus(ingredient)"
                  @blur="onIngredientBlur(ingredient)"
                />
                <div
                  v-if="ingredient.loading"
                  class="absolute right-3 top-[34px] text-[11px] font-medium text-gray-400"
                >
                  Searching...
                </div>
                <div
                  v-if="ingredient.showSuggestions && ingredient.suggestions.length > 0"
                  class="absolute left-0 right-0 top-full z-20 mt-1 overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-lg"
                >
                  <button
                    v-for="item in ingredient.suggestions"
                    :key="item.ingredient_id"
                    type="button"
                    @mousedown.prevent="selectIngredientSuggestion(ingredient, item)"
                    class="flex w-full items-center justify-between gap-3 px-3 py-2.5 text-left hover:bg-brand-50"
                  >
                    <div>
                      <p class="text-sm font-medium text-gray-800">{{ item.name }}</p>
                      <p v-if="item.category" class="text-xs text-gray-400">{{ item.category }}</p>
                    </div>
                    <span class="text-xs font-semibold text-brand-500">Use</span>
                  </button>
                </div>
              </div>
              <div class="col-span-3">
                <label class="text-[11px] font-semibold uppercase tracking-wide text-gray-500 mb-1 block">Qty</label>
                <input v-model="ingredient.quantity" type="number" min="0" step="0.25" class="input-field text-sm" placeholder="2" />
              </div>
              <div class="col-span-3">
                <label class="text-[11px] font-semibold uppercase tracking-wide text-gray-500 mb-1 block">Unit</label>
                <select v-model="ingredient.unit" class="input-field text-sm">
                  <option value="">Select</option>
                  <option v-for="unit in unitOptions" :key="unit" :value="unit">{{ unit }}</option>
                </select>
              </div>
            </div>
            <div class="mt-2 flex justify-between gap-3 text-xs">
              <div class="min-h-[16px]">
                <span v-if="ingredient.matchLabel" :class="ingredient.matchTone">{{ ingredient.matchLabel }}</span>
                <span v-else class="text-gray-400">Ingredient {{ index + 1 }}</span>
              </div>
              <button
                type="button"
                @click="removeIngredient(index)"
                :disabled="form.ingredients.length === 1"
                class="font-semibold text-red-500 disabled:text-gray-300"
              >
                Remove
              </button>
            </div>
          </div>
        </div>
      </section>

      <section class="card p-5 space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-base font-bold text-gray-900">Instructions</h2>
            <p class="text-sm text-gray-500">Break the recipe into clear, manageable steps.</p>
          </div>
          <button type="button" @click="addInstruction" class="btn-secondary text-sm">Add step</button>
        </div>

        <div class="rounded-2xl bg-slate-50 px-4 py-3">
          <p class="text-sm font-medium text-gray-700">Helpful tip</p>
          <p class="text-xs text-gray-500 mt-1">Write each step the way you would say it to a friend cooking alongside you.</p>
        </div>

        <div class="space-y-3">
          <div
            v-for="(step, index) in form.instructions"
            :key="step.id"
            class="rounded-3xl border border-gray-100 bg-white shadow-sm"
          >
            <div class="flex items-start gap-3 p-4">
              <div class="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-2xl bg-brand-100 text-sm font-bold text-brand-700">
                {{ index + 1 }}
              </div>
              <div class="flex-1 space-y-3">
                <div>
                  <label class="text-[11px] font-semibold uppercase tracking-wide text-gray-500 mb-1 block">Instruction</label>
                  <textarea
                    v-model.trim="step.instruction"
                    rows="3"
                    class="input-field min-h-[92px] text-sm"
                    placeholder="Stir the garlic into the oil until fragrant."
                  />
                </div>
                <div>
                  <label class="text-[11px] font-semibold uppercase tracking-wide text-gray-500 mb-1 block">Ingredient tags</label>
                  <input
                    v-model="step.ingredientsText"
                    type="text"
                    class="input-field text-sm"
                    placeholder="Garlic, Olive Oil"
                  />
                  <p class="text-xs text-gray-400 mt-1">Optional. Add a few ingredient names separated by commas.</p>
                </div>
              </div>
            </div>
            <div class="border-t border-gray-100 px-4 py-2 text-right">
              <button
                type="button"
                @click="removeInstruction(index)"
                :disabled="form.instructions.length === 1"
                class="text-xs font-semibold text-red-500 disabled:text-gray-300"
              >
                Remove step
              </button>
            </div>
          </div>
        </div>
      </section>

      <div v-if="submitError" class="rounded-2xl border border-red-100 bg-red-50 px-4 py-3 text-sm text-red-600">
        {{ submitError }}
      </div>

      <div class="sticky bottom-20 z-10 rounded-[28px] border border-gray-100 bg-white/95 p-4 shadow-xl backdrop-blur">
        <div class="flex items-center justify-between gap-3 mb-3">
          <div>
            <p class="text-sm font-bold text-gray-900">Ready to publish?</p>
            <p class="text-xs text-gray-500">Give it one quick look, then share it with the Recipeople community.</p>
          </div>
          <RouterLink to="/feed" class="text-sm font-semibold text-gray-400 hover:text-gray-600">Cancel</RouterLink>
        </div>
        <button
          type="submit"
          :disabled="recipes.loading"
          class="btn-primary w-full flex items-center justify-center gap-2"
        >
          <LoadingSpinner v-if="recipes.loading" size="sm" color="white" />
          <span>{{ recipes.loading ? 'Publishing...' : 'Publish Recipe' }}</span>
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, reactive, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { useRecipesStore } from '@/stores/recipes'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'

const router = useRouter()
const recipes = useRecipesStore()

const mealTypes = [
  'Breakfast',
  'Lunch',
  'Dinner',
  'Appetizer/Starter',
  'Soup',
  'Salad',
  'Side Dish',
  'Main Course',
  'Dessert',
  'Beverage'
]

const cuisineTypes = [
  'Italian',
  'Chinese',
  'Thai',
  'Indian',
  'French',
  'Japanese',
  'Mexican',
  'American',
  'Greek',
  'Mediterranean',
  'Spanish',
  'Korean',
  'Vietnamese',
  'Middle Eastern'
]

const unitOptions = [
  'g',
  'kg',
  'oz',
  'lb',
  'mL',
  'L',
  'tsp',
  'tbsp',
  'cup',
  'pt',
  'qt',
  'gal',
  'each',
  'bunch',
  'slice',
  'clove',
  'pinch'
]

function makeIngredient() {
  return {
    id: crypto.randomUUID(),
    name: '',
    ingredient_id: null,
    quantity: '',
    unit: '',
    suggestions: [],
    loading: false,
    showSuggestions: false,
    searchToken: 0,
    matchLabel: '',
    matchTone: 'text-gray-400'
  }
}

function makeInstruction() {
  return {
    id: crypto.randomUUID(),
    instruction: '',
    ingredientsText: ''
  }
}

const form = reactive({
  title: '',
  description: '',
  meal_type: '',
  cuisine: '',
  cook_time_minutes: '',
  prep_time_minutes: '',
  difficulty: '',
  servings: '',
  thumbnail: null,
  ingredients: [makeIngredient()],
  instructions: [makeInstruction()]
})

const submitError = ref('')
const thumbnailPreview = ref('')

const thumbnailName = computed(() => form.thumbnail?.name ?? '')

function addIngredient() {
  form.ingredients.push(makeIngredient())
}

function removeIngredient(index) {
  if (form.ingredients.length === 1) return
  form.ingredients.splice(index, 1)
}

function addInstruction() {
  form.instructions.push(makeInstruction())
}

function removeInstruction(index) {
  if (form.instructions.length === 1) return
  form.instructions.splice(index, 1)
}

function revokePreview() {
  if (thumbnailPreview.value?.startsWith('blob:')) {
    URL.revokeObjectURL(thumbnailPreview.value)
  }
}

function onThumbnailChange(event) {
  const file = event.target.files?.[0]
  if (!file) return

  form.thumbnail = file
  revokePreview()
  thumbnailPreview.value = URL.createObjectURL(file)
  event.target.value = ''
}

function clearThumbnail() {
  form.thumbnail = null
  revokePreview()
  thumbnailPreview.value = ''
}

function parseStepIngredients(text) {
  return text
    .split(',')
    .map(item => item.trim())
    .filter(Boolean)
}

async function onIngredientInput(ingredient) {
  ingredient.ingredient_id = null
  ingredient.matchLabel = ''
  ingredient.matchTone = 'text-gray-400'

  const query = ingredient.name.trim()
  ingredient.searchToken += 1
  const token = ingredient.searchToken

  if (query.length < 2) {
    ingredient.suggestions = []
    ingredient.showSuggestions = false
    ingredient.loading = false
    return
  }

  ingredient.loading = true
  try {
    const suggestions = await recipes.searchIngredientSuggestions(query)
    if (token !== ingredient.searchToken) return

    ingredient.suggestions = suggestions
    ingredient.showSuggestions = true

    const exact = suggestions.find(item => item.name.toLowerCase() === query.toLowerCase())
    if (exact) {
      ingredient.ingredient_id = exact.ingredient_id
      ingredient.name = exact.name
      ingredient.matchLabel = 'Matched from your ingredient list'
      ingredient.matchTone = 'text-emerald-600'
    }
  } catch {
    if (token !== ingredient.searchToken) return
    ingredient.suggestions = []
  } finally {
    if (token === ingredient.searchToken) ingredient.loading = false
  }
}

function onIngredientFocus(ingredient) {
  if (ingredient.suggestions.length > 0) ingredient.showSuggestions = true
}

function onIngredientBlur(ingredient) {
  window.setTimeout(async () => {
    ingredient.showSuggestions = false

    const query = ingredient.name.trim()
    if (!query || ingredient.ingredient_id) return

    try {
      const { ingredient: match, inferred } = await recipes.resolveIngredientMatch(query)
      if (!match) return

      ingredient.ingredient_id = match.ingredient_id
      ingredient.name = match.name
      ingredient.matchLabel = inferred ? `Using "${match.name}" from the ingredient list` : 'Matched from your ingredient list'
      ingredient.matchTone = inferred ? 'text-amber-600' : 'text-emerald-600'
    } catch {
      ingredient.matchLabel = ''
    }
  }, 120)
}

function selectIngredientSuggestion(target, suggestion) {
  target.ingredient_id = suggestion.ingredient_id
  target.name = suggestion.name
  target.suggestions = []
  target.showSuggestions = false
  target.matchLabel = 'Matched from your ingredient list'
  target.matchTone = 'text-emerald-600'
}

function buildPayload() {
  const ingredients = form.ingredients
    .map(item => ({
      ingredient_id: item.ingredient_id,
      name: item.name.trim(),
      quantity: item.quantity,
      unit: item.unit
    }))
    .filter(item => item.name)

  const instructions = form.instructions
    .map(step => ({
      instruction: step.instruction.trim(),
      ingredients: parseStepIngredients(step.ingredientsText)
    }))
    .filter(step => step.instruction)

  if (!form.title.trim()) throw new Error('Add a recipe title before publishing.')
  if (!form.meal_type) throw new Error('Choose a meal type.')
  if (!mealTypes.includes(form.meal_type)) throw new Error('Choose a valid meal type.')
  if (!form.difficulty) throw new Error('Choose a difficulty level.')
  if (form.cuisine && !cuisineTypes.includes(form.cuisine)) throw new Error('Choose a valid cuisine.')
  if (ingredients.length === 0) throw new Error('Add at least one ingredient.')
  if (instructions.length === 0) throw new Error('Add at least one instruction step.')
  if (ingredients.some(item => item.unit && !unitOptions.includes(item.unit))) {
    throw new Error('Choose a valid unit for each ingredient.')
  }

  return {
    title: form.title,
    description: form.description,
    meal_type: form.meal_type,
    cuisine: form.cuisine,
    cook_time_minutes: form.cook_time_minutes ? Number(form.cook_time_minutes) : null,
    prep_time_minutes: form.prep_time_minutes ? Number(form.prep_time_minutes) : null,
    difficulty: form.difficulty,
    servings: form.servings ? Number(form.servings) : null,
    ingredients,
    instructions,
    thumbnail: form.thumbnail
  }
}

async function submitRecipe() {
  submitError.value = ''

  try {
    const recipeId = await recipes.createRecipe(buildPayload())
    router.push(`/recipe/${recipeId}`)
  } catch (err) {
    submitError.value = err.message || 'Something went wrong while publishing your recipe.'
  }
}

onBeforeUnmount(() => revokePreview())
</script>
