<template>
  <header class="sticky top-0 z-50 bg-[#0B0F19]/80 backdrop-blur-xl border-b border-white/10 transition-all">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-20">
        
        <!-- Brand / Logo BanApp -->
        <router-link to="/" class="flex items-center gap-3.5 group">
          <div class="relative">
            <div class="w-11 h-11 rounded-2xl overflow-hidden shadow-[0_0_20px_rgba(234,179,8,0.4)] group-hover:shadow-[0_0_25px_rgba(234,179,8,0.6)] transition-all">
              <img src="/banapp_logo.svg" alt="BanApp Logo" class="w-full h-full object-cover"/>
            </div>
            <span class="absolute -bottom-1 -right-1 flex h-3.5 w-3.5">
              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
              <span class="relative inline-flex rounded-full h-3.5 w-3.5 bg-amber-400 border-2 border-[#0B0F19]"></span>
            </span>
          </div>

          <div>
            <div class="flex items-center gap-2">
              <span class="font-heading font-black text-lg sm:text-xl tracking-tight text-white group-hover:text-amber-400 transition-colors">
                BanApp
              </span>
              <span class="text-[10px] font-black uppercase tracking-wider px-2 py-0.5 rounded-full bg-amber-400/20 text-amber-300 border border-amber-400/30">
                UNICEF RDC
              </span>
            </div>
            <div class="text-[11px] text-slate-400 font-medium hidden sm:flex items-center gap-2">
              <span>Engagement & Enfants Reporters</span>
              <span class="text-slate-600">•</span>
              <span class="text-amber-400 text-[10px] font-bold">2025–2029</span>
            </div>
          </div>
        </router-link>

        <!-- Main Desktop Navigation Links -->
        <nav class="hidden lg:flex items-center gap-1.5 p-1 rounded-2xl bg-white/[0.03] border border-white/5 backdrop-blur-md">
          <router-link to="/" active-class="!bg-gradient-to-r !from-[#00ADEF] !to-[#0072F5] !text-white !font-bold shadow-[0_0_18px_rgba(0,173,239,0.45)]" class="px-3.5 py-2 rounded-xl text-xs font-semibold text-slate-300 hover:text-white hover:bg-white/5 transition-all">
            {{ t('navHome') }}
          </router-link>
          <router-link to="/inscription" active-class="!bg-gradient-to-r !from-[#00ADEF] !to-[#0072F5] !text-white !font-bold shadow-[0_0_18px_rgba(0,173,239,0.45)]" class="px-3.5 py-2 rounded-xl text-xs font-semibold text-slate-300 hover:text-white hover:bg-white/5 transition-all">
            {{ t('navRegister') }}
          </router-link>
          <router-link to="/consentement" active-class="!bg-gradient-to-r !from-[#00ADEF] !to-[#0072F5] !text-white !font-bold shadow-[0_0_18px_rgba(0,173,239,0.45)]" class="px-3.5 py-2 rounded-xl text-xs font-semibold text-slate-300 hover:text-white hover:bg-white/5 transition-all">
            {{ t('navConsent') }}
          </router-link>
          <router-link to="/formation" active-class="!bg-gradient-to-r !from-[#00ADEF] !to-[#0072F5] !text-white !font-bold shadow-[0_0_18px_rgba(0,173,239,0.45)]" class="px-3.5 py-2 rounded-xl text-xs font-semibold text-slate-300 hover:text-white hover:bg-white/5 transition-all">
            {{ t('navTraining') }}
          </router-link>
          <router-link to="/espace-reporter" active-class="!bg-gradient-to-r !from-[#00ADEF] !to-[#0072F5] !text-white !font-bold shadow-[0_0_18px_rgba(0,173,239,0.45)]" class="px-3.5 py-2 rounded-xl text-xs font-semibold text-slate-300 hover:text-white hover:bg-white/5 transition-all">
            {{ t('navReporter') }}
          </router-link>
          <router-link to="/terrain" active-class="!bg-gradient-to-r !from-[#00ADEF] !to-[#0072F5] !text-white !font-bold shadow-[0_0_18px_rgba(0,173,239,0.45)]" class="px-3.5 py-2 rounded-xl text-xs font-semibold text-slate-300 hover:text-white hover:bg-white/5 transition-all">
            {{ t('navField') }}
          </router-link>
          <router-link to="/ponabana" active-class="!bg-gradient-to-r !from-[#00ADEF] !to-[#0072F5] !text-white !font-bold shadow-[0_0_18px_rgba(0,173,239,0.45)]" class="px-3.5 py-2 rounded-xl text-xs font-semibold text-slate-300 hover:text-white hover:bg-white/5 transition-all">
            Ponabana
          </router-link>
          <router-link to="/dashboard" active-class="!bg-gradient-to-r !from-[#00ADEF] !to-[#0072F5] !text-white !font-bold shadow-[0_0_18px_rgba(0,173,239,0.45)]" class="px-3.5 py-2 rounded-xl text-xs font-semibold text-slate-300 hover:text-white hover:bg-white/5 transition-all">
            {{ t('navDashboard') }}
          </router-link>
          <router-link to="/admin" active-class="!bg-gradient-to-r !from-[#00ADEF] !to-[#0072F5] !text-white !font-bold shadow-[0_0_18px_rgba(0,173,239,0.45)]" class="px-3.5 py-2 rounded-xl text-xs font-semibold text-slate-300 hover:text-white hover:bg-white/5 transition-all">
            {{ t('navAdmin') }}
          </router-link>
        </nav>

        <!-- Actions / Controls -->
        <div class="flex items-center gap-2.5 sm:gap-3">
          
          <!-- Emergency Safeguard 24/7 Button (Prominent Glowing Pulse) -->
          <button @click="store.toggleSafeguardModal(true)" class="relative group px-3.5 py-2 rounded-xl bg-gradient-to-r from-[#FF5C67]/20 to-rose-600/20 border border-[#FF5C67]/40 text-[#FF5C67] hover:border-[#FF5C67] text-xs font-bold transition-all flex items-center gap-2 shadow-[0_0_15px_rgba(255,92,103,0.2)]">
            <span class="flex h-2 w-2 relative">
              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-[#FF5C67] opacity-75"></span>
              <span class="relative inline-flex rounded-full h-2 w-2 bg-[#FF5C67]"></span>
            </span>
            <span class="text-sm">🛡️</span>
            <span class="hidden sm:inline">Alerte 24/7</span>
          </button>

          <!-- Language Selector -->
          <div class="relative">
            <select :value="store.currentLanguage" @change="store.setLanguage($event.target.value)" class="!bg-[#131A2B] !border-white/10 text-slate-200 text-xs rounded-xl px-2.5 py-2 font-medium focus:!border-[#00ADEF] cursor-pointer">
              <option v-for="lang in store.db.languages" :key="lang.code" :value="lang.code" class="bg-[#131A2B] text-white">
                {{ lang.flag }} {{ lang.nom }}
              </option>
            </select>
          </div>

          <!-- Role Selector -->
          <div class="relative hidden sm:block">
            <select :value="store.currentRole" @change="store.setRole($event.target.value)" class="!bg-[#131A2B] !border-[#00ADEF]/30 text-[#00ADEF] text-xs rounded-xl px-2.5 py-2 font-bold focus:!border-[#00ADEF] cursor-pointer">
              <option v-for="role in store.db.roles" :key="role.id" :value="role.id" class="bg-[#131A2B] text-white">
                👤 {{ role.nom }}
              </option>
            </select>
          </div>

        </div>

      </div>

      <!-- Mobile Sub-navigation Bar -->
      <div class="lg:hidden flex items-center gap-2 overflow-x-auto py-2.5 border-t border-white/5 text-xs no-scrollbar">
        <router-link to="/" active-class="!bg-[#00ADEF] !text-white !font-bold" class="px-3 py-1.5 rounded-lg whitespace-nowrap bg-white/5 text-slate-300 font-medium">Accueil</router-link>
        <router-link to="/inscription" active-class="!bg-[#00ADEF] !text-white !font-bold" class="px-3 py-1.5 rounded-lg whitespace-nowrap bg-white/5 text-slate-300 font-medium">Inscription</router-link>
        <router-link to="/consentement" active-class="!bg-[#00ADEF] !text-white !font-bold" class="px-3 py-1.5 rounded-lg whitespace-nowrap bg-white/5 text-slate-300 font-medium">Consentement</router-link>
        <router-link to="/formation" active-class="!bg-[#00ADEF] !text-white !font-bold" class="px-3 py-1.5 rounded-lg whitespace-nowrap bg-white/5 text-slate-300 font-medium">Formation</router-link>
        <router-link to="/espace-reporter" active-class="!bg-[#00ADEF] !text-white !font-bold" class="px-3 py-1.5 rounded-lg whitespace-nowrap bg-white/5 text-slate-300 font-medium">Reporter</router-link>
        <router-link to="/terrain" active-class="!bg-[#00ADEF] !text-white !font-bold" class="px-3 py-1.5 rounded-lg whitespace-nowrap bg-white/5 text-slate-300 font-medium">Terrain</router-link>
        <router-link to="/ponabana" active-class="!bg-[#00ADEF] !text-white !font-bold" class="px-3 py-1.5 rounded-lg whitespace-nowrap bg-white/5 text-slate-300 font-medium">Ponabana</router-link>
        <router-link to="/dashboard" active-class="!bg-[#00ADEF] !text-white !font-bold" class="px-3 py-1.5 rounded-lg whitespace-nowrap bg-white/5 text-slate-300 font-medium">Dashboard</router-link>
        <router-link to="/admin" active-class="!bg-[#00ADEF] !text-white !font-bold" class="px-3 py-1.5 rounded-lg whitespace-nowrap bg-white/5 text-slate-300 font-medium">Admin</router-link>
      </div>

    </div>
  </header>
</template>

<script setup>
import { useAppStore } from '../mock/store'
import { TRANSLATIONS } from '../mock/i18n'

const store = useAppStore()

function t(key) {
  const lang = store.currentLanguage || 'fr'
  return (TRANSLATIONS[lang] && TRANSLATIONS[lang][key]) || TRANSLATIONS.fr[key] || key
}
</script>
