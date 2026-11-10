class Member {
  final String id;
  final String idNumber;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phone;
  final String role; // "Student" or "Staff"
  final String? profilePicUrl;
  final int attendedSessions;
  final int totalSessions;

  const Member({
    required this.id,
    required this.idNumber,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    this.profilePicUrl,
    this.attendedSessions = 0,
    this.totalSessions = 0,
  });

  String get fullName => '$firstName $lastName'.trim();

  bool get isStaff => role.toLowerCase() == 'staff';

  int get attendancePercentage {
    if (totalSessions <= 0) return 0;
    final pct = (attendedSessions / totalSessions) * 100;
    return pct.round().clamp(0, 100);
  }

  Member copyWith({
    String? id,
    String? idNumber,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phone,
    String? role,
    String? profilePicUrl,
    int? attendedSessions,
    int? totalSessions,
  }) {
    return Member(
      id: id ?? this.id,
      idNumber: idNumber ?? this.idNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      attendedSessions: attendedSessions ?? this.attendedSessions,
      totalSessions: totalSessions ?? this.totalSessions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idNumber': idNumber,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phone': phone,
      'role': role,
      'profilePicUrl': profilePicUrl,
      'attendedSessions': attendedSessions,
      'totalSessions': totalSessions,
    };
  }

  factory Member.fromJson(Map<String, dynamic> json, [String? fallbackId]) {
    return Member(
      id: json['id'] as String? ?? fallbackId ?? '',
      idNumber: json['idNumber'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? 'Student',
      profilePicUrl: json['profilePicUrl'] as String?,
      attendedSessions: (json['attendedSessions'] as num?)?.toInt() ?? 0,
      totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
    );
  }
}
