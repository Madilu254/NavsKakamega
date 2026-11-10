import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event.dart';
import '../theme/app_theme.dart';

/// Interactive, swipeable event carousel with snap behavior and page indicators.
class EventCarousel extends StatefulWidget {
  final List<NavsEvent> events;
  final String currentUserId;
  final void Function(NavsEvent event) onEventTap;
  final void Function(NavsEvent event) onRsvpToggle;
  final double height;

  const EventCarousel({
    super.key,
    required this.events,
    required this.currentUserId,
    required this.onEventTap,
    required this.onRsvpToggle,
    this.height = 210,
  });

  @override
  State<EventCarousel> createState() => _EventCarouselState();
}

class _EventCarouselState extends State<EventCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'conference':
        return AppTheme.primary;
      case 'combat':
        return AppTheme.accent;
      case 'fellowship':
        return AppTheme.warning;
      case 'outreach':
        return AppTheme.info;
      default:
        return AppTheme.primaryMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.events.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            'No upcoming events',
            style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: widget.events.length,
            itemBuilder: (context, index) {
              final event = widget.events[index];
              final catColor = _categoryColor(event.category);
              final isRsvpd = event.isUserRsvpd(widget.currentUserId);
              final progress = event.mobilizationProgress;
              final progressPct = (progress * 100).toInt();

              return AnimatedContainer(
                duration: AppTheme.animNormal,
                margin: EdgeInsets.only(
                  left: index == 0 ? 4 : 6,
                  right: index == widget.events.length - 1 ? 4 : 6,
                  top: 4,
                  bottom: 8,
                ),
                child: GestureDetector(
                  onTap: () => widget.onEventTap(event),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardSurface,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Colored top accent strip
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: catColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(AppTheme.radiusLg),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category + Date Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: catColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                                      ),
                                      child: Text(
                                        event.category.toUpperCase(),
                                        style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: catColor,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      event.date,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Title
                                Text(
                                  event.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  event.subtitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const Spacer(),

                                // Venue + Time
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.textMuted),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        event.venue,
                                        style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.access_time_rounded, size: 13, color: AppTheme.textMuted),
                                    const SizedBox(width: 3),
                                    Text(
                                      event.time,
                                      style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Progress bar + RSVP
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${event.rsvpCount}/${event.targetMobilization}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '$progressPct%',
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: catColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(3),
                                            child: LinearProgressIndicator(
                                              value: progress,
                                              minHeight: 4,
                                              backgroundColor: AppTheme.borderLight,
                                              valueColor: AlwaysStoppedAnimation<Color>(catColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () => widget.onRsvpToggle(event),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isRsvpd ? AppTheme.primary : AppTheme.accent,
                                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                                        ),
                                        child: Text(
                                          isRsvpd ? '✓ Going' : 'RSVP',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Page Indicators
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.events.length, (index) {
            final isActive = index == _currentPage;
            return AnimatedContainer(
              duration: AppTheme.animFast,
              width: isActive ? 20 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.accent : AppTheme.borderLight,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
