<template>
  <!-- 
    =============================================================================================
    MODULE 3 : DÉTAIL DU MODULE DE FORMATION & QUIZ (Section 5 du Cahier des Charges)
    
    [PÉRIMÈTRE & DÉPENDANCES - LIVRABLES UNICEF REQUIS] :
    1. Fichiers Vidéo & Audio (Annexe 3) : 
       - En attente de la livraison des masters vidéo compressés en 240p et des capsules audio narratives avec sous-titres officiels.
    2. Contenu textuel et fiches de synthèse :
       - Rédaction sous la responsabilité exclusive de l'UNICEF RDC (Exclus du périmètre prestataire - Section 3).
    3. Questions de quiz et règles de validation :
       - En attente de la validation pédagogique finale des banques de questions par les partenaires institutionnels.
    
    Toutes les interactions (lecteur 240p/audio, fiches, quiz et déblocage de badges) sont simulées et interactives.
    =============================================================================================
  -->
  <div v-if="moduleItem" class="max-w-4xl mx-auto space-y-6 sm:space-y-8 pb-16 px-2 sm:px-4">
    
    <!-- Top breadcrumb & navigation -->
    <div class="flex items-center justify-between">
      <router-link to="/formation" class="text-xs font-bold text-slate-400 hover:text-[#00ADEF] flex items-center gap-1.5 transition-colors">
        <span>← Retour à l'Académie</span>
      </router-link>
      <div class="flex items-center gap-2">
        <span class="text-[10px] font-bold px-2.5 py-1 rounded-full bg-amber-500/10 text-amber-300 border border-amber-500/30 hidden sm:inline-flex">
          ⏳ Contenu Pédagogique Fourni par UNICEF
        </span>
        <span class="text-xs font-black px-3 py-1 rounded-full bg-white/5 text-[#00ADEF] border border-white/10 font-mono">
          MODULE 0{{ moduleItem.numero }} / 06
        </span>
      </div>
    </div>

    <!-- Module Header Card -->
    <div class="p-6 sm:p-8 rounded-3xl bg-white/[0.04] border border-white/10 backdrop-blur-xl space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-start justify-between gap-4 border-b border-white/10 pb-6">
        <div>
          <span class="text-[11px] font-black uppercase tracking-wider text-[#00ADEF]">{{ moduleItem.categorie }}</span>
          <h1 class="text-2xl sm:text-3xl font-black font-heading text-white mt-1">{{ moduleItem.titre }}</h1>
          <p class="text-xs text-slate-400 mt-1">Durée : {{ moduleItem.duree }} • Version ultra-légère 2G/3G</p>
        </div>
        <div class="w-14 h-14 rounded-2xl bg-[#00ADEF]/15 border border-[#00ADEF]/30 text-[#00ADEF] flex items-center justify-center text-3xl shrink-0 shadow-lg">
          📖
        </div>
      </div>

      <!-- Multi-format Media Player Simulation -->
      <div class="p-5 bg-[#070A11] rounded-2xl border border-white/10 text-white space-y-4 shadow-2xl">
        <div class="flex items-center justify-between border-b border-white/10 pb-3">
          <div class="flex items-center gap-2">
            <span class="w-2.5 h-2.5 rounded-full bg-[#00ADEF] animate-ping"></span>
            <span class="text-xs font-bold text-slate-200">Lecteur Média Faible Bande Passante</span>
          </div>
          <div class="flex gap-2 text-xs">
            <button @click="mediaMode = 'video'" :class="mediaMode === 'video' ? '!bg-[#00ADEF] !text-white font-black' : 'bg-white/5 text-slate-400'" class="px-3 py-1.5 rounded-xl transition-all cursor-pointer">
              📹 Vidéo (240p)
            </button>
            <button @click="mediaMode = 'audio'" :class="mediaMode === 'audio' ? '!bg-[#00ADEF] !text-white font-black' : 'bg-white/5 text-slate-400'" class="px-3 py-1.5 rounded-xl transition-all cursor-pointer">
              🎧 Capsule Audio
            </button>
          </div>
        </div>

        <!-- Video player view -->
        <div v-if="mediaMode === 'video'" class="aspect-video bg-[#0C131D] rounded-xl flex flex-col items-center justify-center p-6 text-center space-y-3 border border-white/10 relative overflow-hidden group">
          <div class="w-16 h-16 rounded-full bg-[#00ADEF] hover:bg-[#0072F5] text-white flex items-center justify-center text-2xl font-black cursor-pointer shadow-[0_0_25px_rgba(0,173,239,0.5)] transition-all hover:scale-110">
            ▶
          </div>
          <div class="text-xs text-slate-300 font-medium">
            Vidéo compressée avec sous-titres français / langues nationales ({{ moduleItem.videoTaille }})
          </div>
          <div class="text-[10px] text-slate-400">
            Mode économie de données activé • Conforme WCAG 2.1 AA
          </div>
        </div>

        <!-- Audio player view -->
        <div v-else class="p-5 bg-[#0C131D] rounded-xl flex items-center gap-4 border border-white/10">
          <button @click="isPlayingAudio = !isPlayingAudio" class="w-12 h-12 rounded-2xl bg-[#00ADEF] text-white flex items-center justify-center text-xl font-black shrink-0 hover:scale-105 transition-transform cursor-pointer shadow-[0_0_20px_rgba(0,173,239,0.4)]">
            {{ isPlayingAudio ? '⏸' : '▶' }}
          </button>
          <div class="flex-1 space-y-2">
            <div class="flex justify-between text-xs font-bold text-slate-200">
              <span>Capsule Audio : {{ moduleItem.titre }}</span>
              <span class="text-[#00ADEF] font-mono">03:45 / 12:00</span>
            </div>
            <div class="w-full h-2 bg-slate-800 rounded-full overflow-hidden p-0.5">
              <div class="h-full bg-gradient-to-r from-[#00ADEF] to-[#0072F5] rounded-full w-1/3 shadow-[0_0_8px_rgba(0,173,239,0.5)]"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Objectives -->
      <div class="p-5 bg-white/[0.03] rounded-2xl border border-white/10 space-y-2">
        <h3 class="text-xs font-black uppercase tracking-wider text-[#00ADEF]">🎯 Objectifs Pédagogiques :</h3>
        <ul class="text-xs text-slate-300 space-y-2 list-disc list-inside leading-relaxed">
          <li v-for="(obj, i) in moduleItem.objectifs" :key="i">{{ obj }}</li>
        </ul>
      </div>

      <!-- Pedagogical Content & Transcript -->
      <div class="space-y-3">
        <h3 class="text-sm font-black font-heading text-white">Fiche Pédagogique &amp; Synthèse</h3>
        <div class="p-5 bg-[#070A11] rounded-2xl border border-white/10 text-xs text-slate-300 leading-relaxed space-y-3">
          <p>{{ moduleItem.contenuTexte }}</p>
        </div>
      </div>
    </div>

    <!-- Interactive Quiz Section -->
    <div class="p-6 sm:p-8 rounded-3xl bg-white/[0.04] border border-white/10 backdrop-blur-xl space-y-6">
      <div class="border-b border-white/10 pb-4 flex items-center justify-between">
        <div>
          <h2 class="text-lg font-black font-heading text-white">Quiz d'Évaluation &amp; Validation</h2>
          <p class="text-xs text-slate-400">Réponds correctement à toutes les questions pour débloquer ton badge 3D.</p>
        </div>
        <span class="text-xs font-black px-3 py-1 rounded-full bg-[#00ADEF]/15 text-[#00ADEF] border border-[#00ADEF]/30">
          Seuil : 100%
        </span>
      </div>

      <!-- Quiz Questions -->
      <div class="space-y-6">
        <div v-for="(q, qIndex) in moduleItem.quiz" :key="q.id" class="p-5 rounded-2xl bg-white/[0.02] border border-white/10 space-y-3">
          <div class="text-xs font-bold text-white flex items-start gap-3">
            <span class="w-6 h-6 rounded-lg bg-[#00ADEF]/20 text-[#00ADEF] flex items-center justify-center font-black shrink-0 text-xs">
              {{ qIndex + 1 }}
            </span>
            <span class="text-sm">{{ q.question }}</span>
          </div>

          <div class="space-y-2 pl-9">
            <label v-for="(opt, optIndex) in q.options" :key="optIndex" class="flex items-center gap-3 p-3 rounded-xl border border-white/10 hover:border-white/20 bg-white/[0.02] hover:bg-white/[0.05] cursor-pointer text-xs transition-all">
              <input type="radio" :name="q.id" :value="optIndex" v-model="selectedAnswers[q.id]" :disabled="quizSubmitted" class="text-[#00ADEF] focus:ring-[#00ADEF]">
              <span :class="quizSubmitted && opt.correct ? 'font-black text-emerald-400' : 'text-slate-300'">{{ opt.text }}</span>
            </label>
          </div>

          <div v-if="quizSubmitted" class="pl-9 pt-2 text-xs text-slate-300 italic bg-[#070A11] p-3 rounded-xl border border-white/10">
            💡 <strong>Explication UNICEF :</strong> {{ q.explication }}
          </div>
        </div>
      </div>

      <!-- Quiz Submit / Reset Buttons -->
      <div class="pt-4 border-t border-white/10 flex flex-wrap items-center justify-between gap-4">
        <div v-if="quizPassed" class="text-xs font-black text-emerald-400 flex items-center gap-2">
          <span>🎉</span> Bravo ! Module validé avec succès (Score 100%).
        </div>
        <div v-else-if="quizSubmitted && !quizPassed" class="text-xs font-bold text-rose-400">
          ❌ Score insuffisant. Révise les points clés et réessaie !
        </div>
        <div v-else></div>

        <div class="flex gap-3">
          <button v-if="quizSubmitted && !quizPassed" @click="resetQuiz" class="btn-secondary text-xs">
            Réessayer le Quiz
          </button>
          <button v-if="!quizSubmitted" @click="submitQuiz" class="btn-primary text-xs font-black">
            Valider mes Réponses 📝
          </button>
          <router-link v-if="quizPassed" to="/formation" class="btn-primary text-xs font-black">
            Retour aux Formations →
          </router-link>
        </div>
      </div>

    </div>

    <!-- 3D Badge Celebration modal when passed -->
    <div v-if="quizPassed" class="p-8 rounded-3xl bg-gradient-to-r from-emerald-500/15 via-teal-500/10 to-transparent border-2 border-emerald-500/40 flex flex-col sm:flex-row items-center justify-around gap-8 text-center sm:text-left shadow-[0_0_30px_rgba(16,185,129,0.2)]">
      <Badge3D 
        :title="moduleItem.badgeName" 
        :subtitle="`Module ${moduleItem.numero} UNICEF RDC`" 
        :color="moduleItem.badgeColor" 
        :unlocked="true" 
      />
      <div class="space-y-3 max-w-sm">
        <span class="px-3 py-1 rounded-full bg-emerald-500/20 text-emerald-400 border border-emerald-500/40 text-[10px] font-black uppercase tracking-wider">
          Badge 3D Débloqué !
        </span>
        <h3 class="text-2xl font-black font-heading text-white">Félicitations {{ store.currentAdo.prenom }} !</h3>
        <p class="text-xs text-slate-300 leading-relaxed">
          Tu as obtenu le badge d'engagement <strong>{{ moduleItem.badgeName }}</strong>. Continue ton parcours pour débloquer ton certificat officiel imprimable !
        </p>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import { useAppStore } from '../mock/store'
import Badge3D from '../components/Badge3D.vue'

const route = useRoute()
const store = useAppStore()

const moduleId = computed(() => Number(route.params.id) || 1)
const moduleItem = computed(() => store.db.trainingModules.find(m => m.id === moduleId.value))

const mediaMode = ref('video')
const isPlayingAudio = ref(false)

const selectedAnswers = ref({})
const quizSubmitted = ref(false)
const quizPassed = ref(false)

function submitQuiz() {
  if (!moduleItem.value) return
  let allCorrect = true
  
  for (const q of moduleItem.value.quiz) {
    const selectedIdx = selectedAnswers.value[q.id]
    if (selectedIdx === undefined || !q.options[selectedIdx]?.correct) {
      allCorrect = false
    }
  }

  quizSubmitted.value = true
  quizPassed.value = allCorrect

  if (allCorrect) {
    store.terminerModule(store.currentAdo.id, moduleItem.value.id, 100)
  }
}

function resetQuiz() {
  selectedAnswers.value = {}
  quizSubmitted.value = false
  quizPassed.value = false
}
</script>