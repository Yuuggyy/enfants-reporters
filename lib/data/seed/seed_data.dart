import '../models/article_draft.dart';
import '../models/badge.dart';
import '../models/club.dart';
import '../models/lesson.dart';
import '../models/module.dart';
import '../models/quiz_question.dart';

/// Contenu pédagogique de la Phase 1 : 3 modules, 9 micro-capsules,
/// 36 questions de quiz. Contenu inspiré du programme Enfants Reporters
/// de l'UNICEF RDC (CDE, éthique journalistique, radio).
class SeedData {
  static const modules = [
    ModuleFormation(
      id: 'mod_cde',
      titre: 'Droits de l\'enfant',
      description:
          'Découvre la CDE et le Code de l\'enfant congolais. Le programme '
          'Enfants Reporters lancé en 2009 par l\'UNICEF et le Ministère du '
          'Genre réunit 300 à 600 enfants reporters (10-17 ans) dans presque '
          'toutes les provinces, avec une parité filles-garçons de 50/50.',
      emoji: '⚖️',
      couleurValue: 0xFF1CABE2,
      badgeTitre: 'Badge Expert CDE',
    ),
    ModuleFormation(
      id: 'mod_interview',
      titre: 'Interview et éthique',
      description:
          'Apprends à préparer une interview, poser les bonnes questions et respecter l\'éthique.',
      emoji: '🎤',
      couleurValue: 0xFFFF6B4A,
      badgeTitre: 'Badge Intervieweur',
    ),
    ModuleFormation(
      id: 'mod_radio',
      titre: 'Radio et prise de parole',
      description:
          'Ta voix compte : diction, écriture de script radio et enregistrement au smartphone.',
      emoji: '📻',
      couleurValue: 0xFF7B5AC5,
      badgeTitre: 'Badge Reporter Radio',
    ),
  ];

  static const lessons = [
    // --- Module CDE ---
    Lesson(
      id: 'les_cde_1',
      moduleId: 'mod_cde',
      titre: 'La CDE et ses 4 principes',
      dureeMinutes: 4,
      ordre: 1,
      paragraphes: [
        'La Convention relative aux droits de l\'enfant (CDE) a été adoptée par l\'ONU le 20 novembre 1989. C\'est le texte international le plus ratifié au monde : presque tous les pays, y compris la RDC depuis 1990, se sont engagés à la respecter.',
        'Elle repose sur 4 principes fondamentaux : la non-discrimination (tous les enfants ont les mêmes droits, filles et garçons, handicapés ou non), l\'intérêt supérieur de l\'enfant (toute décision doit d\'abord penser à l\'enfant), le droit à la vie, à la survie et au développement, et le respect de l\'opinion de l\'enfant.',
        'Ce dernier principe est le cœur de ton rôle d\'enfant reporter : la CDE, dans son article 12, dit que tu as le droit de donner ton avis et d\'être écouté sur les questions qui te concernent.',
      ],
    ),
    Lesson(
      id: 'les_cde_2',
      moduleId: 'mod_cde',
      titre: 'Les 4 familles de droits',
      dureeMinutes: 4,
      ordre: 2,
      paragraphes: [
        'Les droits de l\'enfant se regroupent en 4 grandes familles. Les droits à la survie : manger à sa faim, être soigné, avoir un toit. Les droits au développement : aller à l\'école, jouer, accéder à l\'information.',
        'Les droits à la protection : être protégé contre la violence, l\'exploitation, le travail dangereux, le mariage précoce. Enfin, les droits à la participation : s\'exprimer, être écouté, rejoindre un club, donner son avis dans sa communauté.',
        'Aucun droit n\'est plus important qu\'un autre : ils sont tous indivisibles. Un enfant qui va à l\'école mais subit des violences n\'est pas un enfant dont les droits sont respectés.',
      ],
    ),
    Lesson(
      id: 'les_cde_3',
      moduleId: 'mod_cde',
      titre: 'Le Code de l\'enfant en RDC',
      dureeMinutes: 4,
      ordre: 3,
      paragraphes: [
        'La RDC a adopté le 10 janvier 2009 la loi n°09/001 portant protection de l\'enfant, appelée Code de l\'enfant. Elle reprend les engagements de la CDE et les adapte à la réalité congolaise. C\'est aussi en 2009 que l\'UNICEF et le Ministère du Genre ont lancé le programme Enfants Reporters, fondé sur l\'article 12 de la CDE.',
        'Le Code de l\'enfant fixe la majorité à 18 ans, garantit le droit à l\'éducation gratuite au primaire et interdit les pires formes de travail des enfants, y compris dans les mines.',
        'En tant qu\'enfant reporter, connaître ce texte te donne des arguments solides pour tes plaidoyers : tu peux citer la loi, pas seulement la morale.',
      ],
    ),
    // --- Module Interview ---
    Lesson(
      id: 'les_int_1',
      moduleId: 'mod_interview',
      titre: 'Préparer son interview : les 5W+H',
      dureeMinutes: 5,
      ordre: 1,
      paragraphes: [
        'Une bonne interview se prépare toujours. Avant de rencontrer une personne, pose-toi les questions des 5W+H : Who (qui ?), What (quoi ?), Where (où ?), When (quand ?), Why (pourquoi ?) et How (comment ?).',
        'Renseigne-toi d\'abord sur la personne et le sujet. Prépare ta liste de questions par ordre d\'importance : si tu n\'as le temps de poser qu\'une seule question, ce sera la première de ta liste.',
        'Préviens toujours la personne que tu es un enfant reporter et demande son accord avant d\'enregistrer : c\'est ton premier geste d\'éthique.',
      ],
    ),
    Lesson(
      id: 'les_int_2',
      moduleId: 'mod_interview',
      titre: 'Poser de bonnes questions',
      dureeMinutes: 4,
      ordre: 2,
      paragraphes: [
        'Il existe deux types de questions. Les questions fermées appellent une réponse par oui ou non : « Es-tu allé à l\'école ? ». Les questions ouvertes ouvrent la conversation : « Raconte-moi ta journée à l\'école. »',
        'Un bon reporter utilise surtout des questions ouvertes. Il écoute activement : il reformule (« Si je comprends bien... ») et creuse avec des relances (« Pourquoi ? », « Et ensuite ? »).',
        'Ne coupe jamais la personne qui parle. Note les mots importants. Et souviens-toi : il n\'y a pas de question bête, seulement des réponses qui n\'ont pas encore été trouvées.',
      ],
    ),
    Lesson(
      id: 'les_int_3',
      moduleId: 'mod_interview',
      titre: 'Éthique et sécurité du reporter',
      dureeMinutes: 5,
      ordre: 3,
      paragraphes: [
        'L\'éthique, c\'est la règle d\'or du reporter : ne jamais mentir, ne jamais inventer une citation, toujours vérifier ses informations auprès de deux sources différentes.',
        'Protège toujours les personnes vulnérables : on ne publie jamais le nom, le visage ou la voix reconnaissable d\'un enfant victime de violence ou d\'abus. On floute le visage et on change le prénom.',
        'Ta sécurité passe avant le reportage : ne va jamais seul dans un lieu isolé, ne couvre jamais une manifestation sans ton mentor, et si un sujet te met mal à l\'aise, arrête et parles-en à un adulte de confiance.',
      ],
    ),
    // --- Module Radio ---
    Lesson(
      id: 'les_rad_1',
      moduleId: 'mod_radio',
      titre: 'Ta voix à la radio',
      dureeMinutes: 4,
      ordre: 1,
      paragraphes: [
        'La radio reste le média numéro 1 en RDC : elle atteint même ceux qui n\'ont pas accès à Internet, en français comme dans les langues nationales (lingala, swahili, tshiluba, kikongo). Les productions des enfants reporters paraissent sur ponabana.com, sur Radio Okapi et sur les radios communautaires, après validation du comité de modération.',
        'Pour bien parler à la radio : respire calmement, parle ni trop vite ni trop lentement, articule chaque mot et souris sincèrement, on l\'entend dans la voix.',
        'Fais l\'exercice du micro-trottoir : enregistre-toi en posant une question à trois personnes de ton quartier, puis réécoute-toi. Tu progresseras à chaque essai.',
      ],
    ),
    Lesson(
      id: 'les_rad_2',
      moduleId: 'mod_radio',
      titre: 'Écrire un script radio',
      dureeMinutes: 5,
      ordre: 2,
      paragraphes: [
        'Un reportage radio se prépare par écrit. Le format le plus simple est l\'enrobé : une intro lue par toi (qui annonce le sujet), un ou deux extraits sonores des personnes interviewées, et une conclusion.',
        'À la radio, on écrit comme on parle : des phrases courtes, des mots simples. Une phrase = une idée. Évite les chiffres compliqués : arrondis-les et donne-les dans une comparaison parlante.',
        'Ton script doit dire l\'essentiel dans les 10 premières secondes : l\'auditeur décide très vite s\'il continue à écouter ou non.',
      ],
    ),
    Lesson(
      id: 'les_rad_3',
      moduleId: 'mod_radio',
      titre: 'Enregistrer avec un smartphone',
      dureeMinutes: 4,
      ordre: 3,
      paragraphes: [
        'Ton smartphone est un vrai outil de journaliste. Pour un bon son : approche le micro à environ 20 cm de la bouche, cherche un endroit calme, et fais toujours une prise d\'essai de 10 secondes.',
        'Dans le vent ou dans la rue, protège le micro avec ta main ou ton carnet. Si le son est mauvais, ton reportage ne passera pas à l\'antenne, même si le contenu est excellent.',
        'Une fois enregistré, ton fichier peut être envoyé à la radio communautaire partenaire ou partagé sur WhatsApp avec l\'accord de ton mentor. C\'est ainsi que la voix des enfants voyage à travers tout le pays.',
      ],
    ),
  ];

  static const questions = [
    QuizQuestion(
      id: 'q_cde_1_1',
      lessonId: 'les_cde_1',
      question: 'En quelle année la RDC a-t-elle ratifié la CDE ?',
      options: ['1989', '1990', '2009'],
      bonneReponse: 1,
      explication:
          'La CDE a été adoptée le 20 novembre 1989 et la RDC l\'a ratifiée en 1990.',
    ),
    QuizQuestion(
      id: 'q_cde_1_2',
      lessonId: 'les_cde_1',
      question: 'Quel article de la CDE garantit le droit de l\'enfant à donner son avis ?',
      options: ['Article 12', 'Article 32', 'Article 54'],
      bonneReponse: 0,
      explication:
          'L\'article 12 dit que l\'enfant capable de discernement a le droit d\'exprimer librement son opinion et d\'être écouté.',
    ),
    QuizQuestion(
      id: 'q_cde_1_3',
      lessonId: 'les_cde_1',
      question: 'Lequel n\'est PAS un des 4 principes fondamentaux de la CDE ?',
      options: [
        'La non-discrimination',
        'L\'intérêt supérieur de l\'enfant',
        'Le secret des notes scolaires',
      ],
      bonneReponse: 2,
      explication:
          'Les 4 principes sont : non-discrimination, intérêt supérieur de l\'enfant, survie et développement, respect de l\'opinion de l\'enfant.',
    ),
    QuizQuestion(
      id: 'q_cde_1_4',
      lessonId: 'les_cde_1',
      question: 'Pour un enfant reporter, la CDE est surtout...',
      options: [
        'Un texte qui l\'interdit de s\'exprimer',
        'La base légale de son droit à être écouté',
        'Un livre réservé aux adultes',
      ],
      bonneReponse: 1,
      explication:
          'L\'enfant reporter s\'appuie sur la CDE, notamment l\'article 12, pour revendiquer sa participation.',
    ),
    QuizQuestion(
      id: 'q_cde_2_1',
      lessonId: 'les_cde_2',
      question: 'Aller à l\'école appartient à quelle famille de droits ?',
      options: [
        'Droits à la survie',
        'Droits au développement',
        'Droits à la protection',
      ],
      bonneReponse: 1,
      explication:
          'L\'éducation, le jeu et l\'accès à l\'information sont des droits au développement.',
    ),
    QuizQuestion(
      id: 'q_cde_2_2',
      lessonId: 'les_cde_2',
      question: 'Le mariage précoce viole quel droit ?',
      options: [
        'Le droit à la protection',
        'Le droit à la participation',
        'Aucun droit',
      ],
      bonneReponse: 0,
      explication:
          'Le mariage d\'un enfant est une forme de violence : c\'est une atteinte à ses droits à la protection.',
    ),
    QuizQuestion(
      id: 'q_cde_2_3',
      lessonId: 'les_cde_2',
      question: 'Les droits de l\'enfant sont...',
      options: [
        'Indivisibles : tous aussi importants',
        'Classés du plus petit au plus grand',
        'Réservés aux enfants sages',
      ],
      bonneReponse: 0,
      explication:
          'Aucun droit ne peut être sacrifié : ils sont indivisibles et interdépendants.',
    ),
    QuizQuestion(
      id: 'q_cde_2_4',
      lessonId: 'les_cde_2',
      question: 'Quel est un droit à la participation ?',
      options: [
        'Rejoindre un club d\'enfants reporters',
        'Être vacciné',
        'Avoir un acte de naissance',
      ],
      bonneReponse: 0,
      explication:
          'S\'exprimer, s\'associer et rejoindre un club relèvent de la participation.',
    ),
    QuizQuestion(
      id: 'q_cde_3_1',
      lessonId: 'les_cde_3',
      question: 'Quelle loi porte le Code de l\'enfant congolais ?',
      options: ['Loi n°09/001 du 10 janvier 2009', 'Ordonnance n°23/010', 'Loi n°06/018'],
      bonneReponse: 0,
      explication:
          'C\'est la loi n°09/001 du 10 janvier 2009 portant protection de l\'enfant.',
    ),
    QuizQuestion(
      id: 'q_cde_3_2',
      lessonId: 'les_cde_3',
      question: 'Selon le Code de l\'enfant, la majorité est fixée à...',
      options: ['16 ans', '18 ans', '21 ans'],
      bonneReponse: 1,
      explication: 'En RDC, on est enfant jusqu\'à 18 ans.',
    ),
    QuizQuestion(
      id: 'q_cde_3_3',
      lessonId: 'les_cde_3',
      question: 'Le Code de l\'enfant interdit notamment...',
      options: [
        'Les pires formes de travail des enfants, dont les mines',
        'Les jeux en groupe',
        ' Les radios scolaires',
      ],
      bonneReponse: 0,
      explication:
          'La loi protège les enfants contre l\'exploitation, y compris le travail dans les mines.',
    ),
    QuizQuestion(
      id: 'q_cde_3_4',
      lessonId: 'les_cde_3',
      question: 'Citer la loi dans un plaidoyer, c\'est...',
      options: [
        'Plus fort que citer seulement la morale',
        'Interdit aux mineurs',
        'Réservé aux avocats',
      ],
      bonneReponse: 0,
      explication:
          'Un argument légal est plus convaincant auprès des décideurs qu\'un simple appel moral.',
    ),
    QuizQuestion(
      id: 'q_int_1_1',
      lessonId: 'les_int_1',
      question: 'Que signifie le H des 5W+H ?',
      options: ['How (comment)', 'Here (ici)', 'Happy (heureux)'],
      bonneReponse: 0,
      explication: 'H = How : le « comment » de l\'histoire.',
    ),
    QuizQuestion(
      id: 'q_int_1_2',
      lessonId: 'les_int_1',
      question: 'Avant d\'enregistrer quelqu\'un, tu dois d\'abord...',
      options: [
        'Prévenir la personne et demander son accord',
        'Cacher ton dictaphone',
        'Payer la personne',
      ],
      bonneReponse: 0,
      explication:
          'Le consentement de la personne interviewée est une règle d\'éthique essentielle.',
    ),
    QuizQuestion(
      id: 'q_int_1_3',
      lessonId: 'les_int_1',
      question: 'Comment ordonner tes questions ?',
      options: [
        'De la plus importante à la moins importante',
        'Au hasard',
        'De la plus difficile à la plus simple',
      ],
      bonneReponse: 0,
      explication:
          'Si le temps manque, la première question est celle qui compte le plus.',
    ),
    QuizQuestion(
      id: 'q_int_1_4',
      lessonId: 'les_int_1',
      question: 'Un bon préparatif d\'interview comprend...',
      options: [
        'Se renseigner sur la personne et le sujet',
        'Arriver sans rien savoir pour rester neutre',
        'Apprendre les réponses par cœur',
      ],
      bonneReponse: 0,
      explication:
          'Se renseigner évite de poser des questions inutiles et donne de la crédibilité.',
    ),
    QuizQuestion(
      id: 'q_int_2_1',
      lessonId: 'les_int_2',
      question: '« Raconte-moi ta journée » est une question...',
      options: ['Ouverte', 'Fermée', 'Interdite'],
      bonneReponse: 0,
      explication:
          'Elle invite la personne à raconter librement : c\'est une question ouverte.',
    ),
    QuizQuestion(
      id: 'q_int_2_2',
      lessonId: 'les_int_2',
      question: '« Si je comprends bien... » est une technique de...',
      options: ['Reformulation', 'Coupe de parole', 'Intimidation'],
      bonneReponse: 0,
      explication: 'Reformuler montre que tu écoutes et clarifie la réponse.',
    ),
    QuizQuestion(
      id: 'q_int_2_3',
      lessonId: 'les_int_2',
      question: 'Que faire quand la personne parle longtemps ?',
      options: [
        'Écouter sans couper, noter les mots clés',
        'La couper rapidement',
        'Regarder son téléphone',
      ],
      bonneReponse: 0,
      explication:
          'Ne jamais couper : les meilleurs extraits viennent souvent de fin de réponse.',
    ),
    QuizQuestion(
      id: 'q_int_2_4',
      lessonId: 'les_int_2',
      question: 'Une bonne relance après une réponse courte est...',
      options: ['Pourquoi ?', 'D\'accord, merci.', 'Silence radio'],
      bonneReponse: 0,
      explication: '« Pourquoi ? » ou « Et ensuite ? » font approfondir la réponse.',
    ),
    QuizQuestion(
      id: 'q_int_3_1',
      lessonId: 'les_int_3',
      question: 'La règle d\'or du reporter est...',
      options: [
        'Ne jamais mentir ni inventer une citation',
        'Exagérer pour attirer l\'attention',
        'Publier vite, vérifier après',
      ],
      bonneReponse: 0,
      explication:
          'La vérité est la base du journalisme : on ne publie rien sans vérifier.',
    ),
    QuizQuestion(
      id: 'q_int_3_2',
      lessonId: 'les_int_3',
      question: 'Combien de sources pour vérifier une information ?',
      options: ['Une seule', 'Deux au minimum', 'Aucune, la rumeur suffit'],
      bonneReponse: 1,
      explication: 'La règle des deux sources protège contre la désinformation.',
    ),
    QuizQuestion(
      id: 'q_int_3_3',
      lessonId: 'les_int_3',
      question: 'Pour un enfant victime, tu dois...',
      options: [
        'Flouter le visage et changer le prénom',
        'Montrer son visage pour toucher le public',
        'Donner son école',
      ],
      bonneReponse: 0,
      explication:
          'Protéger l\'identité des enfants vulnérables est une obligation éthique et légale.',
    ),
    QuizQuestion(
      id: 'q_int_3_4',
      lessonId: 'les_int_3',
      question: 'Face à un sujet dangereux, le bon réflexe est...',
      options: [
        'Arrêter et en parler à un adulte de confiance',
        'Continuer seul pour faire un scoop',
        'Demander à un ami enfant',
      ],
      bonneReponse: 0,
      explication:
          'Ta sécurité passe toujours avant le reportage.',
    ),
    QuizQuestion(
      id: 'q_rad_1_1',
      lessonId: 'les_rad_1',
      question: 'Pourquoi la radio est-elle le média n°1 en RDC ?',
      options: [
        'Elle atteint les gens même sans Internet',
        'Elle est plus rapide que le smartphone',
        'Elle coûte plus cher',
      ],
      bonneReponse: 0,
      explication:
          'La radio touche tout le territoire, y compris dans les langues nationales.',
    ),
    QuizQuestion(
      id: 'q_rad_1_2',
      lessonId: 'les_rad_1',
      question: 'Combien de langues nationales compte la RDC ?',
      options: ['2', '4', '10'],
      bonneReponse: 1,
      explication: 'Lingala, swahili, tshiluba et kikongo.',
    ),
    QuizQuestion(
      id: 'q_rad_1_3',
      lessonId: 'les_rad_1',
      question: 'Un bon exercice de départ est...',
      options: [
        'Le micro-trottoir enregistré au smartphone',
        'Chanter à la radio',
        'Lire un journal en anglais',
      ],
      bonneReponse: 0,
      explication:
          'Le micro-trottoir entraîne la prise de parole et l\'écoute de sa propre voix.',
    ),
    QuizQuestion(
      id: 'q_rad_1_4',
      lessonId: 'les_rad_1',
      question: 'Bien parler à la radio, c\'est...',
      options: [
        'Parler calmement et articuler',
        'Parler le plus vite possible',
        'Chuchoter',
      ],
      bonneReponse: 0,
      explication:
          'Respiration calme, articulation et débit modéré : la voix porte mieux.',
    ),
    QuizQuestion(
      id: 'q_rad_2_1',
      lessonId: 'les_rad_2',
      question: 'Un enrobé radio contient...',
      options: [
        'Une intro, des sons d\'interviews et une conclusion',
        'Uniquement de la musique',
        'Une seule longue citation',
      ],
      bonneReponse: 0,
      explication:
          'L\'enrobé encadre les sons des personnes interviewées.',
    ),
    QuizQuestion(
      id: 'q_rad_2_2',
      lessonId: 'les_rad_2',
      question: 'À la radio, on écrit...',
      options: [
        'Comme on parle, avec des phrases courtes',
        'Comme un livre, avec des phrases longues',
        'En latin',
      ],
      bonneReponse: 0,
      explication:
          'L\'oreille ne peut pas relire : une phrase = une idée.',
    ),
    QuizQuestion(
      id: 'q_rad_2_3',
      lessonId: 'les_rad_2',
      question: 'Où placer l\'essentiel dans un script radio ?',
      options: [
        'Dans les 10 premières secondes',
        'À la toute fin',
        'Au milieu, comme surprise',
      ],
      bonneReponse: 0,
      explication:
          'L\'auditeur décide très vite s\'il reste ou change de station.',
    ),
    QuizQuestion(
      id: 'q_rad_2_4',
      lessonId: 'les_rad_2',
      question: 'Un chiffre compliqué à la radio se donne...',
      options: [
        'Arrondi, dans une comparaison parlante',
        'Précis jusqu\'à la virgule',
        'Pas du tout',
      ],
      bonneReponse: 0,
      explication:
          '« Environ trois enfants sur dix » parle plus qu\'un nombre à six chiffres.',
    ),
    QuizQuestion(
      id: 'q_rad_3_1',
      lessonId: 'les_rad_3',
      question: 'Distance idéale entre la bouche et le micro ?',
      options: ['Environ 20 cm', '2 mètres', 'Collé à la bouche'],
      bonneReponse: 0,
      explication:
          '20 cm donne un son clair sans capter le souffle.',
    ),
    QuizQuestion(
      id: 'q_rad_3_2',
      lessonId: 'les_rad_3',
      question: 'Avant chaque interview, fais toujours...',
      options: [
        'Une prise d\'essai de 10 secondes',
        'Une photo',
        'Un appel téléphoné',
      ],
      bonneReponse: 0,
      explication: 'La prise d\'essai évite les mauvaises surprises.',
    ),
    QuizQuestion(
      id: 'q_rad_3_3',
      lessonId: 'les_rad_3',
      question: 'Par quoi commence le son d\'un bon reportage ?',
      options: [
        'Un contenu excellent et un son propre',
        'Un bon micro seul',
        'Un titre chanté',
      ],
      bonneReponse: 0,
      explication:
          'Sans bon son, même un excellent contenu ne passera pas à l\'antenne.',
    ),
    QuizQuestion(
      id: 'q_rad_3_4',
      lessonId: 'les_rad_3',
      question: 'Ton fichier audio peut être envoyé à...',
      options: [
        'La radio communautaire partenaire, avec l\'accord du mentor',
        'N\'importe qui sans autorisation',
        'Personne',
      ],
      bonneReponse: 0,
      explication:
          'La chaîne de validation du mentor garantit la sécurité et la qualité.',
    ),
  ];

  static const badges = [
    BadgeCompetence(
      id: 'bad_cde',
      titre: 'Expert CDE',
      description: 'Module Droits de l\'enfant terminé avec succès.',
      emoji: '⚖️',
      moduleId: 'mod_cde',
    ),
    BadgeCompetence(
      id: 'bad_int',
      titre: 'Intervieweur',
      description: 'Module Interview et éthique terminé avec succès.',
      emoji: '🎤',
      moduleId: 'mod_interview',
    ),
    BadgeCompetence(
      id: 'bad_rad',
      titre: 'Reporter Radio',
      description: 'Module Radio terminé avec succès.',
      emoji: '📻',
      moduleId: 'mod_radio',
    ),
  ];

  static const clubs = [
    Club(
      id: 'club_kin_1',
      nom: 'Club Bana Malamu',
      province: 'Kinshasa',
      ville: 'Kinshasa',
      ecole: 'Ecole Prim. et Sec. La Colombe, Gombe',
      nbEnfants: 24,
      mentorNom: 'M. Kabeya',
    ),
    Club(
      id: 'club_kin_2',
      nom: 'Club Sango ya Bana',
      province: 'Kinshasa',
      ville: 'Kinshasa',
      ecole: 'Institut du Rwanda, Kalamu',
      nbEnfants: 30,
      mentorNom: 'Mme Ngalula',
    ),
    Club(
      id: 'club_goma_1',
      nom: 'Club Amani',
      province: 'Nord-Kivu',
      ville: 'Goma',
      ecole: 'Complexe Scolaire Mapendo',
      nbEnfants: 28,
      mentorNom: 'M. Bahati',
    ),
    Club(
      id: 'club_goma_2',
      nom: 'Club Umoja',
      province: 'Nord-Kivu',
      ville: 'Beni',
      ecole: 'Lycée Mulembe',
      nbEnfants: 22,
      mentorNom: 'Mme Kasereka',
    ),
    Club(
      id: 'club_bukavu_1',
      nom: 'Club Mwangaza',
      province: 'Sud-Kivu',
      ville: 'Bukavu',
      ecole: 'Institut Ibanda',
      nbEnfants: 26,
      mentorNom: 'M. Cirhuza',
    ),
    Club(
      id: 'club_lbu_1',
      nom: 'Club Pamoja',
      province: 'Haut-Katanga',
      ville: 'Lubumbashi',
      ecole: 'Lycée Kiwanuka',
      nbEnfants: 32,
      mentorNom: 'Mme Ilunga',
    ),
    Club(
      id: 'club_kan_1',
      nom: 'Club Lumière',
      province: 'Kasaï-Central',
      ville: 'Kananga',
      ecole: 'Complexe scolaire Tshiadi',
      nbEnfants: 20,
      mentorNom: 'M. Kalonji',
    ),
    Club(
      id: 'club_mbm_1',
      nom: 'Club Bomoko',
      province: 'Kasaï-Oriental',
      ville: 'Mbuji-Mayi',
      ecole: 'Institut Diulu',
      nbEnfants: 18,
      mentorNom: 'Mme Tshiala',
    ),
    Club(
      id: 'club_kis_1',
      nom: 'Club Boyeke',
      province: 'Tshopo',
      ville: 'Kisangani',
      ecole: 'Lycée Bosangani',
      nbEnfants: 25,
      mentorNom: 'M. Lokana',
    ),
    Club(
      id: 'club_bunia_1',
      nom: 'Club Tumaini',
      province: 'Ituri',
      ville: 'Bunia',
      ecole: 'Complexe scolaire Shari',
      nbEnfants: 21,
      mentorNom: 'Mme Dina',
    ),
    Club(
      id: 'club_mat_1',
      nom: 'Club Sanga Mambu',
      province: 'Kongo-Central',
      ville: 'Matadi',
      ecole: 'Institut Ndongi',
      nbEnfants: 19,
      mentorNom: 'Mme Nsiantulu',
    ),
    Club(
      id: 'club_mbd_1',
      nom: 'Club Bosolo',
      province: 'Équateur',
      ville: 'Mbandaka',
      ecole: 'Institut Bomba',
      nbEnfants: 16,
      mentorNom: 'M. Bofenda',
    ),
  ];

  /// Missions de terrain suggérées sur l\'écran d\'accueil.
  static const missions = [
    {
      'titre': 'Micro-trottoir du 16 juin',
      'description':
          'Interviewe 3 camarades : « Que changes-tu dans ton école ? » et publie l\'article dans le Studio.',
    },
    {
      'titre': 'Vrai ou faux ?',
      'description':
          'Trouve une rumeur qui circule dans ton quartier et vérifie-la avec 2 sources fiables.',
    },
    {
      'titre': 'La voix des sans-voix',
      'description':
          'Écris un reportage sur un enfant qui travaille au marché : anonymat et respect obligatoires.',
    },
  ];

  static const statutsLibelles = {
    ArticleStatut.brouillon: 'Brouillon',
    ArticleStatut.soumis: 'Soumis au mentor',
    ArticleStatut.valide: 'Validé',
    ArticleStatut.publie: 'Publié',
  };
}
