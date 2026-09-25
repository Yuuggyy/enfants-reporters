import 'package:flutter/material.dart';

import '../data/models/article_draft.dart';
import '../data/repositories/article_repository.dart';

/// Éditeur guidé 5W+H pour rédiger un reportage pas à pas.
class ArticleEditorScreen extends StatefulWidget {
  const ArticleEditorScreen({super.key});

  @override
  State<ArticleEditorScreen> createState() => _ArticleEditorScreenState();
}

class _ArticleEditorScreenState extends State<ArticleEditorScreen> {
  final _repo = ArticleRepository();
  final _form = GlobalKey<FormState>();
  final _titre = TextEditingController();
  final _qui = TextEditingController();
  final _quoi = TextEditingController();
  final _ou = TextEditingController();
  final _quand = TextEditingController();
  final _pourquoi = TextEditingController();
  final _citation = TextEditingController();

  @override
  void dispose() {
    _titre.dispose();
    _qui.dispose();
    _quoi.dispose();
    _ou.dispose();
    _quand.dispose();
    _pourquoi.dispose();
    _citation.dispose();
    super.dispose();
  }

  Future<void> _enregistrer({required bool soumettre}) async {
    if (!_form.currentState!.validate()) return;
    await _repo.enregistrer(
      ArticleDraft(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        titre: _titre.text.trim(),
        qui: _qui.text.trim(),
        quoi: _quoi.text.trim(),
        ou: _ou.text.trim(),
        quand: _quand.text.trim(),
        pourquoi: _pourquoi.text.trim(),
        citation: _citation.text.trim(),
        statut:
            soumettre ? ArticleStatut.soumis : ArticleStatut.brouillon,
        dateCreation: DateTime.now(),
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  Widget _champ(TextEditingController c, String label, IconData icone,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icone),
        ),
        validator: (v) =>
            v == null || v.trim().isEmpty ? 'Ce champ est important' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau reportage')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _champ(_titre, 'Titre de mon reportage', Icons.title),
            _champ(_qui, 'Qui ? (la personne ou le groupe concerné)', Icons.person_search),
            _champ(_quoi, 'Quoi ? (ce qui s\'est passé)', Icons.event_note, maxLines: 2),
            _champ(_ou, 'Où ? (le lieu)', Icons.place),
            _champ(_quand, 'Quand ? (la date ou la période)', Icons.schedule),
            _champ(_pourquoi, 'Pourquoi ? (la cause ou l\'importance)', Icons.help_outline, maxLines: 2),
            _champ(_citation, 'Une citation (une phrase d\'une personne interviewée)', Icons.format_quote, maxLines: 2),
            const SizedBox(height: 8),
            FilledButton.icon(
              icon: const Icon(Icons.send),
              label: const Text('Soumettre à mon mentor'),
              onPressed: () => _enregistrer(soumettre: true),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Enregistrer comme brouillon'),
              onPressed: () => _enregistrer(soumettre: false),
            ),
          ],
        ),
      ),
    );
  }
}
