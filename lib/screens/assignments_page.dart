import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/navs_repository.dart';
import '../models/assignment.dart';
import '../theme/app_theme.dart';
import '../widgets/navskach_background.dart';
import '../widgets/section_header.dart';
import '../widgets/empty_state.dart';
import 'assignment_form_screen.dart';
import 'staff_review_screen.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  final NavsRepository _repo = NavsRepository();
  String _studentFilter = 'all'; // all, pending, completed

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

  @override
  Widget build(BuildContext context) {
    final assignments = _repo.assignments;
    final isStaff = _repo.isStaff;
    final students = _repo.members.where((m) => !m.isStaff).toList();

    // Filter assignments for students
    final filteredAssignments = assignments.where((a) {
      if (isStaff) return true;
      final sub = _repo.getSubmissionForAssignment(a.id);
      final isDone = sub != null;
      if (_studentFilter == 'pending') return !isDone;
      if (_studentFilter == 'completed') return isDone;
      return true;
    }).toList();

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
                    'Assignments',
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    isStaff ? 'Manage & track student progress' : 'Your weekly readings & tasks',
                    style: GoogleFonts.inter(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              actions: [
                if (isStaff) ...[
                  TextButton.icon(
                    onPressed: () => _showCreateAssignmentDialog(context),
                    icon: const Icon(Icons.add_rounded, size: 18, color: AppTheme.primary),
                    label: Text(
                      'New',
                      style: GoogleFonts.inter(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
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
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.warning,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'REALTIME DISCIPLINE',
                                style: GoogleFonts.inter(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isStaff ? 'Staff Review' : 'Student Mode',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Weekly Bible Study Assignments',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Answers submitted on phones sync immediately to staff review.',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 12.5,
                            height: 1.4,
                          ),
                        ),
                        if (isStaff) ...[
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const StaffReviewScreen()),
                                );
                              },
                              icon: const Icon(Icons.analytics_outlined, size: 18),
                              label: Text(
                                'Open Staff Review Portal',
                                style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.warning,
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ═══ STUDENT FILTER CHIPS ═══
                  if (!isStaff) ...[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('all', 'All (${assignments.length})'),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            'pending',
                            'Pending (${assignments.where((a) => _repo.getSubmissionForAssignment(a.id) == null).length})',
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            'completed',
                            'Completed (${assignments.where((a) => _repo.getSubmissionForAssignment(a.id) != null).length})',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ═══ SECTION HEADER ═══
                  SectionHeader(
                    title: isStaff ? 'All Assignments' : 'Your Tasks',
                    actionText: '${filteredAssignments.length} items',
                    onAction: () {},
                  ),
                  const SizedBox(height: 8),

                  // ═══ ASSIGNMENT CARDS ═══
                  if (filteredAssignments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: EmptyState(
                        icon: Icons.assignment_turned_in_rounded,
                        title: 'No Assignments',
                        subtitle: 'No assignments match your filter.',
                      ),
                    )
                  else
                    ...filteredAssignments.map((a) => _buildAssignmentCard(a, isStaff, students)),

                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(Assignment a, bool isStaff, List students) {
    final sub = _repo.getSubmissionForAssignment(a.id);
    final isDone = sub != null;
    final subsCount = _repo.getAllSubmissionsForAssignment(a.id).length;
    final completionRate = students.isEmpty ? 0 : ((subsCount / students.length) * 100).round();
    final typeColor = _getTypeColor(a.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (isStaff) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StaffReviewScreen(initialAssignmentId: a.id)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AssignmentFormScreen(assignment: a)),
            );
          }
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardSurface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(
              color: isDone
                  ? AppTheme.success.withValues(alpha: 0.3)
                  : AppTheme.borderLight,
              width: isDone ? 1.2 : 0.8,
            ),
            boxShadow: AppTheme.subtleShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Icon(_getTypeIcon(a.type), color: typeColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.title,
                          style: GoogleFonts.inter(
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          a.instructions,
                          style: GoogleFonts.inter(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                            height: 1.35,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      a.type.toUpperCase(),
                      style: GoogleFonts.inter(
                        color: typeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.schedule_rounded, size: 12, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    'Due ${a.dueDate}',
                    style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 11),
                  ),
                  const Spacer(),
                  if (isStaff) ...[
                    Text(
                      '$subsCount/${students.length} submitted',
                      style: GoogleFonts.inter(
                        color: AppTheme.success,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppTheme.success.withValues(alpha: 0.12)
                            : AppTheme.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isDone ? Icons.check_circle_rounded : Icons.schedule_rounded,
                            size: 13,
                            color: isDone ? AppTheme.success : AppTheme.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isDone ? 'Done' : 'Pending',
                            style: GoogleFonts.inter(
                              color: isDone ? AppTheme.success : AppTheme.warning,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),

              if (isStaff) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: students.isEmpty ? 0 : subsCount / students.length,
                    minHeight: 5,
                    backgroundColor: AppTheme.borderLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.success),
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$completionRate% class completion',
                    style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 10),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _studentFilter == value;
    return ChoiceChip(
      selected: isSelected,
      label: Text(
        label,
        style: GoogleFonts.inter(
          color: isSelected ? Colors.white : AppTheme.textSecondary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      backgroundColor: AppTheme.cardSurface,
      selectedColor: AppTheme.primary,
      side: BorderSide(color: isSelected ? AppTheme.primary : AppTheme.borderLight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSm)),
      onSelected: (_) => setState(() => _studentFilter = value),
    );
  }

  void _showCreateAssignmentDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final passageCtrl = TextEditingController();
    final instructionsCtrl = TextEditingController();
    final dueDateCtrl = TextEditingController(text: 'Saturday 8:30 AM');
    String selectedType = 'reading';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              top: 16,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
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
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Post New Assignment',
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
                const Divider(color: AppTheme.borderLight),
                const SizedBox(height: 10),

                // Assignment Title
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Assignment Title',
                    hintText: 'e.g. Week 6: Romans 8 Deep Dive',
                    prefixIcon: Icon(Icons.assignment_rounded, size: 20),
                  ),
                ),

                const SizedBox(height: 12),

                // Type Dropdown
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Assignment Type',
                    prefixIcon: Icon(Icons.category_rounded, size: 20),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'reading', child: Text('Reading Assignment')),
                    DropdownMenuItem(value: 'memorization', child: Text('TMS Memorization')),
                    DropdownMenuItem(value: 'reflection', child: Text('Personal Reflection')),
                    DropdownMenuItem(value: 'practice', child: Text('Evangelism Practice')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedType = val);
                  },
                ),

                const SizedBox(height: 12),

                // Due Date
                TextField(
                  controller: dueDateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Due Date & Time',
                    prefixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                  ),
                ),

                const SizedBox(height: 12),

                // Scripture Passage
                TextField(
                  controller: passageCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Scripture Focus Passage',
                    hintText: 'e.g. Romans 8:1-39',
                    prefixIcon: Icon(Icons.menu_book_rounded, size: 20),
                  ),
                ),

                const SizedBox(height: 12),

                // Instructions
                TextField(
                  controller: instructionsCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Instructions / Prompt',
                    hintText: 'Describe questions students need to answer...',
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  icon: const Icon(Icons.publish_rounded, size: 18),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  onPressed: () {
                    if (titleCtrl.text.trim().isEmpty) return;

                    final newAssignment = Assignment(
                      id: 'assign_${DateTime.now().millisecondsSinceEpoch}',
                      title: titleCtrl.text.trim(),
                      weekNumber: _repo.assignments.length + 1,
                      dueDate: dueDateCtrl.text.trim(),
                      passage: passageCtrl.text.trim().isNotEmpty ? passageCtrl.text.trim() : 'Romans 8',
                      instructions: instructionsCtrl.text.trim().isNotEmpty
                          ? instructionsCtrl.text.trim()
                          : 'Complete and submit on your phone before Saturday Bible study.',
                      questions: [
                        'What is the primary spiritual principle revealed in this passage?',
                        'How will you apply this truth in your campus fellowship this week?',
                      ],
                      category: selectedType == 'memorization' ? 'TMS Memory' : 'Bible Study',
                      type: selectedType,
                      createdByStaffId: _repo.currentUser.id,
                      createdAt: DateTime.now().toIso8601String().split('T').first,
                    );

                    _repo.createAssignment(newAssignment);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Assignment "${newAssignment.title}" published!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  label: Text('Publish Assignment', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'reading':
        return AppTheme.info;
      case 'memorization':
        return AppTheme.warning;
      case 'reflection':
        return AppTheme.accent;
      case 'practice':
        return AppTheme.success;
      default:
        return AppTheme.info;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'reading':
        return Icons.menu_book_outlined;
      case 'memorization':
        return Icons.star_outline_rounded;
      case 'reflection':
        return Icons.psychology_outlined;
      case 'practice':
        return Icons.group_work_outlined;
      default:
        return Icons.assignment_outlined;
    }
  }
}
