class Submission {
  final String id;
  final String assignmentId;
  final String studentId;
  final String studentName;
  final String studentPhone;
  final Map<String, String> answers; // question index -> answer text
  final String submittedAt;
  final String status; // "Submitted", "Reviewed"
  final String? staffFeedback;
  final int? score; // 0 - 100
  final String? reviewedBy;

  const Submission({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.studentName,
    required this.studentPhone,
    required this.answers,
    required this.submittedAt,
    this.status = 'Submitted',
    this.staffFeedback,
    this.score,
    this.reviewedBy,
  });

  bool get isReviewed => status == 'Reviewed';

  Submission copyWith({
    String? id,
    String? assignmentId,
    String? studentId,
    String? studentName,
    String? studentPhone,
    Map<String, String>? answers,
    String? submittedAt,
    String? status,
    String? staffFeedback,
    int? score,
    String? reviewedBy,
  }) {
    return Submission(
      id: id ?? this.id,
      assignmentId: assignmentId ?? this.assignmentId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentPhone: studentPhone ?? this.studentPhone,
      answers: answers ?? this.answers,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      staffFeedback: staffFeedback ?? this.staffFeedback,
      score: score ?? this.score,
      reviewedBy: reviewedBy ?? this.reviewedBy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignmentId': assignmentId,
      'studentId': studentId,
      'studentName': studentName,
      'studentPhone': studentPhone,
      'answers': answers,
      'submittedAt': submittedAt,
      'status': status,
      'staffFeedback': staffFeedback,
      'score': score,
      'reviewedBy': reviewedBy,
    };
  }

  factory Submission.fromJson(Map<String, dynamic> json, [String? fallbackId]) {
    final rawAnswers = json['answers'];
    Map<String, String> parsedAnswers = {};
    if (rawAnswers is Map) {
      rawAnswers.forEach((key, value) {
        parsedAnswers[key.toString()] = value.toString();
      });
    }

    return Submission(
      id: json['id'] as String? ?? fallbackId ?? '',
      assignmentId: json['assignmentId'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      studentName: json['studentName'] as String? ?? '',
      studentPhone: json['studentPhone'] as String? ?? '',
      answers: parsedAnswers,
      submittedAt: json['submittedAt'] as String? ?? '',
      status: json['status'] as String? ?? 'Submitted',
      staffFeedback: json['staffFeedback'] as String?,
      score: (json['score'] as num?)?.toInt(),
      reviewedBy: json['reviewedBy'] as String?,
    );
  }
}
