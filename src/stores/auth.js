import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'

export const useAuthStore = defineStore('auth', () => {
  const session = ref(null)
  const profile = ref(null)
  const loading = ref(true)

  const user = computed(() => session.value?.user ?? null)
  const isAuthenticated = computed(() => !!session.value)

  async function init() {
    loading.value = true
    const { data } = await supabase.auth.getSession()
    session.value = data.session
    if (session.value) await fetchProfile()

    supabase.auth.onAuthStateChange(async (event, newSession) => {
      if (event === 'SIGNED_OUT') {
        session.value = null
        profile.value = null
        return
      }
      if (event === 'TOKEN_REFRESHED') {
        // Only update the token — user and profile haven't changed
        session.value = newSession
        return
      }
      if (newSession) {
        const userChanged = session.value?.user?.id !== newSession.user.id
        session.value = newSession
        if (userChanged || !profile.value) {
          await fetchProfile()
        }
      }
    })
    loading.value = false
  }

  async function fetchProfile() {
    if (!user.value) return
    const { data, error } = await supabase
      .from('users')
      .select('user_id, email, username, fname, lname, middle_init, avatar, created_at')
      .eq('user_id', user.value.id)
      .single()

    if (!error) profile.value = data
  }

  async function login(email, password) {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) throw error
    session.value = data.session
    await fetchProfile()
    return data
  }

  async function signup({ email, password, username, fname, lname, middle_init }) {
    // Pass profile fields as metadata so the database trigger can create
    // the public.users row automatically (handles dashboard signups too).
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: { username, fname, lname, middle_init: middle_init || null }
      }
    })
    if (error) throw error

    // Trigger fires async — wait briefly then fetch the created profile
    await new Promise(resolve => setTimeout(resolve, 500))
    session.value = data.session
    await fetchProfile()
    return data
  }

  async function logout() {
    await supabase.auth.signOut()
    session.value = null
    profile.value = null
  }

  async function updateProfile(updates) {
    if (!user.value) return
    const { data, error } = await supabase
      .from('users')
      .update({ ...updates, updated_at: new Date().toISOString() })
      .eq('user_id', user.value.id)
      .select()
      .single()
    if (error) throw error
    profile.value = data
    return data
  }

  async function uploadAvatar(file) {
    if (!user.value) return
    const ext = file.name.split('.').pop()
    const path = `avatars/${user.value.id}.${ext}`

    const { error: uploadError } = await supabase.storage
      .from('avatars')
      .upload(path, file, { upsert: true })
    if (uploadError) {
      // Log the error to the terminal
      // eslint-disable-next-line no-console
      console.error('Avatar upload error:', uploadError)
      throw uploadError
    }

    const { data: urlData } = supabase.storage.from('avatars').getPublicUrl(path)
    await updateProfile({ avatar: urlData.publicUrl })
    return urlData.publicUrl
  }

  async function changePassword(newPassword) {
    const { error } = await supabase.auth.updateUser({ password: newPassword })
    if (error) throw error
  }

  async function deleteAccount() {
    if (!user.value) return
    // Delete profile row — cascade should handle related rows
    await supabase.from('users').delete().eq('user_id', user.value.id)
    await supabase.auth.signOut()
    session.value = null
    profile.value = null
  }

  return {
    session,
    profile,
    loading,
    user,
    isAuthenticated,
    init,
    fetchProfile,
    login,
    signup,
    logout,
    updateProfile,
    uploadAvatar,
    changePassword,
    deleteAccount
  }
})
