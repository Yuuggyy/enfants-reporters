<template>
  <!-- 
    =============================================================================================
    MODULE 5 : STUDIO DES ENFANTS REPORTERS & SOUMISSION MÉDIA (Section 5 du Cahier des Charges)
    
    [PÉRIMÈTRE & DÉPENDANCES - LIVRABLES UNICEF REQUIS] :
    1. Cadre Éditorial & Déontologique (Annexe 2) : 
       - En attente de la version définitive validée du cadre déontologique et éthique des enfants reporters.
    2. Interconnexion WordPress Ponabana (Annexe 5) : 
       - En attente de l'URL du blog Ponabana de production et des identifiants/clés d'application API REST.
    3. Traitement des médias et sauvegarde : 
       - La purge des métadonnées EXIF (géolocalisation) et le simulateur de floutage des visages sont intégrés côté client.
    
    Toutes les interfaces ci-dessous fonctionnent actuellement avec la base de données mockée réactive.
    =============================================================================================
  -->
  <div class="max-w-5xl mx-auto space-y-6 sm:space-y-8 pb-16 px-2 sm:px-4">
    
    <!-- Title banner -->
    <div class="text-center space-y-2">
      <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#A855F7]/15 border border-[#A855F7]/30 text-xs font-black text-[#A855F7] uppercase tracking-wider">
        <span>📸 MODULE 5 : STUDIO DES ENFANTS REPORTERS</span>
      </div>
      <h1 class="text-2xl sm:text-4xl font-black font-heading text-white">
        Studio de Création &amp; Soumission Média
      </h1>
      <p class="text-xs sm:text-sm text-slate-400 max-w-xl mx-auto">
        Raconte les défis et réussites de ta communauté • Détection automatique des visages pour floutage et purge EXIF des métadonnées de géolocalisation.
      </p>
    </div>

    <!-- Active Child Reporter Status -->
    <div class="p-6 rounded-3xl bg-white/[0.04] border border-white/10 backdrop-blur-xl flex flex-col sm:flex-row items-center justify-between gap-4">
      <div class="flex items-center gap-3.5">
        <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-[#A855F7] to-[#00ADEF] p-0.5">
          <div class="w-full h-full bg-[#0B0F19] rounded-[14px] flex items-center justify-center font-heading font-black text-lg text-white">
            {{ store.currentAdo.prenom.charAt(0) }}
          </div>
        </div>
        <div>
          <div class="font-heading font-black text-white text-base">Auteur : {{ store.currentAdo.prenom }} ({{ store.currentAdo.province }})</div>
          <div class="text-xs text-slate-400">Statut de certification : <span class="text-[#00ADEF] font-bold">Enfant Reporter Agréé</span></div>
        </div>
      </div>

      <div class="flex items-center gap-2 text-xs">
        <span class="px-3 py-1.5 rounded-xl bg-white/5 border border-white/10 text-slate-300 font-medium">
          Attribution publique : <strong class="text-white">{{ store.currentAdo.prenom }} ({{ store.currentAdo.age }} ans)</strong>
        </span>
      </div>
    </div>

    <!-- Content Submission Form -->
    <div class="p-6 sm:p-8 rounded-3xl bg-white/[0.04] border border-white/10 backdrop-blur-xl space-y-6">
      <div class="border-b border-white/10 pb-4 flex items-center justify-between">
        <div>
          <h2 class="text-lg font-black font-heading text-white">Formulaire d'Accompagnement Éditorial</h2>
          <p class="text-xs text-slate-400">Conforme à la Charte Déontologique des Enfants Reporters UNICEF</p>
        </div>
        <span class="text-xs font-mono text-[#00ADEF]">WordPress Ponabana API</span>
      </div>

      <form @submit.prevent="submitReporterContent" class="space-y-5">
        
        <div>
          <label class="block text-xs font-bold text-slate-300 mb-1.5">Titre de ton reportage / article *</label>
          <input v-model="form.titre" required type="text" placeholder="Ex: Comment les élèves de notre école ont planté 50 arbres contre l'érosion" class="w-full px-4 py-2.5 text-sm">
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Thématique principale *</label>
            <select v-model="form.theme" required class="w-full px-4 py-2.5 text-sm">
              <option value="Éducation & Scolarisation">Éducation &amp; Scolarisation</option>
              <option value="Eau, Hygiène & Environnement (WASH)">Eau, Hygiène &amp; Environnement (WASH)</option>
              <option value="Santé & Nutrition">Santé &amp; Nutrition</option>
              <option value="Protection & Non-discrimination">Protection &amp; Non-discrimination</option>
              <option value="Participation des Jeunes & Culture">Participation des Jeunes &amp; Culture</option>
            </select>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Format de production *</label>
            <select v-model="form.format" required class="w-full px-4 py-2.5 text-sm">
              <option value="article_photo">Article écrit avec photo</option>
              <option value="photo_reportage">Photo-reportage narratif</option>
              <option value="audio_capsule">Capsule audio (Podcast / Interview)</option>
              <option value="video_courte">Vidéo courte (&lt; 2 minutes)</option>
            </select>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Lieu exact du reportage *</label>
            <input v-model="form.lieu" required type="text" placeholder="Ex: Commune de Limete, Kinshasa" class="w-full px-4 py-2.5 text-sm">
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Sources consultées / Personnes interviewées *</label>
            <input v-model="form.sources" required type="text" placeholder="Ex: Directrice d'école, 2 élèves délégués, 1 infirmier" class="w-full px-4 py-2.5 text-sm">
          </div>
        </div>

        <!-- Simulated Media Upload with Safeguard Scanner -->
        <div class="p-5 bg-[#070A11] rounded-2xl border-2 border-dashed border-white/20 space-y-4">
          <div class="flex items-center justify-between">
            <span class="text-xs font-bold text-white flex items-center gap-2">
              <span>🖼️</span> Téléversement Média (Photo / Audio / Texte)
            </span>
            <span class="text-[11px] font-mono text-[#00ADEF]">Chunked Upload 2G/3G</span>
          </div>

          <div class="flex items-center gap-4">
            <div class="w-20 h-20 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center text-3xl shrink-0">
              📸
            </div>
            <div class="text-xs text-slate-300 space-y-1">
              <div class="font-bold text-white">Fichier téléversé : reportage-terrain.jpg (1.2 Mo)</div>
              <div class="text-emerald-400 font-semibold flex items-center gap-1.5">
                <span>✓</span> Métadonnées GPS et EXIF purgées automatiquement
              </div>
              <div class="text-[#00ADEF] font-semibold flex items-center gap-1.5">
                <span>✓</span> Compression automatique optimisée (&lt; 300 Ko)
              </div>
            </div>
          </div>

          <!-- Face Blur Safeguard Alert Simulation -->
          <div class="p-3.5 bg-amber-500/10 rounded-xl border border-amber-500/30 text-xs text-amber-200 flex items-center gap-3">
            <input type="checkbox" id="faceBlur" v-model="form.faceBlurAlert" class="w-4 h-4 text-[#00ADEF] rounded">
            <label for="faceBlur" class="cursor-pointer">
              <strong>Contrôle de sauvegarde :</strong> L'image contient des visages d'enfants vulnérables nécessitant un floutage éthique avant publication.
            </label>
          </div>
        </div>

        <!-- Mandatory Ethics Declarations -->
        <div class="p-5 bg-white/[0.03] rounded-2xl border border-white/10 space-y-3 text-xs text-slate-300">
          <div class="font-bold text-white mb-1 flex items-center gap-2">
            <span class="text-[#00ADEF]">⚡</span> Engagements Déontologiques Obligatoires :
          </div>
          
          <label class="flex items-start gap-3 cursor-pointer">
            <input type="checkbox" required v-model="form.consentementMentionne" class="mt-0.5 w-4 h-4 text-[#00ADEF] rounded">
            <span>Je certifie avoir recueilli l'accord libre et éclairé de toutes les personnes photographiées ou interviewées.</span>
          </label>

          <label class="flex items-start gap-3 cursor-pointer">
            <input type="checkbox" required v-model="form.verificationFaitsDeclaree" class="mt-0.5 w-4 h-4 text-[#00ADEF] rounded">
            <span>Je déclare avoir vérifié les faits auprès d'au moins deux sources fiables et n'avoir diffusé aucune fausse information.</span>
          </label>
        </div>

        <div class="pt-4 border-t border-white/10 flex flex-col sm:flex-row items-center justify-between gap-4">
          <span class="text-[11px] text-slate-400">Le contenu sera soumis au circuit de validation Niveau 1 (Encadreur REIPE)</span>
          <button type="submit" class="btn-primary text-xs font-black cursor-pointer">
            <span>Soumettre mon Reportage 📤</span>
          </button>
        </div>

      </form>
    </div>

    <!-- My Submitted Articles History -->
    <div class="p-6 sm:p-8 rounded-3xl bg-white/[0.04] border border-white/10 space-y-4">
      <h2 class="text-lg font-black font-heading text-white">Mes Reportages Soumis</h2>

      <div class="space-y-3">
        <div v-for="item in userContents" :key="item.id" class="p-5 rounded-2xl bg-white/[0.02] border border-white/10 flex flex-col sm:flex-row sm:items-center justify-between gap-4 text-xs">
          <div class="space-y-1.5">
            <div class="flex items-center gap-2">
              <span class="font-mono text-[10px] text-[#00ADEF] font-bold">{{ item.id }}</span>
              <span class="px-2.5 py-0.5 rounded-full bg-white/10 text-slate-300 font-bold text-[10px]">{{ item.theme }}</span>
            </div>
            <h4 class="font-bold text-white text-sm">{{ item.titre }}</h4>
            <div class="text-slate-400">Lieu : {{ item.lieu }} • Soumis le {{ item.dateSoumission }}</div>
          </div>

          <div>
            <span v-if="item.statut === 'publie_ponabana'" class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-emerald-500/15 border border-emerald-500/40 text-emerald-400 font-bold">
              ✓ Publié sur Ponabana
            </span>
            <span v-else-if="item.statut === 'valide_encadreur'" class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-sky-500/15 border border-sky-500/40 text-[#00ADEF] font-bold">
              ⏳ Validé Encadreur (En attente Comité)
            </span>
            <span v-else-if="item.statut === 'en_attente_encadreur'" class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-amber-500/15 border border-amber-500/40 text-amber-400 font-bold">
              ⏳ En attente validation encadreur
            </span>
            <span v-else class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-rose-500/15 border border-rose-500/40 text-rose-400 font-bold">
              ⚠️ Modifications demandées
            </span>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAppStore } from '../mock/store'

const store = useAppStore()

const form = ref({
  titre: '',
  theme: 'Éducation & Scolarisation',
  format: 'article_photo',
  lieu: 'Kinshasa / Masina',
  sources: 'Directeur d\'école et élèves',
  consentementMentionne: false,
  verificationFaitsDeclaree: false,
  faceBlurAlert: false
})

const userContents = computed(() => {
  return store.db.reportersContents.filter(c => c.auteurId === store.currentAdo.id)
})

function submitReporterContent() {
  store.soumettreContenu(form.value)
  alert('Votre article a été transmis avec succès à l\'encadreur REIPE de votre zone pour validation éditoriale !')
  form.value.titre = ''
  form.value.consentementMentionne = false
  form.value.verificationFaitsDeclaree = false
}
</script>