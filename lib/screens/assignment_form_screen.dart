import 'package:flutter/material.dart';
import '../data/navs_repository.dart';
import '../models/assignment.dart';
import '../theme/app_theme.dart';

class AssignmentFormScreen extends StatefulWidget {
  final Assignment assignment;

  const AssignmentFormScreen({super.key, required this.assignment});

  @override
  State<AssignmentFormScreen> createState() => _AssignmentFormScreenState();
}

class _AssignmentFormScreenState extends State<AssignmentFormScreen> {
  final NavsRepository _repo = NavsRepository();
  final Map<int, TextEditingController> _controllers = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate if student already has a submission
    final existingSubmission = _repo.getSubmissionForAssignment(widget.assignment.id);
    for (int i = 0; i < widget.assignment.questions.length; i++) {
      final initialAnswer = existingSubmission?.answers['$i'] ?? '';
      _controllers[i] = TextEditingController(text: initialAnswer);
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() async {
    final Map<String, String> answers = {};
    for (int i = 0; i < widget.assignment.questions.length; i++) {
      final txt = _controllers[i]?.text.trim() ?? '';
      if (txt.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please answer Question ${i + 1} before submitting.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      answers['$i'] = txt;
    }

    setState(() => _isSubmitting = true);

    await _repo.submitAssignment(
      assignmentId: widget.assignment.id,
      answers: answers,
    );

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Realtime Assignment submitted successfully! Recorded for staff review.'),
          backgroundColor: AppTheme.primary,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final submission = _repo.getSubmissionForAssignment(widget.assignment.id);
    final isSubmitted = submission != null;
    final isReviewed = submission?.status == 'Reviewed';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assignment.title),
        backgroundColor: AppTheme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Container(
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'WEEK ${widget.assignment.weekNumber} • ${widget.assignment.category.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSubmitted ? AppTheme.primary : Colors.orange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isReviewed
                            ? 'Reviewed (${submission?.score ?? 100}/100)'
                            : (isSubmitted ? 'Submitted ✓' : 'Pending Submission'),
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: isSubmitted ? Colors.white : Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.assignment.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Passage: ${widget.assignment.passage}',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.assignment.instructions,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.3),
                ),
              ],
            ),
          ),

          // If Reviewed, show Staff Feedback banner
          if (isReviewed && submission?.staffFeedback != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.rate_review, color: AppTheme.staffGold, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Staff Feedback • Reviewed by ${submission?.reviewedBy ?? "Staff"}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.staffGold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    submission?.staffFeedback ?? '',
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppTheme.textPrimary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 18),

          const Text(
            'Assignment Questions (Answer on Phone):',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),

          // Questions List
          ...widget.assignment.questions.asMap().entries.map((entry) {
            final idx = entry.key;
            final questionText = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppTheme.primary,
                        child: Text(
                          '${idx + 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          questionText,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controllers[idx],
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Type your answer here in realtime...',
                      hintStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppTheme.border),
                      ),
                      fillColor: AppTheme.background,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 10),

          // Submit Button
          ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _submit,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_upload_outlined),
            label: Text(
              isSubmitted ? 'Update & Re-Submit Assignment' : 'Submit Assignment in Realtime',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
