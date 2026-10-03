<template>
  <!-- 
    =============================================================================================
    MODULE 5 : CIRCUIT ÉDITORIAL & PUBLICATION PONABANA (Section 5 du Cahier des Charges)
    
    [PÉRIMÈTRE & DÉPENDANCES - LIVRABLES UNICEF REQUIS] :
    1. Accès API WordPress Ponabana (Annexe 5) : 
       - En attente de l'accès au endpoint REST `/wp-json/wp/v2/posts` du blog Ponabana de production.
       - En attente de la configuration des Application Passwords / clés JWT d'authentification serveur.
    2. Taxonomie et Catégories officielles :
       - En attente de la nomenclature définitive des catégories et tags éditoriaux UNICEF RDC.
    3. Charte d'anonymisation et attribution des auteurs :
       - Respect de l'attribution paramétrable (Prénom seul, pseudonyme ou anonymat total) conformément aux règles de sauvegarde.
    
    Le circuit de validation à deux niveaux et le simulateur de publication WordPress sont 100% opérationnels.
    =============================================================================================
  -->
  <div class="max-w-5xl mx-auto space-y-6 sm:space-y-8 pb-16 px-2 sm:px-4">
    
    <!-- Title banner -->
    <div class="text-center space-y-2">
      <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#00ADEF]/15 border border-[#00ADEF]/30 text-xs font-black text-[#00ADEF] uppercase tracking-wider">
        <span>📰 MODULE 5 : CIRCUIT ÉDITORIAL &amp; BLOG PONABANA</span>
      </div>
      <h1 class="text-2xl sm:text-4xl font-black font-heading text-white">
        Circuit de Validation Éditoriale Ponabana
      </h1>
      <p class="text-xs sm:text-sm text-slate-400 max-w-xl mx-auto">
        Modération à deux niveaux (Encadreur REIPE de terrain → Comité Éditorial Ponabana) &amp; Publication directe via API WordPress.
      </p>
    </div>

    <!-- Active Tab Filter (Niveau 1, Niveau 2, Publiés) -->
    <div class="p-1.5 rounded-2xl bg-white/[0.04] border border-white/10 backdrop-blur-xl flex flex-wrap gap-2 text-xs font-bold">
      <button 
        @click="filterStatut = 'en_attente_encadreur'" 
        :class="filterStatut === 'en_attente_encadreur' ? '!bg-[#00ADEF] !text-white shadow-[0_0_15px_rgba(0,173,239,0.35)]' : 'text-slate-300 hover:text-white hover:bg-white/5'"
        class="flex-1 min-w-[150px] py-3 px-4 rounded-xl flex items-center justify-center gap-2 transition-all cursor-pointer">
        <span>⏳ Niveau 1 : Encadreurs REIPE</span>
        <span class="px-2 py-0.5 rounded-full bg-[#090D16] text-[#00ADEF] text-[10px] font-mono font-bold">{{ store.pendingEncadreurContents.length }}</span>
      </button>

      <button 
        @click="filterStatut = 'valide_encadreur'" 
        :class="filterStatut === 'valide_encadreur' ? '!bg-[#0072F5] !text-white shadow-[0_0_15px_rgba(0,114,245,0.35)]' : 'text-slate-300 hover:text-white hover:bg-white/5'"
        class="flex-1 min-w-[150px] py-3 px-4 rounded-xl flex items-center justify-center gap-2 transition-all cursor-pointer">
        <span>🔍 Niveau 2 : Comité Ponabana</span>
        <span class="px-2 py-0.5 rounded-full bg-[#090D16] text-[#38BDF8] text-[10px] font-mono font-bold">{{ store.pendingPonabanaContents.length }}</span>
      </button>

      <button 
        @click="filterStatut = 'publie_ponabana'" 
        :class="filterStatut === 'publie_ponabana' ? '!bg-[#0284C7] !text-white shadow-[0_0_15px_rgba(2,132,199,0.35)]' : 'text-slate-300 hover:text-white hover:bg-white/5'"
        class="flex-1 min-w-[150px] py-3 px-4 rounded-xl flex items-center justify-center gap-2 transition-all cursor-pointer">
        <span>✓ En Ligne sur Ponabana</span>
        <span class="px-2 py-0.5 rounded-full bg-[#090D16] text-[#38BDF8] text-[10px] font-mono font-bold">{{ store.stats.contenusPublies }}</span>
      </button>
    </div>

    <!-- UNICEF WordPress Connector Banner -->
    <div class="p-4 rounded-2xl bg-sky-950/30 border border-[#00ADEF]/20 text-xs text-sky-200 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
      <div class="flex items-center gap-2.5">
        <span class="text-base">🌐</span>
        <span>
          <strong>Connecteur Blog Ponabana (WordPress API) :</strong> Simulation locale active. La publication directe en ligne nécessite la configuration des clés de production par l'équipe T4D UNICEF.
        </span>
      </div>
      <span class="text-[10px] font-mono font-bold bg-[#090D16] text-[#00ADEF] px-2.5 py-1 rounded-lg border border-[#00ADEF]/30 shrink-0">
        WP REST Endpoint
      </span>
    </div>

    <!-- Content Items List -->
    <div class="space-y-4">
      <div v-for="item in filteredContents" :key="item.id" class="p-6 rounded-3xl bg-white/[0.04] border border-white/10 hover:border-white/20 transition-all space-y-5">
        
        <div class="flex flex-col sm:flex-row sm:items-start justify-between gap-4">
          <div class="space-y-1.5">
            <div class="flex items-center gap-2">
              <span class="text-[10px] font-mono font-bold bg-[#090D16] text-[#00ADEF] px-2.5 py-0.5 rounded-full border border-[#00ADEF]/30">{{ item.id }}</span>
              <span class="text-[11px] font-bold text-white bg-white/10 px-2.5 py-0.5 rounded-full">{{ item.theme }}</span>
              <span class="text-[11px] text-slate-400">Province : {{ item.province }}</span>
            </div>
            <h3 class="text-lg font-black font-heading text-white">{{ item.titre }}</h3>
            <p class="text-xs text-slate-400">
              Auteur : <strong class="text-slate-200">{{ item.pseudonymeAttribution }}</strong> • Lieu : {{ item.lieu }} • Soumis le : {{ item.dateSoumission }}
            </p>
          </div>

          <!-- Status badge -->
          <div>
            <span v-if="item.statut === 'publie_ponabana'" class="inline-flex items-center gap-1.5 text-xs font-bold px-3 py-1.5 rounded-xl bg-emerald-500/15 border border-emerald-500/40 text-emerald-400">
              ✓ Publié WordPress
            </span>
            <span v-else-if="item.statut === 'valide_encadreur'" class="inline-flex items-center gap-1.5 text-xs font-bold px-3 py-1.5 rounded-xl bg-sky-500/15 border border-sky-500/40 text-[#00ADEF]">
              ⏳ Attente Validation Ponabana
            </span>
            <span v-else class="inline-flex items-center gap-1.5 text-xs font-bold px-3 py-1.5 rounded-xl bg-amber-500/15 border border-amber-500/40 text-amber-400">
              ⏳ Attente Encadreur REIPE
            </span>
          </div>
        </div>

        <!-- Safeguard & Ethics verification metrics -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-3 p-4 bg-[#070A11] rounded-2xl border border-white/10 text-xs text-slate-300">
          <div class="flex items-center gap-2">
            <span :class="item.consentementMentionne ? 'text-emerald-400' : 'text-rose-400'" class="font-black">
              {{ item.consentementMentionne ? '✓' : '✗' }}
            </span>
            <span>Consentement filmés</span>
          </div>

          <div class="flex items-center gap-2">
            <span :class="item.verificationFaitsDeclaree ? 'text-emerald-400' : 'text-rose-400'" class="font-black">
              {{ item.verificationFaitsDeclaree ? '✓' : '✗' }}
            </span>
            <span>Faits vérifiés (2 sources)</span>
          </div>

          <div class="flex items-center gap-2">
            <span :class="item.faceBlurAlert ? 'text-amber-400' : 'text-emerald-400'" class="font-black">
              {{ item.faceBlurAlert ? '⚠️' : '✓' }}
            </span>
            <span>{{ item.faceBlurAlert ? 'Floutage visage requis' : 'Visuel conforme' }}</span>
          </div>
        </div>

        <!-- Validation Details if present -->
        <div v-if="item.validationEncadreur" class="text-xs p-4 rounded-2xl bg-white/[0.03] border border-white/10 text-slate-300 space-y-1">
          <div class="font-bold text-[#00ADEF]">Avis de validation Encadreur ({{ item.validationEncadreur.validePar }}) :</div>
          <div class="italic">"{{ item.validationEncadreur.commentaire }}"</div>
        </div>

        <!-- Publication link if already on Ponabana -->
        <div v-if="item.ponabanaUrl" class="text-xs p-4 rounded-2xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-300 flex items-center justify-between">
          <span>Lien public officiel : <a :href="item.ponabanaUrl" target="_blank" class="underline font-bold text-white">{{ item.ponabanaUrl }}</a></span>
          <span class="text-[10px] bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 px-2.5 py-1 rounded-lg font-mono font-bold">WP REST API</span>
        </div>

        <!-- Action buttons according to current state -->
        <div class="pt-4 border-t border-white/5 flex flex-wrap items-center justify-between gap-3">
          <div class="text-[11px] text-slate-400">
            Sources consultées : {{ item.sources }}
          </div>

          <div class="flex items-center gap-2">
            <!-- Level 1 Action -->
            <button 
              v-if="item.statut === 'en_attente_encadreur'"
              @click="store.validerParEncadreur(item.id)" 
              class="btn-primary text-xs py-2 px-4">
              <span>Valider Niveau 1 (Encadreur REIPE) ✍️</span>
            </button>

            <!-- Level 2 Action -->
            <button 
              v-if="item.statut === 'valide_encadreur'"
              @click="store.publierSurPonabana(item.id)" 
              class="btn-cyan text-xs py-2 px-4">
              <span>Approuver &amp; Publier sur Ponabana 🚀</span>
            </button>
          </div>
        </div>

      </div>

      <div v-if="filteredContents.length === 0" class="text-center py-16 p-8 rounded-3xl bg-white/[0.02] border border-white/10 text-slate-400 text-xs">
        Aucun reportage dans cette file de traitement pour le moment.
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAppStore } from '../mock/store'

const store = useAppStore()
const filterStatut = ref('en_attente_encadreur')

const filteredContents = computed(() => {
  return store.db.reportersContents.filter(c => c.statut === filterStatut.value)
})
</script>