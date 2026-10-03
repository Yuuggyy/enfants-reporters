import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_database.dart';

class AdminRapidproHubTab extends StatefulWidget {
  const AdminRapidproHubTab({super.key});

  @override
  State<AdminRapidproHubTab> createState() => _AdminRapidproHubTabState();
}

class _AdminRapidproHubTabState extends State<AdminRapidproHubTab> {
  final _campagneTitreCtrl = TextEditingController();
  final _campagneMsgCtrl = TextEditingController();
  String _audience = 'Tous les Adolescents (National)';
  String _canal = 'WhatsApp';

  @override
  void dispose() {
    _campagneTitreCtrl.dispose();
    _campagneMsgCtrl.dispose();
    super.dispose();
  }

  void _triggerNationalCampaign(MockDatabaseService db) {
    if (_campagneTitreCtrl.text.trim().isEmpty || _campagneMsgCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez renseigner le titre et le message de la campagne.')),
      );
      return;
    }

    db.broadcasterCampagneNationale(
      titre: _campagneTitreCtrl.text.trim(),
      audience: _audience,
      canal: _canal,
      message: _campagneMsgCtrl.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🚀 Campagne nationale RapidPro ($_canal) lancée pour : $_audience !'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );

    _campagneTitreCtrl.clear();
    _campagneMsgCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabaseService>(context);
    final logs = db.rapidProLogs;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Hub RapidPro
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF0072F5)],
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
                      child: const Text(
                        'Moteur Multicanal RapidPro',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: Color(0xFF10B981)),
                        SizedBox(width: 6),
                        Text(
                          'Backend FastAPI Sync',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Supervision du Moteur de Communication',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gestion des passerelles GSM (Vodacom, Airtel, Orange, Africell), WhatsApp Cloud API & Webhooks',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // État des passerelles
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
                  'Statut des Canaux & Passerelles Télécoms',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: _buildGatewayStatus('WhatsApp API', '99.9%', const Color(0xFF25D366))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildGatewayStatus('SMS SMPP', '98.5%', const Color(0xFF00ADEF))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildGatewayStatus('USSD Gateway', '97.2%', const Color(0xFF8B5CF6))),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Déclencheur Campagne Nationale
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
                const Text(
                  'Déclencher une Campagne Nationale / Provinciale',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 14),
                const Text('Titre de la campagne *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                const SizedBox(height: 6),
                TextField(
                  controller: _campagneTitreCtrl,
                  decoration: InputDecoration(
                    hintText: 'Ex: Campagne Rentrée Scolaire & Plaidoyer Eau',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Audience Cible', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _audience,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Tous les Adolescents (National)',
                                child: Text('Tous les Adolescents (National)', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11)),
                              ),
                              DropdownMenuItem(
                                value: 'Encadreurs REIPE Uniquement',
                                child: Text('Encadreurs REIPE Uniquement', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11)),
                              ),
                              DropdownMenuItem(
                                value: 'Parents / Tuteurs (Relance)',
                                child: Text('Parents / Tuteurs (Relance)', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11)),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _audience = val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Canal Principal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _canal,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'WhatsApp', child: Text('WhatsApp', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'SMS', child: Text('SMS', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12))),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _canal = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Texte du message *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                const SizedBox(height: 6),
                TextField(
                  controller: _campagneMsgCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Message diffusé à l\'ensemble des destinataires ciblés...',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _triggerNationalCampaign(db),
                    icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                    label: const Text('Diffuser la Campagne via RapidPro', style: TextStyle(fontWeight: FontWeight.bold)),
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

          // Logs d'exécution RapidPro
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
                  'Journal des Flux Multicanaux RapidPro',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
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
                            Row(
                              children: [
                                Text(
                                  log.emetteur,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00ADEF).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(log.canal, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF00ADEF))),
                                ),
                              ],
                            ),
                            Text(log.dateEnvoi, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Cible : ${log.destinataire}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                        const SizedBox(height: 4),
                        Text(log.texte, style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
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

  Widget _buildGatewayStatus(String title, String uptime, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cell_tower_rounded, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Dispo : $uptime',
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
