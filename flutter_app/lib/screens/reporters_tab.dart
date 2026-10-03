import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_database.dart';
import '../services/i18n_service.dart';
import '../models/models.dart';

class ReportersTab extends StatefulWidget {
  const ReportersTab({super.key});

  @override
  State<ReportersTab> createState() => _ReportersTabState();
}

class _ReportersTabState extends State<ReportersTab> {
  int _selectedSubTab = 0; // 0: Nouveau Reportage, 1: Modération & Ponabana

  final _titreController = TextEditingController();
  final _resumeController = TextEditingController();

  String _typeMedia = 'Photo / Reportage';
  String _theme = 'Éducation & Scolarisation';
  String _province = 'Kinshasa';
  bool _consentementSujets = true;
  bool _floutageEffectue = true;
  bool _exifPurge = true;

  bool _isSuccess = false;

  final List<String> _typesMedia = [
    'Photo / Reportage',
    'Texte / Article',
    'Capsule Audio',
    'Vidéo Courte 240p',
  ];

  final List<String> _themes = [
    'Éducation & Scolarisation',
    'Eau, Hygiène & Santé',
    'Protection & Non-violence',
    'Nutrition & Développement',
    'Climat & Environnement',
  ];

  @override
  void dispose() {
    _titreController.dispose();
    _resumeController.dispose();
    super.dispose();
  }

  void _submitReportage(MockDatabaseService db) {
    final titre = _titreController.text.trim();
    final resume = _resumeController.text.trim();

    if (titre.isEmpty || resume.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez renseigner le titre et le résumé du reportage.')),
      );
      return;
    }

    final newMedia = ContenuMedia(
      id: 'MED-00${db.medias.length + 1}',
      auteurId: db.activeAdolescent.id,
      auteurPrenom: db.activeAdolescent.prenom,
      clubId: db.activeAdolescent.clubId,
      titre: titre,
      type: _typeMedia,
      province: _province,
      theme: _theme,
      resume: resume,
      consentementSujets: _consentementSujets,
      floutageEffectue: _floutageEffectue,
      exifPurge: _exifPurge,
      statut: 'En attente modération (Encadreur)',
      dateSoumission: DateTime.now().toString().substring(0, 10),
    );

    db.soumettreReportage(newMedia);

    setState(() {
      _isSuccess = true;
    });
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
                        '1. Soumettre un média',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
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
                        '2. Suivi & Blog Ponabana (${db.medias.length})',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
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
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                      child: const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 36),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Reportage Transmis !',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Votre reportage a été transmis à votre encadreur référent pour validation (Niveau 1) avant diffusion sur Ponabana.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isSuccess = false;
                          _titreController.clear();
                          _resumeController.clear();
                          _selectedSubTab = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00ADEF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Consulter le statut', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Formulaire de soumission
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Créer un reportage de plaidoyer',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 14),

                    // Titre
                    const Text('Titre du reportage *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _titreController,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                      decoration: InputDecoration(
                        hintText: 'ex: Accès à l\'eau potable dans notre école',
                        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Type & Theme
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Type de média', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
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
                                    value: _typeMedia,
                                    items: _typesMedia.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)))).toList(),
                                    onChanged: (v) => setState(() => _typeMedia = v!),
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
                              const Text('Thématique', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
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
                                    value: _theme,
                                    items: _themes.map((th) => DropdownMenuItem(value: th, child: Text(th, style: const TextStyle(fontSize: 12)))).toList(),
                                    onChanged: (v) => setState(() => _theme = v!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Résumé
                    const Text('Résumé ou témoignage *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _resumeController,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                      decoration: InputDecoration(
                        hintText: 'Décrivez la situation, les témoignages et les solutions proposées...',
                        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Outils de Sauvegarde
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _floutageEffectue,
                                activeColor: const Color(0xFF00ADEF),
                                onChanged: (v) => setState(() => _floutageEffectue = v ?? true),
                              ),
                              const Expanded(
                                child: Text('Floutage préventif des visages de mineurs', style: TextStyle(fontSize: 11, color: Color(0xFF334155))),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _exifPurge,
                                activeColor: const Color(0xFF00ADEF),
                                onChanged: (v) => setState(() => _exifPurge = v ?? true),
                              ),
                              const Expanded(
                                child: Text('Purge automatique de la géolocalisation EXIF', style: TextStyle(fontSize: 11, color: Color(0xFF334155))),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _consentementSujets,
                                activeColor: const Color(0xFF00ADEF),
                                onChanged: (v) => setState(() => _consentementSujets = v ?? true),
                              ),
                              const Expanded(
                                child: Text('Consentement éclairé des personnes interviewées', style: TextStyle(fontSize: 11, color: Color(0xFF334155))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    ElevatedButton(
                      onPressed: () => _submitReportage(db),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00ADEF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Soumettre le reportage', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ] else ...[
            // Blog Ponabana & Mes Reportages SubTab (Vue Enfant : Consultation & Suivi du statut uniquement)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF00ADEF).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF00ADEF).withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Color(0xFF00ADEF), size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Circuit de validation UNICEF : vos reportages sont relus par votre encadreur de club (Niveau 1) avant validation et publication finale sur le blog Ponabana (Niveau 2).',
                      style: TextStyle(fontSize: 11, color: Color(0xFF0369A1), fontWeight: FontWeight.w600, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            if (db.medias.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.article_outlined, size: 36, color: Color(0xFF94A3B8)),
                    SizedBox(height: 10),
                    Text(
                      'Aucun reportage soumis pour l\'instant.',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569), fontSize: 13),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Utilisez l\'onglet "Soumettre" pour proposer votre premier article ou témoignage.',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...db.medias.map((media) {
              final isPublished = media.statut.contains('Publié');
              final isValidatedEncadreur = media.statut.contains('Validé Encadreur');
              final isNeedsCorrection = media.statut.contains('corriger');
              final isMyReportage = media.auteurId == db.activeAdolescent.id;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isPublished
                        ? Colors.green.shade200
                        : (isMyReportage ? const Color(0xFF00ADEF).withValues(alpha: 0.4) : const Color(0xFFE2E8F0)),
                  ),
                  boxShadow: isMyReportage
                      ? [
                          BoxShadow(
                            color: const Color(0xFF00ADEF).withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(media.type, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                            ),
                            if (isMyReportage) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00ADEF).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text('Mon reportage', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF00ADEF))),
                              ),
                            ],
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isPublished
                                ? Colors.green.shade50
                                : (isValidatedEncadreur
                                    ? Colors.blue.shade50
                                    : (isNeedsCorrection ? Colors.orange.shade50 : Colors.amber.shade50)),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isPublished
                                  ? Colors.green.shade200
                                  : (isValidatedEncadreur
                                      ? Colors.blue.shade200
                                      : (isNeedsCorrection ? Colors.orange.shade200 : Colors.amber.shade200)),
                            ),
                          ),
                          child: Text(
                            media.statut,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isPublished
                                  ? Colors.green.shade700
                                  : (isValidatedEncadreur
                                      ? Colors.blue.shade700
                                      : (isNeedsCorrection ? Colors.orange.shade800 : Colors.amber.shade800)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      media.titre,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      media.resume,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.3),
                    ),
                    if (media.commentaireEncadreur != null && media.commentaireEncadreur!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.comment_bank_rounded, size: 14, color: Color(0xFF0072F5)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Avis Encadreur : ${media.commentaireEncadreur}',
                                style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF334155)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Par ${media.auteurPrenom} • ${media.province} (${media.dateSoumission})',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                        ),
                        if (isPublished)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'En ligne sur Ponabana',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                              ),
                            ],
                          )
                        else
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.schedule_rounded, color: Colors.amber, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                isValidatedEncadreur ? 'En attente Niv 2' : 'En attente Niv 1',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber),
                              ),
                            ],
                          ),
                      ],
                    ),
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
