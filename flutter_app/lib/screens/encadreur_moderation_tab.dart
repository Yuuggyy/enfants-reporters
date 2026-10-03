import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_database.dart';
import '../models/models.dart';

class EncadreurModerationTab extends StatefulWidget {
  const EncadreurModerationTab({super.key});

  @override
  State<EncadreurModerationTab> createState() => _EncadreurModerationTabState();
}

class _EncadreurModerationTabState extends State<EncadreurModerationTab> {
  final Map<String, TextEditingController> _commentControllers = {};

  @override
  void dispose() {
    for (var c in _commentControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(String id) {
    if (!_commentControllers.containsKey(id)) {
      _commentControllers[id] = TextEditingController();
    }
    return _commentControllers[id]!;
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabaseService>(context);
    final activeClub = db.clubsOfActiveEncadreur.isNotEmpty
        ? db.clubsOfActiveEncadreur.first
        : db.clubs.first;

    final clubMedias = db.getMediasForClub(activeClub.id);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Modération Niveau 1
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0072F5).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.rate_review_rounded, color: Color(0xFF0072F5), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Modération Niveau 1 (Encadreur)',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        'Reportages soumis par les enfants du ${activeClub.nom}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (clubMedias.isEmpty)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 40, color: Color(0xFF10B981)),
                  SizedBox(height: 10),
                  Text(
                    'Aucun reportage en attente de modération dans ce club.',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...clubMedias.map((media) {
              final isPending = media.statut.contains('attente');
              final ctrl = _getController(media.id);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isPending ? const Color(0xFF0072F5).withValues(alpha: 0.4) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0072F5).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            media.type,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0072F5)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isPending
                                ? Colors.amber.withValues(alpha: 0.15)
                                : const Color(0xFF10B981).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            media.statut,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isPending ? Colors.amber[800] : const Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      media.titre,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Auteur : ${media.auteurPrenom} (${media.auteurId}) • Date : ${media.dateSoumission}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      media.resume,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF334155), height: 1.4),
                    ),
                    const SizedBox(height: 12),

                    // Contrôles de sauvegarde
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSafetyCheck('Consentement', media.consentementSujets),
                          _buildSafetyCheck('Floutage visages', media.floutageEffectue),
                          _buildSafetyCheck('Purge GPS/EXIF', media.exifPurge),
                        ],
                      ),
                    ),

                    if (media.commentaireEncadreur != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Note Encadreur : ${media.commentaireEncadreur}',
                          style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF475569)),
                        ),
                      ),
                    ],

                    if (isPending) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: ctrl,
                        decoration: InputDecoration(
                          hintText: 'Commentaire ou instructions pour l\'enfant...',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                db.modererReportageParEncadreur(
                                  mediaId: media.id,
                                  valider: false,
                                  commentaire: ctrl.text.isNotEmpty ? ctrl.text : 'Corrections requises avant envoi Ponabana.',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Demande de modifications envoyée à l\'enfant.')),
                                );
                              },
                              icon: const Icon(Icons.edit_note_rounded, size: 16),
                              label: const Text('À corriger', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.amber[800],
                                side: BorderSide(color: Colors.amber[800]!),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                db.modererReportageParEncadreur(
                                  mediaId: media.id,
                                  valider: true,
                                  commentaire: ctrl.text.isNotEmpty ? ctrl.text : 'Validé pour transmission à Ponabana.',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Reportage validé et transmis au Comité Ponabana !'),
                                    backgroundColor: Color(0xFF10B981),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check_circle_rounded, size: 16),
                              label: const Text('Valider Niveau 1', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSafetyCheck(String label, bool isOk) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isOk ? Icons.check_circle_rounded : Icons.cancel_rounded,
          size: 14,
          color: isOk ? const Color(0xFF10B981) : Colors.amber[800],
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isOk ? const Color(0xFF0F172A) : Colors.amber[900],
          ),
        ),
      ],
    );
  }
}
