import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Visual assignment status indicator with icon, color, and optional pulse for overdue.
class AssignmentStatusIndicator extends StatefulWidget {
  final AssignmentStatus status;
  final double size;
  final bool showLabel;

  const AssignmentStatusIndicator({
    super.key,
    required this.status,
    this.size = 36,
    this.showLabel = false,
  });

  @override
  State<AssignmentStatusIndicator> createState() =>
      _AssignmentStatusIndicatorState();
}

class _AssignmentStatusIndicatorState extends State<AssignmentStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Only pulse for overdue status
    if (widget.status == AssignmentStatus.overdue) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant AssignmentStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == AssignmentStatus.overdue) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget indicator = AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.status == AssignmentStatus.overdue
              ? _pulseAnim.value
              : 1.0,
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.status.backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          border: Border.all(
            color: widget.status.color.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Icon(
            widget.status.icon,
            size: widget.size * 0.45,
            color: widget.status.color,
          ),
        ),
      ),
    );

    if (widget.showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(width: 8),
          Text(
            widget.status.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: widget.status.color,
            ),
          ),
        ],
      );
    }

    return indicator;
  }
}

enum AssignmentStatus {
  completed,
  pending,
  inProgress,
  overdue;

  IconData get icon {
    switch (this) {
      case AssignmentStatus.completed:
        return Icons.check_rounded;
      case AssignmentStatus.pending:
        return Icons.radio_button_unchecked_rounded;
      case AssignmentStatus.inProgress:
        return Icons.timelapse_rounded;
      case AssignmentStatus.overdue:
        return Icons.priority_high_rounded;
    }
  }

  Color get color {
    switch (this) {
      case AssignmentStatus.completed:
        return AppTheme.success;
      case AssignmentStatus.pending:
        return AppTheme.accent;
      case AssignmentStatus.inProgress:
        return AppTheme.info;
      case AssignmentStatus.overdue:
        return AppTheme.error;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case AssignmentStatus.completed:
        return AppTheme.successSoft;
      case AssignmentStatus.pending:
        return AppTheme.accentSoft;
      case AssignmentStatus.inProgress:
        return AppTheme.infoSoft;
      case AssignmentStatus.overdue:
        return AppTheme.errorSoft;
    }
  }

  String get label {
    switch (this) {
      case AssignmentStatus.completed:
        return 'Completed';
      case AssignmentStatus.pending:
        return 'Pending';
      case AssignmentStatus.inProgress:
        return 'In Progress';
      case AssignmentStatus.overdue:
        return 'Overdue';
    }
  }
}
