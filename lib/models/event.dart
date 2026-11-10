class NavsEvent {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final String venue;
  final String description;
  final String category; // "Conference", "Combat", "Fellowship", "Prayer"
  final int targetMobilization;
  final List<String> rsvps; // User IDs
  final String? bannerUrl;

  const NavsEvent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.venue,
    required this.description,
    required this.category,
    required this.targetMobilization,
    this.rsvps = const [],
    this.bannerUrl,
  });

  int get rsvpCount => rsvps.length;

  bool isUserRsvpd(String userId) => rsvps.contains(userId);

  double get mobilizationProgress {
    if (targetMobilization <= 0) return 0.0;
    return (rsvpCount / targetMobilization).clamp(0.0, 1.0);
  }

  NavsEvent copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? date,
    String? time,
    String? venue,
    String? description,
    String? category,
    int? targetMobilization,
    List<String>? rsvps,
    String? bannerUrl,
  }) {
    return NavsEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      description: description ?? this.description,
      category: category ?? this.category,
      targetMobilization: targetMobilization ?? this.targetMobilization,
      rsvps: rsvps ?? this.rsvps,
      bannerUrl: bannerUrl ?? this.bannerUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'date': date,
      'time': time,
      'venue': venue,
      'description': description,
      'category': category,
      'targetMobilization': targetMobilization,
      'rsvps': rsvps,
      'bannerUrl': bannerUrl,
    };
  }

  factory NavsEvent.fromJson(Map<String, dynamic> json, [String? fallbackId]) {
    final rawRsvps = json['rsvps'];
    List<String> parsedRsvps = [];
    if (rawRsvps is List) {
      parsedRsvps = rawRsvps.map((e) => e.toString()).toList();
    } else if (rawRsvps is Map) {
      parsedRsvps = rawRsvps.keys.map((e) => e.toString()).toList();
    }

    return NavsEvent(
      id: json['id'] as String? ?? fallbackId ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      venue: json['venue'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      targetMobilization: (json['targetMobilization'] as num?)?.toInt() ?? 50,
      rsvps: parsedRsvps,
      bannerUrl: json['bannerUrl'] as String?,
    );
  }
}
