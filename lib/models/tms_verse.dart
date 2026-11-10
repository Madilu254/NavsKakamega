class TMSVerse {
  final String id;
  final String reference;
  final String text;
  final String topic;
  final int pack;
  final List<String> memorizedMemberIds;

  const TMSVerse({
    required this.id,
    required this.reference,
    required this.text,
    required this.topic,
    required this.pack,
    this.memorizedMemberIds = const [],
  });

  bool isMemorizedBy(String memberId) => memorizedMemberIds.contains(memberId);

  TMSVerse copyWith({
    String? id,
    String? reference,
    String? text,
    String? topic,
    int? pack,
    List<String>? memorizedMemberIds,
  }) {
    return TMSVerse(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      text: text ?? this.text,
      topic: topic ?? this.topic,
      pack: pack ?? this.pack,
      memorizedMemberIds: memorizedMemberIds ?? this.memorizedMemberIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'text': text,
      'topic': topic,
      'pack': pack,
      'memorizedMemberIds': memorizedMemberIds,
    };
  }

  factory TMSVerse.fromJson(Map<String, dynamic> json, [String? fallbackId]) {
    final rawMemorized = json['memorizedMemberIds'] ?? json['memorized'];
    List<String> parsedMemorized = [];
    if (rawMemorized is List) {
      parsedMemorized = rawMemorized.map((e) => e.toString()).toList();
    }

    return TMSVerse(
      id: json['id'] as String? ?? fallbackId ?? '',
      reference: json['reference'] as String? ?? '',
      text: json['text'] as String? ?? '',
      topic: json['topic'] as String? ?? 'Living the New Life',
      pack: (json['pack'] as num?)?.toInt() ?? 1,
      memorizedMemberIds: parsedMemorized,
    );
  }
}
