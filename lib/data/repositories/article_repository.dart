import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/article_draft.dart';

/// Brouillons d'articles stockés localement (offline-first).
class ArticleRepository {
  static const _cle = 'article_drafts';

  Future<List<ArticleDraft>> lireBrouillons() async {
    final prefs = await SharedPreferences.getInstance();
    final brut = prefs.getString(_cle);
    if (brut == null || brut.isEmpty) return [];
    final liste = jsonDecode(brut) as List;
    return liste
        .map((e) => ArticleDraft.fromJson(e as Map<String, dynamic>))
        .toList()
        .reversed
        .toList();
  }

  Future<void> enregistrer(ArticleDraft draft) async {
    final tous = await lireBrouillons();
    final index = tous.indexWhere((d) => d.id == draft.id);
    if (index >= 0) {
      tous[index] = draft;
    } else {
      tous.add(draft);
    }
    await _ecrire(tous);
  }

  Future<void> supprimer(String id) async {
    final tous = await lireBrouillons();
    tous.removeWhere((d) => d.id == id);
    await _ecrire(tous);
  }

  Future<void> _ecrire(List<ArticleDraft> tous) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cle,
      jsonEncode(tous.map((d) => d.toJson()).toList()),
    );
  }
}
