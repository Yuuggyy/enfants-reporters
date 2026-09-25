import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_constants.dart';
import '../data/models/badge.dart';
import '../data/models/user_profile.dart';
import '../data/repositories/academy_repository.dart';

/// État global de l'app : profil connecté, XP, série quotidienne,
/// badges et scores de quiz. Persisté localement (offline-first).
class AppController extends ChangeNotifier {
  final AcademyRepository _academy = AcademyRepository();

  UserProfile? utilisateur;
  int xp = 0;
  int serie = 0;
  DateTime? derniereActivite;
  final Map<String, int> scores = {};
  final Set<String> badgesGagnes = {};

  bool get estConnecte => utilisateur != null;

  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    final u = prefs.getString('utilisateur');
    if (u != null) {
      utilisateur = UserProfile.fromJson(jsonDecode(u) as Map<String, dynamic>);
    }
    xp = prefs.getInt('xp') ?? 0;
    serie = prefs.getInt('serie') ?? 0;
    final d = prefs.getString('derniereActivite');
    derniereActivite = d == null ? null : DateTime.parse(d);
    final s = prefs.getString('scores');
    if (s != null) {
      final m = jsonDecode(s) as Map<String, dynamic>;
      m.forEach((k, v) => scores[k] = v as int);
    }
    final b = prefs.getString('badges');
    if (b != null) {
      badgesGagnes.addAll((jsonDecode(b) as List).cast<String>());
    }
    _mettreAJourSerie();
    notifyListeners();
  }

  Future<void> connecter(UserProfile u) async {
    utilisateur = u;
    await _sauvegarder();
    notifyListeners();
  }

  Future<void> deconnecter() async {
    utilisateur = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('utilisateur');
    notifyListeners();
  }

  Future<void> mettreAJourProfil(UserProfile u) async {
    utilisateur = u;
    await _sauvegarder();
    notifyListeners();
  }

  /// Enregistre le score d'un quiz et verse les XP correspondants.
  /// Retourne le badge débloqué si le module est entièrement terminé.
  BadgeCompetence? enregistrerScore({
    required String lessonId,
    required int bonnesReponses,
    required int totalQuestions,
  }) {
    final seuil = (totalQuestions * AppConstants.seuilReussite).ceil();
    if (bonnesReponses >= seuil) {
      final ancien = scores[lessonId] ?? 0;
      if (bonnesReponses > ancien) {
        scores[lessonId] = bonnesReponses;
        xp += (bonnesReponses - ancien) * AppConstants.xpParBonneReponse +
            (ancien == 0 ? AppConstants.xpBonusLecon : 0);
      }
    }
    _mettreAJourSerie();
    _sauvegarder();
    notifyListeners();

    // Badge si toutes les leçons du module sont validées.
    final lesson = _academy.lecon(lessonId);
    if (lesson != null) {
      final badge = _academy.badgeDuModule(lesson.moduleId);
      if (badge != null && !badgesGagnes.contains(badge.id)) {
        final terminees = _academy.leconsDe(lesson.moduleId).every((l) {
          final t = _academy.questionsDe(l.id).length;
          return (scores[l.id] ?? 0) >= (t * AppConstants.seuilReussite).ceil();
        });
        if (terminees) {
          badgesGagnes.add(badge.id);
          xp += AppConstants.xpBonusBadge;
          _sauvegarder();
          notifyListeners();
          return badge;
        }
      }
    }
    return null;
  }

  /// Série quotidienne résiliente : 1 jour manqué = série conservée (gel).
  void _mettreAJourSerie() {
    final aujourdhui = DateTime.now();
    final jour = DateTime(aujourdhui.year, aujourdhui.month, aujourdhui.day);
    if (derniereActivite == null) {
      serie = 0;
      return;
    }
    final dernier = DateTime(
      derniereActivite!.year,
      derniereActivite!.month,
      derniereActivite!.day,
    );
    final ecart = jour.difference(dernier).inDays;
    if (ecart == 1) {
      serie += 1;
      derniereActivite = jour;
    } else if (ecart == 2) {
      // Gel de série : un jour d'absence n'annule pas la série.
      derniereActivite = jour;
    } else if (ecart > 2) {
      serie = 0;
    }
    // ecart == 0 : déjà actif aujourd'hui.
  }

  Future<void> _sauvegarder() async {
    final prefs = await SharedPreferences.getInstance();
    if (utilisateur != null) {
      await prefs.setString('utilisateur', jsonEncode(utilisateur!.toJson()));
    }
    await prefs.setInt('xp', xp);
    await prefs.setInt('serie', serie);
    await prefs.setString(
      'derniereActivite',
      DateTime.now().toIso8601String(),
    );
    await prefs.setString('scores', jsonEncode(scores));
    await prefs.setString('badges', jsonEncode(badgesGagnes.toList()));
  }
}
