<template>
  <!-- 
    =============================================================================================
    MODULE 2 : CONSENTEMENT PARENTAL ET SAUVEGARDE (Section 5 & 7 du Cahier des Charges)
    
    [STATUT DES DÉPENDANCES & LIVRABLES UNICEF REQUIS] :
    1. Formulations juridiques de consentement (Annexe 4) : 
       - En attente de la validation finale des mentions légales de consentement par la section PSE/Sauvegarde et le service juridique UNICEF RDC.
       - En attente des traductions officielles certifiées du formulaire d'information parentale dans les 4 langues nationales (Lingála, Swahili, Tshiluba, Kikongo).
    2. Passerelle d'envoi automatique de SMS parentaux : 
       - En attente de la liaison avec le serveur SMS d'agrégation institutionnel UNICEF.
    3. Bordereaux de consentement papier : 
       - En attente du modèle officiel de bordereau papier avec code-barres/QR d'identification pour la numérisation terrain par les encadreurs REIPE.
    
    Toutes les interfaces ci-dessous fonctionnent actuellement avec la base de données mockée réactive.
    =============================================================================================
  -->
  <div class="max-w-5xl mx-auto space-y-6 sm:space-y-8 pb-16 px-2 sm:px-4">
    
    <!-- Title banner -->
    <div class="text-center space-y-2">
      <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/30 text-xs font-black text-emerald-400 uppercase tracking-wider">
        <span>🛡️ MODULE 2 : CONSENTEMENT PARENTAL &amp; SAUVEGARDE</span>
      </div>
      <h1 class="text-2xl sm:text-4xl font-black font-heading text-white">
        Protection &amp; Autorisation Parentale
      </h1>
      <p class="text-xs sm:text-sm text-slate-400 max-w-xl mx-auto">
        Aucun traitement de données sans autorisation parentale validée (politique de sauvegarde UNICEF RDC &amp; législation congolaise).
      </p>
    </div>

    <!-- Active Adolescent Consent Status Banner -->
    <div class="p-6 sm:p-8 rounded-3xl bg-white/[0.04] border border-white/10 backdrop-blur-xl space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-white/10 pb-5">
        <div>
          <div class="text-xs font-bold text-slate-400">Adolescent sous surveillance :</div>
          <div class="text-xl font-black font-heading text-white flex items-center gap-2 mt-0.5">
            <span>{{ store.currentAdo.prenom }} {{ store.currentAdo.nomFamillePseudonymise }}</span>
            <span class="text-xs font-mono font-normal bg-[#090D16] text-[#00ADEF] px-2.5 py-0.5 rounded-full border border-[#00ADEF]/30">
              {{ store.currentAdo.id }}
            </span>
          </div>
          <div class="text-xs text-slate-400 mt-1">
            Parent / Tuteur : <strong class="text-slate-200">{{ store.currentAdo.consentement.nomParent }}</strong> ({{ store.currentAdo.consentement.telephoneParent }})
          </div>
        </div>

        <div>
          <span v-if="store.currentAdo.consentement.statut === 'valide'" class="inline-flex items-center gap-2 px-4 py-2 rounded-2xl bg-emerald-500/15 border border-emerald-500/40 text-emerald-400 font-bold text-xs shadow-[0_0_15px_rgba(16,185,129,0.2)]">
            <span class="w-2 h-2 rounded-full bg-emerald-400 animate-ping"></span>
            Consentement Validé ({{ store.currentAdo.consentement.mode }})
          </span>
          <span v-else-if="store.currentAdo.consentement.statut === 'en_attente'" class="inline-flex items-center gap-2 px-4 py-2 rounded-2xl bg-amber-500/15 border border-amber-500/40 text-amber-400 font-bold text-xs animate-pulse">
            <span class="w-2 h-2 rounded-full bg-amber-400"></span>
            En Attente de Réponse Parentale
          </span>
          <span v-else class="inline-flex items-center gap-2 px-4 py-2 rounded-2xl bg-rose-500/15 border border-rose-500/40 text-rose-400 font-bold text-xs">
            <span class="w-2 h-2 rounded-full bg-rose-400"></span>
            Consentement Retiré / Compte Purge
          </span>
        </div>
      </div>

      <!-- Action simulators for parental consent -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4 pt-2">
        
        <!-- 1. Simulator SMS / WhatsApp Validation -->
        <div class="p-5 rounded-2xl bg-white/[0.03] border border-white/10 hover:border-[#10B981]/40 transition-all flex flex-col justify-between space-y-4">
          <div>
            <div class="text-sm font-bold text-white flex items-center gap-2">
              <span class="w-7 h-7 rounded-lg bg-emerald-500/20 text-emerald-400 flex items-center justify-center text-xs">💬</span>
              <span>Réponse SMS / WhatsApp</span>
            </div>
            <p class="text-xs text-slate-400 mt-2 leading-relaxed">
              Simuler l'envoi d'un message "OUI" par le parent en réponse au SMS d'information.
            </p>
          </div>
          <button @click="validerParMessage" :disabled="store.currentAdo.consentement.statut === 'valide'" class="btn-primary w-full text-xs">
            Simuler Réponse "OUI" 💬
          </button>
        </div>

        <!-- 2. Paper Consent Upload Simulator -->
        <div class="p-5 rounded-2xl bg-white/[0.03] border border-white/10 hover:border-[#00ADEF]/40 transition-all flex flex-col justify-between space-y-4">
          <div>
            <div class="text-sm font-bold text-white flex items-center gap-2">
              <span class="w-7 h-7 rounded-lg bg-[#00ADEF]/20 text-[#00ADEF] flex items-center justify-center text-xs">📄</span>
              <span>Formulaire Papier Numérisé</span>
            </div>
            <p class="text-xs text-slate-400 mt-2 leading-relaxed">
              Téléversement du bordereau physique signé lors des descentes terrain REIPE.
            </p>
          </div>
          <button @click="validerParPapier" :disabled="store.currentAdo.consentement.statut === 'valide'" class="btn-cyan w-full text-xs">
            Téléverser scan signé 📄
          </button>
        </div>

        <!-- 3. Revocation & Anonymization -->
        <div class="p-5 rounded-2xl bg-rose-500/5 border border-rose-500/20 hover:border-rose-500/40 transition-all flex flex-col justify-between space-y-4">
          <div>
            <div class="text-sm font-bold text-rose-300 flex items-center gap-2">
              <span class="w-7 h-7 rounded-lg bg-rose-500/20 text-rose-400 flex items-center justify-center text-xs">🔒</span>
              <span>Droit de Retrait &amp; Purge</span>
            </div>
            <p class="text-xs text-rose-400/80 mt-2 leading-relaxed">
              Révocation du consentement, blocage de compte et anonymisation irréversible.
            </p>
          </div>
          <button @click="retirerConsentement" :disabled="store.currentAdo.consentement.statut === 'refuse'" class="btn-danger w-full text-xs">
            Retirer le Consentement 🔒
          </button>
        </div>

      </div>
    </div>

    <!-- Parental Explanatory Message Preview in 5 Languages -->
    <!-- 
      [EN ATTENTE LIVRABLE UNICEF - Annexe 4] : 
      Nécessite la validation des textes juridiques et des scripts SMS/WhatsApp 
      par les sections C&A et Sauvegarde de l'UNICEF RDC ainsi que leur traduction certifiée.
    -->
    <div class="p-6 rounded-3xl bg-white/[0.03] border border-white/10 space-y-3">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-white/10 pb-3">
        <h2 class="text-base font-black font-heading text-white">Aperçu du Message d'Information Parentale</h2>
        <div class="flex items-center gap-2">
          <span class="text-[10px] font-bold px-2.5 py-0.5 rounded-full bg-amber-500/10 text-amber-300 border border-amber-500/30">
            ⏳ Validation Juridique UNICEF
          </span>
          <span class="text-xs font-semibold text-[#00ADEF]">Transmis en 5 Langues</span>
        </div>
      </div>

      <div class="p-4 rounded-2xl bg-[#090D16] border border-white/10 text-xs text-slate-300 space-y-2 leading-relaxed">
        <div class="font-bold text-[#00ADEF]">
          Message officiel transmis au parent ({{ store.currentAdo.consentement.telephoneParent }}) :
        </div>
        <p class="italic text-slate-400">
          "Bonjour Monsieur/Madame {{ store.currentAdo.consentement.nomParent }}. Votre adolescent(e) {{ store.currentAdo.prenom }} souhaite participer au programme d'engagement citoyen et de formation aux droits de l'enfant de l'UNICEF RDC. Les formations sont 100% gratuites et sécurisées. Pour valider votre accord parental, répondez simplement <strong>OUI</strong> à ce message ou contactez notre équipe au 116. Vous pouvez retirer cet accord à tout moment."
        </p>
      </div>
    </div>

    <!-- All Registered Adolescents Consent Table -->
    <div class="p-6 rounded-3xl bg-white/[0.04] border border-white/10 space-y-4">
      <div class="flex items-center justify-between">
        <h2 class="text-lg font-black font-heading text-white">Registre Unifié des Consentements</h2>
        <span class="text-xs font-mono text-slate-400">{{ store.db.adolescents.length }} dossiers actifs</span>
      </div>
      
      <div class="overflow-x-auto">
        <table class="w-full text-left text-xs">
          <thead class="bg-white/5 text-slate-400 border-b border-white/10 font-bold uppercase text-[10px] tracking-wider">
            <tr>
              <th class="py-3 px-4">Identifiant</th>
              <th class="py-3 px-4">Prénom &amp; Âge</th>
              <th class="py-3 px-4">Province</th>
              <th class="py-3 px-4">Canal</th>
              <th class="py-3 px-4">Statut Consentement</th>
              <th class="py-3 px-4">Mode</th>
              <th class="py-3 px-4 text-right">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-white/5">
            <tr v-for="ado in store.db.adolescents" :key="ado.id" :class="ado.id === store.currentAdoId ? 'bg-white/[0.06] font-semibold' : ''" class="hover:bg-white/[0.03] transition-colors">
              <td class="py-3 px-4 font-mono text-[#00ADEF]">{{ ado.id }}</td>
              <td class="py-3 px-4 text-white">{{ ado.prenom }} ({{ ado.age }} ans)</td>
              <td class="py-3 px-4 text-slate-300">{{ ado.province }}</td>
              <td class="py-3 px-4 uppercase text-[10px] font-bold text-slate-400">{{ ado.canalInscription }}</td>
              <td class="py-3 px-4">
                <span v-if="ado.consentement.statut === 'valide'" class="text-emerald-400 font-bold">✓ Validé</span>
                <span v-else-if="ado.consentement.statut === 'en_attente'" class="text-amber-400 font-bold">⏳ En attente</span>
                <span v-else class="text-rose-400 font-bold">❌ Retiré</span>
              </td>
              <td class="py-3 px-4 text-slate-400">{{ ado.consentement.mode || 'N/A' }}</td>
              <td class="py-3 px-4 text-right">
                <button @click="store.setAdo(ado.id)" class="px-2.5 py-1 rounded-lg bg-white/10 hover:bg-[#00ADEF] hover:text-white text-slate-200 font-bold transition-all cursor-pointer">
                  Sélectionner
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</template>

<script setup>
import { useAppStore } from '../mock/store'

const store = useAppStore()

function validerParMessage() {
  store.validerConsentement(store.currentAdo.id, 'whatsapp', store.currentAdo.consentement.nomParent)
}

function validerParPapier() {
  store.validerConsentement(store.currentAdo.id, 'papier', store.currentAdo.consentement.nomParent)
}

function retirerConsentement() {
  if (confirm(`Confirmez-vous le retrait du consentement pour ${store.currentAdo.prenom} ? Les données seront immédiatement anonymisées conformément aux règles de sauvegarde.`)) {
    store.retirerConsentement(store.currentAdo.id)
  }
}
</script>