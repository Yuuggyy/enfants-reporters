import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_database.dart';

class EncadreurRapidproTab extends StatefulWidget {
  const EncadreurRapidproTab({super.key});

  @override
  State<EncadreurRapidproTab> createState() => _EncadreurRapidproTabState();
}

class _EncadreurRapidproTabState extends State<EncadreurRapidproTab> {
  final _msgCtrl = TextEditingController();
  String _canal = 'WhatsApp';

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  void _sendClubBroadcast(MockDatabaseService db) {
    if (_msgCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir votre message de diffusion.')),
      );
      return;
    }

    final activeClub = db.clubsOfActiveEncadreur.isNotEmpty
        ? db.clubsOfActiveEncadreur.first
        : db.clubs.first;

    db.broadcasterMessageClub(
      clubId: activeClub.id,
      canal: _canal,
      message: _msgCtrl.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message diffusé avec succès via le moteur RapidPro ($_canal) aux membres du ${activeClub.nom} !'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );

    _msgCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabaseService>(context);
    final activeClub = db.clubsOfActiveEncadreur.isNotEmpty
        ? db.clubsOfActiveEncadreur.first
        : db.clubs.first;

    final logs = db.rapidProLogs;

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
                    color: const Color(0xFF0072F5).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.campaign_rounded, color: Color(0xFF0072F5), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Diffusion RapidPro vers mon Club',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        'Envoi de rappels & annonces aux enfants et parents du ${activeClub.nom}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Composer
          Container(
            padding: const EdgeInsets.all(20),
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
                    const Text('Canal de diffusion :', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'WhatsApp', label: Text('WhatsApp', style: TextStyle(fontSize: 11))),
                        ButtonSegment(value: 'SMS', label: Text('SMS', style: TextStyle(fontSize: 11))),
                      ],
                      selected: {_canal},
                      onSelectionChanged: (set) {
                        setState(() => _canal = set.first);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('Message pour le club *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                const SizedBox(height: 6),
                TextField(
                  controller: _msgCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Ex: Chers membres du club, rappel : atelier pratique de plaidoyer ce samedi à 10h...',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _sendClubBroadcast(db),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: Text('Diffuser via RapidPro ($_canal)', style: const TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0072F5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Historique des messages RapidPro
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
                      'Flux des Messages RapidPro',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Row(
                      children: [
                        Icon(Icons.sync_rounded, size: 14, color: Color(0xFF10B981)),
                        SizedBox(width: 4),
                        Text('Connecté au Backend', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...logs.map((log) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: log.canal == 'WhatsApp'
                                    ? const Color(0xFF25D366).withValues(alpha: 0.15)
                                    : const Color(0xFF00ADEF).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                log.canal,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: log.canal == 'WhatsApp' ? const Color(0xFF1EBE5D) : const Color(0xFF00ADEF),
                                ),
                              ),
                            ),
                            Text(
                              log.dateEnvoi,
                              style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Destinataire : ${log.destinataire}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          log.texte,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
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
