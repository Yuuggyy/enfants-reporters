import { defineStore } from 'pinia'
import { INITIAL_DATABASE } from './database'

const STORAGE_KEY = 'unicef_rdc_db_v1'

function loadFromStorage() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw) {
      return JSON.parse(raw)
    }
  } catch (e) {
    console.error('Erreur chargement localStorage', e)
  }
  return JSON.parse(JSON.stringify(INITIAL_DATABASE))
}

function saveToStorage(state) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(state.db))
  } catch (e) {
    console.error('Erreur sauvegarde localStorage', e)
  }
}

export const useAppStore = defineStore('app', {
  state: () => ({
    db: loadFromStorage(),
    currentRole: 'ado', // 'ado' | 'encadreur' | 'ponabana' | 'provincial' | 'unicef_ca' | 'admin'
    currentLanguage: 'fr', // 'fr' | 'ln' | 'sw' | 'tsh' | 'kg'
    currentAdoId: 'UNICEF-RDC-784101', // Active adolescent session
    safeguardModalOpen: false,
    offlineQueue: [], // For REIPE assisted offline sync
    isOfflineMode: false
  }),

  getters: {
    currentAdo(state) {
      return state.db.adolescents.find(a => a.id === state.currentAdoId) || state.db.adolescents[0]
    },

    stats(state) {
      const ados = state.db.adolescents
      const totalInscrits = ados.length
      const consentementsValides = ados.filter(a => a.consentement.statut === 'valide').length
      const certifieCount = ados.filter(a => a.progression.certifie).length
      const filles = ados.filter(a => a.sexe === 'F').length
      const garcons = ados.filter(a => a.sexe === 'M').length
      const handicapCount = ados.filter(a => a.handicap !== 'aucun').length
      const ruraux = ados.filter(a => a.milieu === 'rural').length
      const contenusPublies = state.db.reportersContents.filter(c => c.statut === 'publie_ponabana').length
      const campagnesTotal = state.db.advocacyCampaigns.length
      const incidentsSauvegarde = state.db.safeguardIncidents.length

      return {
        totalInscrits,
        consentementsValides,
        tauxConsentement: Math.round((consentementsValides / (totalInscrits || 1)) * 100),
        certifieCount,
        tauxCertification: Math.round((certifieCount / (totalInscrits || 1)) * 100),
        pourcentageFilles: Math.round((filles / (totalInscrits || 1)) * 100),
        filles,
        garcons,
        handicapCount,
        ruraux,
        contenusPublies,
        campagnesTotal,
        incidentsSauvegarde
      }
    },

    pendingEncadreurContents(state) {
      return state.db.reportersContents.filter(c => c.statut === 'en_attente_encadreur')
    },

    pendingPonabanaContents(state) {
      return state.db.reportersContents.filter(c => c.statut === 'valide_encadreur')
    }
  },

  actions: {
    setRole(roleId) {
      this.currentRole = roleId
    },

    setLanguage(langCode) {
      this.currentLanguage = langCode
    },

    setAdo(adoId) {
      this.currentAdoId = adoId
    },

    toggleSafeguardModal(val) {
      this.safeguardModalOpen = typeof val === 'boolean' ? val : !this.safeguardModalOpen
    },

    resetDatabase() {
      this.db = JSON.parse(JSON.stringify(INITIAL_DATABASE))
      saveToStorage(this)
    },

    // Inscription Module 1
    inscrireAdolescent(donnees) {
      const generatedId = `UNICEF-RDC-${Math.floor(100000 + Math.random() * 900000)}`
      const newAdo = {
        id: generatedId,
        prenom: donnees.prenom,
        nomFamillePseudonymise: `${donnees.nomFamille ? donnees.nomFamille.charAt(0) : 'A'}***`,
        age: Number(donnees.age),
        sexe: donnees.sexe,
        province: donnees.province,
        ville: donnees.ville,
        milieu: donnees.milieu || 'urbain',
        statutScolaire: donnees.statutScolaire || 'scolarise',
        handicap: donnees.handicap || 'aucun',
        langue: donnees.langue || this.currentLanguage,
        telephone: donnees.telephone,
        canalInscription: donnees.canalInscription || 'web',
        dateInscription: new Date().toISOString().split('T')[0],
        consentement: {
          statut: 'en_attente',
          mode: donnees.canalInscription === 'whatsapp' ? 'whatsapp' : (donnees.canalInscription === 'sms' ? 'sms' : 'web'),
          nomParent: donnees.nomParent || 'Parent / Tuteur',
          dateValidation: null,
          telephoneParent: donnees.telephoneParent || donnees.telephone
        },
        progression: {
          modulesTermines: [],
          scoreMoyen: 0,
          certifie: false,
          dateCertification: null,
          codeCertificat: null,
          filiere: null
        },
        badges: ['premier_pas'],
        statut: 'en_attente_consentement'
      }

      this.db.adolescents.unshift(newAdo)
      this.currentAdoId = generatedId

      // Audit log
      this.db.auditLogs.unshift({
        id: `LOG-${Date.now()}`,
        horodatage: new Date().toLocaleString(),
        utilisateur: donnees.prenom,
        role: 'ado',
        action: 'Nouvelle inscription',
        details: `ID ${generatedId} (${donnees.province}) via ${donnees.canalInscription}`
      })

      saveToStorage(this)
      return newAdo
    },

    // Consentement Module 2
    validerConsentement(adoId, mode = 'web', nomParent = '') {
      const ado = this.db.adolescents.find(a => a.id === adoId)
      if (ado) {
        ado.consentement.statut = 'valide'
        ado.consentement.mode = mode
        if (nomParent) ado.consentement.nomParent = nomParent
        ado.consentement.dateValidation = new Date().toISOString().split('T')[0]
        ado.statut = ado.progression.certifie ? 'actif' : 'en_formation'

        this.db.auditLogs.unshift({
          id: `LOG-${Date.now()}`,
          horodatage: new Date().toLocaleString(),
          utilisateur: ado.consentement.nomParent,
          role: 'parent',
          action: 'Consentement parental accordé',
          details: `Adolescent ID ${ado.id} validé via ${mode}`
        })

        saveToStorage(this)
      }
    },

    retirerConsentement(adoId) {
      const ado = this.db.adolescents.find(a => a.id === adoId)
      if (ado) {
        ado.consentement.statut = 'refuse'
        ado.statut = 'desactive_rgpd'
        ado.prenom = 'Anonyme'
        ado.nomFamillePseudonymise = '***'
        ado.telephone = '+243000000000'

        this.db.auditLogs.unshift({
          id: `LOG-${Date.now()}`,
          horodatage: new Date().toLocaleString(),
          utilisateur: 'Délégué Protection / Parent',
          role: 'admin',
          action: 'Retrait de consentement et anonymisation',
          details: `Compte ${ado.id} désactivé et données purgées`
        })

        saveToStorage(this)
      }
    },

    // Formation Module 3
    terminerModule(adoId, moduleId, score = 100) {
      const ado = this.db.adolescents.find(a => a.id === adoId)
      if (ado) {
        if (!ado.progression.modulesTermines.includes(moduleId)) {
          ado.progression.modulesTermines.push(moduleId)
        }

        // Attribution du badge associé
        const mod = this.db.trainingModules.find(m => m.id === moduleId)
        if (mod && mod.badgeId && !ado.badges.includes(mod.badgeId)) {
          ado.badges.push(mod.badgeId)
        }

        // Vérification de la certification complète (6 modules requis)
        if (ado.progression.modulesTermines.length >= 6 && !ado.progression.certifie) {
          ado.progression.certifie = true
          ado.progression.dateCertification = new Date().toISOString().split('T')[0]
          ado.progression.codeCertificat = `CERT-${new Date().getFullYear()}-${ado.province.substring(0, 3).toUpperCase()}-${ado.id.split('-')[2]}`
          ado.progression.filiere = 'enfant_reporter'
          ado.statut = 'actif'
          if (!ado.badges.includes('ambassadeur')) {
            ado.badges.push('ambassadeur')
          }
        }

        saveToStorage(this)
      }
    },

    // Soumission de contenus Module 5
    soumettreContenu(contenu) {
      const newContenu = {
        id: `CONT-${new Date().getFullYear()}-${Math.floor(100 + Math.random() * 900)}`,
        titre: contenu.titre,
        theme: contenu.theme,
        format: contenu.format || 'article_photo',
        auteurId: this.currentAdo.id,
        auteurPrenom: this.currentAdo.prenom,
        pseudonymeAttribution: `${this.currentAdo.prenom} (${this.currentAdo.age} ans, ${this.currentAdo.province})`,
        province: this.currentAdo.province,
        lieu: contenu.lieu,
        dateSoumission: new Date().toISOString().split('T')[0],
        sources: contenu.sources,
        consentementMentionne: Boolean(contenu.consentementMentionne),
        verificationFaitsDeclaree: Boolean(contenu.verificationFaitsDeclaree),
        faceBlurAlert: Boolean(contenu.faceBlurAlert),
        exifStripped: true,
        statut: 'en_attente_encadreur',
        validationEncadreur: null,
        validationComite: null,
        ponabanaUrl: null
      }

      this.db.reportersContents.unshift(newContenu)

      this.db.auditLogs.unshift({
        id: `LOG-${Date.now()}`,
        horodatage: new Date().toLocaleString(),
        utilisateur: this.currentAdo.prenom,
        role: 'ado',
        action: 'Soumission de contenu enfant reporter',
        details: `Article "${contenu.titre.substring(0, 30)}..." (${newContenu.id})`
      })

      saveToStorage(this)
      return newContenu
    },

    // Circuit de validation éditoriale
    validerParEncadreur(contentId, commentaire = 'Conforme aux critères éditoriaux et éthiques.') {
      const item = this.db.reportersContents.find(c => c.id === contentId)
      if (item) {
        item.statut = 'valide_encadreur'
        item.validationEncadreur = {
          validePar: 'Encadreur REIPE Provincial',
          date: new Date().toISOString().split('T')[0],
          commentaire
        }
        saveToStorage(this)
      }
    },

    publierSurPonabana(contentId, commentaire = 'Validé pour publication sur le blog Ponabana.') {
      const item = this.db.reportersContents.find(c => c.id === contentId)
      if (item) {
        item.statut = 'publie_ponabana'
        item.validationComite = {
          validePar: 'Comité Éditorial Central Ponabana',
          date: new Date().toISOString().split('T')[0],
          commentaire
        }
        const slug = item.titre.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '')
        item.ponabanaUrl = `https://ponabana.org/${new Date().getFullYear()}/${slug}/`
        saveToStorage(this)
      }
    },

    rejeterContenu(contentId, raison) {
      const item = this.db.reportersContents.find(c => c.id === contentId)
      if (item) {
        item.statut = 'a_corriger'
        item.motifRejet = raison
        saveToStorage(this)
      }
    },

    // Signalement de sauvegarde
    signalerIncident(donnees) {
      const incident = {
        id: `SAFE-${new Date().getFullYear()}-${Math.floor(100 + Math.random() * 900)}`,
        dateSignalement: new Date().toLocaleString(),
        type: donnees.type,
        severite: donnees.severite || 'haute',
        province: donnees.province || this.currentAdo?.province || 'Non spécifiée',
        statut: 'en_cours_investigation',
        pointFocalUnicef: 'Point Focal Sauvegarde UNICEF RDC (Astreinte 24h)',
        delaiReponseHeures: 24,
        actionsEntreprises: 'Signalement crypté transmis immédiatement au point focal PSE et protection de l\'enfant.'
      }

      this.db.safeguardIncidents.unshift(incident)

      this.db.auditLogs.unshift({
        id: `LOG-${Date.now()}`,
        horodatage: new Date().toLocaleString(),
        utilisateur: 'Système Sauvegarde (Confidentiel)',
        role: 'unicef_ca',
        action: 'Alerte Sauvegarde déclenchée',
        details: `Incident ${incident.id} - Type: ${incident.type}`
      })

      saveToStorage(this)
      return incident
    }
  }
})
