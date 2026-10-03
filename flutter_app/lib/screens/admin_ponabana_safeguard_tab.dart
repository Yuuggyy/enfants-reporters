import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_database.dart';
import '../models/models.dart';

class AdminPonabanaSafeguardTab extends StatelessWidget {
  const AdminPonabanaSafeguardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabaseService>(context);
    final medias = db.medias;
    final incidents = db.incidents;
    final auditLogs = db.auditLogs;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
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
                    color: const Color(0xFF0F172A).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.public_rounded, color: Color(0xFF0F172A), size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Publication Ponabana & Sauvegarde 24h',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        'Validation Niveau 2 (WordPress API) & Traitement des incidents',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Section Ponabana
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reportages Prêts pour Publication Ponabana',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Icon(Icons.feed_rounded, color: Color(0xFF00ADEF), size: 18),
                  ],
                ),
                const SizedBox(height: 14),
                ...medias.map((media) {
                  final canPublish = media.statut.contains('Validé Encadreur');
                  final isPublished = media.statut.contains('Publié');

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              media.titre,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isPublished
                                    ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                    : Colors.amber.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                media.statut,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isPublished ? const Color(0xFF10B981) : Colors.amber[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Auteur : ${media.auteurPrenom} • Province : ${media.province} • Note Encadreur : ${media.commentaireEncadreur ?? "N/A"}',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                        if (canPublish) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                db.publierReportagePonabana(media.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('✅ "${media.titre}" publié sur Ponabana (WordPress API sync) !'),
                                    backgroundColor: const Color(0xFF10B981),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.cloud_upload_rounded, size: 16),
                              label: const Text('Publier sur Ponabana.org (WordPress API)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0072F5),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Incidents de Sauvegarde 24h
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Registre des Incidents de Sauvegarde (24h)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
                    ),
                    Icon(Icons.shield_rounded, color: Color(0xFFEF4444), size: 18),
                  ],
                ),
                const SizedBox(height: 14),
                ...incidents.map((inc) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFECACA)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${inc.type} (${inc.id})',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF991B1B)),
                            ),
                            Text(inc.date, style: const TextStyle(fontSize: 10, color: Color(0xFF991B1B))),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Province : ${inc.province} • Statut : ${inc.statut}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF7F1D1D)),
                        ),
                        const SizedBox(height: 4),
                        Text(inc.description, style: const TextStyle(fontSize: 11, color: Color(0xFF450A0A))),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Journal d'Audit Immuable
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Journal d\'Audit de Sécurité',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 12),
                ...auditLogs.take(5).map((log) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.fiber_manual_record, size: 10, color: Color(0xFF00ADEF)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '[${log.date}] ${log.utilisateur} (${log.role}) : ${log.action}',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
