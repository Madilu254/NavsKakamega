class Assignment {
  final String id;
  final String title;
  final int weekNumber;
  final String dueDate;
  final String passage;
  final String instructions;
  final List<String> questions;
  final String category; // "Bible Study", "TMS Memory", "Reflection"
  final String type; // "reading", "memorization", "reflection", "practice"
  final String createdByStaffId;
  final String createdAt;

  const Assignment({
    required this.id,
    required this.title,
    required this.weekNumber,
    required this.dueDate,
    required this.passage,
    required this.instructions,
    required this.questions,
    required this.category,
    this.type = 'reading',
    required this.createdByStaffId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'weekNumber': weekNumber,
      'dueDate': dueDate,
      'passage': passage,
      'instructions': instructions,
      'questions': questions,
      'category': category,
      'type': type,
      'createdByStaffId': createdByStaffId,
      'createdAt': createdAt,
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> json, [String? fallbackId]) {
    final rawQuestions = json['questions'];
    List<String> parsedQuestions = [];
    if (rawQuestions is List) {
      parsedQuestions = rawQuestions.map((q) => q.toString()).toList();
    }

    final cat = json['category'] as String? ?? 'Bible Study';
    String resolvedType = json['type'] as String? ?? '';
    if (resolvedType.isEmpty) {
      if (cat.toLowerCase().contains('memory') || cat.toLowerCase().contains('tms')) {
        resolvedType = 'memorization';
      } else if (cat.toLowerCase().contains('reflection')) {
        resolvedType = 'reflection';
      } else if (cat.toLowerCase().contains('practice')) {
        resolvedType = 'practice';
      } else {
        resolvedType = 'reading';
      }
    }

    return Assignment(
      id: json['id'] as String? ?? fallbackId ?? '',
      title: json['title'] as String? ?? '',
      weekNumber: (json['weekNumber'] as num?)?.toInt() ?? 1,
      dueDate: json['dueDate'] as String? ?? '',
      passage: json['passage'] as String? ?? '',
      instructions: json['instructions'] as String? ?? '',
      questions: parsedQuestions,
      category: cat,
      type: resolvedType,
      createdByStaffId: json['createdByStaffId'] as String? ?? 'staff_1',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}
