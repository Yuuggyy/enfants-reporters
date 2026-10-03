<template>
  <!-- 
    =============================================================================================
    MODULE 4 : COMMUNAUTÉS D'ENGAGEMENT & SUIVI DE TERRAIN (Section 5 du Cahier des Charges)
    
    [PÉRIMÈTRE & DÉPENDANCES - LIVRABLES UNICEF REQUIS] :
    1. Interopérabilité KoboToolbox (Annexe 5) : 
       - En attente de l'accès au compte/serveur KoboToolbox UNICEF RDC et des templates XLSForm de collecte terrain.
    2. Groupes WhatsApp de proximité :
       - En attente de la configuration des numéros et liens d'invitation sécurisés générés et contrôlés par les jeunes encadreurs REIPE.
    3. Fiches de campagnes de plaidoyer et engagements :
       - Modèle de documentation d'impact conforme au cadre de suivi-évaluation UNICEF.
    
    Toutes les interfaces ci-dessous fonctionnent actuellement avec la base de données mockée réactive.
    =============================================================================================
  -->
  <div class="max-w-5xl mx-auto space-y-6 sm:space-y-8 pb-16 px-2 sm:px-4">
    
    <!-- Title banner -->
    <div class="text-center space-y-2">
      <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-amber-500/15 border border-amber-500/30 text-xs font-black text-amber-400 uppercase tracking-wider">
        <span>🤝 MODULE 4 : COMMUNAUTÉS LOCALES &amp; TERRAIN REIPE</span>
      </div>
      <h1 class="text-2xl sm:text-4xl font-black font-heading text-white">
        Espace Encadreurs &amp; Suivi de Proximité
      </h1>
      <p class="text-xs sm:text-sm text-slate-400 max-w-xl mx-auto">
        Animation locale, affectation automatique aux groupes WhatsApp sécurisés, alertes de décrochage et suivi des engagements des autorités.
      </p>
    </div>

    <!-- Active Field Stats -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
      <div class="p-5 rounded-3xl bg-white/[0.04] border border-white/10 hover:border-amber-400/40 transition-all">
        <div class="text-xs font-bold text-slate-400">Groupes Territoriaux</div>
        <div class="text-2xl font-black font-heading text-white mt-2">14 Zones</div>
        <div class="text-[11px] text-[#00ADEF] font-bold mt-1">Kinshasa, Lubumbashi, Goma...</div>
      </div>

      <div class="p-5 rounded-3xl bg-white/[0.04] border border-white/10 hover:border-sky-400/40 transition-all">
        <div class="text-xs font-bold text-slate-400">Campagnes Menées</div>
        <div class="text-2xl font-black font-heading text-white mt-2">{{ store.db.advocacyCampaigns.length }}</div>
        <div class="text-[11px] text-[#00ADEF] font-bold mt-1">Plaidoyer direct autorités</div>
      </div>

      <div class="p-5 rounded-3xl bg-white/[0.04] border border-white/10 hover:border-emerald-400/40 transition-all">
        <div class="text-xs font-bold text-slate-400">Engagements Obtenus</div>
        <div class="text-2xl font-black font-heading text-emerald-400 mt-2">2 Actes</div>
        <div class="text-[11px] text-slate-400 font-medium mt-1">Bourgmestres &amp; Mairies</div>
      </div>

      <div class="p-5 rounded-3xl bg-white/[0.04] border border-white/10 hover:border-purple-400/40 transition-all">
        <div class="text-xs font-bold text-slate-400">Transition 18 ans</div>
        <div class="text-2xl font-black font-heading text-purple-400 mt-2">3 Mentors</div>
        <div class="text-[11px] text-purple-300 font-medium mt-1">Vivier des anciens</div>
      </div>
    </div>

    <!-- REIPE Supervisor Youth List with Dropout Alert -->
    <div class="p-6 sm:p-8 rounded-3xl bg-white/[0.04] border border-white/10 space-y-4">
      <div class="flex items-center justify-between border-b border-white/10 pb-4">
        <div>
          <h2 class="text-lg font-black font-heading text-white">Tableau de Suivi de Proximité des Adolescents</h2>
          <p class="text-xs text-slate-400">Détection automatique du risque de décrochage et relance multicanale</p>
        </div>
        <span class="text-xs font-bold text-purple-400 bg-purple-500/10 border border-purple-500/30 px-3 py-1 rounded-full">
          Supervision REIPE
        </span>
      </div>

      <div class="overflow-x-auto">
        <table class="w-full text-left text-xs">
          <thead class="bg-white/5 text-slate-400 border-b border-white/10 font-bold uppercase text-[10px] tracking-wider">
            <tr>
              <th class="py-3 px-4">Adolescent</th>
              <th class="py-3 px-4">Zone / Ville</th>
              <th class="py-3 px-4">Groupe WhatsApp</th>
              <th class="py-3 px-4">Modules Validés</th>
              <th class="py-3 px-4">Statut &amp; Alerte</th>
              <th class="py-3 px-4 text-right">Action</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-white/5">
            <tr v-for="ado in store.db.adolescents" :key="ado.id" class="hover:bg-white/[0.03] transition-colors">
              <td class="py-3 px-4">
                <div class="font-bold text-white">{{ ado.prenom }} ({{ ado.age }} ans)</div>
                <div class="font-mono text-[10px] text-[#00ADEF]">{{ ado.id }}</div>
              </td>
              <td class="py-3 px-4 text-slate-300">{{ ado.ville }} ({{ ado.province }})</td>
              <td class="py-3 px-4">
                <span class="inline-flex items-center gap-1.5 text-[11px] font-bold text-emerald-400 bg-emerald-500/10 px-2.5 py-1 rounded-xl border border-emerald-500/30">
                  <span>📱</span> WA-{{ ado.province.substring(0, 3).toUpperCase() }}-{{ ado.ville.split('/')[0].trim() }}
                </span>
              </td>
              <td class="py-3 px-4">
                <div class="flex items-center gap-2">
                  <div class="w-16 h-2 bg-slate-900 rounded-full overflow-hidden p-0.5">
                    <div class="h-full bg-gradient-to-r from-[#00ADEF] to-[#0072F5] rounded-full" :style="{ width: `${(ado.progression.modulesTermines.length / 6) * 100}%` }"></div>
                  </div>
                  <span class="font-bold text-white">{{ ado.progression.modulesTermines.length }}/6</span>
                </div>
              </td>
              <td class="py-3 px-4">
                <span v-if="ado.progression.certifie" class="px-2.5 py-1 rounded-full bg-emerald-500/15 border border-emerald-500/30 text-emerald-400 font-bold text-[10px]">
                  ✓ Certifié Actif
                </span>
                <span v-else-if="ado.progression.modulesTermines.length === 0" class="px-2.5 py-1 rounded-full bg-rose-500/15 border border-rose-500/30 text-rose-400 font-bold text-[10px] animate-pulse">
                  ⚠️ Risque Décrochage
                </span>
                <span v-else class="px-2.5 py-1 rounded-full bg-sky-500/15 border border-sky-500/30 text-[#00ADEF] font-bold text-[10px]">
                  En Formation
                </span>
              </td>
              <td class="py-3 px-4 text-right">
                <button @click="relancerAdo(ado)" class="px-2.5 py-1 rounded-lg bg-white/10 hover:bg-[#00ADEF] hover:text-white text-slate-200 font-bold transition-all cursor-pointer">
                  Relancer 💬
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Advocacy Campaigns Module -->
    <div class="p-6 sm:p-8 rounded-3xl bg-white/[0.04] border border-white/10 space-y-5">
      <div class="flex items-center justify-between border-b border-white/10 pb-4">
        <div>
          <h2 class="text-lg font-black font-heading text-white">Gestion des Campagnes de Plaidoyer Locales</h2>
          <p class="text-xs text-slate-400">Documentation des actions citoyennes et suivi des engagements des autorités.</p>
        </div>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
        <div v-for="camp in store.db.advocacyCampaigns" :key="camp.id" class="p-5 rounded-2xl bg-white/[0.02] border border-white/10 hover:border-[#00ADEF]/40 transition-all space-y-4">
          <div class="flex items-start justify-between">
            <span class="text-[10px] font-mono font-bold bg-[#090D16] px-2.5 py-0.5 rounded-full border border-white/10 text-[#00ADEF]">{{ camp.id }}</span>
            <span :class="camp.statut === 'succes' ? 'bg-emerald-500/15 border border-emerald-500/30 text-emerald-400' : 'bg-sky-500/15 border border-sky-500/30 text-[#00ADEF]'" class="px-2.5 py-0.5 rounded-full text-[10px] font-bold">
              {{ camp.statut === 'succes' ? '✓ Engagement Obtenu' : 'En cours' }}
            </span>
          </div>

          <h3 class="font-bold text-white text-base">{{ camp.titre }}</h3>
          <div class="text-xs text-slate-300 space-y-1">
            <div>📍 <strong>Province :</strong> {{ camp.province }}</div>
            <div>🎯 <strong>Cible décideurs :</strong> {{ camp.cibleDecideurs }}</div>
            <div>👥 <strong>Adolescents mobilisés :</strong> <span class="text-[#00ADEF] font-bold">{{ camp.adosParticipants }}</span></div>
          </div>

          <div class="p-3.5 bg-[#070A11] rounded-xl border border-white/10 text-xs text-slate-300 space-y-1">
            <div class="font-bold text-emerald-400 flex items-center gap-1.5">
              <span>📜</span> Engagement Officiel Obtenu :
            </div>
            <div v-for="(eng, i) in camp.engagementsObtenus" :key="i" class="italic">"{{ eng }}"</div>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { useAppStore } from '../mock/store'

const store = useAppStore()

function relancerAdo(ado) {
  alert(`Message automatique de rappel envoyé par WhatsApp/SMS à ${ado.prenom} (${ado.telephone}) pour encourager la reprise du module interrompu.`)
}
</script>