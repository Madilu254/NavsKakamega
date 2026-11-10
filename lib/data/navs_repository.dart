import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/member.dart';
import '../models/event.dart';
import '../models/assignment.dart';
import '../models/submission.dart';
import '../models/attendance_record.dart';
import '../models/chat_message.dart';
import '../models/tms_verse.dart';

class NavsRepository extends ChangeNotifier {
  static final NavsRepository _instance = NavsRepository._internal();
  factory NavsRepository() => _instance;
  NavsRepository._internal();

  static const String firebaseDbUrl = 'https://navigators-5d36f-default-rtdb.firebaseio.com';
  final _uuid = const Uuid();

  // Active Current User
  Member _currentUser = const Member(
    id: 'student_1',
    idNumber: 'NAV/KK/2026/042',
    firstName: 'Elvis',
    lastName: 'Mowdi',
    username: 'elvis_mowdi',
    email: 'elvis.mowdi@navigators.org',
    phone: '+254 712 345 678',
    role: 'Student',
    attendedSessions: 7,
    totalSessions: 8,
  );

  Member get currentUser => _currentUser;
  bool get isStaff => _currentUser.isStaff;

  // In-memory state collections
  List<Member> _members = [];
  List<NavsEvent> _events = [];
  List<Assignment> _assignments = [];
  List<Submission> _submissions = [];
  List<AttendanceRecord> _attendanceRecords = [];
  List<TMSVerse> _tmsVerses = [];
  Map<String, List<ChatMessage>> _channelMessages = {};

  List<Member> get members => List.unmodifiable(_members);
  List<NavsEvent> get events => List.unmodifiable(_events);
  List<Assignment> get assignments => List.unmodifiable(_assignments);
  List<Submission> get submissions => List.unmodifiable(_submissions);
  List<AttendanceRecord> get attendanceRecords => List.unmodifiable(_attendanceRecords);
  List<TMSVerse> get tmsVerses => List.unmodifiable(_tmsVerses);
  int get currentUserMemorizedCount => _tmsVerses.where((v) => v.isMemorizedBy(_currentUser.id)).length;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;

    // 1. Seed base offline datasets
    _seedDefaultData();

    // 2. Load stored preferences for active role / current user
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRole = prefs.getString('user_role');
      if (savedRole != null && savedRole.isNotEmpty) {
        _currentUser = _currentUser.copyWith(role: savedRole);
      }
      final savedFirstName = prefs.getString('user_first_name');
      final savedLastName = prefs.getString('user_last_name');
      if (savedFirstName != null && savedLastName != null) {
        _currentUser = _currentUser.copyWith(
          firstName: savedFirstName,
          lastName: savedLastName,
        );
      }
    } catch (_) {}

    // 3. Attempt background fetch from Firebase Realtime DB
    _syncWithFirebase();

    _initialized = true;
    notifyListeners();
  }

  // Switch between Student and Staff mode
  Future<void> switchRole(String newRole) async {
    _currentUser = _currentUser.copyWith(role: newRole);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', newRole);
    } catch (_) {}
    notifyListeners();
  }

  void setCurrentUser(Member member) {
    _currentUser = member;
    notifyListeners();
  }

  // --- ATTENDANCE & BIBLE STUDY ---

  bool hasCurrentUserAttendedSession(String sessionId) {
    return _attendanceRecords.any(
      (r) => r.sessionId == sessionId && r.memberId == _currentUser.id && r.present,
    );
  }

  Future<void> markAttendanceForSession({
    required String sessionId,
    required String sessionName,
    required String sessionType,
  }) async {
    if (hasCurrentUserAttendedSession(sessionId)) return;

    final newRecord = AttendanceRecord(
      id: _uuid.v4(),
      sessionId: sessionId,
      sessionName: sessionName,
      sessionType: sessionType,
      memberId: _currentUser.id,
      memberName: _currentUser.fullName,
      memberRole: _currentUser.role,
      date: DateTime.now().toIso8601String().split('T').first,
      timestamp: '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      present: true,
    );

    _attendanceRecords.insert(0, newRecord);

    // Update member's attended count
    final idx = _members.indexWhere((m) => m.id == _currentUser.id);
    if (idx != -1) {
      final updated = _members[idx].copyWith(
        attendedSessions: _members[idx].attendedSessions + 1,
      );
      _members[idx] = updated;
      _currentUser = updated;
    } else {
      _currentUser = _currentUser.copyWith(
        attendedSessions: _currentUser.attendedSessions + 1,
      );
    }

    notifyListeners();
    _pushAttendanceToFirebase(newRecord);
  }

  List<Member> getPresentMembersForSession(String sessionId) {
    final presentIds = _attendanceRecords
        .where((r) => r.sessionId == sessionId && r.present)
        .map((r) => r.memberId)
        .toSet();
    return _members.where((m) => presentIds.contains(m.id)).toList();
  }

  List<Member> getAbsentMembersForSession(String sessionId) {
    final presentIds = _attendanceRecords
        .where((r) => r.sessionId == sessionId && r.present)
        .map((r) => r.memberId)
        .toSet();
    return _members.where((m) => !presentIds.contains(m.id)).toList();
  }

  Future<void> recordSessionAttendance({
    required String sessionId,
    required String sessionName,
    required String date,
    required Set<String> presentMemberIds,
    String? notes,
  }) async {
    for (final m in _members) {
      final isPresent = presentMemberIds.contains(m.id);
      final rec = AttendanceRecord(
        id: _uuid.v4(),
        sessionId: sessionId,
        sessionName: sessionName,
        sessionType: 'Bible Study',
        memberId: m.id,
        memberName: m.fullName,
        memberRole: m.role,
        date: date,
        timestamp: '09:00 AM',
        present: isPresent,
      );
      _attendanceRecords.insert(0, rec);
      _pushAttendanceToFirebase(rec);

      final mIdx = _members.indexWhere((mem) => mem.id == m.id);
      if (mIdx != -1) {
        final currentAttended = _members[mIdx].attendedSessions;
        final currentTotal = _members[mIdx].totalSessions;
        _members[mIdx] = _members[mIdx].copyWith(
          attendedSessions: isPresent ? currentAttended + 1 : currentAttended,
          totalSessions: currentTotal + 1,
        );
      }
    }
    notifyListeners();
  }

  // --- TOPICAL MEMORY SYSTEM (TMS) ---

  Future<void> toggleVerseMemorized(String verseId) async {
    final idx = _tmsVerses.indexWhere((v) => v.id == verseId);
    if (idx == -1) return;
    final v = _tmsVerses[idx];
    final memberId = _currentUser.id;
    final currentList = List<String>.from(v.memorizedMemberIds);
    if (currentList.contains(memberId)) {
      currentList.remove(memberId);
    } else {
      currentList.add(memberId);
    }
    _tmsVerses[idx] = v.copyWith(memorizedMemberIds: currentList);
    notifyListeners();
  }

  // --- EVENTS & MOBILIZATION ---

  Future<void> toggleEventRsvp(String eventId) async {
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx == -1) return;

    final event = _events[idx];
    final currentRsvps = List<String>.from(event.rsvps);
    if (currentRsvps.contains(_currentUser.id)) {
      currentRsvps.remove(_currentUser.id);
    } else {
      currentRsvps.add(_currentUser.id);
    }

    _events[idx] = event.copyWith(rsvps: currentRsvps);
    notifyListeners();

    _pushEventRsvpToFirebase(eventId, currentRsvps);
  }

  Future<void> addNewEvent(NavsEvent event) async {
    _events.insert(0, event);
    notifyListeners();
    _pushEventToFirebase(event);
  }

  // --- ASSIGNMENTS & REALTIME SUBMISSION ---

  Submission? getSubmissionForAssignment(String assignmentId, [String? studentId]) {
    final targetStudentId = studentId ?? _currentUser.id;
    try {
      return _submissions.firstWhere(
        (s) => s.assignmentId == assignmentId && s.studentId == targetStudentId,
      );
    } catch (_) {
      return null;
    }
  }

  List<Submission> getAllSubmissionsForAssignment(String assignmentId) {
    return _submissions.where((s) => s.assignmentId == assignmentId).toList();
  }

  List<Member> getMembersWhoSubmitted(String assignmentId) {
    final submittedStudentIds = _submissions
        .where((s) => s.assignmentId == assignmentId)
        .map((s) => s.studentId)
        .toSet();
    return _members
        .where((m) => !m.isStaff && submittedStudentIds.contains(m.id))
        .toList();
  }

  List<Member> getMembersWhoDidNotSubmit(String assignmentId) {
    final submittedStudentIds = _submissions
        .where((s) => s.assignmentId == assignmentId)
        .map((s) => s.studentId)
        .toSet();
    return _members
        .where((m) => !m.isStaff && !submittedStudentIds.contains(m.id))
        .toList();
  }

  Future<void> submitAssignment({
    required String assignmentId,
    required Map<String, String> answers,
  }) async {
    final existingIdx = _submissions.indexWhere(
      (s) => s.assignmentId == assignmentId && s.studentId == _currentUser.id,
    );

    final submission = Submission(
      id: existingIdx != -1 ? _submissions[existingIdx].id : _uuid.v4(),
      assignmentId: assignmentId,
      studentId: _currentUser.id,
      studentName: _currentUser.fullName,
      studentPhone: _currentUser.phone,
      answers: answers,
      submittedAt: DateTime.now().toIso8601String(),
      status: 'Submitted',
    );

    if (existingIdx != -1) {
      _submissions[existingIdx] = submission;
    } else {
      _submissions.insert(0, submission);
    }

    notifyListeners();
    _pushSubmissionToFirebase(submission);
  }

  Future<void> gradeSubmission({
    required String submissionId,
    required String feedback,
    required int score,
  }) async {
    final idx = _submissions.indexWhere((s) => s.id == submissionId);
    if (idx == -1) return;

    _submissions[idx] = _submissions[idx].copyWith(
      staffFeedback: feedback,
      score: score,
      status: 'Reviewed',
      reviewedBy: _currentUser.fullName,
    );

    notifyListeners();
    _pushSubmissionToFirebase(_submissions[idx]);
  }

  Future<void> createAssignment(Assignment assignment) async {
    _assignments.insert(0, assignment);
    notifyListeners();
    _pushAssignmentToFirebase(assignment);
  }

  // --- CHATS & MESSAGING ---

  List<ChatMessage> getMessagesForChannel(String channelId) {
    return List.unmodifiable(_channelMessages[channelId] ?? []);
  }

  ChatMessage? getLastMessageForChannel(String channelId) {
    final msgs = _channelMessages[channelId];
    if (msgs != null && msgs.isNotEmpty) {
      return msgs.last;
    }
    return null;
  }

  Future<void> sendMessage({
    required String channelId,
    required String text,
  }) async {
    final msg = ChatMessage(
      id: _uuid.v4(),
      channelId: channelId,
      senderId: _currentUser.id,
      senderName: _currentUser.fullName,
      text: text,
      timestamp: '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      isStaff: _currentUser.isStaff,
      isRead: true,
    );

    if (!_channelMessages.containsKey(channelId)) {
      _channelMessages[channelId] = [];
    }
    _channelMessages[channelId]!.add(msg);
    notifyListeners();

    _pushMessageToFirebase(msg);
  }

  // --- MEMBERS & REGISTRATION ---

  Future<void> registerMember(Member newMember) async {
    _members.add(newMember);
    _currentUser = newMember;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', newMember.role);
      await prefs.setString('user_first_name', newMember.firstName);
      await prefs.setString('user_last_name', newMember.lastName);
      await prefs.setString('user_id', newMember.idNumber);
    } catch (_) {}

    _pushMemberToFirebase(newMember);
  }

  // --- FIREBASE SYNC HELPERS (REST) ---

  Future<void> _syncWithFirebase() async {
    try {
      // Sync users
      final userRes = await http.get(Uri.parse('$firebaseDbUrl/users.json'));
      if (userRes.statusCode == 200 && userRes.body != 'null') {
        final Map<String, dynamic> data = jsonDecode(userRes.body);
        final List<Member> fbMembers = [];
        data.forEach((key, val) {
          if (val is Map<String, dynamic>) {
            fbMembers.add(Member.fromJson(val, key));
          }
        });
        if (fbMembers.isNotEmpty) {
          _members = fbMembers;
        }
      }

      // Sync events
      final eventRes = await http.get(Uri.parse('$firebaseDbUrl/events.json'));
      if (eventRes.statusCode == 200 && eventRes.body != 'null') {
        final Map<String, dynamic> data = jsonDecode(eventRes.body);
        final List<NavsEvent> fbEvents = [];
        data.forEach((key, val) {
          if (val is Map<String, dynamic>) {
            fbEvents.add(NavsEvent.fromJson(val, key));
          }
        });
        if (fbEvents.isNotEmpty) {
          _events = fbEvents;
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Firebase background sync notice: using local offline resilient data');
    }
  }

  Future<void> _pushMemberToFirebase(Member member) async {
    try {
      final key = member.idNumber.replaceAll('.', '_').replaceAll('/', '_');
      await http.put(
        Uri.parse('$firebaseDbUrl/users/$key.json'),
        body: jsonEncode(member.toJson()),
      );
    } catch (_) {}
  }

  Future<void> _pushEventToFirebase(NavsEvent event) async {
    try {
      await http.put(
        Uri.parse('$firebaseDbUrl/events/${event.id}.json'),
        body: jsonEncode(event.toJson()),
      );
    } catch (_) {}
  }

  Future<void> _pushEventRsvpToFirebase(String eventId, List<String> rsvps) async {
    try {
      await http.put(
        Uri.parse('$firebaseDbUrl/events/$eventId/rsvps.json'),
        body: jsonEncode(rsvps),
      );
    } catch (_) {}
  }

  Future<void> _pushSubmissionToFirebase(Submission sub) async {
    try {
      await http.put(
        Uri.parse('$firebaseDbUrl/submissions/${sub.assignmentId}/${sub.studentId}.json'),
        body: jsonEncode(sub.toJson()),
      );
    } catch (_) {}
  }

  Future<void> _pushAssignmentToFirebase(Assignment assignment) async {
    try {
      await http.put(
        Uri.parse('$firebaseDbUrl/assignments/${assignment.id}.json'),
        body: jsonEncode(assignment.toJson()),
      );
    } catch (_) {}
  }

  Future<void> _pushAttendanceToFirebase(AttendanceRecord record) async {
    try {
      await http.put(
        Uri.parse('$firebaseDbUrl/attendance/${record.sessionId}/${record.memberId}.json'),
        body: jsonEncode(record.toJson()),
      );
    } catch (_) {}
  }

  Future<void> _pushMessageToFirebase(ChatMessage msg) async {
    try {
      await http.post(
        Uri.parse('$firebaseDbUrl/chats/${msg.channelId}/messages.json'),
        body: jsonEncode(msg.toJson()),
      );
    } catch (_) {}
  }

  // --- DEFAULT SEED DATA ---

  void _seedDefaultData() {
    _members = [
      const Member(
        id: 'student_1',
        idNumber: 'NAV/KK/2026/042',
        firstName: 'Elvis',
        lastName: 'Mowdi',
        username: 'elvis_mowdi',
        email: 'elvis.mowdi@navigators.org',
        phone: '+254 712 345 678',
        role: 'Student',
        attendedSessions: 7,
        totalSessions: 8,
      ),
      const Member(
        id: 'student_2',
        idNumber: 'NAV/KK/2026/015',
        firstName: 'Mercy',
        lastName: 'Chebet',
        username: 'mercy_c',
        email: 'mercy.chebet@mmust.ac.ke',
        phone: '+254 722 111 222',
        role: 'Student',
        attendedSessions: 8,
        totalSessions: 8,
      ),
      const Member(
        id: 'student_3',
        idNumber: 'NAV/KK/2026/088',
        firstName: 'Brian',
        lastName: 'Ochieng',
        username: 'brian_o',
        email: 'brian.ochieng@gmail.com',
        phone: '+254 733 444 555',
        role: 'Student',
        attendedSessions: 6,
        totalSessions: 8,
      ),
      const Member(
        id: 'student_4',
        idNumber: 'NAV/KK/2026/102',
        firstName: 'Faith',
        lastName: 'Wangari',
        username: 'faith_w',
        email: 'faith.w@mmust.ac.ke',
        phone: '+254 701 999 888',
        role: 'Student',
        attendedSessions: 7,
        totalSessions: 8,
      ),
      const Member(
        id: 'student_5',
        idNumber: 'NAV/KK/2026/054',
        firstName: 'Samuel',
        lastName: 'Kimani',
        username: 'sam_kim',
        email: 'samuel.kimani@navs.ke',
        phone: '+254 719 333 222',
        role: 'Student',
        attendedSessions: 5,
        totalSessions: 8,
      ),
      const Member(
        id: 'student_6',
        idNumber: 'NAV/KK/2026/077',
        firstName: 'Joy',
        lastName: 'Muthoni',
        username: 'joy_m',
        email: 'joy.muthoni@gmail.com',
        phone: '+254 742 888 111',
        role: 'Student',
        attendedSessions: 4,
        totalSessions: 8,
      ),
      const Member(
        id: 'student_7',
        idNumber: 'NAV/KK/2026/119',
        firstName: 'Dennis',
        lastName: 'Barasa',
        username: 'dennis_b',
        email: 'dennis.barasa@yahoo.com',
        phone: '+254 755 667 788',
        role: 'Student',
        attendedSessions: 3,
        totalSessions: 8,
      ),
      const Member(
        id: 'staff_1',
        idNumber: 'STAFF/KK/001',
        firstName: 'Eric',
        lastName: 'Opilo',
        username: 'eric_opilo',
        email: 'opiloeric395@gmail.com',
        phone: '+254 700 000 089',
        role: 'Staff',
        attendedSessions: 8,
        totalSessions: 8,
      ),
      const Member(
        id: 'staff_2',
        idNumber: 'STAFF/KK/002',
        firstName: 'Daniel',
        lastName: 'Otanga',
        username: 'dan_otanga',
        email: 'dfotanga@mmust.ac.ke',
        phone: '+254 721 555 444',
        role: 'Staff',
        attendedSessions: 8,
        totalSessions: 8,
      ),
      const Member(
        id: 'staff_3',
        idNumber: 'STAFF/KK/003',
        firstName: 'Hellen',
        lastName: 'Angulu',
        username: 'hellen_a',
        email: 'hangulu@mmust.ac.ke',
        phone: '+254 723 999 112',
        role: 'Staff',
        attendedSessions: 8,
        totalSessions: 8,
      ),
    ];

    _events = [
      const NavsEvent(
        id: 'event_missions_conf',
        title: 'Missions Conference 2026',
        subtitle: 'Mobilizing Laborers to Campus and Beyond',
        date: 'Oct 24 – 26, 2026',
        time: '8:00 AM – 5:30 PM EAT',
        venue: 'Kakamega Main Assembly Hall',
        description:
            'The flagship East Africa Missions Conference! Join hundreds of student disciples and laborers for 3 days of deep plenary sessions, cross-cultural evangelism workshops, and life commitment to the Great Commission.',
        category: 'Conference',
        targetMobilization: 150,
        rsvps: ['student_1', 'student_2', 'student_3', 'student_4', 'staff_1', 'staff_2'],
      ),
      const NavsEvent(
        id: 'event_core_combat',
        title: 'Core Combat: Spiritual Readiness',
        subtitle: 'Armor of God, Scripture Memory & Evangelism',
        date: 'Nov 7, 2026',
        time: '9:00 AM – 4:30 PM EAT',
        venue: 'CU Pavilion, Kakamega',
        description:
            'Intensive disciple-equipping boot camp. Practical drills on Topical Memory System (TMS), conversational apologetics, spiritual warfare (Ephesians 6), and winning disciples on campus.',
        category: 'Combat',
        targetMobilization: 100,
        rsvps: ['student_1', 'student_2', 'student_5', 'staff_1'],
      ),
      const NavsEvent(
        id: 'event_family_tea',
        title: 'Navs Family Tea & Fellowship',
        subtitle: 'Weekly Snacks, Praises & Testimonies',
        date: 'Every Sunday',
        time: '3:00 PM – 6:30 PM EAT',
        venue: 'Navs Staff Residence / Center',
        description:
            'A warm Sunday family time for all Navigator students and alumni. Enjoy hot tea, testimonies, song ministrations, and relational discipleship.',
        category: 'Fellowship',
        targetMobilization: 60,
        rsvps: ['student_1', 'student_3', 'student_4', 'student_6', 'staff_1', 'staff_3'],
      ),
    ];

    _assignments = [
      const Assignment(
        id: 'assign_week_4',
        title: 'Week 4: The Wheel Illustration & Christ the Center',
        weekNumber: 4,
        dueDate: 'Saturday 8:30 AM',
        passage: 'Galatians 2:20 & 2 Corinthians 5:17',
        instructions:
            'Complete all four questions on your phone before Saturday Bible Study. Staff will review and discuss your responses during the Saturday 9 AM session.',
        questions: [
          'Read Galatians 2:20. In what areas of your daily campus life are you actively allowing Christ to be the Lord and Center of the wheel?',
          'The Wheel Illustration has four spokes: The Word, Prayer, Fellowship, and Witnessing. Which spoke do you currently find most challenging, and why?',
          'What is one specific, measurable step you will take this coming week to strengthen your personal Quiet Time in God\'s Word?',
          'Quote 2 Corinthians 5:17 from memory and describe how becoming a "new creation" has impacted your relationships.',
        ],
        category: 'Bible Study',
        createdByStaffId: 'staff_1',
        createdAt: '2026-09-10',
      ),
      const Assignment(
        id: 'assign_tms_a',
        title: 'TMS Scripture Memory - Series A (Live with Christ)',
        weekNumber: 5,
        dueDate: 'Friday 5:00 PM',
        passage: '2 Cor 5:17, Gal 2:20, John 16:24',
        instructions:
            'Type the verses word for word with reference and topic, then answer the personal reflection question.',
        questions: [
          'Quote 2 Corinthians 5:17 with topic and reference word-perfect.',
          'Quote Galatians 2:20 with topic and reference word-perfect.',
          'How do you plan to use these two verses when discipling someone new to the faith?',
        ],
        category: 'TMS Memory',
        createdByStaffId: 'staff_2',
        createdAt: '2026-09-12',
      ),
    ];

    _submissions = [
      const Submission(
        id: 'sub_1',
        assignmentId: 'assign_week_4',
        studentId: 'student_2',
        studentName: 'Mercy Chebet',
        studentPhone: '+254 722 111 222',
        submittedAt: '2026-09-13T18:40:00Z',
        status: 'Reviewed',
        score: 95,
        staffFeedback: 'Exceptional insight on the Fellowship spoke! Keep pressing into Galatians 2:20.',
        reviewedBy: 'Eric Opilo',
        answers: {
          '0': 'I am learning to surrender my academics and exam anxiety to Christ every morning before lectures.',
          '1': 'Witnessing spoke is my most challenging because I often feel nervous initiating spiritual conversations.',
          '2': 'I will wake up at 6:00 AM each morning for 30 minutes of uninterrupted study in Romans 8.',
          '3': '2 Corinthians 5:17: "Therefore, if anyone is in Christ, the new creation has come: The old has gone, the new is here!" My past mistakes no longer define me.',
        },
      ),
      const Submission(
        id: 'sub_2',
        assignmentId: 'assign_week_4',
        studentId: 'student_3',
        studentName: 'Brian Ochieng',
        studentPhone: '+254 733 444 555',
        submittedAt: '2026-09-14T07:15:00Z',
        status: 'Submitted',
        answers: {
          '0': 'Allowing Christ to lead my hostel interactions and choosing integrity in coursework.',
          '1': 'Prayer spoke needs more consistency; my prayer life is often hurried.',
          '2': 'I have set an alarm for 6:30 AM to read one chapter in Proverbs daily.',
          '3': 'The old life is gone; I am made completely new in Jesus Christ.',
        },
      ),
    ];

    _attendanceRecords = [
      const AttendanceRecord(
        id: 'att_1',
        sessionId: 'sat_bs_session_1',
        sessionName: 'Saturday Bible Study (9:00 AM – 12:00 PM)',
        sessionType: 'Bible Study',
        memberId: 'student_1',
        memberName: 'Elvis Mowdi',
        memberRole: 'Student',
        date: '2026-09-12',
        timestamp: '09:05 AM',
        present: true,
      ),
      const AttendanceRecord(
        id: 'att_2',
        sessionId: 'sat_bs_session_1',
        sessionName: 'Saturday Bible Study (9:00 AM – 12:00 PM)',
        sessionType: 'Bible Study',
        memberId: 'student_2',
        memberName: 'Mercy Chebet',
        memberRole: 'Student',
        date: '2026-09-12',
        timestamp: '08:58 AM',
        present: true,
      ),
      const AttendanceRecord(
        id: 'att_3',
        sessionId: 'fri_prep_session_1',
        sessionName: 'Friday Staff Preparatory Meeting',
        sessionType: 'Staff Prep',
        memberId: 'staff_1',
        memberName: 'Eric Opilo',
        memberRole: 'Staff',
        date: '2026-09-11',
        timestamp: '05:00 PM',
        present: true,
      ),
    ];

    _channelMessages = {
      'kakamega_general': [
        const ChatMessage(
          id: 'm1',
          channelId: 'kakamega_general',
          senderId: 'staff_1',
          senderName: 'Eric Opilo (Staff)',
          text: 'Praise the Lord team! Reminder that Saturday Bible Study is on from 9:00 AM to 12:00 PM sharp.',
          timestamp: '08:30 AM',
          isStaff: true,
        ),
        const ChatMessage(
          id: 'm2',
          channelId: 'kakamega_general',
          senderId: 'student_2',
          senderName: 'Mercy Chebet',
          text: 'Amen Pastor Eric! Looking forward to discussing the Wheel Illustration.',
          timestamp: '08:45 AM',
          isStaff: false,
        ),
        const ChatMessage(
          id: 'm3',
          channelId: 'kakamega_general',
          senderId: 'student_1',
          senderName: 'Elvis Mowdi',
          text: 'Don\'t forget to complete the realtime assignment on the app before Saturday session!',
          timestamp: '09:15 AM',
          isStaff: false,
        ),
      ],
      'bible_study_circle': [
        const ChatMessage(
          id: 'b1',
          channelId: 'bible_study_circle',
          senderId: 'staff_2',
          senderName: 'Daniel Otanga',
          text: 'Scripture focus for Saturday: 2 Timothy 2:2. Reflect on who you are discipling.',
          timestamp: '11:00 AM',
          isStaff: true,
        ),
        const ChatMessage(
          id: 'b2',
          channelId: 'bible_study_circle',
          senderId: 'student_3',
          senderName: 'Brian Ochieng',
          text: 'Noted! I have submitted my assignment questions.',
          timestamp: '11:45 AM',
          isStaff: false,
        ),
      ],
      'staff_prep_forum': [
        const ChatMessage(
          id: 's1',
          channelId: 'staff_prep_forum',
          senderId: 'staff_1',
          senderName: 'Eric Opilo',
          text: 'Staff Prep agenda for Friday 5:00 PM: 1. Review student assignment submissions, 2. Saturday Bible Study leader assignments, 3. Missions Conference mobilization roster.',
          timestamp: 'Yesterday',
          isStaff: true,
        ),
        const ChatMessage(
          id: 's2',
          channelId: 'staff_prep_forum',
          senderId: 'staff_3',
          senderName: 'Hellen Angulu',
          text: 'Confirmed. I have prepared the attendance records for review.',
          timestamp: 'Yesterday',
          isStaff: true,
        ),
      ],
      'prayer_chain': [
        const ChatMessage(
          id: 'p1',
          channelId: 'prayer_chain',
          senderId: 'student_4',
          senderName: 'Faith Wangari',
          text: 'Please pray for the high school outreach happening this weekend in Kakamega.',
          timestamp: '07:20 AM',
          isStaff: false,
        ),
        const ChatMessage(
          id: 'p2',
          channelId: 'prayer_chain',
          senderId: 'student_1',
          senderName: 'Elvis Mowdi',
          text: 'Praying with you Faith! May the Lord grant bold witnesses.',
          timestamp: '07:35 AM',
          isStaff: false,
        ),
      ],
      'general': [
        const ChatMessage(
          id: 'm1',
          channelId: 'general',
          senderId: 'staff_1',
          senderName: 'Eric Opilo (Staff)',
          text: 'Praise the Lord team! Reminder that Saturday Bible Study is on from 9:00 AM to 12:00 PM sharp.',
          timestamp: '08:30 AM',
          isStaff: true,
        ),
        const ChatMessage(
          id: 'm2',
          channelId: 'general',
          senderId: 'student_2',
          senderName: 'Mercy Chebet',
          text: 'Amen Pastor Eric! Looking forward to discussing the Wheel Illustration and Romans 8.',
          timestamp: '08:45 AM',
          isStaff: false,
        ),
        const ChatMessage(
          id: 'm3',
          channelId: 'general',
          senderId: 'student_1',
          senderName: 'Elvis Mowdi',
          text: 'Don\'t forget to complete the realtime assignment on the app before Saturday session!',
          timestamp: '09:15 AM',
          isStaff: false,
        ),
      ],
      'prayer': [
        const ChatMessage(
          id: 'p1',
          channelId: 'prayer',
          senderId: 'student_4',
          senderName: 'Faith Wangari',
          text: 'Please pray for the high school outreach happening this weekend in Kakamega.',
          timestamp: '07:20 AM',
          isStaff: false,
        ),
        const ChatMessage(
          id: 'p2',
          channelId: 'prayer',
          senderId: 'student_1',
          senderName: 'Elvis Mowdi',
          text: 'Praying with you Faith! May the Lord grant bold witnesses and softened hearts.',
          timestamp: '07:35 AM',
          isStaff: false,
        ),
        const ChatMessage(
          id: 'p3',
          channelId: 'prayer',
          senderId: 'student_3',
          senderName: 'Brian Ochieng',
          text: 'Can someone send the link for Thursday morning dawn prayer call?',
          timestamp: '10:00 AM',
          isStaff: false,
        ),
      ],
      'announcements': [
        const ChatMessage(
          id: 'a1',
          channelId: 'announcements',
          senderId: 'staff_2',
          senderName: 'Daniel Otanga (Staff)',
          text: '📣 ANNOUNCEMENT: Missions Conference 2026 mobilization is live! Tap the Events tab to RSVP your attendance.',
          timestamp: '10:30 AM',
          isStaff: true,
        ),
        const ChatMessage(
          id: 'a2',
          channelId: 'announcements',
          senderId: 'staff_1',
          senderName: 'Eric Opilo (Staff)',
          text: '📣 Core Combat registration has officially opened. Please confirm with your small group leader before Friday.',
          timestamp: 'Yesterday',
          isStaff: true,
        ),
      ],
      'staff': [
        const ChatMessage(
          id: 's1',
          channelId: 'staff',
          senderId: 'staff_1',
          senderName: 'Eric Opilo',
          text: 'Staff Prep agenda for Friday 5:00 PM: 1. Review student assignment submissions, 2. Saturday Bible Study leader assignments, 3. Missions Conference mobilization roster.',
          timestamp: 'Yesterday',
          isStaff: true,
        ),
        const ChatMessage(
          id: 's2',
          channelId: 'staff',
          senderId: 'staff_3',
          senderName: 'Hellen Angulu',
          text: 'Confirmed. I have prepared the attendance records and assignment review rubrics.',
          timestamp: 'Yesterday',
          isStaff: true,
        ),
      ],
    };

    _tmsVerses = [
      const TMSVerse(
        id: 'v1',
        reference: '2 Timothy 3:16',
        text: 'All Scripture is God-breathed and is useful for teaching, rebuking, correcting and training in righteousness,',
        topic: 'Living the New Life',
        pack: 1,
        memorizedMemberIds: ['student_1', 'student_2', 'student_3'],
      ),
      const TMSVerse(
        id: 'v2',
        reference: 'Joshua 1:8',
        text: 'Keep this Book of the Law always on your lips; meditate on it day and night, so that you may be careful to do everything written in it. Then you will be prosperous and successful.',
        topic: 'Living the New Life',
        pack: 1,
        memorizedMemberIds: ['student_1', 'student_2'],
      ),
      const TMSVerse(
        id: 'v3',
        reference: 'John 3:16',
        text: 'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.',
        topic: 'Christ the Center',
        pack: 1,
        memorizedMemberIds: ['student_1', 'student_2', 'student_3', 'student_4', 'student_6'],
      ),
      const TMSVerse(
        id: 'v4',
        reference: 'Romans 3:23',
        text: 'for all have sinned and fall short of the glory of God,',
        topic: 'Proclaiming Christ',
        pack: 1,
        memorizedMemberIds: ['student_1', 'student_3'],
      ),
      const TMSVerse(
        id: 'v5',
        reference: 'Romans 6:23',
        text: 'For the wages of sin is death, but the gift of God is eternal life in Christ Jesus our Lord.',
        topic: 'Proclaiming Christ',
        pack: 1,
        memorizedMemberIds: ['student_1'],
      ),
      const TMSVerse(
        id: 'v6',
        reference: 'Philippians 4:6-7',
        text: 'Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God. And the peace of God, which transcends all understanding, will guard your hearts and your minds in Christ Jesus.',
        topic: 'Relying on God\'s Resources',
        pack: 1,
        memorizedMemberIds: ['student_2', 'student_6'],
      ),
      const TMSVerse(
        id: 'v7',
        reference: 'Matthew 28:19-20',
        text: 'Therefore go and make disciples of all nations, baptizing them in the name of the Father and of the Son and of the Holy Spirit, and teaching them to obey everything I have commanded you. And surely I am with you always, to the very end of the age.',
        topic: 'Growing to Be Like Christ',
        pack: 1,
        memorizedMemberIds: ['student_1', 'student_3', 'student_7'],
      ),
      const TMSVerse(
        id: 'v8',
        reference: '1 John 1:9',
        text: 'If we confess our sins, he is faithful and just and will forgive us our sins and purify us from all unrighteousness.',
        topic: 'Living the New Life',
        pack: 1,
        memorizedMemberIds: ['student_2', 'student_4'],
      ),
      const TMSVerse(
        id: 'v9',
        reference: 'Hebrews 4:12',
        text: 'For the word of God is alive and active. Sharper than any double-edged sword, it penetrates even to dividing soul and spirit, joints and marrow; it judges the thoughts and attitudes of the heart.',
        topic: 'Proclaiming Christ',
        pack: 2,
        memorizedMemberIds: ['student_1'],
      ),
      const TMSVerse(
        id: 'v10',
        reference: 'Proverbs 3:5-6',
        text: 'Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight.',
        topic: 'Relying on God\'s Resources',
        pack: 2,
        memorizedMemberIds: ['student_1', 'student_6'],
      ),
    ];
  }
}
