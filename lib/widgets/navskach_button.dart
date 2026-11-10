import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Premium Navskach button with multiple variants, loading state,
/// and micro-interaction press feedback.
class NavskachButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final NavskachButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const NavskachButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = NavskachButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.height,
    this.padding,
  });

  @override
  State<NavskachButton> createState() => _NavskachButtonState();
}

enum NavskachButtonVariant {
  primary,    // Green filled
  accent,     // Orange gradient
  secondary,  // Outlined green
  ghost,      // Text only
  danger,     // Error/destructive
}

class _NavskachButtonState extends State<NavskachButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: AppTheme.animFast,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final height = widget.height ?? 50.0;

    return GestureDetector(
      onTapDown: _isEnabled ? (_) => _scaleController.forward() : null,
      onTapUp: _isEnabled ? (_) => _scaleController.reverse() : null,
      onTapCancel: _isEnabled ? () => _scaleController.reverse() : null,
      onTap: _isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          );
        },
        child: AnimatedOpacity(
          duration: AppTheme.animFast,
          opacity: _isEnabled ? 1.0 : 0.5,
          child: Container(
            height: height,
            width: widget.isFullWidth ? double.infinity : null,
            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24),
            decoration: _buildDecoration(),
            child: Row(
              mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading) ...[
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(_foregroundColor),
                    ),
                  ),
                  const SizedBox(width: 10),
                ] else if (widget.icon != null) ...[
                  Icon(widget.icon, size: 18, color: _foregroundColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.isLoading ? 'Please wait...' : widget.label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _foregroundColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    switch (widget.variant) {
      case NavskachButtonVariant.primary:
        return BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          boxShadow: _isEnabled ? AppTheme.glowShadow : null,
        );
      case NavskachButtonVariant.accent:
        return BoxDecoration(
          gradient: AppTheme.accentGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          boxShadow: _isEnabled ? AppTheme.accentGlowShadow : null,
        );
      case NavskachButtonVariant.secondary:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: AppTheme.primary, width: 1.5),
        );
      case NavskachButtonVariant.ghost:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        );
      case NavskachButtonVariant.danger:
        return BoxDecoration(
          color: AppTheme.error,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        );
    }
  }

  Color get _foregroundColor {
    switch (widget.variant) {
      case NavskachButtonVariant.primary:
      case NavskachButtonVariant.accent:
      case NavskachButtonVariant.danger:
        return Colors.white;
      case NavskachButtonVariant.secondary:
        return AppTheme.primary;
      case NavskachButtonVariant.ghost:
        return AppTheme.accent;
    }
  }
}
