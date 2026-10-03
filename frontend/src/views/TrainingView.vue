<template>
  <!-- 
    =============================================================================================
    MODULE 3 : FORMATION THÉORIQUE INTERACTIVE ET CERTIFICATION (Section 5 du Cahier des Charges)
    
    [PÉRIMÈTRE & DÉPENDANCES - LIVRABLES UNICEF REQUIS] :
    1. Rédaction des contenus pédagogiques (Exclus du périmètre de développement - Section 3) :
       - Rédaction intégrale des 6 modules assurée par l'UNICEF RDC et ses partenaires.
       - Le prestataire assure l'intégration, l'interactivité, le responsive et la compression numérique.
    2. Enregistrements audio & Vidéos 240p (Annexe 3) :
       - En attente des masters vidéo finaux sous-titrés et des voix off en français et 4 langues nationales.
    3. Traductions en langues nationales (Lingála, Swahili, Tshiluba, Kikongo) :
       - Traduction officielle assurée par l'UNICEF (Section 3).
    4. Banques de questions et barèmes de quiz :
       - En attente de la validation définitive des seuils d'évaluation.
    
    Toutes les interfaces ci-dessous fonctionnent actuellement avec la base de données mockée réactive.
    =============================================================================================
  -->
  <div class="max-w-5xl mx-auto space-y-6 sm:space-y-8 pb-16 px-2 sm:px-4">
    
    <!-- Header Banner -->
    <div class="p-6 sm:p-10 rounded-3xl bg-gradient-to-br from-[#131A2B] via-[#0F172A] to-[#0B0F19] border border-white/10 relative overflow-hidden shadow-2xl">
      <div class="absolute -right-10 -bottom-10 w-72 h-72 bg-[#00ADEF]/15 rounded-full blur-3xl pointer-events-none"></div>
      
      <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-6 relative z-10">
        <div class="space-y-3 max-w-xl">
          <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#00ADEF]/15 border border-[#00ADEF]/30 text-xs font-black text-[#00ADEF] uppercase tracking-wider">
            <span>🎓 MODULE 3 : ACADÉMIE DES DROITS &amp; CERTIFICATION</span>
          </div>
          <h1 class="text-2xl sm:text-4xl font-black font-heading text-white">
            Formation &amp; Certification Officielle
          </h1>
          <p class="text-xs sm:text-sm text-slate-300 leading-relaxed">
            Acquiers les compétences clés en droits de l'enfant, techniques de plaidoyer, fact-checking et journalisme citoyen pour devenir Enfant Reporter ou Ambassadeur de Plaidoyer.
          </p>
        </div>

        <!-- Offline download package indicator -->
        <div class="bg-white/[0.04] p-5 rounded-2xl border border-white/10 text-xs space-y-3 min-w-[260px] backdrop-blur-md">
          <div class="flex items-center justify-between">
            <span class="font-bold text-white flex items-center gap-1.5">
              <span>📥</span> Pack Hors Ligne
            </span>
            <span class="px-2 py-0.5 rounded-full bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 text-[10px] font-black">
              PWA &lt; 18 Mo
            </span>
          </div>
          <p class="text-[11px] text-slate-400">Emporte les 6 modules sur ton téléphone pour étudier au village sans connexion.</p>
          <button @click="simulerTelechargement" class="btn-cyan w-full text-xs font-bold py-2">
            {{ downloadProgress ? `Téléchargement ${downloadProgress}%` : 'Télécharger le Pack (17.4 Mo) 📥' }}
          </button>
        </div>
      </div>
    </div>

    <!-- Parental consent block notice if pending -->
    <div v-if="store.currentAdo.consentement.statut !== 'valide'" class="p-5 bg-amber-500/10 border border-amber-500/30 rounded-3xl text-xs text-amber-200 flex items-start gap-3">
      <span class="text-2xl">⏳</span>
      <div class="space-y-1.5">
        <h4 class="font-bold text-sm text-amber-100">Consentement parental en attente pour {{ store.currentAdo.prenom }}</h4>
        <p class="text-slate-300">
          Conformément aux directives de sauvegarde de l'UNICEF RDC, tu peux consulter les fiches pédagogiques, mais la délivrance du certificat officiel et la soumission de reportages seront débloquées dès validation par ton tuteur légal.
        </p>
        <router-link to="/consentement" class="inline-block font-bold text-[#00ADEF] hover:underline pt-1">
          Accéder à la gestion du consentement →
        </router-link>
      </div>
    </div>

    <!-- Certificate unlocked banner if all 6 completed -->
    <div v-if="store.currentAdo.progression.certifie" class="p-6 sm:p-8 rounded-3xl bg-gradient-to-r from-emerald-500/15 via-teal-500/10 to-transparent border-2 border-emerald-500/40 flex flex-col sm:flex-row items-center justify-between gap-6 shadow-[0_0_25px_rgba(16,185,129,0.15)]">
      <div class="flex items-center gap-4">
        <div class="w-16 h-16 rounded-2xl bg-emerald-500/20 text-emerald-400 border border-emerald-500/40 flex items-center justify-center text-3xl shadow-lg">
          🏆
        </div>
        <div>
          <div class="text-xs font-black uppercase tracking-wider text-emerald-400">Félicitations {{ store.currentAdo.prenom }} !</div>
          <h2 class="text-xl font-black font-heading text-white mt-0.5">Tu es Officiellement Certifié(e)</h2>
          <p class="text-xs text-slate-300 mt-1">Code de vérification unique : <code class="font-mono font-bold bg-[#090D16] text-[#00ADEF] px-2 py-0.5 rounded border border-[#00ADEF]/30">{{ store.currentAdo.progression.codeCertificat }}</code></p>
        </div>
      </div>

      <router-link to="/certificat" class="btn-primary whitespace-nowrap text-xs font-black">
        <span>📜 Voir &amp; Imprimer mon Certificat</span>
      </router-link>
    </div>

    <!-- Progress overview bar -->
    <div class="p-6 rounded-3xl bg-white/[0.04] border border-white/10 space-y-3">
      <div class="flex items-center justify-between text-xs font-bold">
        <span class="text-slate-300">Progression globale ({{ store.currentAdo.progression.modulesTermines.length }} / 6 modules validés)</span>
        <span class="text-[#00ADEF] font-black text-sm">{{ Math.round((store.currentAdo.progression.modulesTermines.length / 6) * 100) }}%</span>
      </div>
      <div class="w-full h-3 bg-slate-900 rounded-full overflow-hidden p-0.5 border border-white/10">
        <div class="h-full bg-gradient-to-r from-[#00ADEF] to-[#0072F5] transition-all duration-500 rounded-full shadow-[0_0_10px_rgba(0,173,239,0.5)]" :style="{ width: `${(store.currentAdo.progression.modulesTermines.length / 6) * 100}%` }"></div>
      </div>
    </div>

    <!-- 6 Training Modules Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
      <div v-for="mod in store.db.trainingModules" :key="mod.id" class="p-6 rounded-3xl bg-white/[0.04] border border-white/10 hover:border-[#00ADEF]/40 transition-all flex flex-col justify-between space-y-5 group">
        <div class="space-y-3">
          <div class="flex items-start justify-between">
            <span class="text-[11px] font-black px-3 py-1 rounded-full bg-white/5 text-slate-300 border border-white/10">
              Module 0{{ mod.numero }} • {{ mod.categorie }}
            </span>
            <span v-if="store.currentAdo.progression.modulesTermines.includes(mod.id)" class="text-xs font-bold text-emerald-400 flex items-center gap-1.5 bg-emerald-500/10 px-2.5 py-0.5 rounded-full border border-emerald-500/30">
              <span class="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
              Validé
            </span>
            <span v-else class="text-xs text-slate-400 font-medium">
              ⏱️ {{ mod.duree }}
            </span>
          </div>

          <h3 class="font-heading font-black text-lg text-white group-hover:text-[#00ADEF] transition-colors leading-snug">
            {{ mod.titre }}
          </h3>
          <p class="text-xs text-slate-400 line-clamp-2 leading-relaxed">
            {{ mod.description }}
          </p>

          <div class="pt-2 flex items-center gap-2 text-[11px]">
            <span class="px-2.5 py-1 bg-[#00ADEF]/10 text-[#00ADEF] rounded-xl font-bold border border-[#00ADEF]/20">🎧 Audio</span>
            <span class="px-2.5 py-1 bg-purple-500/10 text-purple-400 rounded-xl font-bold border border-purple-500/20">📹 Vidéo 240p</span>
            <span class="px-2.5 py-1 bg-sky-500/10 text-sky-400 rounded-xl font-bold border border-sky-500/20">❓ Quiz</span>
          </div>
        </div>

        <div class="pt-4 border-t border-white/5 flex items-center justify-between">
          <div class="text-xs font-medium text-slate-400 flex items-center gap-1.5">
            <span>🏅 Badge :</span>
            <strong class="text-slate-200">{{ mod.badgeName }}</strong>
          </div>

          <router-link :to="`/formation/${mod.id}`" class="btn-primary text-xs py-2 px-4">
            {{ store.currentAdo.progression.modulesTermines.includes(mod.id) ? 'Revoir ↺' : 'Commencer →' }}
          </router-link>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useAppStore } from '../mock/store'

const store = useAppStore()
const downloadProgress = ref(0)

function simulerTelechargement() {
  if (downloadProgress.value > 0) return
  downloadProgress.value = 10
  const interval = setInterval(() => {
    downloadProgress.value += 30
    if (downloadProgress.value >= 100) {
      clearInterval(interval)
      downloadProgress.value = 100
      setTimeout(() => {
        alert('Pack de formation hors ligne (17.4 Mo) enregistré en cache local avec succès ! Vous pouvez maintenant étudier sans connexion internet.')
        downloadProgress.value = 0
      }, 300)
    }
  }, 250)
}
</script>