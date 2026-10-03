import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_database.dart';
import '../models/models.dart';

class EncadreurAssistedRegTab extends StatefulWidget {
  const EncadreurAssistedRegTab({super.key});

  @override
  State<EncadreurAssistedRegTab> createState() => _EncadreurAssistedRegTabState();
}

class _EncadreurAssistedRegTabState extends State<EncadreurAssistedRegTab> {
  final _prenomCtrl = TextEditingController();
  final _ageCtrl = TextEditingController(text: '15');
  final _telAdoCtrl = TextEditingController();
  final _telParentCtrl = TextEditingController();

  String _sexe = 'F';
  String _milieu = 'Urbain';
  String _statutScolaire = 'Scolarisé(e)';
  bool _handicap = false;
  String _langue = 'Lingála';

  @override
  void dispose() {
    _prenomCtrl.dispose();
    _ageCtrl.dispose();
    _telAdoCtrl.dispose();
    _telParentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitAssistedRegistration(MockDatabaseService db) async {
    if (_prenomCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir le prénom de l\'adolescent.')),
      );
      return;
    }

    final age = int.tryParse(_ageCtrl.text) ?? 15;
    if (age < 12 || age > 17) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Âge inéligible : le programme est réservé aux 12–17 ans.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final activeClub = db.clubsOfActiveEncadreur.isNotEmpty
        ? db.clubsOfActiveEncadreur.first
        : db.clubs.first;

    final newId = 'ADO-243-00${db.adolescents.length + 1}';

    final ado = Adolescent(
      id: newId,
      prenom: _prenomCtrl.text.trim(),
      age: age,
      sexe: _sexe,
      province: activeClub.province,
      ville: activeClub.ville,
      milieu: _milieu,
      statutScolaire: _statutScolaire,
      situationHandicap: _handicap,
      languePreferee: _langue,
      telephone: _telAdoCtrl.text.isNotEmpty ? _telAdoCtrl.text.trim() : '+243810000000',
      telephoneParent: _telParentCtrl.text.isNotEmpty ? _telParentCtrl.text.trim() : '+243819999999',
      clubId: activeClub.id,
      canal: CanalInscription.assiste,
      statutConsentement: StatutConsentement.enAttente,
      modeConsentement: 'Inscription Assistée Encadreur REIPE',
      progressionFormation: 0,
      certifie: false,
      codeCertificat: '',
      dateInscription: DateTime.now().toString().substring(0, 10),
      badges: ['Bienvenue'],
    );

    String assignedId = newId;
    try {
      assignedId = await db.ajouterAdolescent(ado);
    } catch (_) {}

    db.relancerConsentementRapidPro(assignedId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ${ado.prenom} inscrit(e) au ${activeClub.nom} ($assignedId). Notification RapidPro envoyée au parent !'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }

    _prenomCtrl.clear();
    _telAdoCtrl.clear();
    _telParentCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabaseService>(context);
    final activeClub = db.clubsOfActiveEncadreur.isNotEmpty
        ? db.clubsOfActiveEncadreur.first
        : db.clubs.first;

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
                  child: const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF0072F5), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Inscription Assistée (Hors-Ligne)',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        'Rattachement automatique au : ${activeClub.nom}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF0072F5), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Formulaire
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
                const Text('Prénom de l\'adolescent *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                const SizedBox(height: 6),
                TextField(
                  controller: _prenomCtrl,
                  decoration: InputDecoration(
                    hintText: 'Ex: Kethia',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Âge (12–17 ans) *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _ageCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Sexe *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _sexe,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'F', child: Text('Fille (F)', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'M', child: Text('Garçon (M)', overflow: TextOverflow.ellipsis)),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _sexe = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                const Text('Téléphone Parent / Tuteur (pour consentement RapidPro) *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                const SizedBox(height: 6),
                TextField(
                  controller: _telParentCtrl,
                  decoration: InputDecoration(
                    hintText: '+243810000000',
                    prefixIcon: const Icon(Icons.phone_rounded, size: 18, color: Color(0xFF0072F5)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Langue préférée', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _langue,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Lingála', child: Text('Lingála', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Kiswahili', child: Text('Kiswahili', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Tshiluba', child: Text('Tshiluba', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Kikongo', child: Text('Kikongo', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Français', child: Text('Français', overflow: TextOverflow.ellipsis)),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _langue = val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Milieu', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _milieu,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Urbain', child: Text('Urbain', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Périurbain', child: Text('Périurbain', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Rural', child: Text('Rural', overflow: TextOverflow.ellipsis)),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _milieu = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                SwitchListTile(
                  title: const Text('Situation de handicap (facultatif)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Permet d\'adapter les supports et ateliers de plaidoyer', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  value: _handicap,
                  activeColor: const Color(0xFF0072F5),
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setState(() => _handicap = val),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _submitAssistedRegistration(db),
                    icon: const Icon(Icons.how_to_reg_rounded, size: 18),
                    label: const Text('Inscrire l\'adolescent dans mon Club', style: TextStyle(fontWeight: FontWeight.bold)),
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
        ],
      ),
    );
  }
}
