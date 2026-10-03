<template>
  <div class="max-w-4xl mx-auto space-y-8 pb-16">
    
    <!-- Header Title & Context -->
    <div class="text-center space-y-2">
      <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#00ADEF]/10 border border-[#00ADEF]/30 text-xs font-black text-[#00ADEF] uppercase tracking-wider">
        <span>⚡ MODULE 1 : MOBILISATION & INSCRIPTION MULTICANALE</span>
      </div>
      <h1 class="text-2xl sm:text-4xl font-black font-heading text-white">
        Rejoins la Vague des Adolescents Engagés
      </h1>
      <p class="text-xs sm:text-sm text-slate-400 max-w-xl mx-auto">
        Accessible partout en RDC sur smartphone, WhatsApp, SMS/USSD ou via les encadreurs de proximité REIPE.
      </p>
    </div>

    <!-- Channel Selector Tabs (Sleek Glass Pills) -->
    <div class="p-1.5 rounded-2xl bg-white/[0.04] border border-white/10 backdrop-blur-xl flex flex-wrap gap-2 text-xs font-bold">
      <button 
        @click="activeChannel = 'web'" 
        :class="activeChannel === 'web' ? '!bg-[#00ADEF] !text-white shadow-[0_0_15px_rgba(0,173,239,0.35)]' : 'text-slate-300 hover:text-white hover:bg-white/5'"
        class="flex-1 min-w-[140px] py-3 px-4 rounded-xl flex items-center justify-center gap-2 transition-all cursor-pointer">
        <span>🌐</span> Formulaire Web (&lt;500 Ko)
      </button>
      <button 
        @click="activeChannel = 'whatsapp'" 
        :class="activeChannel === 'whatsapp' ? '!bg-[#0072F5] !text-white shadow-[0_0_15px_rgba(0,114,245,0.35)]' : 'text-slate-300 hover:text-white hover:bg-white/5'"
        class="flex-1 min-w-[140px] py-3 px-4 rounded-xl flex items-center justify-center gap-2 transition-all cursor-pointer">
        <span>💬</span> Chatbot WhatsApp
      </button>
      <button 
        @click="activeChannel = 'sms'" 
        :class="activeChannel === 'sms' ? '!bg-[#0284C7] !text-white shadow-[0_0_15px_rgba(2,132,199,0.35)]' : 'text-slate-300 hover:text-white hover:bg-white/5'"
        class="flex-1 min-w-[140px] py-3 px-4 rounded-xl flex items-center justify-center gap-2 transition-all cursor-pointer">
        <span>📱</span> Simulateur SMS / USSD
      </button>
      <button 
        @click="activeChannel = 'assiste'" 
        :class="activeChannel === 'assiste' ? '!bg-[#6366F1] !text-white shadow-[0_0_15px_rgba(99,102,241,0.35)]' : 'text-slate-300 hover:text-white hover:bg-white/5'"
        class="flex-1 min-w-[140px] py-3 px-4 rounded-xl flex items-center justify-center gap-2 transition-all cursor-pointer">
        <span>🤝</span> Mode Terrain REIPE
      </button>
    </div>

    <!-- Success Feedback Overlay -->
    <div v-if="registeredAdo" class="p-8 sm:p-10 rounded-3xl bg-gradient-to-b from-[#131A2B] to-[#0B0F19] border-2 border-[#00ADEF] space-y-6 text-center shadow-[0_0_35px_rgba(0,173,239,0.2)]">
      <div class="w-20 h-20 rounded-3xl bg-[#00ADEF]/15 text-[#00ADEF] text-4xl font-black flex items-center justify-center mx-auto border border-[#00ADEF]/40 shadow-lg animate-bounce">
        ✓
      </div>
      <div class="space-y-2">
        <h3 class="text-2xl font-black font-heading text-white">Inscription Validée avec Succès !</h3>
        <p class="text-sm text-slate-300 max-w-lg mx-auto">
          Bienvenue <strong>{{ registeredAdo.prenom }}</strong>. Ton identifiant unique confidentiel non-signifiant est :
        </p>
      </div>

      <div class="inline-block bg-[#090D16] px-8 py-4 rounded-2xl border border-[#00ADEF]/50 font-mono text-2xl font-black text-[#00ADEF] tracking-wider shadow-inner">
        {{ registeredAdo.id }}
      </div>

      <div class="p-5 bg-white/[0.03] rounded-2xl border border-white/10 text-xs text-left max-w-lg mx-auto space-y-2">
        <div class="font-bold text-white flex items-center gap-2">
          <span class="w-2 h-2 rounded-full bg-[#00ADEF]"></span>
          <span>Prochaine Étape : Validation du Consentement Parental</span>
        </div>
        <div class="text-slate-300 leading-relaxed">
          Un message automatique a été envoyé au tuteur légal ({{ registeredAdo.consentement.telephoneParent }}). Dès validation, l'accès complet aux modules et aux groupes communautaires sera activé.
        </div>
      </div>

      <div class="flex flex-wrap justify-center gap-3 pt-4">
        <router-link to="/consentement" class="btn-primary">
          <span>Simuler la Validation Parentale →</span>
        </router-link>
        <button @click="registeredAdo = null" class="btn-secondary">
          <span>Inscrire un Autre Adolescent</span>
        </button>
      </div>
    </div>

    <!-- 1. Web Form (< 500 Ko) -->
    <div v-else-if="activeChannel === 'web'" class="p-6 sm:p-8 rounded-3xl bg-white/[0.04] border border-white/10 backdrop-blur-xl space-y-6">
      <div class="flex items-center justify-between border-b border-white/10 pb-4">
        <div>
          <h2 class="text-xl font-black font-heading text-white">Formulaire Mobile-First Léger</h2>
          <p class="text-xs text-slate-400 mt-0.5">Optimisé 2G/3G • Poids de transfert inférieur à 120 Ko</p>
        </div>
        <span class="text-[11px] font-black px-3 py-1 rounded-full bg-[#00ADEF]/15 text-[#00ADEF] border border-[#00ADEF]/30">
          Moins de 500 Ko
        </span>
      </div>

      <!-- Age Gating Notice -->
      <div v-if="ageError" class="p-4 bg-rose-500/10 border border-rose-500/30 rounded-2xl text-xs text-rose-300 flex items-start gap-3">
        <span class="text-xl">⚠️</span>
        <div>
          <strong class="text-rose-200">Âge non éligible ({{ form.age }} ans) :</strong> Le programme d'engagement des adolescents est strictement réservé aux <strong>12 à 17 ans</strong>. Les personnes majeures (18+) sont orientées vers les rôles de mentor ou U-Report Jeunesse.
        </div>
      </div>

      <form @submit.prevent="submitWebForm" class="space-y-5">
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          
          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Prénom de l'adolescent(e) *</label>
            <input v-model="form.prenom" required type="text" placeholder="Ex: Amina" class="w-full px-4 py-2.5 text-sm">
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Nom de famille (sera pseudonymisé) *</label>
            <input v-model="form.nomFamille" required type="text" placeholder="Ex: Kanku" class="w-full px-4 py-2.5 text-sm">
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Âge (12 à 17 ans révolus) *</label>
            <input v-model.number="form.age" @input="checkAge" required type="number" min="10" max="25" placeholder="15" class="w-full px-4 py-2.5 text-sm">
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Sexe *</label>
            <select v-model="form.sexe" required class="w-full px-4 py-2.5 text-sm">
              <option value="F">Féminin (Fille)</option>
              <option value="M">Masculin (Garçon)</option>
            </select>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Province *</label>
            <select v-model="form.province" required class="w-full px-4 py-2.5 text-sm">
              <option v-for="p in store.db.provinces" :key="p.id" :value="p.nom">{{ p.nom }}</option>
            </select>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Ville ou Territoire *</label>
            <input v-model="form.ville" required type="text" placeholder="Ex: Ndjili, Kenya, Goma..." class="w-full px-4 py-2.5 text-sm">
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Milieu de vie *</label>
            <select v-model="form.milieu" required class="w-full px-4 py-2.5 text-sm">
              <option value="urbain">Urbain</option>
              <option value="rural">Rural</option>
            </select>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Statut scolaire *</label>
            <select v-model="form.statutScolaire" required class="w-full px-4 py-2.5 text-sm">
              <option value="scolarise">Scolarisé(e)</option>
              <option value="non_scolarise">Déscolarisé(e) / Non scolarisé(e)</option>
              <option value="formation_pro">En formation professionnelle</option>
            </select>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Situation de handicap (facultatif / déclaratif)</label>
            <select v-model="form.handicap" class="w-full px-4 py-2.5 text-sm">
              <option value="aucun">Aucun handicap déclaré</option>
              <option value="visuel">Déficience visuelle</option>
              <option value="auditif">Déficience auditive</option>
              <option value="moteur">Handicap moteur</option>
              <option value="autre">Autre situation spécifique</option>
            </select>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Langue de formation préférée *</label>
            <select v-model="form.langue" required class="w-full px-4 py-2.5 text-sm">
              <option v-for="l in store.db.languages" :key="l.code" :value="l.code">
                {{ l.flag }} {{ l.nom }}
              </option>
            </select>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Téléphone de l'adolescent (ou parent)</label>
            <input v-model="form.telephone" type="tel" placeholder="+243..." class="w-full px-4 py-2.5 text-sm font-mono">
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Téléphone du Parent / Tuteur (Consentement) *</label>
            <input v-model="form.telephoneParent" required type="tel" placeholder="+243..." class="w-full px-4 py-2.5 text-sm font-mono">
          </div>

        </div>

        <div class="pt-4">
          <button type="submit" :disabled="ageError" class="btn-primary w-full text-sm font-bold">
            <span>Valider et Générer Mon Identifiant Unique 🚀</span>
          </button>
        </div>
      </form>
    </div>

    <!-- 2. WhatsApp Simulator (RapidPro Integration) -->
    <div v-else-if="activeChannel === 'whatsapp'" class="p-6 sm:p-8 rounded-3xl bg-white/[0.04] border border-white/10 backdrop-blur-xl space-y-6">
      <div class="flex items-center justify-between border-b border-white/10 pb-4">
        <div>
          <h2 class="text-xl font-black font-heading text-white">Simulateur Chatbot WhatsApp (RapidPro)</h2>
          <p class="text-xs text-slate-400 mt-0.5">Infrastructure U-Report RDC existante • Multilingue</p>
        </div>
        <span class="text-[11px] font-black px-3 py-1 rounded-full bg-emerald-500/15 text-emerald-400 border border-emerald-500/30">
          +243 81 U-REPORT
        </span>
      </div>

      <!-- Phone Frame Mockup -->
      <div class="max-w-md mx-auto bg-[#070A11] rounded-3xl border border-white/20 shadow-2xl overflow-hidden">
        <!-- WhatsApp Header -->
        <div class="bg-[#1F2C34] text-white p-3.5 flex items-center justify-between border-b border-white/10">
          <div class="flex items-center gap-3">
            <div class="w-9 h-9 rounded-full bg-emerald-600 flex items-center justify-center font-black text-sm">
              U
            </div>
            <div>
              <div class="font-bold text-xs">U-Report RDC (UNICEF)</div>
              <div class="text-[10px] text-emerald-400">En ligne • Bot Officiel</div>
            </div>
          </div>
          <span class="text-xs font-mono text-slate-400">RapidPro API</span>
        </div>

        <!-- Chat Conversation Area -->
        <div class="p-4 space-y-3 h-80 overflow-y-auto bg-[#0C1317]">
          <div v-for="(msg, index) in botMessages" :key="index" :class="msg.fromUser ? 'text-right' : 'text-left'">
            <div 
              :class="msg.fromUser ? 'bg-[#005C4B] text-white ml-auto' : 'bg-[#202C33] text-slate-100 mr-auto'"
              class="inline-block p-3 rounded-2xl text-xs max-w-[85%] leading-relaxed shadow-sm">
              {{ msg.text }}
            </div>
          </div>
        </div>

        <!-- Input Area -->
        <div class="p-3 bg-[#1F2C34] flex items-center gap-2">
          <input 
            v-model="botInput" 
            @keyup.enter="sendBotMsg" 
            type="text" 
            placeholder="Tape ton message ici..." 
            class="flex-1 !bg-[#2A3942] !border-none text-white text-xs px-3.5 py-2 rounded-xl focus:!ring-1 focus:!ring-emerald-500">
          <button @click="sendBotMsg" class="w-9 h-9 rounded-xl bg-[#00A884] text-white flex items-center justify-center font-bold text-sm cursor-pointer">
            ➤
          </button>
        </div>
      </div>
    </div>

    <!-- 3. SMS / USSD Simulator (Nokia Vintage LCD) -->
    <div v-else-if="activeChannel === 'sms'" class="p-6 sm:p-8 rounded-3xl bg-white/[0.04] border border-white/10 backdrop-blur-xl space-y-6">
      <div class="flex items-center justify-between border-b border-white/10 pb-4">
        <div>
          <h2 class="text-xl font-black font-heading text-white">Parcours SMS &amp; Code USSD (*116#)</h2>
          <p class="text-xs text-slate-400 mt-0.5">Adapté aux téléphones basiques sans internet</p>
        </div>
        <span class="text-[11px] font-black px-3 py-1 rounded-full bg-[#00ADEF]/15 text-[#00ADEF] border border-[#00ADEF]/30">
          GSM 2G Gratuit
        </span>
      </div>

      <!-- Vintage Phone Screen -->
      <div class="max-w-xs mx-auto p-5 bg-[#131A2B] rounded-3xl border border-white/20 shadow-2xl space-y-4">
        <!-- Retro LCD Display -->
        <div class="bg-[#1C281F] text-[#6BF178] p-4 rounded-2xl font-mono text-xs space-y-2 border border-[#6BF178]/30 min-h-[140px] shadow-inner whitespace-pre-line leading-relaxed">
          {{ ussdScreen }}
        </div>

        <div class="flex gap-2">
          <input 
            v-model="ussdInput" 
            @keyup.enter="handleUssd" 
            type="text" 
            placeholder="Tape 1, 2, 3..." 
            class="flex-1 !bg-[#070A11] !border-white/10 text-[#6BF178] font-mono text-xs px-3 py-2 rounded-xl">
          <button @click="handleUssd" class="px-4 py-2 rounded-xl bg-[#00ADEF] text-white text-xs font-bold cursor-pointer">
            Envoyer
          </button>
        </div>

        <div class="text-[10px] text-slate-400 text-center">
          Simulation passerelle Vodacom / Airtel / Orange / Africell
        </div>
      </div>
    </div>

    <!-- 4. Mode Inscription Assistée REIPE -->
    <div v-else-if="activeChannel === 'assiste'" class="p-6 sm:p-8 rounded-3xl bg-white/[0.04] border border-white/10 backdrop-blur-xl space-y-6">
      <div class="flex items-center justify-between border-b border-white/10 pb-4">
        <div>
          <h2 class="text-xl font-black font-heading text-white">Mode Inscription Assistée Terrain (REIPE)</h2>
          <p class="text-xs text-slate-400 mt-0.5">Pour les jeunes encadreurs et relais communautaires hors ligne</p>
        </div>
        <span class="text-[11px] font-black px-3 py-1 rounded-full bg-purple-500/15 text-purple-400 border border-purple-500/30">
          Hors Ligne Actif
        </span>
      </div>

      <form @submit.prevent="submitAssistedForm" class="space-y-4">
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Prénom de l'adolescent(e)</label>
            <input v-model="assistedForm.prenom" required type="text" placeholder="Ex: Dorcas" class="w-full px-4 py-2.5 text-sm">
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Âge (12-17)</label>
            <input v-model.number="assistedForm.age" required type="number" min="12" max="17" class="w-full px-4 py-2.5 text-sm">
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Province de collecte</label>
            <select v-model="assistedForm.province" class="w-full px-4 py-2.5 text-sm">
              <option v-for="p in store.db.provinces" :key="p.id" :value="p.nom">{{ p.nom }}</option>
            </select>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-300 mb-1.5">Nom du Parent / Tuteur</label>
            <input v-model="assistedForm.nomParent" required type="text" placeholder="Ex: Maman Bahati" class="w-full px-4 py-2.5 text-sm">
          </div>
        </div>

        <div class="flex items-center gap-2 p-3 bg-white/[0.02] rounded-xl border border-white/10">
          <input v-model="assistedForm.hasPaperConsent" type="checkbox" id="paperConsent" class="w-4 h-4 text-purple-600 rounded">
          <label for="paperConsent" class="text-xs text-slate-300">
            Bordereau papier de consentement signé physiquement par le tuteur sur le terrain
          </label>
        </div>

        <button type="submit" class="btn-primary w-full text-sm font-bold cursor-pointer">
          <span>Enregistrer l'Adolescent sur le Terrain ✍️</span>
        </button>
      </form>
    </div>

  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useAppStore } from '../mock/store'

const store = useAppStore()

const activeChannel = ref('web')
const registeredAdo = ref(null)
const ageError = ref(false)

// Web form model
const form = ref({
  prenom: '',
  nomFamille: '',
  age: 15,
  sexe: 'F',
  province: 'Kinshasa',
  ville: 'Kinshasa',
  milieu: 'urbain',
  statutScolaire: 'scolarise',
  handicap: 'aucun',
  langue: store.currentLanguage,
  telephone: '+243810012345',
  telephoneParent: '+243990012345',
  canalInscription: 'web'
})

function checkAge() {
  if (form.value.age < 12 || form.value.age > 17) {
    ageError.value = true
  } else {
    ageError.value = false
  }
}

function submitWebForm() {
  if (ageError.value) return
  form.value.canalInscription = 'web'
  const newAdo = store.inscrireAdolescent(form.value)
  registeredAdo.value = newAdo
}

// WhatsApp bot simulator
const botInput = ref('')
const botStep = ref(0)
const botMessages = ref([
  { fromUser: false, text: 'Bienvenue ! Réponds en tapant ton Prénom et ton Âge (ex: Gloria 15)' }
])

function sendBotMsg() {
  if (!botInput.value) return
  const text = botInput.value
  botMessages.value.push({ fromUser: true, text })
  botInput.value = ''

  setTimeout(() => {
    if (botStep.value === 0) {
      botMessages.value.push({ fromUser: false, text: 'Super ! Dans quelle province habites-tu ? (ex: Kinshasa, Haut-Katanga, Nord-Kivu...)' })
      botStep.value = 1
    } else if (botStep.value === 1) {
      botMessages.value.push({ fromUser: false, text: 'Quel est le numéro WhatsApp ou téléphone de ton parent ou tuteur pour valider ton consentement ?' })
      botStep.value = 2
    } else {
      const generated = store.inscrireAdolescent({
        prenom: text.split(' ')[0] || 'Adolescent WhatsApp',
        nomFamille: 'W***',
        age: 15,
        sexe: 'F',
        province: 'Kinshasa',
        ville: 'Kinshasa',
        canalInscription: 'whatsapp',
        telephone: '+243810009988',
        telephoneParent: text
      })
      botMessages.value.push({ fromUser: false, text: `🎉 Félicitations ! Ton inscription est enregistrée sous le code ${generated.id}. Un SMS a été envoyé à ton parent.` })
    }
  }, 600)
}

// USSD Simulator
const ussdScreen = ref('Bienvenue UNICEF RDC\n1. S\'inscrire au programme\n2. Vérifier mon statut\n3. Urgence Sauvegarde')
const ussdInput = ref('')
const ussdStep = ref(0)

function handleUssd() {
  const val = ussdInput.value.trim()
  ussdInput.value = ''

  if (ussdStep.value === 0) {
    if (val === '1') {
      ussdScreen.value = 'Entrez votre Prénom et Âge séparés par un espace (ex: David 16) :'
      ussdStep.value = 1
    } else if (val === '3') {
      ussdScreen.value = 'Alerte Sauvegarde envoyée. Le numéro d\'urgence 116 est gratuit.'
    } else {
      ussdScreen.value = 'Option invalide. Réessayez.'
    }
  } else if (ussdStep.value === 1) {
    const parts = val.split(' ')
    const prenom = parts[0] || 'Ado'
    const age = parseInt(parts[1]) || 15
    const ado = store.inscrireAdolescent({
      prenom,
      nomFamille: 'S***',
      age,
      sexe: 'M',
      province: 'Kasaï-Oriental',
      ville: 'Mbuji-Mayi',
      canalInscription: 'sms',
      telephone: '+243840001122',
      telephoneParent: '+243980001122'
    })
    ussdScreen.value = `Succès ! ID: ${ado.id}\nConsentement en attente SMS parent.`
    ussdStep.value = 0
  }
}

// Assisted Form
const assistedForm = ref({
  prenom: '',
  age: 14,
  sexe: 'F',
  province: 'Nord-Kivu',
  ville: 'Goma',
  nomParent: '',
  hasPaperConsent: true
})

function submitAssistedForm() {
  const ado = store.inscrireAdolescent({
    prenom: assistedForm.value.prenom,
    nomFamille: 'P***',
    age: assistedForm.value.age,
    sexe: assistedForm.value.sexe,
    province: assistedForm.value.province,
    ville: assistedForm.value.ville,
    canalInscription: 'assiste_reipe',
    nomParent: assistedForm.value.nomParent,
    telephone: '+243890001122',
    telephoneParent: '+243990001122'
  })
  if (assistedForm.value.hasPaperConsent) {
    store.validerConsentement(ado.id, 'papier', assistedForm.value.nomParent)
  }
  registeredAdo.value = ado
}
</script>