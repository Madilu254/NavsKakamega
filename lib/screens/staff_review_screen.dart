import 'package:flutter/material.dart';
import '../data/navs_repository.dart';
import '../models/assignment.dart';
import '../models/submission.dart';
import '../theme/app_theme.dart';


class StaffReviewScreen extends StatefulWidget {
  final String? initialAssignmentId;

  const StaffReviewScreen({super.key, this.initialAssignmentId});

  @override
  State<StaffReviewScreen> createState() => _StaffReviewScreenState();
}

class _StaffReviewScreenState extends State<StaffReviewScreen> with SingleTickerProviderStateMixin {
  final NavsRepository _repo = NavsRepository();
  late TabController _tabController;
  late String _selectedAssignmentId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedAssignmentId = widget.initialAssignmentId ??
        (_repo.assignments.isNotEmpty ? _repo.assignments.first.id : '');
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

  void _openSubmissionReviewModal(Submission sub, Assignment assignment) {
    final feedbackController = TextEditingController(text: sub.staffFeedback ?? '');
    final scoreController = TextEditingController(text: sub.score?.toString() ?? '90');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sub.studentName,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text('Phone: ${sub.studentPhone}', style: const TextStyle(color: AppTheme.textSecondary)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        sub.status,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                const Text(
                  'Student Realtime Answers:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.primaryDark),
                ),
                const SizedBox(height: 12),

                ...assignment.questions.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final q = entry.value;
                  final answer = sub.answers['$idx'] ?? '(No answer provided)';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Q${idx + 1}: $q',
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          answer,
                          style: const TextStyle(fontSize: 13.5, color: Color(0xFF1F2937), height: 1.3),
                        ),
                      ],
                    ),
                  );
                }),

                const Divider(height: 24),

                const Text(
                  'Staff Evaluation & Remarks:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Text('Score (0 - 100): ', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: scoreController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: feedbackController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Feedback / Encouragement for Student',
                    hintText: 'e.g. Excellent application of Galatians 2:20!',
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    final score = int.tryParse(scoreController.text.trim()) ?? 85;
                    final feedback = feedbackController.text.trim();

                    _repo.gradeSubmission(
                      submissionId: sub.id,
                      feedback: feedback.isNotEmpty ? feedback : 'Well done on completing this study!',
                      score: score,
                    );

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Review & feedback saved for ${sub.studentName}!'),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save Review & Feedback'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignments = _repo.assignments;
    final currentAssignment = assignments.firstWhere(
      (a) => a.id == _selectedAssignmentId,
      orElse: () => assignments.first,
    );

    final submittedMembers = _repo.getMembersWhoSubmitted(currentAssignment.id);
    final unsubmittedMembers = _repo.getMembersWhoDidNotSubmit(currentAssignment.id);
    final totalStudents = submittedMembers.length + unsubmittedMembers.length;
    final completionPct = totalStudents > 0 ? ((submittedMembers.length / totalStudents) * 100).toInt() : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Assignment Review'),
        backgroundColor: AppTheme.primary,
      ),
      body: Column(
        children: [
          // Assignment Selector
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Text('Select Study:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedAssignmentId,
                      items: assignments.map((a) {
                        return DropdownMenuItem(
                          value: a.id,
                          child: Text(
                            a.title,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedAssignmentId = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Completion Rate Progress Card
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Realtime Submissions Overview',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      '$completionPct% Completed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: completionPct >= 60 ? AppTheme.primary : Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: totalStudents > 0 ? (submittedMembers.length / totalStudents) : 0,
                    minHeight: 9,
                    backgroundColor: AppTheme.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '✓ ${submittedMembers.length} Completed',
                      style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12.5),
                    ),
                    Text(
                      '⚠️ ${unsubmittedMembers.length} Did Not Do Assignment',
                      style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 12.5),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tabs: Who Did Assignment vs Who Didn't
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.primary,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: 'Did Assignment (${submittedMembers.length})'),
                Tab(text: 'Didn\'t Do Assignment (${unsubmittedMembers.length})'),
              ],
            ),
          ),

          // Tab Bar View Lists
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Submitted Students List
                submittedMembers.isEmpty
                    ? const Center(
                        child: Text(
                          'No students have submitted this assignment yet.',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        itemCount: submittedMembers.length,
                        itemBuilder: (context, index) {
                          final member = submittedMembers[index];
                          final sub = _repo.getSubmissionForAssignment(currentAssignment.id, member.id);
                          if (sub == null) return const SizedBox.shrink();

                          final isReviewed = sub.status == 'Reviewed';

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                                child: Text(
                                  member.firstName[0],
                                  style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(member.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                isReviewed ? 'Reviewed • Score: ${sub.score}/100' : 'Submitted on phone • Pending review',
                                style: TextStyle(
                                  color: isReviewed ? AppTheme.primary : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () => _openSubmissionReviewModal(sub, currentAssignment),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isReviewed ? AppTheme.background : AppTheme.primary,
                                  foregroundColor: isReviewed ? AppTheme.primary : Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: isReviewed ? AppTheme.primary : Colors.transparent),
                                  ),
                                ),
                                child: Text(isReviewed ? 'View / Re-grade' : 'Review & Grade', style: const TextStyle(fontSize: 12)),
                              ),
                            ),
                          );
                        },
                      ),

                // 2. Unsubmitted (Pending) Students List
                unsubmittedMembers.isEmpty
                    ? const Center(
                        child: Text(
                          '🎉 Excellent! All enrolled students have completed this assignment.',
                          style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                        ),
                      )
                    : ListView(
                        children: [
                          // Batch Mobilize Action Banner
                          Container(
                            margin: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.notifications_active, color: Colors.deepOrange, size: 22),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Mobilize unsubmitted students with a reminder before Saturday Bible Study.',
                                    style: TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Batch mobilization reminder broadcast to all unsubmitted students!'),
                                        backgroundColor: AppTheme.primary,
                                      ),
                                    );
                                  },
                                  child: const Text('Remind All', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),

                          ...unsubmittedMembers.map((member) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                                  child: Text(
                                    member.firstName[0],
                                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(member.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  'Phone: ${member.phone} • Attendance: ${member.attendancePercentage}%',
                                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                ),
                                trailing: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Mobilization reminder sent to ${member.fullName}!'),
                                        backgroundColor: AppTheme.primary,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.send, size: 14),
                                  label: const Text('Remind'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
