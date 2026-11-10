import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Premium white card with subtle shadow, touch feedback, and press animation.
class NavskachCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool elevated;

  const NavskachCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.onTap,
    this.elevated = false,
  });

  @override
  State<NavskachCard> createState() => _NavskachCardState();
}

class _NavskachCardState extends State<NavskachCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppTheme.animFast,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppTheme.radiusLg;

    Widget card = AnimatedContainer(
      duration: AppTheme.animFast,
      padding: widget.padding ?? const EdgeInsets.all(AppTheme.spacingMd),
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.color ?? AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: widget.elevated ? AppTheme.elevatedShadow : AppTheme.cardShadow,
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnim,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnim.value,
              child: child,
            );
          },
          child: card,
        ),
      );
    }

    return card;
  }
}
