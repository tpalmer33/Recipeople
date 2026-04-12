<template>
  <div class="page-container">
    <h1 class="text-2xl font-bold text-gray-900 mb-6">Settings</h1>

    <!-- Avatar section -->
    <div class="card p-5 mb-4">
      <div class="flex items-center gap-4">
        <label class="cursor-pointer group relative">
          <div class="w-20 h-20 rounded-full overflow-hidden bg-brand-100 flex items-center justify-center ring-2 ring-brand-200 group-hover:ring-brand-400 transition-all">
            <img
              v-if="auth.profile?.avatar"
              :src="auth.profile.avatar"
              :alt="auth.profile?.username"
              class="w-full h-full object-cover"
            />
            <span v-else class="text-brand-600 font-bold text-2xl">{{ initials }}</span>
          </div>
          <div class="absolute inset-0 bg-black/30 rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"/>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"/>
            </svg>
          </div>
          <input
            type="file"
            accept="image/*"
            class="hidden"
            @change="onAvatarChange"
          />
        </label>

        <div>
          <p class="font-bold text-gray-900">{{ auth.profile?.fname }} {{ auth.profile?.lname }}</p>
          <p class="text-sm text-gray-500">@{{ auth.profile?.username }}</p>
          <p class="text-xs text-brand-500 mt-1">Tap photo to change</p>
        </div>
      </div>
      <div v-if="avatarLoading" class="mt-3 flex items-center gap-2 text-sm text-gray-400">
        <LoadingSpinner size="sm" color="gray" /> Uploading…
      </div>
    </div>

    <!-- Profile section -->
    <div class="card p-5 mb-4">
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-base font-bold text-gray-900">Profile</h2>
        <button
          v-if="!editingProfile"
          @click="startEditProfile"
          class="text-sm text-brand-600 font-semibold hover:underline"
        >Edit</button>
      </div>

      <form v-if="editingProfile" @submit.prevent="saveProfile" class="space-y-3">
        <div class="grid grid-cols-2 gap-3">
          <div>
            <label class="text-xs font-medium text-gray-500 mb-1 block">First name</label>
            <input v-model="profileForm.fname" type="text" required class="input-field text-sm" />
          </div>
          <div>
            <label class="text-xs font-medium text-gray-500 mb-1 block">Last name</label>
            <input v-model="profileForm.lname" type="text" required class="input-field text-sm" />
          </div>
        </div>
        <div>
          <label class="text-xs font-medium text-gray-500 mb-1 block">Middle initial</label>
          <input v-model="profileForm.middle_init" type="text" maxlength="1" class="input-field text-sm" />
        </div>
        <div>
          <label class="text-xs font-medium text-gray-500 mb-1 block">Username</label>
          <input v-model="profileForm.username" type="text" minlength="6" required class="input-field text-sm" />
        </div>

        <div v-if="profileError" class="text-sm text-red-500">{{ profileError }}</div>

        <div class="flex gap-2 pt-1">
          <button type="button" @click="editingProfile = false" class="btn-secondary flex-1 text-sm">Cancel</button>
          <button type="submit" :disabled="profileLoading" class="btn-primary flex-1 text-sm flex items-center justify-center gap-2">
            <LoadingSpinner v-if="profileLoading" size="sm" color="white" />
            <span>Save</span>
          </button>
        </div>
      </form>

      <div v-else class="space-y-3 text-sm">
        <div class="flex justify-between">
          <span class="text-gray-400">Name</span>
          <span class="text-gray-800 font-medium">{{ auth.profile?.fname }} {{ auth.profile?.middle_init ? auth.profile.middle_init + '. ' : '' }}{{ auth.profile?.lname }}</span>
        </div>
        <div class="flex justify-between">
          <span class="text-gray-400">Username</span>
          <span class="text-gray-800 font-medium">@{{ auth.profile?.username }}</span>
        </div>
        <div class="flex justify-between">
          <span class="text-gray-400">Email</span>
          <span class="text-gray-800 font-medium">{{ auth.profile?.email }}</span>
        </div>
        <div class="flex justify-between">
          <span class="text-gray-400">Member since</span>
          <span class="text-gray-800 font-medium">{{ memberSince }}</span>
        </div>
      </div>
    </div>

    <!-- Security section -->
    <div class="card p-5 mb-4">
      <h2 class="text-base font-bold text-gray-900 mb-4">Security</h2>

      <button @click="showPasswordModal = true" class="w-full text-left flex items-center justify-between py-2">
        <div class="flex items-center gap-3">
          <div class="w-8 h-8 rounded-lg bg-gray-100 flex items-center justify-center flex-shrink-0">
            <svg class="w-4 h-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
            </svg>
          </div>
          <span class="text-sm font-medium text-gray-700">Change password</span>
        </div>
        <svg class="w-4 h-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
        </svg>
      </button>
    </div>

    <!-- Danger zone -->
    <div class="card p-5 mb-4 border border-red-100">
      <h2 class="text-base font-bold text-red-600 mb-3">Danger Zone</h2>
      <button
        @click="showDeleteModal = true"
        class="w-full text-left flex items-center gap-3 py-2"
      >
        <div class="w-8 h-8 rounded-lg bg-red-50 flex items-center justify-center flex-shrink-0">
          <svg class="w-4 h-4 text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
          </svg>
        </div>
        <span class="text-sm font-medium text-red-500">Delete account</span>
      </button>
    </div>

    <!-- Sign out -->
    <button @click="onLogout" class="btn-secondary w-full flex items-center justify-center gap-2">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
      </svg>
      <span>Sign Out</span>
    </button>

    <!-- Change password modal -->
    <AppModal v-model="showPasswordModal" title="Change Password">
      <form @submit.prevent="changePassword" class="space-y-3">
        <div>
          <label class="text-sm font-medium text-gray-700 mb-1 block">New password</label>
          <input
            v-model="passwordForm.newPassword"
            type="password"
            required
            minlength="8"
            placeholder="Min. 8 characters"
            class="input-field"
          />
        </div>
        <div>
          <label class="text-sm font-medium text-gray-700 mb-1 block">Confirm password</label>
          <input
            v-model="passwordForm.confirmPassword"
            type="password"
            required
            placeholder="Re-enter new password"
            class="input-field"
            :class="{ 'ring-2 ring-red-400': passwordForm.confirmPassword && passwordForm.newPassword !== passwordForm.confirmPassword }"
          />
        </div>
        <div v-if="passwordError" class="text-sm text-red-500">{{ passwordError }}</div>
        <div class="flex gap-2 pt-1">
          <button type="button" @click="showPasswordModal = false" class="btn-secondary flex-1">Cancel</button>
          <button
            type="submit"
            :disabled="passwordLoading || passwordForm.newPassword !== passwordForm.confirmPassword"
            class="btn-primary flex-1 flex items-center justify-center gap-2"
          >
            <LoadingSpinner v-if="passwordLoading" size="sm" color="white" />
            <span>Update</span>
          </button>
        </div>
      </form>
    </AppModal>

    <!-- Delete account modal -->
    <AppModal v-model="showDeleteModal" title="Delete Account">
      <div class="text-center mb-5">
        <div class="w-14 h-14 mx-auto mb-3 rounded-full bg-red-50 flex items-center justify-center">
          <svg class="w-7 h-7 text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
          </svg>
        </div>
        <p class="text-gray-700 font-medium">Are you sure you want to delete your account?</p>
        <p class="text-sm text-gray-400 mt-1">This action is permanent and cannot be undone. All your data will be lost.</p>
      </div>
      <div class="flex gap-2">
        <button @click="showDeleteModal = false" class="btn-secondary flex-1">Cancel</button>
        <button @click="deleteAccount" :disabled="deleteLoading" class="btn-danger flex-1 flex items-center justify-center gap-2">
          <LoadingSpinner v-if="deleteLoading" size="sm" color="white" />
          <span>Delete</span>
        </button>
      </div>
    </AppModal>

    <!-- Toast -->
    <Transition name="fade">
      <div
        v-if="toast"
        class="fixed bottom-24 left-1/2 -translate-x-1/2 bg-green-500 text-white text-sm font-medium px-4 py-2.5 rounded-xl shadow-lg z-50 whitespace-nowrap"
      >
        {{ toast }}
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import AppModal from '@/components/ui/AppModal.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'

const auth   = useAuthStore()
const router = useRouter()

const initials = computed(() => {
  if (!auth.profile) return '?'
  return `${auth.profile.fname?.[0] ?? ''}${auth.profile.lname?.[0] ?? ''}`.toUpperCase()
})

const memberSince = computed(() => {
  if (!auth.profile?.created_at) return '—'
  return new Date(auth.profile.created_at).toLocaleDateString('en-US', { month: 'long', year: 'numeric' })
})

const editingProfile = ref(false)
const profileLoading = ref(false)
const profileError   = ref('')
const profileForm    = reactive({ fname: '', lname: '', middle_init: '', username: '' })

function startEditProfile() {
  profileForm.fname       = auth.profile?.fname       ?? ''
  profileForm.lname       = auth.profile?.lname       ?? ''
  profileForm.middle_init = auth.profile?.middle_init ?? ''
  profileForm.username    = auth.profile?.username    ?? ''
  editingProfile.value    = true
  profileError.value      = ''
}

async function saveProfile() {
  profileLoading.value = true
  profileError.value   = ''
  try {
    await auth.updateProfile(profileForm)
    editingProfile.value = false
    showToast('Profile updated')
  } catch (err) {
    profileError.value = err.message
  } finally {
    profileLoading.value = false
  }
}

const avatarLoading = ref(false)
async function onAvatarChange(e) {
  const file = e.target.files?.[0]
  if (!file) return
  avatarLoading.value = true
  try {
    await auth.uploadAvatar(file)
    showToast('Avatar updated')
  } catch (err) {
    showToast('Failed to upload avatar: ' + err.message)
  } finally {
    avatarLoading.value = false
    e.target.value = ''
  }
}

const showPasswordModal = ref(false)
const passwordLoading   = ref(false)
const passwordError     = ref('')
const passwordForm      = reactive({ newPassword: '', confirmPassword: '' })

async function changePassword() {
  if (passwordForm.newPassword !== passwordForm.confirmPassword) return
  passwordLoading.value = true
  passwordError.value   = ''
  try {
    await auth.changePassword(passwordForm.newPassword)
    showPasswordModal.value  = false
    passwordForm.newPassword = ''
    passwordForm.confirmPassword = ''
    showToast('Password updated')
  } catch (err) {
    passwordError.value = err.message
  } finally {
    passwordLoading.value = false
  }
}

const showDeleteModal = ref(false)
const deleteLoading   = ref(false)

async function deleteAccount() {
  deleteLoading.value = true
  try {
    await auth.deleteAccount()
    router.push('/login')
  } catch (err) {
    showDeleteModal.value = false
    showToast('Error: ' + err.message)
  } finally {
    deleteLoading.value = false
  }
}

async function onLogout() {
  await auth.logout()
  router.push('/login')
}

const toast = ref('')
function showToast(msg) {
  toast.value = msg
  setTimeout(() => toast.value = '', 3000)
}

onMounted(() => {
  if (!auth.profile) auth.fetchProfile()
})
</script>

<style scoped>
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
