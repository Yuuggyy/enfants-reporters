# Enfants Reporters RDC 🎙️⚖️

Application Flutter de **gestion, formation et évaluation des Enfants Reporters**
en République Démocratique du Congo (programme inspiré de l'initiative UNICEF RDC).

## Objectifs
- **Former** : Académie de micro-capsules (3-5 min) avec quiz, XP, badges et certificats.
- **Gérer** : clubs par province, profils, consentement parental, circuit de modération.
- **Tester** : quiz de maîtrise (seuil 75 %), anti-triche léger, suivi de progression.

## Phase 1 (ce dépôt)
- Authentification simulée avec 4 rôles : Enfant, Mentor, Modérateur, Parent/Tuteur.
- Consentement parental numérique obligatoire (Code de l'enfant 09/011).
- Académie : 3 modules (Droits de l'enfant, Interview et éthique, Radio),
  9 micro-capsules, 36 questions de quiz avec explications.
- Gamification : XP, série quotidienne résiliente (gel de série), 3 badges.
- Studio Reporter : rédaction guidée 5W+H, brouillons locaux, soumission au mentor.
- Annuaire des clubs par province, écran profil avec CV de reporter et SOS.
- 100 % offline-first : progression et brouillons stockés localement (SharedPreferences).

## Phase 2 (roadmap)
- Branchement sur l'API Laravel auto-hébergée (kit Yuuggyy/laravel-kit).
- Module Mentor/Modérateur : relecture et validation des articles, tableau de bord.
- Audio compressé (Opus) et téléchargement anticipé des capsules sur Wi-Fi.
- Certificats numériques vérifiables par QR code.
- Enregistreur radio intégré et floutage automatique des visages.

## Conventions
- Flutter Material 3, design **phone-first**, `const` partout où possible.
- Modèles avec `equatable`.
- Isolation stricte du dépôt : uniquement les fichiers de ce projet Flutter.

---
Inspire by YuuStore • +243 977 555 768
