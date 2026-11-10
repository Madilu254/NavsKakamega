import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../data/navs_repository.dart';
import '../models/event.dart';
import '../theme/app_theme.dart';
import '../widgets/event_card.dart';
import '../widgets/navskach_background.dart';
import '../widgets/section_header.dart';
import '../widgets/empty_state.dart';
import 'event_detail_screen.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final NavsRepository _repo = NavsRepository();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final venueController = TextEditingController();
    final descController = TextEditingController();
    String category = 'Conference';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.borderLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Post New Event',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Create a new event for the community',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Event Title',
                        hintText: 'e.g. Missions Conference',
                        prefixIcon: Icon(Icons.event_rounded, size: 20),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: subtitleController,
                      decoration: const InputDecoration(
                        labelText: 'Subtitle / Theme',
                        prefixIcon: Icon(Icons.subtitles_rounded, size: 20),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category_rounded, size: 20),
                      ),
                      items: ['Conference', 'Combat', 'Fellowship', 'Outreach']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setSheetState(() => category = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: dateController,
                            decoration: const InputDecoration(
                              labelText: 'Date',
                              hintText: 'Oct 24–26',
                              prefixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: timeController,
                            decoration: const InputDecoration(
                              labelText: 'Time',
                              hintText: '9:00 AM',
                              prefixIcon: Icon(Icons.access_time_rounded, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: venueController,
                      decoration: const InputDecoration(
                        labelText: 'Venue',
                        hintText: 'Kakamega CU Hall',
                        prefixIcon: Icon(Icons.location_on_rounded, size: 20),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Event details and mobilization goal...',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Icon(Icons.description_rounded, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final title = titleController.text.trim();
                              if (title.isEmpty) return;

                              final newEvent = NavsEvent(
                                id: const Uuid().v4(),
                                title: title,
                                subtitle: subtitleController.text.trim(),
                                date: dateController.text.trim().isNotEmpty
                                    ? dateController.text.trim()
                                    : 'Upcoming',
                                time: timeController.text.trim().isNotEmpty
                                    ? timeController.text.trim()
                                    : '9:00 AM',
                                venue: venueController.text.trim().isNotEmpty
                                    ? venueController.text.trim()
                                    : 'Kakamega CU',
                                description: descController.text.trim().isNotEmpty
                                    ? descController.text.trim()
                                    : 'Event details to be announced.',
                                category: category,
                                targetMobilization: 100,
                                rsvps: [_repo.currentUser.id],
                              );

                              _repo.addNewEvent(newEvent);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Event "$title" posted!'),
                                  backgroundColor: AppTheme.primary,
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Post Event'),
                          ),
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    final allEvents = _repo.events;
    final filteredEvents = allEvents.where((e) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Conferences') return e.category.toLowerCase() == 'conference';
      if (_selectedFilter == 'Core Combat') return e.category.toLowerCase() == 'combat';
      if (_selectedFilter == 'Fellowship') return e.category.toLowerCase() == 'fellowship';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.primaryBg,
      floatingActionButton: _repo.isStaff
          ? FloatingActionButton.extended(
              onPressed: _showAddEventDialog,
              icon: const Icon(Icons.add_rounded),
              label: Text('New Event', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.white,
              elevation: 4,
            )
          : null,
      body: NavskachBackground(
        variant: NavskachBgVariant.list,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 8),

            // ═══ STATUS STORIES ═══
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.cardSurface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                boxShadow: AppTheme.subtleShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Ministry Updates',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 88,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        _buildStatusItem(
                          title: 'My Status',
                          subtitle: 'Tap to add',
                          icon: Icons.add_rounded,
                          isMe: true,
                        ),
                        _buildStatusItem(
                          title: 'Missions',
                          subtitle: 'Oct 24–26',
                          icon: Icons.flag_rounded,
                          color: AppTheme.primary,
                        ),
                        _buildStatusItem(
                          title: 'Combat',
                          subtitle: 'Armor of God',
                          icon: Icons.shield_rounded,
                          color: AppTheme.accent,
                        ),
                        _buildStatusItem(
                          title: 'Friday Prep',
                          subtitle: 'Staff notes',
                          icon: Icons.menu_book_rounded,
                          color: AppTheme.staffGold,
                        ),
                        _buildStatusItem(
                          title: 'Weekly Verse',
                          subtitle: '2 Tim 2:2',
                          icon: Icons.auto_stories_rounded,
                          color: AppTheme.info,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ═══ EVENTS SECTION HEADER ═══
            SectionHeader(
              title: 'Events & Mobilization',
              actionText: '${allEvents.length} Total',
              onAction: () {},
            ),

            const SizedBox(height: 4),

            // ═══ FILTER CHIPS ═══
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: ['All', 'Conferences', 'Core Combat', 'Fellowship'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: AnimatedContainer(
                      duration: AppTheme.animFast,
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        selectedColor: AppTheme.primary,
                        labelStyle: GoogleFonts.inter(
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                        backgroundColor: AppTheme.cardSurface,
                        side: BorderSide(
                          color: isSelected ? AppTheme.primary : AppTheme.borderLight,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedFilter = filter);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // ═══ EVENTS LIST ═══
            if (filteredEvents.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                child: EmptyState(
                  icon: Icons.event_busy_rounded,
                  title: 'No Events Found',
                  subtitle: 'No events match your filter. Try selecting a different category.',
                ),
              )
            else
              ...filteredEvents.map((event) {
                final isRsvpd = event.isUserRsvpd(_repo.currentUser.id);
                return EventCard(
                  event: event,
                  isUserRsvpd: isRsvpd,
                  onRsvpToggle: () => _repo.toggleEventRsvp(event.id),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(eventId: event.id),
                      ),
                    );
                  },
                );
              }),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required String title,
    required String subtitle,
    required IconData icon,
    Color color = AppTheme.primary,
    bool isMe = false,
  }) {
    return Container(
      width: 72,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isMe ? AppTheme.borderLight : color,
                width: 2.2,
              ),
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 20),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 9,
              color: AppTheme.textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
