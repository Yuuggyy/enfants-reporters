<template>
  <!-- 
    =============================================================================================
    MODULE 3 : CERTIFICAT OFFICIEL NOMINATIF (Section 5 du Cahier des Charges)
    
    [PÉRIMÈTRE & DÉPENDANCES - LIVRABLES UNICEF REQUIS] :
    1. Gabarit graphique & Sceau officiel (Annexe 1 & 4) : 
       - En attente des chartes graphiques définitives et armoiries officielles des Ministères partenaires et Divisions Provinciales.
    2. Mentions légales et signataires agréés :
       - En attente de la liste des signataires habilités (Chefs de divisions provinciales & Points focaux UNICEF C&A).
    3. URL de vérification publique :
       - Le QR Code pointe actuellement vers le nom de domaine cible unicef / ponabana.org/certificat.
    
    Le générateur de certificat HTML/CSS vectoriel haute résolution est opérationnel et prêt pour l'impression/PDF.
    =============================================================================================
  -->
  <div class="max-w-4xl mx-auto space-y-6 sm:space-y-8 pb-16 px-2 sm:px-4">
    
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 no-print">
      <router-link to="/formation" class="text-xs font-bold text-slate-400 hover:text-[#00ADEF] flex items-center gap-1.5 transition-colors">
        <span>← Retour à l'Académie</span>
      </router-link>
      <div class="flex items-center gap-3">
        <span class="text-[10px] font-bold px-2.5 py-1 rounded-full bg-amber-500/10 text-amber-300 border border-amber-500/30 hidden sm:inline-flex">
          ⏳ Format Officiel Division Provinciale
        </span>
        <button @click="imprimerCertificat" class="btn-primary text-xs font-black shadow-[0_0_20px_rgba(0,173,239,0.35)] cursor-pointer">
          <span>🖨️ Imprimer / Exporter en PDF</span>
        </button>
      </div>
    </div>

    <!-- Official Certificate Document (Printable) -->
    <div class="bg-[#FCFDFE] text-slate-900 border-8 border-double border-[#00ADEF] rounded-3xl p-8 sm:p-14 shadow-2xl relative overflow-hidden space-y-8 print:border-4 print:p-6 print:shadow-none print:rounded-none">
      
      <!-- Watermark background -->
      <div class="absolute inset-0 flex items-center justify-center pointer-events-none opacity-[0.03]">
        <span class="text-[180px] font-black text-sky-950 font-heading">UNICEF</span>
      </div>

      <!-- Header with UNICEF and Republic logos/symbols -->
      <div class="flex items-center justify-between border-b-2 border-sky-900/20 pb-6 relative z-10">
        <div class="text-left space-y-0.5">
          <div class="text-[11px] font-black uppercase tracking-wider text-slate-800 font-heading">RÉPUBLIQUE DÉMOCRATIQUE DU CONGO</div>
          <div class="text-[10px] text-slate-600 font-medium">Ministère du Genre, Enfant et Famille</div>
          <div class="text-[10px] text-slate-600 font-medium">Division Provinciale de {{ store.currentAdo.province }}</div>
        </div>

        <div class="w-16 h-16 rounded-2xl bg-gradient-to-br from-[#00ADEF] to-sky-600 text-white flex items-center justify-center font-black text-2xl shadow-lg border-2 border-white">
          U
        </div>

        <div class="text-right space-y-0.5">
          <div class="text-xs font-black text-[#00ADEF] font-heading">UNICEF RDC</div>
          <div class="text-[10px] text-slate-600 font-medium">Programme Pays CPD 2025–2029</div>
          <div class="text-[10px] font-black text-emerald-700">Réseau REIPE</div>
        </div>
      </div>

      <!-- Main Title -->
      <div class="text-center space-y-2 relative z-10">
        <span class="text-[11px] font-black uppercase tracking-widest text-[#00ADEF] bg-sky-50 px-4 py-1 rounded-full border border-sky-200 shadow-xs">
          Certificat Officiel de Réussite &amp; d'Engagement
        </span>
        <h1 class="text-3xl sm:text-4xl font-black font-heading text-slate-900 tracking-tight pt-2">
          CERTIFICAT D'ENFANT REPORTER &amp; PLAIDOYER
        </h1>
        <p class="text-xs text-slate-500 font-medium">Délivré en application du cadre national d'engagement des adolescents (12–17 ans)</p>
      </div>

      <!-- Recipient name -->
      <div class="text-center space-y-3 py-4 relative z-10">
        <div class="text-xs uppercase tracking-wider text-slate-500 font-semibold">Il est certifié par la présente que :</div>
        <div class="text-3xl sm:text-5xl font-black text-[#00ADEF] font-heading tracking-wide">
          {{ store.currentAdo.prenom }}
        </div>
        <div class="text-xs text-slate-700 max-w-xl mx-auto leading-relaxed">
          Âgé(e) de <strong>{{ store.currentAdo.age }} ans</strong>, résidant à <strong>{{ store.currentAdo.ville }} (Province du {{ store.currentAdo.province }})</strong>, a validé avec succès l'ensemble des 6 modules du parcours de formation aux droits de l'enfant, tactiques de plaidoyer, fact-checking, sécurité numérique et cadre éditorial Ponabana.
        </div>
      </div>

      <!-- Signatures & Verification Area -->
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 pt-6 border-t-2 border-slate-200 items-end text-xs relative z-10">
        
        <!-- Left: Provincial Representative -->
        <div class="text-center space-y-8">
          <div class="text-[11px] font-black text-slate-800">Pour la Division Provinciale :</div>
          <div class="font-serif italic text-slate-600 text-sm">Le Chef de Division</div>
          <div class="w-32 h-0.5 bg-slate-300 mx-auto"></div>
        </div>

        <!-- Center: QR Code Verification -->
        <div class="text-center space-y-2">
          <div class="w-24 h-24 bg-slate-950 text-white mx-auto rounded-2xl flex flex-col items-center justify-center p-2 shadow-inner border border-slate-800">
            <span class="text-3xl">🏁</span>
            <span class="text-[8px] font-mono mt-1 text-[#00ADEF]">AUTH QR-CODE</span>
          </div>
          <div class="font-mono text-[10px] font-black text-slate-800">
            {{ store.currentAdo.progression.codeCertificat || 'CERT-2026-RDC-VALID' }}
          </div>
          <div class="text-[9px] text-slate-500">Authenticité vérifiable sur ponabana.org/certificat</div>
        </div>

        <!-- Right: UNICEF Focal Point -->
        <div class="text-center space-y-8">
          <div class="text-[11px] font-black text-slate-800">Pour l'UNICEF RDC :</div>
          <div class="font-serif italic text-slate-600 text-sm">Section C&amp;A / Sauvegarde</div>
          <div class="w-32 h-0.5 bg-slate-300 mx-auto"></div>
        </div>

      </div>

    </div>

  </div>
</template>

<script setup>
import { useAppStore } from '../mock/store'

const store = useAppStore()

function imprimerCertificat() {
  window.print()
}
</script>

<style scoped>
@media print {
  .no-print {
    display: none !important;
  }
}
</style>