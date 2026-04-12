<template>
  <nav class="fixed bottom-0 left-0 right-0 z-40 bg-white border-t border-gray-100 safe-area-bottom">
    <div class="max-w-lg mx-auto flex">
      <RouterLink
        v-for="item in navItems"
        :key="item.to"
        :to="item.to"
        class="flex-1 flex flex-col items-center justify-center py-2.5 gap-0.5 transition-colors"
        :class="isActive(item.to) ? 'text-brand-500' : 'text-gray-400 hover:text-gray-600'"
      >
        <component :is="item.icon" class="w-5 h-5" :active="isActive(item.to)" />
        <span class="text-[10px] font-medium leading-none">{{ item.label }}</span>
      </RouterLink>
    </div>
  </nav>
</template>

<script setup>
import { RouterLink, useRoute } from 'vue-router'
import { defineComponent, h } from 'vue'

const route = useRoute()

function isActive(path) {
  return route.path === path || route.path.startsWith(path + '/')
}

const IconHome = defineComponent({
  props: { active: Boolean },
  setup(props) {
    return () => props.active
      ? h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
          h('path', { d: 'M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z' })
        ])
      : h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
          h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6' })
        ])
  }
})

const IconSearch = defineComponent({
  props: { active: Boolean },
  setup(props) {
    return () => props.active
      ? h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
          h('path', { 'fill-rule': 'evenodd', 'clip-rule': 'evenodd', d: 'M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z' })
        ])
      : h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
          h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z' })
        ])
  }
})

const IconPantry = defineComponent({
  props: { active: Boolean },
  setup(props) {
    return () => props.active
      ? h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
          h('path', { d: 'M3 6a1 1 0 000 2h1l1.5 9A1 1 0 006.5 18h11a1 1 0 00.986-.836L20 8h1a1 1 0 000-2H3z' }),
          h('path', { 'fill-rule': 'evenodd', 'clip-rule': 'evenodd', d: 'M8 4a1 1 0 00-1 1v1H5a1 1 0 000 2h14a1 1 0 000-2h-2V5a1 1 0 00-1-1H8zm1 2V5h6v1H9z' })
        ])
      : h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
          h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z' })
        ])
  }
})

const IconHeart = defineComponent({
  props: { active: Boolean },
  setup(props) {
    return () => props.active
      ? h('svg', { fill: 'currentColor', viewBox: '0 0 24 24' }, [
          h('path', { d: 'M3.172 5.172a4 4 0 015.656 0L12 8.343l3.172-3.171a4 4 0 115.656 5.656L12 19.657l-8.828-8.829a4 4 0 010-5.656z' })
        ])
      : h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
          h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z' })
        ])
  }
})

const IconSettings = defineComponent({
  props: { active: Boolean },
  setup() {
    return () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z' }),
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M15 12a3 3 0 11-6 0 3 3 0 016 0z' })
    ])
  }
})

const navItems = [
  { to: '/feed',      icon: IconHome,     label: 'Feed'      },
  { to: '/search',    icon: IconSearch,   label: 'Search'    },
  { to: '/pantry',    icon: IconPantry,   label: 'Pantry'    },
  { to: '/favorites', icon: IconHeart,    label: 'Favorites' },
  { to: '/settings',  icon: IconSettings, label: 'Settings'  },
]
</script>
