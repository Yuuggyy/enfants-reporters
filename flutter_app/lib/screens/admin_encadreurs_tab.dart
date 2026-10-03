import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_database.dart';
import '../models/models.dart';

class AdminEncadreursTab extends StatelessWidget {
  const AdminEncadreursTab({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabaseService>(context);
    final encadreurs = db.encadreurs;
    final clubs = db.clubs;
    final totalAdos = db.adolescents.length;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Superviseur des Encadreurs
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                )
              ],
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
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'UNICEF RDC • Superviseur National',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(Icons.security_rounded, color: Color(0xFF00ADEF), size: 18),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Supervision des Encadreurs & Clubs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${encadreurs.length} encadreurs actifs • ${clubs.length} clubs opérationnels • $totalAdos enfants encadrés',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Liste des encadreurs supervisés
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
                      'Réseau des Encadreurs REIPE & Ministères',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Icon(Icons.supervised_user_circle_rounded, color: Color(0xFF00ADEF), size: 20),
                  ],
                ),
                const SizedBox(height: 14),
                ...encadreurs.map((enc) {
                  final assignedClubs = clubs.where((c) => enc.clubIds.contains(c.id)).toList();
                  final membersCount = assignedClubs.fold<int>(0, (sum, c) => sum + c.nombreMembres);

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
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(0xFF0072F5).withValues(alpha: 0.15),
                                  child: const Icon(Icons.person, color: Color(0xFF0072F5), size: 18),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${enc.nomComplet} (${enc.id})',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                    ),
                                    Text(
                                      '${enc.organisation} • ${enc.province} (${enc.ville})',
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Actif',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Email : ${enc.email} • Tél : ${enc.telephone} • $membersCount enfants encadrés',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: assignedClubs.map((c) {
                            return Chip(
                              padding: EdgeInsets.zero,
                              label: Text('${c.nom} (${c.nombreMembres} ados)', style: const TextStyle(fontSize: 10)),
                              backgroundColor: const Color(0xFF00ADEF).withValues(alpha: 0.1),
                              side: BorderSide(color: const Color(0xFF00ADEF).withValues(alpha: 0.2)),
                            );
                          }).toList(),
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
