<template>
  <!-- 
    =============================================================================================
    ÉCOSYSTÈME DIGITAL UNICEF RDC : ENGAGEMENT DES ADOLESCENTS & ENFANTS REPORTERS (CPD 2025–2029)
    
    [CARTOGRAPHIE DES DÉPENDANCES ET LIVRABLES ATTENDUS DE L'UNICEF] :
    - Module 1 (Inscription) : Clés API RapidPro U-Report RDC (WhatsApp) & Accords passerelles SMS/USSD Télécoms.
    - Module 2 (Consentement) : Mentions légales de consentement validées PSE et traductions en 4 langues nationales.
    - Module 3 (Formation) : Contenus pédagogiques finaux, scripts narratifs, vidéos 240p et audios officiels.
    - Module 4 (Terrain) : Serveur KoboToolbox UNICEF et schémas XLSForms de collecte terrain.
    - Module 5 (Ponabana) : Endpoint REST API WordPress Ponabana et clés d'application de production.
    - Module 6 (Dashboard) : Liste définitive des indicateurs clés UNICEF (Annexe 6) et flux analytics.
    - Module 7 (Admin) : Authentification SSO/2FA Azure AD UNICEF et annuaire chiffré des points focaux 24h.
    
    L'intégralité du frontend est connectée à la base de données réactive mockée locale et optimisée pour mobile 2G/3G.
    =============================================================================================
  -->
  <div class="space-y-6 sm:space-y-10 pb-16 px-2 sm:px-4">
    
    <!-- Hero Banner with Pulse Hub Aesthetics -->
    <div class="relative overflow-hidden rounded-3xl bg-gradient-to-br from-[#131A2B] via-[#0F172A] to-[#0B0F19] border border-white/10 p-6 sm:p-12 shadow-2xl">
      <!-- Ambient Glows -->
      <div class="absolute -right-20 -top-20 w-80 h-80 bg-[#00ADEF]/25 rounded-full blur-3xl pointer-events-none"></div>
      <div class="absolute -left-20 -bottom-20 w-80 h-80 bg-[#0072F5]/20 rounded-full blur-3xl pointer-events-none"></div>

      <div class="relative z-10 max-w-3xl space-y-5">
        
        <div class="inline-flex items-center gap-2.5 px-3.5 py-1.5 rounded-full bg-white/[0.06] border border-white/10 text-xs font-bold text-slate-200 backdrop-blur-md">
          <span class="flex h-2 w-2 relative">
            <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
            <span class="relative inline-flex rounded-full h-2 w-2 bg-amber-400"></span>
          </span>
          <span class="text-amber-400">BanApp RDC</span>
          <span class="text-slate-500">•</span>
          <span>UNICEF Programme Pays 2025–2029</span>
        </div>

        <h1 class="text-3xl sm:text-5xl font-black font-heading tracking-tight text-white leading-tight">
          Façonne l'Avenir, <br class="hidden sm:inline" />
          <span class="bg-gradient-to-r from-[#00ADEF] via-sky-300 to-[#38BDF8] bg-clip-text text-transparent">
            Fais Entendre Ta Voix !
          </span>
        </h1>

        <p class="text-sm sm:text-base text-slate-300 leading-relaxed font-normal max-w-2xl">
          L'écosystème digital officiel d'engagement des adolescents de 12 à 17 ans et des Enfants Reporters en RDC. Forme-toi, obtiens ton certificat officiel, rejoins ta communauté locale et publie tes reportages.
        </p>

        <div class="flex flex-wrap items-center gap-3.5 pt-3">
          <router-link to="/inscription" class="btn-primary">
            <span>🚀 Inscription Multicanale</span>
          </router-link>
          <router-link to="/formation" class="btn-cyan">
            <span>🎓 Académie des Droits</span>
          </router-link>
          <router-link to="/espace-reporter" class="btn-secondary">
            <span>📸 Studio Reporter</span>
          </router-link>
        </div>

      </div>
    </div>

    <!-- Live Youth Profile & XP Status Widget -->
    <div class="p-6 rounded-3xl bg-gradient-to-r from-white/[0.05] to-white/[0.02] border border-white/10 backdrop-blur-xl">
      <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
        
        <div class="flex items-center gap-4">
          <div class="relative">
            <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-[#00ADEF] to-[#0072F5] p-0.5 shadow-[0_0_15px_rgba(0,173,239,0.3)]">
              <div class="w-full h-full bg-[#0B0F19] rounded-[14px] flex items-center justify-center font-heading font-black text-xl text-white">
                {{ store.currentAdo.prenom.charAt(0) }}
              </div>
            </div>
            <span class="absolute -bottom-1 -right-1 px-1.5 py-0.5 rounded-full bg-[#00ADEF] text-white text-[10px] font-black">
              {{ store.currentAdo.age }} ans
            </span>
          </div>

          <div>
            <div class="flex items-center gap-2">
              <h3 class="font-heading font-black text-lg text-white">{{ store.currentAdo.prenom }} {{ store.currentAdo.nomFamillePseudonymise }}</h3>
              <span class="px-2.5 py-0.5 rounded-full bg-[#00ADEF]/20 text-[#00ADEF] text-[11px] font-bold border border-[#00ADEF]/30">
                {{ store.currentAdo.province }}
              </span>
            </div>
            <div class="text-xs text-slate-400 mt-0.5 flex items-center gap-2">
              <span class="text-[#38BDF8] font-bold">● Consentement Validé</span>
              <span>•</span>
              <span>ID: <code class="text-slate-300 font-mono">{{ store.currentAdo.id }}</code></span>
            </div>
          </div>
        </div>

        <!-- Level Progress & Badges preview -->
        <div class="w-full md:w-auto flex-1 max-w-md bg-white/[0.03] p-4 rounded-2xl border border-white/5">
          <div class="flex items-center justify-between text-xs mb-2">
            <span class="font-bold text-slate-300 flex items-center gap-1.5">
              <span>⚡ Niveau 4 :</span>
              <span class="text-[#00ADEF]">Enfant Reporter Étoile</span>
            </span>
            <span class="font-mono text-[#38BDF8] font-bold">940 / 1000 XP</span>
          </div>
          <div class="w-full h-2.5 bg-slate-800 rounded-full overflow-hidden p-0.5 border border-white/5">
            <div class="h-full bg-gradient-to-r from-[#00ADEF] via-sky-400 to-[#0072F5] rounded-full w-[94%] transition-all duration-500 shadow-[0_0_12px_rgba(0,173,239,0.6)]"></div>
          </div>
          <div class="flex items-center justify-between text-[11px] text-slate-400 mt-2">
            <span>{{ store.currentAdo.progression.modulesTermines.length }}/6 Modules validés</span>
            <router-link to="/certificat" class="text-[#00ADEF] font-bold hover:underline flex items-center gap-1">
              Voir Certificat Officiel →
            </router-link>
          </div>
        </div>

      </div>
    </div>

    <!-- Key Indicators Bar (Real-Time Pulse Metrics) -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
      
      <div class="p-5 rounded-2xl bg-white/[0.04] border border-white/10 hover:border-[#00ADEF]/40 transition-all group">
        <div class="flex items-center justify-between">
          <span class="text-xs font-bold text-slate-400">Total Inscrits</span>
          <span class="w-8 h-8 rounded-xl bg-[#00ADEF]/15 text-[#00ADEF] flex items-center justify-center text-sm font-black">👥</span>
        </div>
        <div class="text-3xl font-black font-heading text-white mt-3 group-hover:text-[#00ADEF] transition-colors">
          {{ store.stats.totalInscrits }}
        </div>
        <div class="text-[11px] text-emerald-400 font-medium mt-1 flex items-center gap-1">
          <span>↑ +18% ce mois</span>
          <span class="text-slate-500">• 26 Provinces</span>
        </div>
      </div>

      <div class="p-5 rounded-2xl bg-white/[0.04] border border-white/10 hover:border-emerald-500/40 transition-all group">
        <div class="flex items-center justify-between">
          <span class="text-xs font-bold text-slate-400">Consentements</span>
          <span class="w-8 h-8 rounded-xl bg-emerald-500/15 text-emerald-400 flex items-center justify-center text-sm font-black">🛡️</span>
        </div>
        <div class="text-3xl font-black font-heading text-white mt-3 group-hover:text-emerald-400 transition-colors">
          {{ store.stats.tauxConsentement }}%
        </div>
        <div class="text-[11px] text-slate-400 font-medium mt-1 flex items-center gap-1">
          <span>SMS / WhatsApp / Papier</span>
        </div>
      </div>

      <div class="p-5 rounded-2xl bg-white/[0.04] border border-white/10 hover:border-[#00ADEF]/40 transition-all group">
        <div class="flex items-center justify-between">
          <span class="text-xs font-bold text-slate-400">Certifiés</span>
          <span class="w-8 h-8 rounded-xl bg-[#00ADEF]/15 text-[#00ADEF] flex items-center justify-center text-sm font-black">🎓</span>
        </div>
        <div class="text-3xl font-black font-heading text-white mt-3 group-hover:text-[#00ADEF] transition-colors">
          {{ store.stats.certifieCount }}
        </div>
        <div class="text-[11px] text-[#00ADEF] font-medium mt-1 flex items-center gap-1">
          <span>Code QR Unique Vérifiable</span>
        </div>
      </div>

      <div class="p-5 rounded-2xl bg-white/[0.04] border border-white/10 hover:border-purple-500/40 transition-all group">
        <div class="flex items-center justify-between">
          <span class="text-xs font-bold text-slate-400">Ponabana Blog</span>
          <span class="w-8 h-8 rounded-xl bg-purple-500/15 text-purple-400 flex items-center justify-center text-sm font-black">📰</span>
        </div>
        <div class="text-3xl font-black font-heading text-white mt-3 group-hover:text-purple-400 transition-colors">
          {{ store.stats.contenusPublies }}
        </div>
        <div class="text-[11px] text-purple-300 font-medium mt-1 flex items-center gap-1">
          <span>Reportages Validés WordPress</span>
        </div>
      </div>

    </div>

    <!-- Interactive Badges 3D Showcase (Gamification & Recognition) -->
    <div class="p-6 sm:p-8 rounded-3xl bg-gradient-to-b from-white/[0.05] to-white/[0.02] border border-white/10 backdrop-blur-xl">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
        <div>
          <div class="inline-flex items-center gap-2 text-xs font-black uppercase text-[#00ADEF] tracking-wider">
            <span>✨ GAMIFICATION & EXCELLENCE</span>
          </div>
          <h2 class="text-2xl font-black font-heading text-white mt-1">Badges Numériques d'Engagement 3D</h2>
          <p class="text-xs text-slate-400 mt-1">Fais pivoter les badges avec ta souris ou ton doigt pour admirer tes récompenses d'engagement.</p>
        </div>
        <router-link to="/formation" class="text-xs font-bold text-[#00ADEF] hover:underline flex items-center gap-1">
          Débloquer tous les modules →
        </router-link>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <Badge3D 
          title="Défenseur Droits" 
          subtitle="Module 1 validé" 
          color="#00ADEF" 
          :unlocked="store.currentAdo.progression.modulesTermines.includes(1)" 
        />
        <Badge3D 
          title="Artisan Plaidoyer" 
          subtitle="Module 2 validé" 
          color="#0072F5" 
          :unlocked="store.currentAdo.progression.modulesTermines.includes(2)" 
        />
        <Badge3D 
          title="Enfant Reporter" 
          subtitle="Module 3 validé" 
          color="#0284C7" 
          :unlocked="store.currentAdo.progression.modulesTermines.includes(3)" 
        />
        <Badge3D 
          title="Fact-Checker" 
          subtitle="Module 4 validé" 
          color="#6366F1" 
          :unlocked="store.currentAdo.progression.modulesTermines.includes(4)" 
        />
      </div>
    </div>

    <!-- 7 Modules Interactive Journey Map (CPD 2025–2029) -->
    <div class="p-6 sm:p-8 rounded-3xl bg-white/[0.03] border border-white/10">
      <div class="mb-8">
        <div class="text-xs font-black uppercase text-[#00ADEF] tracking-wider">
          PARCOURS DE L'ADOLESCENT ENGAGÉ
        </div>
        <h2 class="text-2xl font-black font-heading text-white mt-1">
          Les 7 Modules Clés du Cahier des Charges UNICEF RDC
        </h2>
        <p class="text-xs text-slate-400 mt-1">
          Une architecture modulaire, accessible à faible connectivité et sécurisée pour chaque adolescent de RDC.
        </p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        
        <!-- Module 1 -->
        <router-link to="/inscription" class="p-5 rounded-2xl bg-white/[0.03] border border-white/10 hover:border-[#00ADEF] hover:bg-white/[0.06] transition-all group">
          <div class="flex items-center justify-between">
            <span class="w-10 h-10 rounded-xl bg-[#00ADEF]/15 text-[#00ADEF] font-black text-sm flex items-center justify-center">01</span>
            <span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-white/5 text-slate-300">Multicanal</span>
          </div>
          <h3 class="font-heading font-black text-base text-white mt-4 group-hover:text-[#00ADEF] transition-colors">
            Mobilisation & Inscription
          </h3>
          <p class="text-xs text-slate-400 mt-2 leading-relaxed">
            Formulaire web léger (&lt;500 Ko), chatbot WhatsApp RapidPro en 5 langues, SMS/USSD & mode hors-ligne REIPE.
          </p>
        </router-link>

        <!-- Module 2 -->
        <router-link to="/consentement" class="p-5 rounded-2xl bg-white/[0.03] border border-white/10 hover:border-emerald-400 hover:bg-white/[0.06] transition-all group">
          <div class="flex items-center justify-between">
            <span class="w-10 h-10 rounded-xl bg-emerald-500/15 text-emerald-400 font-black text-sm flex items-center justify-center">02</span>
            <span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-500/10 text-emerald-400">Sauvegarde</span>
          </div>
          <h3 class="font-heading font-black text-base text-white mt-4 group-hover:text-emerald-400 transition-colors">
            Consentement & Protection
          </h3>
          <p class="text-xs text-slate-400 mt-2 leading-relaxed">
            Validation parentale automatique, anonymisation à la demande et bouton d'alerte sauvegarde 24h.
          </p>
        </router-link>

        <!-- Module 3 -->
        <router-link to="/formation" class="p-5 rounded-2xl bg-white/[0.03] border border-white/10 hover:border-[#00ADEF] hover:bg-white/[0.06] transition-all group">
          <div class="flex items-center justify-between">
            <span class="w-10 h-10 rounded-xl bg-[#00ADEF]/15 text-[#00ADEF] font-black text-sm flex items-center justify-center">03</span>
            <span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-[#00ADEF]/10 text-[#00ADEF]">Formation</span>
          </div>
          <h3 class="font-heading font-black text-base text-white mt-4 group-hover:text-[#00ADEF] transition-colors">
            Académie & Certification
          </h3>
          <p class="text-xs text-slate-400 mt-2 leading-relaxed">
            6 modules courts, capsules audio, vidéos 240p, quiz interactifs et certificat officiel avec QR code unique.
          </p>
        </router-link>

        <!-- Module 4 -->
        <router-link to="/terrain" class="p-5 rounded-2xl bg-white/[0.03] border border-white/10 hover:border-amber-400 hover:bg-white/[0.06] transition-all group">
          <div class="flex items-center justify-between">
            <span class="w-10 h-10 rounded-xl bg-amber-500/15 text-amber-400 font-black text-sm flex items-center justify-center">04</span>
            <span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-amber-500/10 text-amber-400">Terrain REIPE</span>
          </div>
          <h3 class="font-heading font-black text-base text-white mt-4 group-hover:text-amber-400 transition-colors">
            Communautés & Plaidoyer
          </h3>
          <p class="text-xs text-slate-400 mt-2 leading-relaxed">
            Groupes WhatsApp par ville, collecte hors ligne KoboToolbox, ateliers pratiques et transition des 18 ans.
          </p>
        </router-link>

        <!-- Module 5 -->
        <router-link to="/espace-reporter" class="p-5 rounded-2xl bg-white/[0.03] border border-white/10 hover:border-purple-400 hover:bg-white/[0.06] transition-all group">
          <div class="flex items-center justify-between">
            <span class="w-10 h-10 rounded-xl bg-purple-500/15 text-purple-400 font-black text-sm flex items-center justify-center">05</span>
            <span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-purple-500/10 text-purple-400">Ponabana</span>
          </div>
          <h3 class="font-heading font-black text-base text-white mt-4 group-hover:text-purple-400 transition-colors">
            Studio Enfants Reporters
          </h3>
          <p class="text-xs text-slate-400 mt-2 leading-relaxed">
            Soumission média mobile, purge EXIF automatique, floutage des visages et publication API WordPress.
          </p>
        </router-link>

        <!-- Module 6 & 7 -->
        <router-link to="/dashboard" class="p-5 rounded-2xl bg-white/[0.03] border border-white/10 hover:border-rose-400 hover:bg-white/[0.06] transition-all group">
          <div class="flex items-center justify-between">
            <span class="w-10 h-10 rounded-xl bg-rose-500/15 text-rose-400 font-black text-sm flex items-center justify-center">06</span>
            <span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-rose-500/10 text-rose-400">Dashboard & Admin</span>
          </div>
          <h3 class="font-heading font-black text-base text-white mt-4 group-hover:text-rose-400 transition-colors">
            Indicateurs & Administration
          </h3>
          <p class="text-xs text-slate-400 mt-2 leading-relaxed">
            Statistiques désagrégées en temps réel (sexe/âge/province/handicap), exports CSV et journal d'audit sécurisé.
          </p>
        </router-link>

      </div>
    </div>

    <!-- Active Mock Session Quick Switcher -->
    <div class="p-5 bg-white/[0.02] rounded-2xl border border-white/10 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-xl bg-[#00ADEF]/20 text-[#00ADEF] font-black flex items-center justify-center">
          {{ store.currentAdo.prenom.charAt(0) }}
        </div>
        <div>
          <span class="font-bold text-white">Profil Mock en Cours :</span> {{ store.currentAdo.prenom }} ({{ store.currentAdo.age }} ans, {{ store.currentAdo.province }}) — <code class="text-slate-400 font-mono">{{ store.currentAdo.id }}</code>
        </div>
      </div>

      <div class="flex items-center gap-2">
        <select :value="store.currentAdoId" @change="store.setAdo($event.target.value)" class="!bg-[#131A2B] text-slate-200 text-xs px-3 py-1.5 rounded-xl cursor-pointer">
          <option v-for="ado in store.db.adolescents" :key="ado.id" :value="ado.id">
            Changer : {{ ado.prenom }} ({{ ado.province }})
          </option>
        </select>
        <button @click="store.resetDatabase" class="px-3 py-1.5 rounded-xl bg-white/10 hover:bg-white/20 text-slate-300 font-bold transition-all">
          🔄 Réinitialiser
        </button>
      </div>
    </div>

  </div>
</template>

<script setup>
import { useAppStore } from '../mock/store'
import Badge3D from '../components/Badge3D.vue'

const store = useAppStore()
</script>
