class AttendanceRecord {
  final String id;
  final String sessionId;
  final String sessionName;
  final String sessionType; // "Bible Study" or "Staff Prep"
  final String memberId;
  final String memberName;
  final String memberRole;
  final String date;
  final String timestamp;
  final bool present;

  const AttendanceRecord({
    required this.id,
    required this.sessionId,
    required this.sessionName,
    required this.sessionType,
    required this.memberId,
    required this.memberName,
    required this.memberRole,
    required this.date,
    required this.timestamp,
    this.present = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'sessionName': sessionName,
      'sessionType': sessionType,
      'memberId': memberId,
      'memberName': memberName,
      'memberRole': memberRole,
      'date': date,
      'timestamp': timestamp,
      'present': present,
    };
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json, [String? fallbackId]) {
    return AttendanceRecord(
      id: json['id'] as String? ?? fallbackId ?? '',
      sessionId: json['sessionId'] as String? ?? '',
      sessionName: json['sessionName'] as String? ?? '',
      sessionType: json['sessionType'] as String? ?? 'Bible Study',
      memberId: json['memberId'] as String? ?? '',
      memberName: json['memberName'] as String? ?? '',
      memberRole: json['memberRole'] as String? ?? 'Student',
      date: json['date'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      present: json['present'] as bool? ?? true,
    );
  }
}
