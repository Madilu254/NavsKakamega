import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navs_kakamega/models/member.dart';
import 'package:navs_kakamega/models/event.dart';
import 'package:navs_kakamega/models/assignment.dart';
import 'package:navs_kakamega/models/submission.dart';
import 'package:navs_kakamega/widgets/whatsapp_chat_bubble.dart';
import 'package:navs_kakamega/models/chat_message.dart';
import 'package:navs_kakamega/widgets/attendance_gauge.dart';
import 'package:navs_kakamega/models/tms_verse.dart';

void main() {
  group('Navigators Kakamega Models & Features Tests', () {
    test('Member attendance frequency calculation', () {
      const student = Member(
        id: '1',
        idNumber: 'NAV/KK/001',
        firstName: 'Elvis',
        lastName: 'Mowdi',
        username: 'elvis',
        email: 'elvis@navs.org',
        phone: '0712345678',
        role: 'Student',
        attendedSessions: 7,
        totalSessions: 8,
      );

      expect(student.fullName, 'Elvis Mowdi');
      expect(student.isStaff, false);
      expect(student.attendancePercentage, 88);
    });

    test('Staff member role and permissions', () {
      const staff = Member(
        id: '2',
        idNumber: 'STAFF/KK/001',
        firstName: 'Eric',
        lastName: 'Opilo',
        username: 'eric',
        email: 'opiloeric395@gmail.com',
        phone: '0700000089',
        role: 'Staff',
        attendedSessions: 8,
        totalSessions: 8,
      );

      expect(staff.isStaff, true);
      expect(staff.attendancePercentage, 100);
    });

    test('Incoming Events mobilization progress and RSVP', () {
      const event = NavsEvent(
        id: 'conf_1',
        title: 'Missions Conference 2026',
        subtitle: 'Reaching Campus and Beyond',
        date: 'Oct 24-26, 2026',
        time: '9:00 AM',
        venue: 'Kakamega Assembly',
        description: 'East Africa Missions Conference',
        category: 'Conference',
        targetMobilization: 100,
        rsvps: ['user_1', 'user_2', 'user_3'],
      );

      expect(event.rsvpCount, 3);
      expect(event.isUserRsvpd('user_1'), true);
      expect(event.isUserRsvpd('user_99'), false);
      expect(event.mobilizationProgress, 0.03);
    });

    test('Realtime assignment and submission verification', () {
      const assignment = Assignment(
        id: 'assign_1',
        title: 'Week 4: The Wheel Illustration',
        weekNumber: 4,
        dueDate: 'Saturday 8:30 AM',
        passage: 'Galatians 2:20',
        instructions: 'Answer questions on your phone',
        questions: ['Question 1', 'Question 2'],
        category: 'Bible Study',
        createdByStaffId: 'staff_1',
        createdAt: '2026-09-14',
      );

      expect(assignment.questions.length, 2);

      const submission = Submission(
        id: 'sub_1',
        assignmentId: 'assign_1',
        studentId: 'student_1',
        studentName: 'Elvis Mowdi',
        studentPhone: '+254 712 345 678',
        submittedAt: '2026-09-14T10:00:00Z',
        status: 'Reviewed',
        score: 95,
        staffFeedback: 'Great application of Christ the Center!',
        answers: {'0': 'Christ is Lord', '1': 'Fellowship spoke'},
      );

      expect(submission.isReviewed, true);
      expect(submission.score, 95);
      expect(submission.answers['0'], 'Christ is Lord');
    });

    testWidgets('WhatsApp chat bubble widget test', (WidgetTester tester) async {
      const msg = ChatMessage(
        id: 'm1',
        channelId: 'general',
        senderId: 'staff_1',
        senderName: 'Eric Opilo',
        text: 'Saturday Bible Study is at 9:00 AM!',
        timestamp: '09:00 AM',
        isStaff: true,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WhatsAppChatBubble(message: msg, isMe: false),
          ),
        ),
      );

      expect(find.text('Saturday Bible Study is at 9:00 AM!'), findsOneWidget);
      expect(find.text('Eric Opilo'), findsOneWidget);
      expect(find.text('STAFF'), findsOneWidget);
    });

    testWidgets('Attendance frequency gauge widget test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AttendanceGauge(
              percentage: 88,
              attended: 7,
              total: 8,
            ),
          ),
        ),
      );

      expect(find.text('88%'), findsOneWidget);
      expect(find.text('7 of 8 Sessions Attended'), findsOneWidget);
      expect(find.text('Faithful Attendee 🔥'), findsOneWidget);
    });

    test('TMSVerse memorization check and JSON serialization', () {
      const verse = TMSVerse(
        id: 'v1',
        reference: '2 Timothy 3:16',
        text: 'All Scripture is God-breathed...',
        topic: 'Living the New Life',
        pack: 1,
        memorizedMemberIds: ['user_1', 'user_2'],
      );

      expect(verse.isMemorizedBy('user_1'), true);
      expect(verse.isMemorizedBy('user_99'), false);
      expect(verse.pack, 1);

      final json = verse.toJson();
      final fromJson = TMSVerse.fromJson(json);
      expect(fromJson.reference, '2 Timothy 3:16');
      expect(fromJson.memorizedMemberIds.length, 2);
    });

    test('Assignment type parsing and default assignment category', () {
      final json = {
        'id': 'a1',
        'title': 'Romans 8 Deep Dive',
        'type': 'reading',
        'category': 'Bible Study',
        'dueDate': '2026-09-20',
        'questions': ['Q1', 'Q2'],
      };
      final parsed = Assignment.fromJson(json);
      expect(parsed.type, 'reading');
      expect(parsed.category, 'Bible Study');
    });
  });
}
