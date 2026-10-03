import 'package:flutter/material.dart';

/// Logo officiel de l'application BanApp
/// Conforme à la charte graphique : fond doré chaleureux, smartphone stylisé,
/// badges sociaux flottants (coeur/profil), typographie serif 'BanApp' et emblème UNICEF.
class BanAppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final double borderRadius;
  final bool hasShadow;

  const BanAppLogo({
    super.key,
    this.size = 48,
    this.showText = true,
    this.borderRadius = 14,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEAB308), // Jaune or / ambré vif
            Color(0xFFCA8A04), // Or profond
            Color(0xFFA16207), // Ambré chaleureux
          ],
        ),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: const Color(0xFFCA8A04).withValues(alpha: 0.35),
                  blurRadius: size * 0.18,
                  offset: Offset(0, size * 0.08),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: CustomPaint(
          size: Size(size, size),
          painter: _BanAppLogoPainter(showText: showText),
        ),
      ),
    );
  }
}

/// Peintre personnalisé haute définition pour restituer fidèlement le logo BanApp
class _BanAppLogoPainter extends CustomPainter {
  final bool showText;

  _BanAppLogoPainter({required this.showText});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Fond texturé et reflets doux
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        radius: 0.8,
        colors: [
          const Color(0xFFFDE047).withValues(alpha: 0.4),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), glowPaint);

    // 2. Tracé du Smartphone incliné (lignes sombres dorées)
    final phoneStrokePaint = Paint()
      ..color = const Color(0xFF78350F).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.038
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final phoneFillPaint = Paint()
      ..color = const Color(0xFFFEF08A).withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    canvas.save();
    // Rotation légère du téléphone comme sur le logo original (-12 degrés)
    canvas.translate(w * 0.50, h * 0.50);
    canvas.rotate(-0.22);

    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(-w * 0.02, 0),
        width: w * 0.44,
        height: h * 0.76,
      ),
      Radius.circular(w * 0.08),
    );
    canvas.drawRRect(phoneRect, phoneFillPaint);
    canvas.drawRRect(phoneRect, phoneStrokePaint);

    // Écran intérieur du téléphone
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(-w * 0.02, 0),
        width: w * 0.36,
        height: h * 0.64,
      ),
      Radius.circular(w * 0.05),
    );
    final screenStrokePaint = Paint()
      ..color = const Color(0xFF92400E).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.018;
    canvas.drawRRect(screenRect, screenStrokePaint);

    // Encoche haut-parleur
    final notchPaint = Paint()
      ..color = const Color(0xFF78350F).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.022
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(-w * 0.07, -h * 0.32),
      Offset(w * 0.03, -h * 0.32),
      notchPaint,
    );

    canvas.restore();

    // 3. Badges sociaux flottants (en haut à droite)
    // Badge 1 : Coeur (Like)
    final badge1Rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.70, h * 0.33),
        width: w * 0.22,
        height: w * 0.20,
      ),
      Radius.circular(w * 0.05),
    );
    final badgeFill = Paint()
      ..color = const Color(0xFFFEF9C3).withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    final badgeStroke = Paint()
      ..color = const Color(0xFF78350F).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.032;

    canvas.drawRRect(badge1Rect, badgeFill);
    canvas.drawRRect(badge1Rect, badgeStroke);

    // Dessin du coeur dans le badge 1
    final heartPath = Path();
    final hx = w * 0.70;
    final hy = h * 0.32;
    final hs = w * 0.06;
    heartPath.moveTo(hx, hy + hs * 0.7);
    heartPath.cubicTo(
      hx - hs, hy,
      hx - hs, hy - hs * 0.8,
      hx, hy - hs * 0.3,
    );
    heartPath.cubicTo(
      hx + hs, hy - hs * 0.8,
      hx + hs, hy,
      hx, hy + hs * 0.7,
    );
    final heartPaint = Paint()
      ..color = const Color(0xFF78350F).withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.024
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(heartPath, heartPaint);

    // Badge 2 : Profil utilisateur (en dessous du badge 1)
    final badge2Rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.74, h * 0.58),
        width: w * 0.22,
        height: w * 0.20,
      ),
      Radius.circular(w * 0.05),
    );
    canvas.drawRRect(badge2Rect, badgeFill);
    canvas.drawRRect(badge2Rect, badgeStroke);

    // Icône profil dans le badge 2
    final px = w * 0.74;
    final py = h * 0.57;
    final userPaint = Paint()
      ..color = const Color(0xFF78350F).withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.024;
    // Tête
    canvas.drawCircle(Offset(px, py - w * 0.025), w * 0.032, userPaint);
    // Buste
    final bustePath = Path()
      ..arcTo(
        Rect.fromCenter(center: Offset(px, py + w * 0.04), width: w * 0.10, height: w * 0.08),
        3.14,
        3.14,
        false,
      );
    canvas.drawPath(bustePath, userPaint);

    // 4. Texte élégant blanc serif 'Ban' et 'App'
    if (showText) {
      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: w * 0.28,
        fontWeight: FontWeight.w900,
        fontFamily: 'serif',
        shadows: [
          Shadow(
            color: const Color(0xFF78350F).withValues(alpha: 0.4),
            offset: Offset(0, w * 0.02),
            blurRadius: w * 0.04,
          ),
        ],
      );

      // 'Ban'
      final banPainter = TextPainter(
        text: TextSpan(text: 'Ban', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      banPainter.paint(canvas, Offset(w * 0.16, h * 0.24));

      // 'App'
      final appPainter = TextPainter(
        text: TextSpan(text: 'App', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      appPainter.paint(canvas, Offset(w * 0.34, h * 0.48));
    }

    // 5. Emblème UNICEF circulaire en bas à droite
    final unicefCenterX = w * 0.82;
    final unicefCenterY = h * 0.82;
    final unicefRadius = w * 0.13;

    final unicefBgPaint = Paint()
      ..color = const Color(0xFFB45309).withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(unicefCenterX, unicefCenterY), unicefRadius, unicefBgPaint);

    final unicefRingPaint = Paint()
      ..color = const Color(0xFFFDE68A).withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.018;
    canvas.drawCircle(Offset(unicefCenterX, unicefCenterY), unicefRadius, unicefRingPaint);

    // Lauriers & Silhouettes stylisés
    final unicefInnerPaint = Paint()
      ..color = const Color(0xFFFEF3C7).withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.016;
    canvas.drawCircle(Offset(unicefCenterX - w * 0.02, unicefCenterY), w * 0.04, unicefInnerPaint);
    canvas.drawCircle(Offset(unicefCenterX + w * 0.02, unicefCenterY - w * 0.01), w * 0.028, unicefInnerPaint);
  }

  @override
  bool shouldRepaint(covariant _BanAppLogoPainter oldDelegate) {
    return oldDelegate.showText != showText;
  }
}
