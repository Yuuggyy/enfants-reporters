<template>
  <div class="min-h-screen bg-[#090D16] text-slate-100 flex flex-col font-sans antialiased relative selection:bg-[#00ADEF] selection:text-white">
    
    <!-- Ambient Glowing Orbs Background (Pulse Aesthetics) -->
    <div class="fixed inset-0 overflow-hidden pointer-events-none z-0">
      <div class="absolute -top-40 -left-40 w-96 h-96 bg-[#00ADEF]/20 rounded-full blur-[120px] animate-pulse-slow"></div>
      <div class="absolute top-1/3 -right-40 w-[30rem] h-[30rem] bg-[#0072F5]/15 rounded-full blur-[140px] animate-pulse-slow" style="animation-delay: 3s;"></div>
      <div class="absolute -bottom-40 left-1/3 w-96 h-96 bg-[#8B5CF6]/15 rounded-full blur-[130px] animate-pulse-slow" style="animation-delay: 5s;"></div>
      <div class="absolute inset-0 bg-[radial-gradient(#ffffff0a_1px,transparent_1px)] [background-size:24px_24px] opacity-40"></div>
    </div>

    <!-- Navigation Header -->
    <Navbar />
    
    <!-- Main Content Area -->
    <main class="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8 relative z-10">
      <router-view />
    </main>

    <!-- Global Safeguard Emergency Modal (24/7 Hotline) -->
    <SafeguardModal />

    <!-- Modern Footer -->
    <footer class="relative z-10 border-t border-white/10 bg-[#0B0F19]/80 backdrop-blur-xl py-8 text-xs text-slate-400 mt-12">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col md:flex-row items-center justify-between gap-6">
        
        <div class="flex items-center gap-3">
          <div class="w-8 h-8 rounded-xl bg-gradient-to-br from-[#00ADEF] to-[#0072F5] flex items-center justify-center text-white font-black text-sm shadow-md">
            U
          </div>
          <div>
            <div class="font-bold text-slate-200 flex items-center gap-2">
              <span>UNICEF République Démocratique du Congo</span>
              <span class="text-[10px] font-black uppercase tracking-wider px-2 py-0.5 rounded-full bg-[#00ADEF]/15 text-[#00ADEF] border border-[#00ADEF]/30">CPD 2025–2029</span>
            </div>
            <div class="text-[11px] text-slate-400">
              En partenariat avec le REIPE & les Ministères du Genre, Affaires Sociales et Éducation
            </div>
          </div>
        </div>

        <div class="flex flex-wrap items-center justify-center gap-4 text-xs">
          <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-white/5 border border-white/10 text-slate-300">
            <span class="w-2 h-2 rounded-full bg-[#00ADEF] animate-ping"></span>
            Mock DB Réactive Locale
          </span>
          <span class="hover:text-[#00ADEF] transition-colors cursor-pointer">Protection des Données (Minimisation & Pseudonymisation)</span>
          <span class="hover:text-[#00ADEF] transition-colors cursor-pointer">Biens Publics Numériques</span>
        </div>

      </div>
    </footer>
  </div>
</template>

<script setup>
import Navbar from './components/Navbar.vue'
import SafeguardModal from './components/SafeguardModal.vue'
</script>
