import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NavsLogo extends StatelessWidget {
  final double size;
  final bool showShadow;

  const NavsLogo({
    super.key,
    this.size = 80,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(size * 0.22),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.35),
                  blurRadius: size * 0.16,
                  offset: Offset(0, size * 0.05),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/images/navs.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return CustomPaint(
            size: Size(size, size),
            painter: _NavsLogoPainter(),
          );
        },
      ),
    );
  }
}

class _NavsLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Outer Background
    final bgPaint = Paint()
      ..color = AppTheme.primary
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), Radius.circular(w * 0.2)),
      bgPaint,
    );

    // Inner White Circle
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final center = Offset(w * 0.5, h * 0.5);
    final radius = w * 0.38;
    canvas.drawCircle(center, radius, whitePaint);

    // Sail & Compass Emblem
    final sailPaint = Paint()
      ..color = AppTheme.primary
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(w * 0.30, h * 0.70);
    path.lineTo(w * 0.74, h * 0.70);
    path.quadraticBezierTo(w * 0.82, h * 0.45, w * 0.50, h * 0.22);
    path.quadraticBezierTo(w * 0.42, h * 0.50, w * 0.30, h * 0.70);
    path.close();

    canvas.drawPath(path, sailPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
