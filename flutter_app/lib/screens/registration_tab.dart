import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_database.dart';
import '../services/i18n_service.dart';
import '../models/models.dart';

class RegistrationTab extends StatefulWidget {
  const RegistrationTab({super.key});

  @override
  State<RegistrationTab> createState() => _RegistrationTabState();
}

class _RegistrationTabState extends State<RegistrationTab> {
  int _selectedSubTab = 0; // 0: Formulaire / Canaux, 1: Suivi Consentement

  // Form controllers
  final _prenomController = TextEditingController();
  final _ageController = TextEditingController(text: '15');
  final _villeController = TextEditingController();
  final _telAdoController = TextEditingController();
  final _telParentController = TextEditingController();

  String _sexe = 'F';
  String _province = 'Kinshasa';
  String _milieu = 'Urbain';
  String _statutScolaire = 'Scolarisé(e)';
  bool _handicap = false;
  String _langue = 'Français';
  CanalInscription _canal = CanalInscription.web;

  bool _isSuccess = false;
  bool _isSubmitting = false;
  String _generatedId = '';

  final List<String> _provinces = [
    'Kinshasa',
    'Haut-Katanga',
    'Nord-Kivu',
    'Kasaï-Central',
    'Sud-Kivu',
    'Ituri',
    'Kongo-Central',
    'Tshopo',
    'Lualaba',
    'Autre province',
  ];

  @override
  void dispose() {
    _prenomController.dispose();
    _ageController.dispose();
    _villeController.dispose();
    _telAdoController.dispose();
    _telParentController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(MockDatabaseService db) async {
    final prenom = _prenomController.text.trim();
    final age = int.tryParse(_ageController.text.trim()) ?? 15;
    final ville = _villeController.text.trim().isNotEmpty ? _villeController.text.trim() : 'Centre';
    final telAdo = _telAdoController.text.trim().isNotEmpty ? _telAdoController.text.trim() : '+243810000000';
    final telParent = _telParentController.text.trim().isNotEmpty ? _telParentController.text.trim() : '+243819999999';

    if (prenom.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez renseigner le prénom de l\'adolescent.')),
      );
      return;
    }

    if (age < 12 || age > 17) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Âge non éligible (programme réservé aux 12–17 ans).')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final clubId = _province.contains('Katanga')
        ? 'CLUB-LUB-02'
        : _province.contains('Kasaï')
            ? 'CLUB-KAN-03'
            : 'CLUB-KIN-01';

    final newAdo = Adolescent(
      id: 'ADO-243-00${db.adolescents.length + 1}',
      prenom: prenom,
      age: age,
      sexe: _sexe,
      province: _province,
      ville: ville,
      milieu: _milieu,
      statutScolaire: _statutScolaire,
      situationHandicap: _handicap,
      languePreferee: _langue,
      telephone: telAdo,
      telephoneParent: telParent,
      clubId: clubId,
      canal: _canal,
      statutConsentement: StatutConsentement.enAttente,
      modeConsentement: 'En attente confirmation parentale',
      progressionFormation: 0,
      certifie: false,
      codeCertificat: '',
      dateInscription: DateTime.now().toString().substring(0, 10),
      badges: ['Nouveau Membre'],
    );

    try {
      final realId = await db.ajouterAdolescent(newAdo);
      setState(() {
        _generatedId = realId;
        _isSuccess = true;
      });
    } catch (e) {
      setState(() {
        _generatedId = newAdo.id;
        _isSuccess = true;
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabaseService>(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Segmented sub-tabs
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedSubTab = 0),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedSubTab == 0 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _selectedSubTab == 0
                            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                            : null,
                      ),
                      child: Text(
                        '1. Inscription',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _selectedSubTab == 0 ? const Color(0xFF0072F5) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedSubTab = 1),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedSubTab == 1 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _selectedSubTab == 1
                            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                            : null,
                      ),
                      child: Text(
                        '2. Consentement (${db.adolescents.where((a) => a.statutConsentement == StatutConsentement.enAttente).length})',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _selectedSubTab == 1 ? const Color(0xFF0072F5) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          if (_selectedSubTab == 0) ...[
            if (_isSuccess) ...[
              // Success confirmation
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.green.shade200),
                  boxShadow: [
                    BoxShadow(color: Colors.green.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 6)),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded, color: Colors.green, size: 36),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Inscription Enregistrée !',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    if (_generatedId.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00ADEF).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF00ADEF).withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'Identifiant attribué : $_generatedId',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF00ADEF)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    const Text(
                      'Un message automatique d\'information a été préparé pour le tuteur légal. Le compte sera activé dès validation du consentement.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isSuccess = false;
                          _prenomController.clear();
                          _villeController.clear();
                          _telAdoController.clear();
                          _telParentController.clear();
                          _selectedSubTab = 1; // switch to consent tab
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00ADEF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Voir les consentements en attente', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Channel Selector Pills
              const Text(
                'Canal de collecte',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _CanalPill(
                      label: 'Formulaire Web',
                      icon: Icons.language_rounded,
                      selected: _canal == CanalInscription.web,
                      onTap: () => setState(() => _canal = CanalInscription.web),
                    ),
                    const SizedBox(width: 8),
                    _CanalPill(
                      label: 'WhatsApp U-Report',
                      icon: Icons.chat_rounded,
                      selected: _canal == CanalInscription.whatsapp,
                      onTap: () => setState(() => _canal = CanalInscription.whatsapp),
                    ),
                    const SizedBox(width: 8),
                    _CanalPill(
                      label: 'SMS / USSD 2G',
                      icon: Icons.sms_rounded,
                      selected: _canal == CanalInscription.sms,
                      onTap: () => setState(() => _canal = CanalInscription.sms),
                    ),
                    const SizedBox(width: 8),
                    _CanalPill(
                      label: 'Assisté REIPE',
                      icon: Icons.offline_pin_rounded,
                      selected: _canal == CanalInscription.assiste,
                      onTap: () => setState(() => _canal = CanalInscription.assiste),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Registration Form Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Prénom & Âge
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _InputField(
                            label: 'Prénom de l\'adolescent *',
                            controller: _prenomController,
                            hint: 'ex: Esther',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: _InputField(
                            label: 'Âge (12-17) *',
                            controller: _ageController,
                            hint: '15',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Sexe & Milieu
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Genre', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFCBD5E1)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _sexe,
                                    items: const [
                                      DropdownMenuItem(value: 'F', child: Text('Fille (F)')),
                                      DropdownMenuItem(value: 'M', child: Text('Garçon (M)')),
                                    ],
                                    onChanged: (v) => setState(() => _sexe = v!),
                                  ),
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
                              const Text('Milieu', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFCBD5E1)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _milieu,
                                    items: const [
                                      DropdownMenuItem(value: 'Urbain', child: Text('Urbain')),
                                      DropdownMenuItem(value: 'Rural', child: Text('Rural')),
                                      DropdownMenuItem(value: 'Périurbain', child: Text('Périurbain')),
                                    ],
                                    onChanged: (v) => setState(() => _milieu = v!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Province & Ville
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Province', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFCBD5E1)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _province,
                                    items: _provinces.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                                    onChanged: (v) => setState(() => _province = v!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InputField(
                            label: 'Ville / Territoire',
                            controller: _villeController,
                            hint: 'ex: Nsele',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Numéros de contact
                    _InputField(
                      label: 'Numéro de contact Parent / Tuteur *',
                      controller: _telParentController,
                      hint: '+243 81 ... (SMS de consentement)',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),

                    // Handicap declaratif
                    Row(
                      children: [
                        Checkbox(
                          value: _handicap,
                          activeColor: const Color(0xFF00ADEF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (v) => setState(() => _handicap = v ?? false),
                        ),
                        const Expanded(
                          child: Text(
                            'Situation de handicap (déclaratif et facultatif)',
                            style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    ElevatedButton(
                      onPressed: _isSubmitting ? null : () => _submitForm(db),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00ADEF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text(
                              'Enregistrer l\'inscription',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ] else ...[
            // Consent Management SubTab
            Text(
              'Dossiers en attente de consentement parentale (${db.adolescents.where((a) => a.statutConsentement == StatutConsentement.enAttente).length})',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 10),

            ...db.adolescents.map((ado) {
              final isPending = ado.statutConsentement == StatutConsentement.enAttente;
              final isValid = ado.statutConsentement == StatutConsentement.valide;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isPending ? Colors.amber.shade200 : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${ado.prenom} (${ado.age} ans)',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isValid
                                ? Colors.green.shade50
                                : (isPending ? Colors.amber.shade50 : Colors.red.shade50),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isValid
                                  ? Colors.green.shade200
                                  : (isPending ? Colors.amber.shade200 : Colors.red.shade200),
                            ),
                          ),
                          child: Text(
                            isValid ? 'Validé' : (isPending ? 'En attente' : 'Révoqué'),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isValid
                                  ? Colors.green.shade700
                                  : (isPending ? Colors.amber.shade800 : Colors.red.shade700),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${ado.id} • ${ado.province} • Tuteur : ${ado.telephoneParent}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 12),

                    if (isPending) ...[
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => db.validerConsentement(ado.id, 'SMS Parent'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green.shade700,
                                side: BorderSide(color: Colors.green.shade300),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              icon: const Icon(Icons.check_rounded, size: 16),
                              label: const Text('Valider SMS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => db.validerConsentement(ado.id, 'Bordereau Papier'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF00ADEF),
                                side: const BorderSide(color: Color(0xFF00ADEF)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              icon: const Icon(Icons.description_rounded, size: 16),
                              label: const Text('Papier REIPE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ] else if (isValid) ...[
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => db.revoquerConsentement(ado.id),
                          icon: const Icon(Icons.block_rounded, size: 14, color: Colors.redAccent),
                          label: const Text(
                            'Révoquer & Anonymiser',
                            style: TextStyle(fontSize: 11, color: Colors.redAccent),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _CanalPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CanalPill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00ADEF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF00ADEF) : const Color(0xFFCBD5E1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: selected ? Colors.white : const Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _InputField({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00ADEF), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
