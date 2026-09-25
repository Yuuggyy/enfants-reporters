import 'package:flutter/material.dart';

import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../data/models/badge.dart';
import '../data/models/quiz_question.dart';
import '../data/repositories/academy_repository.dart';
import '../state/app_controller.dart';

/// Quiz de validation d'une capsule : réponses instantanées, XP,
/// badge débloqué à la fin du module.
class QuizScreen extends StatefulWidget {
  final AppController controller;
  final String lessonId;

  const QuizScreen({
    super.key,
    required this.controller,
    required this.lessonId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final AcademyRepository _academy = AcademyRepository();
  late final List<QuizQuestion> _questions;
  int _index = 0;
  int? _choix;
  int _bonnes = 0;
  bool _termine = false;
  BadgeCompetence? _badgeGagne;

  @override
  void initState() {
    super.initState();
    _questions = _academy.questionsDe(widget.lessonId);
  }

  void _repondre(int i) {
    if (_choix != null) return;
    setState(() => _choix = i);
    if (i == _questions[_index].bonneReponse) _bonnes++;
  }

  void _suivant() {
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _choix = null;
      });
      return;
    }
    _terminer();
  }

  Future<void> _terminer() async {
    final badge = widget.controller.enregistrerScore(
      lessonId: widget.lessonId,
      bonnesReponses: _bonnes,
      totalQuestions: _questions.length,
    );
    setState(() {
      _termine = true;
      _badgeGagne = badge;
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_index];
    final seuil = (_questions.length * AppConstants.seuilReussite).ceil();
    return Scaffold(
      appBar: AppBar(title: Text('Quiz ${_index + 1}/${_questions.length}')),
      body: _termine
          ? _resultat(context, seuil)
          : _question(context, q),
    );
  }

  Widget _question(BuildContext context, QuizQuestion q) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        LinearProgressIndicator(
          value: (_index + 1) / _questions.length,
          color: AppTheme.vert,
        ),
        const SizedBox(height: 24),
        Text(
          q.question,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),
        for (int i = 0; i < q.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _option(q, i),
          ),
        const SizedBox(height: 8),
        if (_choix != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _choix == q.bonneReponse
                      ? const Color(0xFFE4F7EC)
                      : const Color(0xFFFDECE8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(q.explication),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _suivant,
                  child: Text(
                    _index < _questions.length - 1
                        ? 'Question suivante'
                        : 'Voir mon résultat',
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _option(QuizQuestion q, int i) {
    final choisie = _choix == i;
    final bonne = i == q.bonneReponse;
    Color? fond;
    IconData? icone;
    if (_choix != null) {
      if (bonne) {
        fond = AppTheme.vert;
        icone = Icons.check_circle;
      } else if (choisie) {
        fond = AppTheme.corail;
        icone = Icons.cancel;
      }
    }
    return Material(
      color: fond ?? Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: _choix == null ? 1 : 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _repondre(i),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: choisie ? null : Border.all(color: const Color(0xFFD8E6F0)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  q.options[i],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: fond == null ? Colors.black87 : Colors.white,
                  ),
                ),
              ),
              if (icone != null)
                Icon(icone, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultat(BuildContext context, int seuil) {
    final reussi = _bonnes >= seuil;
    final xpGagnes = reussi ? _bonnes * AppConstants.xpParBonneReponse : 0;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              reussi ? Icons.emoji_events : Icons.refresh,
              size: 80,
              color: reussi ? AppTheme.jaune : AppTheme.bleu,
            ),
            const SizedBox(height: 16),
            Text(
              reussi ? 'Capsule validée !' : 'Presque !',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Score : $_bonnes/${_questions.length}'
              '  •  Seuil : $seuil bonnes réponses',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              reussi ? '+$xpGagnes XP' : 'Tu peux réessayer autant de fois que tu veux.',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.vert,
              ),
            ),
            if (_badgeGagne != null) ...[
              const SizedBox(height: 24),
              Card(
                color: AppTheme.violet,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        _badgeGagne!.emoji,
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Badge débloqué : ${_badgeGagne!.titre}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '+${AppConstants.xpBonusBadge} XP bonus',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Terminer'),
            ),
          ],
        ),
      ),
    );
  }
}
