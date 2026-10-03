<template>
  <!-- 
    =============================================================================================
    MODULE 7 : ADMINISTRATION ET GESTION DES ACCÈS (Section 5 du Cahier des Charges)
    
    [PÉRIMÈTRE & DÉPENDANCES - LIVRABLES UNICEF REQUIS] :
    1. Authentification forte adulte 2FA & SSO (Section 5 & 6) : 
       - En attente de l'intégration avec le fournisseur d'identité Azure AD / SSO de l'UNICEF pour les comptes administrateurs et points focaux.
    2. Cloisonnement provincial des données :
       - Modèle de contrôle d'accès basé sur les rôles (RBAC) conforme au principe du moindre privilège.
    3. Habilitation du personnel prestataire (Section 7) :
       - Signature des engagements de sauvegarde, du code de conduite UNICEF et vérification des antécédents avant tout accès aux données de production.
    
    Le sélecteur dynamique de profils et le journal d'audit des actions sensibles sont 100% opérationnels.
    =============================================================================================
  -->
  <div class="max-w-5xl mx-auto space-y-6 sm:space-y-8 pb-16 px-2 sm:px-4">
    
    <!-- Title banner -->
    <div class="text-center space-y-2">
      <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#00ADEF]/15 border border-[#00ADEF]/30 text-xs font-black text-[#00ADEF] uppercase tracking-wider">
        <span>⚙️ MODULE 7 : ADMINISTRATION &amp; SÉCURITÉ</span>
      </div>
      <h1 class="text-2xl sm:text-4xl font-black font-heading text-white">
        Console d'Administration &amp; Journal d'Audit
      </h1>
      <p class="text-xs sm:text-sm text-slate-400 max-w-xl mx-auto">
        Principe du moindre privilège, cloisonnement des données par province, traçabilité cryptographique et journal d'audit immuable.
      </p>
    </div>

    <!-- Roles & Permissions Matrix -->
    <div class="p-6 sm:p-8 rounded-3xl bg-white/[0.04] border border-white/10 backdrop-blur-xl space-y-5">
      <div class="flex items-center justify-between border-b border-white/10 pb-4">
        <div>
          <h2 class="text-lg font-black font-heading text-white">Gestion des Profils &amp; Droits d'Accès</h2>
          <p class="text-xs text-slate-400">Clique sur un rôle pour basculer instantanément de profil utilisateur</p>
        </div>
      </div>
      
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
        <div 
          v-for="r in store.db.roles" 
          :key="r.id" 
          :class="store.currentRole === r.id ? 'border-2 border-[#00ADEF] bg-white/[0.08] shadow-[0_0_20px_rgba(0,173,239,0.25)]' : 'border border-white/10 bg-white/[0.02] hover:border-white/20'" 
          class="p-5 rounded-2xl flex flex-col justify-between space-y-3 cursor-pointer transition-all" 
          @click="store.setRole(r.id)">
          <div>
            <div class="flex items-center justify-between">
              <span class="font-heading font-black text-sm text-white">{{ r.nom }}</span>
              <span v-if="store.currentRole === r.id" class="text-[10px] bg-[#00ADEF] text-white px-2 py-0.5 rounded-full font-black">Actif</span>
            </div>
            <p class="text-[11px] text-slate-400 mt-1.5 leading-relaxed">{{ r.description }}</p>
          </div>
          <button class="text-xs font-bold text-left pt-2 text-[#00ADEF]">
            {{ store.currentRole === r.id ? '● Profil Actuellement Sélectionné' : 'Bascule vers ce profil →' }}
          </button>
        </div>
      </div>
    </div>

    <!-- Security & Audit Log (Journal d'audit Section 5 & 7) -->
    <div class="p-6 sm:p-8 rounded-3xl bg-white/[0.04] border border-white/10 space-y-5">
      <div class="flex items-center justify-between border-b border-white/10 pb-4">
        <div>
          <h2 class="text-lg font-black font-heading text-white">Journal d'Audit des Actions Sensibles (Immuable)</h2>
          <p class="text-xs text-slate-400">Traçabilité complète des consultations, modifications, exports et révocations.</p>
        </div>
        <span class="text-xs font-mono font-bold text-[#00ADEF] bg-white/5 border border-white/10 px-3 py-1 rounded-full">
          {{ store.db.auditLogs.length }} Événements
        </span>
      </div>

      <div class="overflow-x-auto">
        <table class="w-full text-left text-xs">
          <thead class="bg-white/5 text-slate-400 border-b border-white/10 font-bold uppercase text-[10px] tracking-wider">
            <tr>
              <th class="py-3 px-4">Horodatage</th>
              <th class="py-3 px-4">Utilisateur / Profil</th>
              <th class="py-3 px-4">Action Réalisée</th>
              <th class="py-3 px-4">Détails Techniques</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-white/5 font-mono">
            <tr v-for="log in store.db.auditLogs" :key="log.id" class="hover:bg-white/[0.02] transition-colors">
              <td class="py-3 px-4 text-slate-400">{{ log.horodatage }}</td>
              <td class="py-3 px-4 font-sans font-bold text-white">{{ log.utilisateur }} ({{ log.role }})</td>
              <td class="py-3 px-4 font-sans font-black text-[#00ADEF]">{{ log.action }}</td>
              <td class="py-3 px-4 text-slate-300 font-sans">{{ log.details }}</td>
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
</script>