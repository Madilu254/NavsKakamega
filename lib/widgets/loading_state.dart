import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shimmer-like loading placeholder with gradient sweep animation.
class LoadingState extends StatefulWidget {
  final int itemCount;
  final double itemHeight;
  final bool isCard;

  const LoadingState({
    super.key,
    this.itemCount = 3,
    this.itemHeight = 80,
    this.isCard = true,
  });

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (context, child) {
        return Column(
          children: List.generate(widget.itemCount, (index) {
            return Container(
              height: widget.itemHeight,
              margin: EdgeInsets.only(
                bottom: AppTheme.spacingSm,
                left: widget.isCard ? AppTheme.spacingMd : 0,
                right: widget.isCard ? AppTheme.spacingMd : 0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  widget.isCard ? AppTheme.radiusLg : AppTheme.radiusSm,
                ),
                gradient: LinearGradient(
                  begin: Alignment(_shimmerAnim.value - 1, 0),
                  end: Alignment(_shimmerAnim.value, 0),
                  colors: [
                    AppTheme.bgWarm.withValues(alpha: 0.4),
                    AppTheme.bgSoft.withValues(alpha: 0.8),
                    AppTheme.bgWarm.withValues(alpha: 0.4),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Row(
                  children: [
                    // Shimmer avatar/icon placeholder
                    Container(
                      width: widget.itemHeight * 0.55,
                      height: widget.itemHeight * 0.55,
                      decoration: BoxDecoration(
                        color: AppTheme.bgDark.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    // Shimmer text lines
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 12,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppTheme.bgDark.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 10,
                            width: 120,
                            decoration: BoxDecoration(
                              color: AppTheme.bgDark.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
