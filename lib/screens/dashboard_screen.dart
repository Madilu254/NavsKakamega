import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/navs_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/navskach_background.dart';
import '../widgets/navskach_card.dart';
import '../widgets/section_header.dart';
import '../widgets/assignment_status_indicator.dart';
import '../widgets/event_carousel.dart';
import '../widgets/resource_carousel.dart';
import '../widgets/conversation_starter_card.dart';
import 'assignment_form_screen.dart';
import 'bible_reader_screen.dart';
import 'event_detail_screen.dart';
import 'scripture_tms_screen.dart';
import 'staff_review_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const DashboardScreen({super.key, this.onNavigateTab});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final repo = NavsRepository();

    return ListenableBuilder(
      listenable: repo,
      builder: (context, _) {
        final user = repo.currentUser;
        final isStaff = user.isStaff;
        final students = repo.members.where((m) => !m.isStaff).toList();
        final assignments = repo.assignments;
        final events = repo.events;
        final tmsVerses = repo.tmsVerses;

        final memorizedCount = repo.currentUserMemorizedCount;
        final pendingAssignmentsCount = assignments.where((a) {
          final sub = repo.getSubmissionForAssignment(a.id);
          return sub == null;
        }).length;

        final attendanceRate = students.isEmpty
            ? 85
            : ((students.fold<int>(0, (sum, m) => sum + m.attendedSessions) /
                        (students.length * (students.first.totalSessions > 0 ? students.first.totalSessions : 8))) *
                    100)
                .round();

        return Scaffold(
          backgroundColor: AppTheme.primaryBg,
          body: NavskachBackground(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Warm App Bar
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  floating: true,
                  pinned: false,
                  elevation: 0,
                  toolbarHeight: 60,
                  title: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/navs.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.menu_book, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Navskach',
                            style: GoogleFonts.inter(
                              color: AppTheme.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            'Kakamega Chapter',
                            style: GoogleFonts.inter(
                              color: AppTheme.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    // Role Badge
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isStaff
                            ? AppTheme.staffGold.withValues(alpha: 0.15)
                            : AppTheme.primarySoft,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        border: Border.all(
                          color: isStaff
                              ? AppTheme.staffGold.withValues(alpha: 0.4)
                              : AppTheme.primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 3.5,
                            backgroundColor: isStaff ? AppTheme.staffGold : AppTheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isStaff ? 'Staff' : 'Student',
                            style: GoogleFonts.inter(
                              color: isStaff ? AppTheme.staffGold : AppTheme.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.sync_alt_rounded, color: AppTheme.textMuted, size: 20),
                      tooltip: 'Switch Role',
                      onPressed: () {
                        final newRole = isStaff ? 'Student' : 'Staff';
                        repo.switchRole(newRole);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Switched to $newRole mode'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),

                      // ═══ HERO / WELCOME CARD ═══
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildHeroCard(context, user.firstName, isStaff),
                      ),

                      const SizedBox(height: 20),

                      // ═══ STATS GRID ═══
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildStatsGrid(
                          isStaff: isStaff,
                          totalStudents: students.length,
                          attendanceRate: attendanceRate,
                          openAssignments: assignments.length,
                          upcomingEvents: events.length,
                          memorizedVerses: memorizedCount,
                          totalVerses: tmsVerses.length,
                          pendingAssignments: pendingAssignmentsCount,
                          attendedSessions: user.attendedSessions,
                          totalSessions: user.totalSessions,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ═══ QUICK SHORTCUTS ═══
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildQuickShortcuts(context),
                      ),

                      const SizedBox(height: 26),

                      // ═══ UPCOMING EVENTS (CAROUSEL) ═══
                      SectionHeader(
                        title: 'Upcoming Events',
                        actionText: 'View All',
                        actionIcon: Icons.arrow_forward_ios_rounded,
                        onAction: () => onNavigateTab?.call(4),
                      ),
                      const SizedBox(height: 4),
                      EventCarousel(
                        events: events,
                        currentUserId: user.id,
                        onEventTap: (event) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EventDetailScreen(eventId: event.id),
                            ),
                          );
                        },
                        onRsvpToggle: (event) => repo.toggleEventRsvp(event.id),
                      ),

                      const SizedBox(height: 26),

                      // ═══ RECENT ASSIGNMENTS ═══
                      SectionHeader(
                        title: 'Recent Assignments',
                        actionText: 'View All',
                        actionIcon: Icons.arrow_forward_ios_rounded,
                        onAction: () => onNavigateTab?.call(3),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildRecentAssignments(context, repo, isStaff),
                      ),

                      const SizedBox(height: 26),

                      // ═══ RECOMMENDED RESOURCES ═══
                      SectionHeader(
                        title: 'Recommended Resources',
                        actionText: 'Explore',
                        actionIcon: Icons.arrow_forward_ios_rounded,
                        onAction: () {},
                      ),
                      const SizedBox(height: 4),
                      _buildResourcesSection(),

                      const SizedBox(height: 26),

                      // ═══ CONVERSATION STARTERS ═══
                      SectionHeader(
                        title: 'Conversation Starters',
                        actionText: 'More',
                        actionIcon: Icons.arrow_forward_ios_rounded,
                        onAction: () => onNavigateTab?.call(1),
                      ),
                      const SizedBox(height: 4),
                      _buildConversationStarters(context),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HERO WELCOME CARD
  // ═══════════════════════════════════════════════════════════════
  Widget _buildHeroCard(BuildContext context, String firstName, bool isStaff) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00694A), Color(0xFF008250), Color(0xFF00A86B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getGreeting()},',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$firstName 👋',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      firstName.isNotEmpty ? firstName[0] : 'N',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              isStaff
                  ? 'You have pastoral oversight of Navigators Kakamega Bible Study. Review assignments and mobilize disciples.'
                  : 'Welcome to Navigators Kakamega. Keep growing in faith and the Word!',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 12.5, height: 1.4),
            ),
            const SizedBox(height: 16),

            // Verse of the Day
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wb_sunny_outlined, color: AppTheme.staffGold, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'VERSE OF THE DAY',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '"Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight."',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '— Proverbs 3:5-6',
                      style: GoogleFonts.inter(color: AppTheme.staffGold, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // STATS GRID
  // ═══════════════════════════════════════════════════════════════
  Widget _buildStatsGrid({
    required bool isStaff,
    required int totalStudents,
    required int attendanceRate,
    required int openAssignments,
    required int upcomingEvents,
    required int memorizedVerses,
    required int totalVerses,
    required int pendingAssignments,
    required int attendedSessions,
    required int totalSessions,
  }) {
    final stats = isStaff
        ? [
            {'title': 'Total Students', 'value': '$totalStudents', 'sub': '$totalStudents registered', 'icon': Icons.people_alt_outlined, 'color': AppTheme.info},
            {'title': 'Attendance Rate', 'value': '$attendanceRate%', 'sub': 'Saturday sessions', 'icon': Icons.check_box_outlined, 'color': AppTheme.primary},
            {'title': 'Assignments', 'value': '$openAssignments', 'sub': 'Weekly tasks', 'icon': Icons.assignment_outlined, 'color': AppTheme.warning},
            {'title': 'Events', 'value': '$upcomingEvents', 'sub': 'Next 30 days', 'icon': Icons.calendar_month_outlined, 'color': AppTheme.accent},
          ]
        : [
            {'title': 'TMS Memorized', 'value': '$memorizedVerses', 'sub': 'of $totalVerses total verses', 'icon': Icons.star_outline_rounded, 'color': AppTheme.warning},
            {'title': 'Pending Work', 'value': '$pendingAssignments', 'sub': pendingAssignments == 0 ? 'All caught up!' : 'Due this week', 'icon': Icons.edit_note_outlined, 'color': AppTheme.accent},
            {'title': 'Attendance', 'value': '$attendedSessions', 'sub': 'of $totalSessions sessions', 'icon': Icons.check_circle_outline_rounded, 'color': AppTheme.primary},
            {'title': 'Events', 'value': '$upcomingEvents', 'sub': 'Upcoming gatherings', 'icon': Icons.event_available_outlined, 'color': AppTheme.info},
          ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.50,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final item = stats[index];
        final color = item['color'] as Color;
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.cardSurface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            boxShadow: AppTheme.subtleShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['title'] as String,
                      style: GoogleFonts.inter(
                        color: AppTheme.textMuted,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Icon(item['icon'] as IconData, size: 16, color: color),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['value'] as String,
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['sub'] as String,
                    style: GoogleFonts.inter(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // QUICK SHORTCUTS
  // ═══════════════════════════════════════════════════════════════
  Widget _buildQuickShortcuts(BuildContext context) {
    final shortcuts = [
      {
        'title': 'TMS Memory',
        'icon': Icons.star_rounded,
        'color': AppTheme.warning,
        'action': () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ScriptureTMSScreen()));
        },
      },
      {
        'title': 'Bible Reader',
        'icon': Icons.menu_book_rounded,
        'color': AppTheme.info,
        'action': () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const BibleReaderScreen()));
        },
      },
      {
        'title': 'Chats',
        'icon': Icons.chat_bubble_outline_rounded,
        'color': AppTheme.onlineGreen,
        'action': () => onNavigateTab?.call(1),
      },
      {
        'title': 'Attendance',
        'icon': Icons.how_to_reg_outlined,
        'color': AppTheme.primary,
        'action': () => onNavigateTab?.call(2),
      },
    ];

    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: shortcuts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final s = shortcuts[index];
          final color = s['color'] as Color;
          return InkWell(
            onTap: s['action'] as VoidCallback,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            child: Container(
              width: 110,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.cardSurface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                boxShadow: AppTheme.subtleShadow,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Icon(s['icon'] as IconData, color: color, size: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    s['title'] as String,
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // RECENT ASSIGNMENTS (with status indicators)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildRecentAssignments(BuildContext context, NavsRepository repo, bool isStaff) {
    final assignments = repo.assignments.take(3).toList();

    return NavskachCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          if (assignments.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No assignments posted yet.',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: assignments.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16, color: AppTheme.divider),
              itemBuilder: (context, index) {
                final a = assignments[index];
                final sub = repo.getSubmissionForAssignment(a.id);
                final isDone = sub != null;

                // Determine status
                final status = isDone
                    ? AssignmentStatus.completed
                    : AssignmentStatus.pending;

                return InkWell(
                  onTap: () {
                    if (isStaff) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => StaffReviewScreen(initialAssignmentId: a.id)));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => AssignmentFormScreen(assignment: a)));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        // Status Indicator
                        AssignmentStatusIndicator(status: status),
                        const SizedBox(width: 12),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.title,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(Icons.schedule, size: 12, color: AppTheme.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Due ${a.dueDate}',
                                    style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 11.5),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(a.type).withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      a.type,
                                      style: GoogleFonts.inter(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700,
                                        color: _getTypeColor(a.type),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Trailing status / staff info
                        if (isStaff)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primarySoft,
                              borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                            ),
                            child: Text(
                              '${repo.getAllSubmissionsForAssignment(a.id).length} in',
                              style: GoogleFonts.inter(
                                color: AppTheme.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        else
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 20,
                            color: AppTheme.textLight,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // RECOMMENDED RESOURCES
  // ═══════════════════════════════════════════════════════════════
  Widget _buildResourcesSection() {
    final resources = [
      ResourceItem(
        title: 'Quiet Time Guide',
        type: 'Devotional',
        accentColor: AppTheme.primary,
        icon: Icons.menu_book_rounded,
        imageAsset: 'assets/images/bible.jpg',
      ),
      ResourceItem(
        title: 'Fellowship & Community',
        type: 'Guide',
        accentColor: AppTheme.accent,
        icon: Icons.groups_rounded,
        imageAsset: 'assets/images/fellowship.jpg',
      ),
      ResourceItem(
        title: 'Scripture Memory System',
        type: 'Tool',
        accentColor: AppTheme.warning,
        icon: Icons.star_rounded,
      ),
      ResourceItem(
        title: 'Prayer Journal',
        type: 'Template',
        accentColor: AppTheme.info,
        icon: Icons.edit_note_rounded,
      ),
    ];

    return ResourceCarousel(items: resources);
  }

  // ═══════════════════════════════════════════════════════════════
  // CONVERSATION STARTERS
  // ═══════════════════════════════════════════════════════════════
  Widget _buildConversationStarters(BuildContext context) {
    final starters = [
      {'q': 'What has God been teaching you this week through His Word?', 'cat': 'Growth'},
      {'q': 'How can we better support and encourage one another in our walk?', 'cat': 'Fellowship'},
      {'q': 'Share a verse that has been especially meaningful to you lately.', 'cat': 'Scripture'},
      {'q': 'What area of your life are you trusting God in right now?', 'cat': 'Faith'},
    ];

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: starters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final s = starters[index];
          return ConversationStarterCard(
            question: s['q']!,
            category: s['cat'],
            onTap: () => onNavigateTab?.call(1),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'reading':
        return AppTheme.info;
      case 'memorization':
        return AppTheme.warning;
      case 'reflection':
        return AppTheme.accent;
      case 'practice':
        return AppTheme.primary;
      default:
        return AppTheme.info;
    }
  }
}
