import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/navs_repository.dart';
import '../models/member.dart';
import '../theme/app_theme.dart';
import '../widgets/navskach_background.dart';
import '../widgets/attendance_gauge.dart';

class BibleStudyPage extends StatefulWidget {
  const BibleStudyPage({super.key});

  @override
  State<BibleStudyPage> createState() => _BibleStudyPageState();
}

class _BibleStudyPageState extends State<BibleStudyPage> with SingleTickerProviderStateMixin {
  final NavsRepository _repo = NavsRepository();
  late TabController _tabController;

  static const String currentSessionId = 'sat_bs_session_current';
  static const String currentSessionName = 'Saturday Bible Study (9:00 AM – 12:00 PM)';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = _repo.currentUser;
    final isStaff = _repo.isStaff;
    final students = _repo.members.where((m) => !m.isStaff).toList();
    final hasAttended = _repo.hasCurrentUserAttendedSession(currentSessionId);
    final presentMembers = _repo.getPresentMembersForSession(currentSessionId);
    final absentMembers = _repo.getAbsentMembersForSession(currentSessionId);

    // Calculate group average rate
    final avgAttendance = students.isEmpty
        ? 85
        : ((students.fold<int>(0, (sum, m) => sum + m.attendedSessions) /
                    (students.length * (students.first.totalSessions > 0 ? students.first.totalSessions : 8))) *
                100)
            .round();

    return Scaffold(
      backgroundColor: AppTheme.primaryBg,
      body: NavskachBackground(
        variant: NavskachBgVariant.list,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ═══ APP BAR ═══
            SliverAppBar(
              backgroundColor: AppTheme.primaryBg,
              elevation: 0,
              scrolledUnderElevation: 0,
              floating: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bible Study & Attendance',
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    isStaff ? 'Saturday roll call & session oversight' : 'Track your consistency streak',
                    style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ],
              ),
              actions: [
                if (isStaff) ...[
                  TextButton.icon(
                    onPressed: () => _showRecordSessionModal(context, students),
                    icon: const Icon(Icons.playlist_add_check_rounded, size: 18, color: AppTheme.primary),
                    label: Text(
                      'Roll Call',
                      style: GoogleFonts.inter(color: AppTheme.primary, fontWeight: FontWeight.w700),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.primarySoft,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ],
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ═══ HERO BANNER ═══
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primary,
                          AppTheme.primary.withValues(alpha: 0.85),
                          const Color(0xFF006040),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.warning,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'WEEKLY ACTIVITY',
                                style: GoogleFonts.inter(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.schedule_rounded, size: 13, color: Colors.white70),
                                const SizedBox(width: 4),
                                Text(
                                  'Sat 9 AM – 12 PM',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Saturday Bible Study',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '2 Timothy 2:2 • The Multiplication of Disciples\nJoin fellow students for breakouts and scripture discussion.',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Check-In Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: hasAttended
                                ? null
                                : () {
                                    _repo.markAttendanceForSession(
                                      sessionId: currentSessionId,
                                      sessionName: currentSessionName,
                                      sessionType: 'Bible Study',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Attendance recorded! Streak updated.'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                            icon: Icon(
                              hasAttended ? Icons.check_circle_rounded : Icons.how_to_reg_rounded,
                              size: 18,
                            ),
                            label: Text(
                              hasAttended ? 'Checked In ✓' : 'Mark My Attendance',
                              style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hasAttended ? AppTheme.success : AppTheme.warning,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              ),
                              disabledBackgroundColor: AppTheme.success.withValues(alpha: 0.8),
                              disabledForegroundColor: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ═══ FRIDAY PREP CARD ═══
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardSurface,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      boxShadow: AppTheme.subtleShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: AppTheme.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.groups_rounded, color: AppTheme.accent, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Friday Staff Preparatory',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Every Friday • 5:00 PM – 7:00 PM\nReview assignments & mobilization',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: AppTheme.textMuted,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ═══ STATS ROW ═══
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          label: 'Total Sessions',
                          value: '${user.totalSessions}',
                          icon: Icons.calendar_month_rounded,
                          color: AppTheme.info,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildMetricTile(
                          label: 'Avg Attendance',
                          value: '$avgAttendance%',
                          icon: Icons.trending_up_rounded,
                          color: AppTheme.success,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildMetricTile(
                          label: 'Students',
                          value: '${students.length}',
                          icon: Icons.people_outline_rounded,
                          color: AppTheme.accent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ═══ ATTENDANCE GAUGE ═══
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardSurface,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      boxShadow: AppTheme.subtleShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Attendance Frequency',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AttendanceGauge(
                          percentage: user.attendancePercentage,
                          attended: user.attendedSessions,
                          total: user.totalSessions,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ═══ STUDENT LEADERBOARD ═══
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardSurface,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      boxShadow: AppTheme.subtleShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Student Attendance',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                '${students.length} students',
                                style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: AppTheme.divider),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: students.length,
                          separatorBuilder: (_, _) => const Divider(height: 1, indent: 56, color: AppTheme.divider),
                          itemBuilder: (context, index) {
                            final s = students[index];
                            final pct = s.attendancePercentage;
                            final rateColor = pct >= 80
                                ? AppTheme.success
                                : (pct >= 60 ? AppTheme.warning : AppTheme.error);

                            return ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor: rateColor.withValues(alpha: 0.12),
                                child: Text(
                                  s.firstName.isNotEmpty ? s.firstName[0] : 'S',
                                  style: GoogleFonts.inter(
                                    color: rateColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              title: Text(
                                s.fullName,
                                style: GoogleFonts.inter(
                                  color: AppTheme.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct / 100,
                                  minHeight: 4,
                                  backgroundColor: AppTheme.borderLight,
                                  valueColor: AlwaysStoppedAnimation<Color>(rateColor),
                                ),
                              ),
                              trailing: Text(
                                '$pct%',
                                style: GoogleFonts.inter(
                                  color: rateColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ═══ ROLL CALL ═══
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardSurface,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      boxShadow: AppTheme.subtleShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Session Roll Call',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.success.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${presentMembers.length} Present',
                                  style: GoogleFonts.inter(
                                    color: AppTheme.success,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TabBar(
                          controller: _tabController,
                          labelColor: AppTheme.primary,
                          unselectedLabelColor: AppTheme.textMuted,
                          indicatorColor: AppTheme.primary,
                          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12.5),
                          unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12.5),
                          tabs: [
                            Tab(text: 'Present (${presentMembers.length})'),
                            Tab(text: 'Absent (${absentMembers.length})'),
                          ],
                        ),
                        SizedBox(
                          height: 240,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Present List
                              presentMembers.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No check-ins recorded yet.',
                                        style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 13),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: presentMembers.length,
                                      itemBuilder: (context, index) {
                                        final m = presentMembers[index];
                                        return ListTile(
                                          dense: true,
                                          leading: const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 20),
                                          title: Text(
                                            m.fullName,
                                            style: GoogleFonts.inter(
                                              color: AppTheme.textPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            m.role,
                                            style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 11),
                                          ),
                                        );
                                      },
                                    ),

                              // Absent List
                              absentMembers.isEmpty
                                  ? Center(
                                      child: Text(
                                        'All members present! 🎉',
                                        style: GoogleFonts.inter(color: AppTheme.success, fontSize: 13),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: absentMembers.length,
                                      itemBuilder: (context, index) {
                                        final m = absentMembers[index];
                                        return ListTile(
                                          dense: true,
                                          leading: const Icon(Icons.cancel_rounded, color: AppTheme.error, size: 20),
                                          title: Text(
                                            m.fullName,
                                            style: GoogleFonts.inter(
                                              color: AppTheme.textPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            m.phone,
                                            style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 11),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppTheme.info, size: 18),
                                            tooltip: 'Mobilize member',
                                            onPressed: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Reminder sent to ${m.firstName}!'),
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showRecordSessionModal(BuildContext context, List<Member> students) {
    final Set<String> presentIds = {};
    final dateCtrl = TextEditingController(text: DateTime.now().toIso8601String().split('T').first);
    final notesCtrl = TextEditingController(text: 'Saturday study on 2 Timothy 2:2');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Record Roll Call',
                      style: GoogleFonts.inter(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppTheme.textMuted),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const Divider(color: AppTheme.divider),

                // Date & Notes
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dateCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          prefixIcon: Icon(Icons.calendar_today_rounded, size: 16),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: notesCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Session Notes',
                          prefixIcon: Icon(Icons.notes_rounded, size: 16),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tap to toggle (${presentIds.length}/${students.length})',
                      style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 11),
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          if (presentIds.length == students.length) {
                            presentIds.clear();
                          } else {
                            presentIds.addAll(students.map((s) => s.id));
                          }
                        });
                      },
                      child: Text(
                        presentIds.length == students.length ? 'Clear All' : 'Select All',
                        style: GoogleFonts.inter(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                // Student checklist
                Expanded(
                  child: ListView.separated(
                    itemCount: students.length,
                    separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.divider),
                    itemBuilder: (context, index) {
                      final s = students[index];
                      final isPresent = presentIds.contains(s.id);

                      return CheckboxListTile(
                        value: isPresent,
                        activeColor: AppTheme.success,
                        checkColor: Colors.white,
                        title: Text(
                          s.fullName,
                          style: GoogleFonts.inter(
                            color: AppTheme.textPrimary,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          s.phone,
                          style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 11),
                        ),
                        onChanged: (val) {
                          setModalState(() {
                            if (val == true) {
                              presentIds.add(s.id);
                            } else {
                              presentIds.remove(s.id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save_rounded, size: 18),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                    ),
                    onPressed: () {
                      final sessionId = 'sat_bs_${DateTime.now().millisecondsSinceEpoch}';
                      _repo.recordSessionAttendance(
                        sessionId: sessionId,
                        sessionName: currentSessionName,
                        date: dateCtrl.text.trim(),
                        presentMemberIds: presentIds,
                        notes: notesCtrl.text.trim(),
                      );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Saved! ${presentIds.length} members marked present.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    label: Text(
                      'Save Session Roll Call',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
