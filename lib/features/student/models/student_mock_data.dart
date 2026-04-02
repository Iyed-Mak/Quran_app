// Mock data for the student area until API integration.

import 'package:intl/intl.dart';

class StudentProfile {
  StudentProfile({
    required this.fullName,
    required this.studentId,
    required this.gradeLevel,
    required this.section,
    required this.phone,
    required this.email,
    required this.guardianName,
  });

  String fullName;
  String studentId;
  String gradeLevel;
  String section;
  String phone;
  String email;
  String guardianName;
}

class ExamResultItem {
  ExamResultItem({
    required this.subject,
    required this.examTitle,
    required this.score,
    required this.maxScore,
    required this.date,
    this.analysisHint,
  });

  final String subject;
  final String examTitle;
  final double score;
  final double maxScore;
  final DateTime date;
  final String? analysisHint;

  double get percentage => maxScore == 0 ? 0 : (score / maxScore) * 100;
}

class GradeBreakdown {
  GradeBreakdown({
    required this.label,
    required this.points,
    required this.maxPoints,
  });

  final String label;
  final double points;
  final double maxPoints;
}

class GradeReportItem {
  GradeReportItem({
    required this.examTitle,
    required this.subject,
    required this.date,
    required this.breakdown,
  });

  final String examTitle;
  final String subject;
  final DateTime date;
  final List<GradeBreakdown> breakdown;
}

class ScheduledExam {
  ScheduledExam({
    required this.subject,
    required this.title,
    required this.start,
    required this.room,
  });

  final String subject;
  final String title;
  final DateTime start;
  final String room;

  bool isWithinDays(int days) {
    final now = DateTime.now();
    final end = now.add(Duration(days: days));
    return !start.isBefore(now) && start.isBefore(end);
  }
}

final DateFormat scheduleFormat = DateFormat('yyyy/MM/dd — HH:mm', 'ar');

StudentProfile mockStudentProfile = StudentProfile(
  fullName: 'أحمد محمد العلي',
  studentId: 'ST-2024-0142',
  gradeLevel: 'الصف الثالث متوسط',
  section: 'أ',
  phone: '05xxxxxxxx',
  email: 'ahmed.student@school.edu',
  guardianName: 'محمد العلي',
);

final List<double> mockDailyScores = [72, 85, 78, 90, 88, 82, 91];
final List<double> mockMonthlyScores = [68, 70, 75, 78, 80, 82, 85, 86, 88];

final List<ExamResultItem> mockExamResults = [
  ExamResultItem(
    subject: 'التجويد',
    examTitle: 'اختبار نصف الفصل — مخارج الحروف',
    score: 42,
    maxScore: 50,
    date: DateTime(2026, 2, 10),
    analysisHint:
        'أداء جيد في المدود؛ ركّز على أحكام النون الساكنة والتنوين في المراجعة القادمة.',
  ),
  ExamResultItem(
    subject: 'الحفظ والمراجعة',
    examTitle: 'جلسة تقييم — سورة البقرة (مقتطف)',
    score: 38,
    maxScore: 40,
    date: DateTime(2026, 2, 5),
    analysisHint:
        'الحفظ متقن؛ حسّن الربط بين الآيات وثبات الإيقاع في التلاوة الجماعية.',
  ),
  ExamResultItem(
    subject: 'التفسير المبسط',
    examTitle: 'اختبار مفاهيم وآيات',
    score: 44,
    maxScore: 50,
    date: DateTime(2026, 1, 28),
  ),
];

final List<GradeReportItem> mockGradeReports = [
  GradeReportItem(
    examTitle: 'اختبار نصف الفصل — التجويد',
    subject: 'التجويد',
    date: DateTime(2026, 2, 10),
    breakdown: [
      GradeBreakdown(label: 'مخارج الحروف', points: 18, maxPoints: 20),
      GradeBreakdown(label: 'صفات الحروف', points: 16, maxPoints: 20),
      GradeBreakdown(label: 'أحكام الميم والنون', points: 8, maxPoints: 10),
    ],
  ),
  GradeReportItem(
    examTitle: 'جلسة تقييم — الحفظ',
    subject: 'الحفظ والمراجعة',
    date: DateTime(2026, 2, 5),
    breakdown: [
      GradeBreakdown(label: 'دقة الحفظ', points: 12, maxPoints: 14),
      GradeBreakdown(label: 'التجويد في التلاوة', points: 14, maxPoints: 14),
      GradeBreakdown(label: 'الخشوع والأداء', points: 12, maxPoints: 12),
    ],
  ),
];

List<ScheduledExam> get mockScheduledExams {
  final now = DateTime.now();
  return [
    ScheduledExam(
      subject: 'التجويد',
      title: 'اختبار عملي — المد والغنة',
      start: now.add(const Duration(days: 1, hours: 3)),
      room: 'قاعة التلاوة ١',
    ),
    ScheduledExam(
      subject: 'الحفظ والمراجعة',
      title: 'اختبار حفظ — الجزء المحدد',
      start: now.add(const Duration(days: 5)),
      room: 'مصلى الطلاب',
    ),
    ScheduledExam(
      subject: 'اللغة العربية',
      title: 'قواعد النحو — ربط بالقراءة',
      start: now.add(const Duration(days: 12, hours: 2)),
      room: 'قاعة ٧',
    ),
  ];
}
