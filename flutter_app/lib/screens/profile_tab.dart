import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_database.dart';
import '../services/i18n_service.dart';
import '../models/models.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  int _selectedSubTab = 0; // 0: Fil Social, 1: Badges & Impact, 2: Paramètres
  final _postController = TextEditingController();
  final _commentController = TextEditingController();
  String? _selectedPostIdForComment;

  final List<Map<String, dynamic>> _availableAvatars = [
    {'id': 'avatar_ado_1', 'label': 'Esther (Étoile)', 'icon': Icons.face_3_rounded, 'color': Color(0xFF00ADEF)},
    {'id': 'avatar_ado_2', 'label': 'Junior (Casque)', 'icon': Icons.face_rounded, 'color': Color(0xFF0072F5)},
    {'id': 'avatar_ado_3', 'label': 'Gloire (Fleur)', 'icon': Icons.face_4_rounded, 'color': Color(0xFF10B981)},
    {'id': 'avatar_ado_4', 'label': 'Daniel (Lunettes)', 'icon': Icons.face_6_rounded, 'color': Color(0xFFF59E0B)},
    {'id': 'avatar_encadreur_1', 'label': 'Encadreur Pro', 'icon': Icons.person_rounded, 'color': Color(0xFF6366F1)},
    {'id': 'avatar_admin_1', 'label': 'UNICEF Officiel', 'icon': Icons.verified_user_rounded, 'color': Color(0xFF0F172A)},
  ];

  @override
  void dispose() {
    _postController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _showEditProfileDialog(BuildContext context, MockDatabaseService db) {
    final isChild = db.currentRole == RoleUtilisateur.adolescent;
    final isEncadreur = db.currentRole == RoleUtilisateur.encadreur;

    final prenomController = TextEditingController(
      text: isChild
          ? db.activeAdolescent.prenom
          : (isEncadreur ? db.activeEncadreur.prenom : db.activeAdmin.prenom),
    );
    final nomController = TextEditingController(
      text: isEncadreur ? db.activeEncadreur.nom : db.activeAdmin.nom,
    );
    final bioController = TextEditingController(
      text: isChild
          ? db.activeAdolescent.bio
          : (isEncadreur ? db.activeEncadreur.bio : db.activeAdmin.bio),
    );
    final phoneController = TextEditingController(
      text: isEncadreur ? db.activeEncadreur.telephone : '',
    );
    String selectedAvatar = isChild
        ? db.activeAdolescent.avatarUrl
        : (isEncadreur ? db.activeEncadreur.avatarUrl : db.activeAdmin.avatarUrl);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Modifier mon profil & photo',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Choisissez votre avatar de réseau social :',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 70,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _availableAvatars.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          final av = _availableAvatars[i];
                          final isSelected = selectedAvatar == av['id'];
                          return InkWell(
                            onTap: () {
                              setModalState(() {
                                selectedAvatar = av['id'] as String;
                              });
                            },
                            borderRadius: BorderRadius.circular(35),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF00ADEF) : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 26,
                                backgroundColor: (av['color'] as Color).withValues(alpha: 0.15),
                                child: Icon(av['icon'] as IconData, color: av['color'] as Color, size: 28),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: prenomController,
                      decoration: InputDecoration(
                        labelText: 'Prénom',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    if (!isChild) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: nomController,
                        decoration: InputDecoration(
                          labelText: 'Nom de famille',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                    if (isEncadreur) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'Numéro de contact professionnel',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextField(
                      controller: bioController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Bio / Slogan d\'engagement',
                        hintText: 'Ex: Engagé pour les droits de l\'enfant à Kinshasa 🇨🇩✊',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (isChild) {
                          db.updateAdolescentProfile(
                            prenom: prenomController.text.trim(),
                            bio: bioController.text.trim(),
                            avatarUrl: selectedAvatar,
                          );
                        } else if (isEncadreur) {
                          db.updateEncadreurProfile(
                            prenom: prenomController.text.trim(),
                            nom: nomController.text.trim(),
                            bio: bioController.text.trim(),
                            avatarUrl: selectedAvatar,
                            telephone: phoneController.text.trim(),
                          );
                        } else {
                          db.updateAdminProfile(
                            prenom: prenomController.text.trim(),
                            nom: nomController.text.trim(),
                            bio: bioController.text.trim(),
                            avatarUrl: selectedAvatar,
                          );
                        }
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profil et photo mis à jour avec succès !')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00ADEF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Enregistrer les modifications', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _publishSocialPost(MockDatabaseService db) {
    final text = _postController.text.trim();
    if (text.isEmpty) return;

    db.creerSocialPost(
      texte: text,
      tags: ['#EngagementJeunes', '#UNICEFRDC', '#Plaidoyer'],
    );
    _postController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Publication partagée sur le réseau des jeunes ! (+25 XP)')),
    );
  }

  void _addCommentToPost(MockDatabaseService db, String postId) {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    db.ajouterCommentairePost(postId, text);
    _commentController.clear();
    setState(() {
      _selectedPostIdForComment = null;
    });
  }

  Widget _buildAvatarWidget(String avatarId, {double radius = 30}) {
    IconData iconData = Icons.face_rounded;
    Color iconColor = const Color(0xFF00ADEF);

    for (final av in _availableAvatars) {
      if (av['id'] == avatarId) {
        iconData = av['icon'] as IconData;
        iconColor = av['color'] as Color;
        break;
      }
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: iconColor.withValues(alpha: 0.15),
      child: Icon(iconData, color: iconColor, size: radius * 1.1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabaseService>(context);
    final i18n = Provider.of<I18nService>(context);

    final isChild = db.currentRole == RoleUtilisateur.adolescent;
    final isEncadreur = db.currentRole == RoleUtilisateur.encadreur;

    final displayName = isChild
        ? db.activeAdolescent.prenom
        : (isEncadreur ? db.activeEncadreur.nomComplet : db.activeAdmin.nomComplet);

    final pseudo = isChild
        ? db.activeAdolescent.pseudo
        : (isEncadreur ? db.activeEncadreur.pseudo : db.activeAdmin.pseudo);

    final bio = isChild
        ? db.activeAdolescent.bio
        : (isEncadreur ? db.activeEncadreur.bio : db.activeAdmin.bio);

    final avatarUrl = isChild
        ? db.activeAdolescent.avatarUrl
        : (isEncadreur ? db.activeEncadreur.avatarUrl : db.activeAdmin.avatarUrl);

    final roleTitle = isChild
        ? 'Adolescent Reporter • 15 ans'
        : (isEncadreur ? 'Superviseur REIPE (${db.activeEncadreur.ville})' : 'Superviseur National UNICEF');

    final roleColor = isChild
        ? const Color(0xFF00ADEF)
        : (isEncadreur ? const Color(0xFF0072F5) : const Color(0xFF0F172A));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header profil réseau social avec cover et avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      roleColor,
                      const Color(0xFF0072F5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isChild ? db.activeAdolescent.id : (isEncadreur ? db.activeEncadreur.id : db.activeAdmin.id),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showEditProfileDialog(context, db),
                        icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                        tooltip: 'Modifier mon profil',
                      ),
                    ],
                  ),
                ),
              ),

              // Avatar & photo flottante
              Positioned(
                bottom: -40,
                left: 20,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: _buildAvatarWidget(avatarUrl, radius: 38),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => _showEditProfileDialog(context, db),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00ADEF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 48),

          // Informations Identité & Bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.verified_rounded, color: Color(0xFF00ADEF), size: 18),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      pseudo,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        roleTitle,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: roleColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  bio,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.35),
                ),
                const SizedBox(height: 14),

                // Social Stats Row (Style Réseau Social)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSocialStat('Publications', '${db.socialPosts.where((p) => p.auteurId == (isChild ? db.activeAdolescent.id : (isEncadreur ? db.activeEncadreur.id : db.activeAdmin.id))).length + 2}'),
                      Container(height: 24, width: 1, color: const Color(0xFFE2E8F0)),
                      _buildSocialStat(
                        isChild ? 'Points XP' : 'Clubs / Rôle',
                        isChild ? '${db.activeAdolescent.pointsXp} XP' : (isEncadreur ? '${db.activeEncadreur.clubIds.length} Club' : 'National'),
                      ),
                      Container(height: 24, width: 1, color: const Color(0xFFE2E8F0)),
                      _buildSocialStat(
                        'Communauté',
                        isChild ? (db.clubOfActiveAdolescent?.nom.split(' ').last ?? 'Nsele') : (isEncadreur ? 'REIPE' : 'UNICEF'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Sous-onglets Navigation Profil (Fil Social / Badges & Réalisations / Paramètres & Déconnexion)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedSubTab = 0),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedSubTab == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _selectedSubTab == 0
                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]
                              : null,
                        ),
                        child: Text(
                          'Mur Social',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
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
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedSubTab == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _selectedSubTab == 1
                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]
                              : null,
                        ),
                        child: Text(
                          isChild ? 'Badges & XP' : 'Supervision',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _selectedSubTab == 1 ? const Color(0xFF0072F5) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedSubTab = 2),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedSubTab == 2 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _selectedSubTab == 2
                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]
                              : null,
                        ),
                        child: Text(
                          'Paramètres',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _selectedSubTab == 2 ? const Color(0xFF0072F5) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Contenu du sous-onglet sélectionné
          if (_selectedSubTab == 0) ...[
            // 1. MUR SOCIAL : Créer une publication & Fil d'actualité
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildAvatarWidget(avatarUrl, radius: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _postController,
                            decoration: const InputDecoration(
                              hintText: 'Partagez une action de plaidoyer ou une idée...',
                              hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Ajout de photo avec purge EXIF & floutage activés.')),
                                );
                              },
                              icon: const Icon(Icons.add_photo_alternate_rounded, color: Color(0xFF00ADEF), size: 20),
                              tooltip: 'Ajouter une photo',
                            ),
                            IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Tag #Plaidoyer #UNICEF ajouté')),
                                );
                              },
                              icon: const Icon(Icons.tag_rounded, color: Color(0xFF0072F5), size: 20),
                              tooltip: 'Ajouter un tag',
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _publishSocialPost(db),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00ADEF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.send_rounded, size: 14),
                          label: const Text('Publier', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Liste des posts du fil social
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: db.socialPosts.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.forum_outlined, size: 36, color: Color(0xFF94A3B8)),
                          SizedBox(height: 10),
                          Text(
                            'Aucune publication sur le mur pour l\'instant.',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569), fontSize: 13),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Soyez le premier à partager une action de plaidoyer avec votre club !',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: db.socialPosts.map((post) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Auteur header
                        Row(
                          children: [
                            _buildAvatarWidget(post.auteurAvatar, radius: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        post.auteurNom,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.verified_rounded, color: Color(0xFF00ADEF), size: 13),
                                    ],
                                  ),
                                  Text(
                                    '${post.auteurRole} • ${post.date}',
                                    style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                post.clubNom,
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF0072F5)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          post.texte,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4),
                        ),
                        if (post.tags.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            children: post.tags.map((tag) {
                              return Text(
                                tag,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF00ADEF)),
                              );
                            }).toList(),
                          ),
                        ],
                        const SizedBox(height: 12),
                        // Actions likes & commentaires
                        Row(
                          children: [
                            InkWell(
                              onTap: () => db.toggleLikePost(post.id),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                      color: post.isLiked ? const Color(0xFFEF4444) : const Color(0xFF64748B),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${post.likesCount}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: post.isLiked ? const Color(0xFFEF4444) : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedPostIdForComment =
                                      _selectedPostIdForComment == post.id ? null : post.id;
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.mode_comment_outlined, color: Color(0xFF64748B), size: 18),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${post.commentaires.length}',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Section commentaires déroulante
                        if (post.commentaires.isNotEmpty || _selectedPostIdForComment == post.id) ...[
                          const Divider(height: 16),
                          ...post.commentaires.map((com) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildAvatarWidget(com.auteurAvatar, radius: 12),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          com.auteurNom,
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                        ),
                                        Text(
                                          com.texte,
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(com.date, style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
                                ],
                              ),
                            );
                          }),
                          // Input commentaire
                          if (_selectedPostIdForComment == post.id) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _commentController,
                                    decoration: InputDecoration(
                                      hintText: 'Écrire un mot d\'encouragement...',
                                      hintStyle: const TextStyle(fontSize: 11),
                                      isDense: true,
                                      filled: true,
                                      fillColor: const Color(0xFFF1F5F9),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                IconButton(
                                  onPressed: () => _addCommentToPost(db, post.id),
                                  icon: const Icon(Icons.send_rounded, color: Color(0xFF00ADEF), size: 18),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ] else if (_selectedSubTab == 1) ...[
            // 2. BADGES & RÉALISATIONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isChild) ...[
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
                            children: [
                              Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 22),
                              SizedBox(width: 8),
                              Text(
                                'Mes Badges & Niveaux',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: db.activeAdolescent.badges.map((b) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star_rounded, color: Color(0xFFD97706), size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      b,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
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
                            'Prérogatives & Supervision',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.check_circle_rounded, color: Colors.green),
                            title: Text(isEncadreur ? 'Superviseur agréé REIPE' : 'Superviseur National UNICEF'),
                            subtitle: Text(isEncadreur ? 'Habilité validation Niveau 1 & inscription assistée' : 'Habilité validation Ponabana & Hub RapidPro'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ] else ...[
            // 3. PARAMÈTRES & BOUTON DÉCONNEXION CLAIR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                          'Informations de Session',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Langue active', i18n.languageNames[i18n.currentLanguage] ?? 'Français'),
                        _buildInfoRow('Rôle système', isChild ? 'Adolescent (12-17 ans)' : (isEncadreur ? 'Encadreur de terrain' : 'Administrateur')),
                        _buildInfoRow('Localisation', isChild ? '${db.activeAdolescent.province} (${db.activeAdolescent.ville})' : (isEncadreur ? db.activeEncadreur.ville : 'RDC')),
                        _buildInfoRow('Sauvegarde PSE', 'Protection 24/7 active'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // BOUTON SE DÉCONNECTER PROMINENT
                  ElevatedButton.icon(
                    onPressed: () {
                      db.logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Déconnexion effectuée. À bientôt !')),
                      );
                    },
                    icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                    label: const Text(
                      'Se déconnecter de ce compte',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSocialStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }
}
