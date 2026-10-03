import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_database.dart';
import '../models/models.dart';

class EncadreurClubTab extends StatelessWidget {
  const EncadreurClubTab({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabaseService>(context);
    final encadreur = db.activeEncadreur;
    final clubs = db.clubsOfActiveEncadreur;
    final activeClub = clubs.isNotEmpty ? clubs.first : db.clubs.first;
    final adolescents = db.getAdolescentsForClub(activeClub.id);

    final consentCount = adolescents.where((a) => a.statutConsentement == StatutConsentement.valide).length;
    final certifieCount = adolescents.where((a) => a.certifie).length;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Superviseur Club
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0072F5), Color(0xFF00ADEF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0072F5).withValues(alpha: 0.25),
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
                      child: Text(
                        '${encadreur.organisation} • ${encadreur.province}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        encadreur.id,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Superviseur : ${encadreur.nomComplet}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gestion & encadrement du : ${activeClub.nom} (${activeClub.ville})',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // KPIs du Club supervisé
          Row(
            children: [
              Expanded(
                child: _KpiBox(
                  title: 'Enfants du Club',
                  value: '${adolescents.length}',
                  icon: Icons.groups_rounded,
                  color: const Color(0xFF0072F5),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _KpiBox(
                  title: 'Consentements',
                  value: '$consentCount/${adolescents.length}',
                  icon: Icons.how_to_reg_rounded,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _KpiBox(
                  title: 'Certifiés',
                  value: '$certifieCount',
                  icon: Icons.verified_rounded,
                  color: const Color(0xFF00ADEF),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Liste détaillée des enfants supervisés
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Adolescents du Club (${adolescents.length})',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      activeClub.nom,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0072F5)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (adolescents.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text('Aucun adolescent inscrit dans ce club.')),
                  )
                else
                  ...adolescents.map((ado) {
                    final isConsentValid = ado.statutConsentement == StatutConsentement.valide;
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
                                    radius: 16,
                                    backgroundColor: const Color(0xFF0072F5).withValues(alpha: 0.15),
                                    child: Text(
                                      ado.prenom[0],
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0072F5), fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${ado.prenom} (${ado.id})',
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                      ),
                                      Text(
                                        '${ado.age} ans • ${ado.sexe == "F" ? "Fille" : "Garçon"} • ${ado.telephone}',
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isConsentValid
                                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                      : Colors.amber.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  isConsentValid ? 'Consentement OK' : 'Consentement requis',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isConsentValid ? const Color(0xFF10B981) : Colors.amber[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Jauge de formation
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Formation :', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                        Text('${ado.progressionFormation}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: LinearProgressIndicator(
                                        value: ado.progressionFormation / 100,
                                        backgroundColor: const Color(0xFFE2E8F0),
                                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0072F5)),
                                        minHeight: 5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Actions encadreur pour cet enfant
                          Row(
                            children: [
                              if (!isConsentValid) ...[
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      db.relancerConsentementRapidPro(ado.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Relance RapidPro SMS/WhatsApp envoyée au parent de ${ado.prenom} (${ado.telephoneParent}) !'),
                                          backgroundColor: const Color(0xFF0072F5),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.send_rounded, size: 14),
                                    label: const Text('Relance RapidPro', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF0072F5),
                                      side: const BorderSide(color: Color(0xFF0072F5)),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      db.validerConsentement(ado.id, 'Validation Papier Numérisé Encadreur');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Bordereau papier validé pour ${ado.prenom} !'),
                                          backgroundColor: const Color(0xFF10B981),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.document_scanner_rounded, size: 14),
                                    label: const Text('Valider Papier', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Actif • Mode : ${ado.modeConsentement}',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
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

class _KpiBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiBox({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
