import 'package:flutter/material.dart';

/// Petites pastilles de statistiques (XP, série, badges).
class StatChip extends StatelessWidget {
  final IconData icone;
  final String libelle;
  final Color couleur;

  const StatChip({
    super.key,
    required this.icone,
    required this.libelle,
    required this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11001B4E),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, color: couleur, size: 18),
          const SizedBox(width: 6),
          Text(
            libelle,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
