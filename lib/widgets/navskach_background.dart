import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Premium organic background with multi-layer flowing shapes.
/// Wraps content with smooth cubic bezier curves on the Navskach cream base.
/// Inspired by premium app backgrounds with gentle, non-distracting tonal variation.
class NavskachBackground extends StatelessWidget {
  final Widget child;
  final bool showTopShape;
  final bool showBottomShape;
  final bool showMiddleShape;
  final NavskachBgVariant variant;

  const NavskachBackground({
    super.key,
    required this.child,
    this.showTopShape = true,
    this.showBottomShape = true,
    this.showMiddleShape = true,
    this.variant = NavskachBgVariant.home,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primaryBg,
      child: CustomPaint(
        painter: _OrganicBgPainter(
          showTop: showTopShape,
          showBottom: showBottomShape,
          showMiddle: showMiddleShape,
          variant: variant,
        ),
        child: child,
      ),
    );
  }
}

/// Background variants for different screen contexts
enum NavskachBgVariant {
  /// Full organic shapes — used on home/dashboard
  home,
  /// Subtle and minimal — used on detail/form pages
  detail,
  /// Simple top wave only — used for list pages
  list,
}

class _OrganicBgPainter extends CustomPainter {
  final bool showTop;
  final bool showBottom;
  final bool showMiddle;
  final NavskachBgVariant variant;

  _OrganicBgPainter({
    required this.showTop,
    required this.showBottom,
    required this.showMiddle,
    required this.variant,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (variant) {
      case NavskachBgVariant.home:
        _paintHome(canvas, size);
        break;
      case NavskachBgVariant.detail:
        _paintDetail(canvas, size);
        break;
      case NavskachBgVariant.list:
        _paintList(canvas, size);
        break;
    }
  }

  void _paintHome(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Layer 1: Subtle warm gradient wash (full background) ──
    final bgRect = Rect.fromLTWH(0, 0, w, h);
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFECE2D0),  // Slightly lighter at top
          Color(0xFFE0D4BC),  // Standard mid
          Color(0xFFD8CCB6),  // Slightly darker at bottom
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bgRect);
    canvas.drawRect(bgRect, bgPaint);

    // ── Layer 2: Top flowing organic shape — light cream ──
    if (showTop) {
      final topPaint = Paint()
        ..color = AppTheme.bgLight.withValues(alpha: 0.55)
        ..style = PaintingStyle.fill;

      final topPath = Path();
      topPath.moveTo(0, 0);
      topPath.lineTo(w, 0);
      topPath.lineTo(w, h * 0.14);
      topPath.cubicTo(
        w * 0.82, h * 0.20,
        w * 0.60, h * 0.22,
        w * 0.42, h * 0.17,
      );
      topPath.cubicTo(
        w * 0.24, h * 0.12,
        w * 0.10, h * 0.08,
        0, h * 0.13,
      );
      topPath.close();
      canvas.drawPath(topPath, topPaint);

      // Top accent — very faint warm glow
      final topGlow = Paint()
        ..color = AppTheme.bgSoft.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;

      final glowPath = Path();
      glowPath.moveTo(w * 0.3, 0);
      glowPath.lineTo(w, 0);
      glowPath.lineTo(w, h * 0.10);
      glowPath.cubicTo(
        w * 0.85, h * 0.14,
        w * 0.65, h * 0.16,
        w * 0.45, h * 0.12,
      );
      glowPath.cubicTo(
        w * 0.38, h * 0.10,
        w * 0.32, h * 0.06,
        w * 0.3, 0,
      );
      glowPath.close();
      canvas.drawPath(glowPath, topGlow);
    }

    // ── Layer 3: Middle flowing ribbon — warm tone ──
    if (showMiddle) {
      final midPaint = Paint()
        ..color = AppTheme.bgWarm.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill;

      final midPath = Path();
      midPath.moveTo(w, h * 0.32);
      midPath.cubicTo(
        w * 0.78, h * 0.38,
        w * 0.55, h * 0.42,
        w * 0.35, h * 0.37,
      );
      midPath.cubicTo(
        w * 0.15, h * 0.32,
        w * 0.05, h * 0.35,
        0, h * 0.40,
      );
      midPath.lineTo(0, h * 0.52);
      midPath.cubicTo(
        w * 0.12, h * 0.48,
        w * 0.30, h * 0.50,
        w * 0.48, h * 0.53,
      );
      midPath.cubicTo(
        w * 0.68, h * 0.57,
        w * 0.88, h * 0.52,
        w, h * 0.46,
      );
      midPath.close();
      canvas.drawPath(midPath, midPaint);

      // Secondary mid layer — offset for depth
      final mid2Paint = Paint()
        ..color = AppTheme.bgDark.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill;

      final mid2Path = Path();
      mid2Path.moveTo(0, h * 0.44);
      mid2Path.cubicTo(
        w * 0.20, h * 0.40,
        w * 0.42, h * 0.46,
        w * 0.60, h * 0.42,
      );
      mid2Path.cubicTo(
        w * 0.80, h * 0.38,
        w * 0.95, h * 0.43,
        w, h * 0.40,
      );
      mid2Path.lineTo(w, h * 0.50);
      mid2Path.cubicTo(
        w * 0.88, h * 0.54,
        w * 0.65, h * 0.48,
        w * 0.45, h * 0.52,
      );
      mid2Path.cubicTo(
        w * 0.25, h * 0.56,
        w * 0.08, h * 0.50,
        0, h * 0.54,
      );
      mid2Path.close();
      canvas.drawPath(mid2Path, mid2Paint);
    }

    // ── Layer 4: Bottom organic shapes — darker cream ──
    if (showBottom) {
      final bottomPaint = Paint()
        ..color = AppTheme.bgDark.withValues(alpha: 0.30)
        ..style = PaintingStyle.fill;

      final bottomPath = Path();
      bottomPath.moveTo(0, h * 0.76);
      bottomPath.cubicTo(
        w * 0.18, h * 0.72,
        w * 0.38, h * 0.78,
        w * 0.55, h * 0.74,
      );
      bottomPath.cubicTo(
        w * 0.72, h * 0.70,
        w * 0.88, h * 0.76,
        w, h * 0.72,
      );
      bottomPath.lineTo(w, h);
      bottomPath.lineTo(0, h);
      bottomPath.close();
      canvas.drawPath(bottomPath, bottomPaint);

      // Second bottom layer — softer, slightly offset
      final bottom2Paint = Paint()
        ..color = AppTheme.bgSoft.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;

      final bottom2Path = Path();
      bottom2Path.moveTo(0, h * 0.84);
      bottom2Path.cubicTo(
        w * 0.25, h * 0.80,
        w * 0.45, h * 0.86,
        w * 0.62, h * 0.82,
      );
      bottom2Path.cubicTo(
        w * 0.80, h * 0.78,
        w * 0.92, h * 0.84,
        w, h * 0.80,
      );
      bottom2Path.lineTo(w, h);
      bottom2Path.lineTo(0, h);
      bottom2Path.close();
      canvas.drawPath(bottom2Path, bottom2Paint);

      // Warm accent at very bottom
      final bottomAccent = Paint()
        ..color = AppTheme.bgWarm.withValues(alpha: 0.20)
        ..style = PaintingStyle.fill;

      final accentPath = Path();
      accentPath.moveTo(0, h * 0.92);
      accentPath.cubicTo(
        w * 0.30, h * 0.88,
        w * 0.60, h * 0.94,
        w, h * 0.90,
      );
      accentPath.lineTo(w, h);
      accentPath.lineTo(0, h);
      accentPath.close();
      canvas.drawPath(accentPath, bottomAccent);
    }
  }

  void _paintDetail(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Subtle gradient base
    final bgRect = Rect.fromLTWH(0, 0, w, h);
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF2ECE0), Color(0xFFE0D4BC)],
      ).createShader(bgRect);
    canvas.drawRect(bgRect, bgPaint);

    // Single subtle top curve
    if (showTop) {
      final topPaint = Paint()
        ..color = AppTheme.bgLight.withValues(alpha: 0.45)
        ..style = PaintingStyle.fill;

      final topPath = Path();
      topPath.moveTo(0, 0);
      topPath.lineTo(w, 0);
      topPath.lineTo(w, h * 0.08);
      topPath.cubicTo(
        w * 0.75, h * 0.12,
        w * 0.45, h * 0.10,
        0, h * 0.06,
      );
      topPath.close();
      canvas.drawPath(topPath, topPaint);
    }
  }

  void _paintList(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Subtle gradient base
    final bgRect = Rect.fromLTWH(0, 0, w, h);
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFECE2D0), Color(0xFFE0D4BC)],
      ).createShader(bgRect);
    canvas.drawRect(bgRect, bgPaint);

    // Top wave
    if (showTop) {
      final topPaint = Paint()
        ..color = AppTheme.bgLight.withValues(alpha: 0.50)
        ..style = PaintingStyle.fill;

      final topPath = Path();
      topPath.moveTo(0, 0);
      topPath.lineTo(w, 0);
      topPath.lineTo(w, h * 0.12);
      topPath.cubicTo(
        w * 0.80, h * 0.16,
        w * 0.55, h * 0.14,
        w * 0.35, h * 0.10,
      );
      topPath.cubicTo(
        w * 0.18, h * 0.06,
        w * 0.06, h * 0.09,
        0, h * 0.08,
      );
      topPath.close();
      canvas.drawPath(topPath, topPaint);
    }

    // Bottom accent
    if (showBottom) {
      final bottomPaint = Paint()
        ..color = AppTheme.bgDark.withValues(alpha: 0.20)
        ..style = PaintingStyle.fill;

      final bottomPath = Path();
      bottomPath.moveTo(0, h * 0.88);
      bottomPath.cubicTo(
        w * 0.35, h * 0.84,
        w * 0.65, h * 0.90,
        w, h * 0.86,
      );
      bottomPath.lineTo(w, h);
      bottomPath.lineTo(0, h);
      bottomPath.close();
      canvas.drawPath(bottomPath, bottomPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrganicBgPainter old) =>
      showTop != old.showTop ||
      showBottom != old.showBottom ||
      showMiddle != old.showMiddle ||
      variant != old.variant;
}

/// Simpler version for smaller sections — single subtle wave
class NavskachSectionBg extends StatelessWidget {
  final Widget child;
  final Color? baseColor;

  const NavskachSectionBg({super.key, required this.child, this.baseColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SectionWavePainter(baseColor: baseColor ?? AppTheme.bgWarm),
      child: child,
    );
  }
}

class _SectionWavePainter extends CustomPainter {
  final Color baseColor;

  _SectionWavePainter({required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = baseColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.cubicTo(
      size.width * 0.15, size.height * 0.18,
      size.width * 0.35, size.height * 0.22,
      size.width * 0.5, size.height * 0.25,
    );
    path.cubicTo(
      size.width * 0.65, size.height * 0.28,
      size.width * 0.85, size.height * 0.35,
      size.width, size.height * 0.2,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SectionWavePainter old) =>
      baseColor != old.baseColor;
}
