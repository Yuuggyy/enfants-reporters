import 'package:flutter/material.dart';

import '../data/models/article_draft.dart';
import '../data/repositories/article_repository.dart';
import '../data/seed/seed_data.dart';
import '../widgets/yuustore_footer.dart';
import 'article_editor_screen.dart';

/// Studio : brouillons de l'enfant et rédaction guidée 5W+H.
class StudioScreen extends StatefulWidget {
  final String? enfantId;

  const StudioScreen({super.key, this.enfantId});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  final ArticleRepository _repo = ArticleRepository();
  List<ArticleDraft> _brouillons = [];

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final tous = await _repo.lireBrouillons();
    if (mounted) setState(() => _brouillons = tous);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Studio Reporter')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.edit),
        label: const Text('Nouvel article'),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ArticleEditorScreen(),
            ),
          );
          _charger();
        },
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Rédige tes reportages au format journaliste : Qui ? Quoi ? '
              'Où ? Quand ? Pourquoi ? Ton mentor validera avant publication.',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          if (_brouillons.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Aucun article pour le moment. Touche « Nouvel article » '
                  'pour écrire ton premier reportage !',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          for (final d in _brouillons)
            Dismissible(
              key: ValueKey(d.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                color: Colors.red,
                padding: const EdgeInsets.only(right: 24),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) {
                _repo.supprimer(d.id);
                setState(() => _brouillons.remove(d));
              },
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.article,
                    color: d.statut == ArticleStatut.brouillon
                        ? Colors.black26
                        : d.statut == ArticleStatut.soumis
                            ? const Color(0xFFFF6B4A)
                            : const Color(0xFF2FBF71),
                  ),
                  title: Text(
                    d.titre.isEmpty ? '(Sans titre)' : d.titre,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    '${SeedData.statutsLibelles[d.statut]}  •  '
                    '${d.dateCreation.day}/${d.dateCreation.month}/${d.dateCreation.year}',
                  ),
                ),
              ),
            ),
          const YuuStoreFooter(),
        ],
      ),
    );
  }
}
