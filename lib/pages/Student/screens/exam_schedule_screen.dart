import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quran_app/utils/date_formatter.dart';

/// شاشة جدول الاختبارات
///
/// تعرض بطاقة مميزة لأقرب اختبار قادم في الأعلى، ثم قائمة بكل
/// الاختبارات كبطاقات متجاوبة مع شارة حالة لكل اختبار (قادم / اليوم / منتهي).
///
/// ملاحظة: جميع البيانات هنا بيانات تجريبية (Mock) فقط،
/// لا يوجد أي اتصال بقاعدة بيانات أو واجهة خلفية (API).
class ExamScheduleScreen extends StatefulWidget {
  const ExamScheduleScreen({super.key});

  @override
  State<ExamScheduleScreen> createState() => _ExamScheduleScreenState();
}

class _ExamScheduleScreenState extends State<ExamScheduleScreen> {
  // ---------------------------------------------------------------------
  // بيانات تجريبية (Mock Data)
  // ---------------------------------------------------------------------
  //
  // التواريخ محسوبة بشكل نسبي من تاريخ اليوم (DateTime.now) بدل تواريخ
  // ثابتة، حتى تبقى شارات "اليوم" و"قادم" و"منتهي" منطقية بغض النظر
  // عن وقت تشغيل التطبيق.

  late final List<Map<String, dynamic>> examSchedule = _generateMockExams();

  List<Map<String, dynamic>> _generateMockExams() {
    final now = DateTime.now();
    DateTime onlyDate(DateTime d) => DateTime(d.year, d.month, d.day);

    return [
      {
        'subject': 'الحفظ',
        'date': onlyDate(now.add(const Duration(days: 2))),
        'time': '09:00 - 11:00',
        'location': 'قاعة 1',
      },
      {
        'subject': 'التفسير',
        'date': onlyDate(now),
        'time': '10:00 - 12:00',
        'location': 'قاعة 3',
      },
      {
        'subject': 'التجويد',
        'date': onlyDate(now.add(const Duration(days: 5))),
        'time': '13:00 - 15:00',
        'location': 'قاعة 2',
      },
      {
        'subject': 'الفقه',
        'date': onlyDate(now.add(const Duration(days: 10))),
        'time': '11:00 - 13:00',
        'location': 'قاعة 1',
      },
      {
        'subject': 'السيرة النبوية',
        'date': onlyDate(now.subtract(const Duration(days: 3))),
        'time': '14:00 - 16:00',
        'location': 'قاعة 4',
      },
    ];
  }

  // ---------------------------------------------------------------------
  // أدوات مساعدة (الحالة / التنسيق)
  // ---------------------------------------------------------------------

  static final Color _gradientStart = Colors.purple.shade600;
  static final Color _gradientEnd = Colors.purpleAccent.shade200;

  static final LinearGradient _appGradient = LinearGradient(
    colors: [_gradientStart, _gradientEnd],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  /// قادم / اليوم / منتهي بحسب تاريخ الاختبار مقارنة باليوم الحالي.
  String _statusOf(DateTime examDate) {
    final today = DateTime.now();
    final onlyToday = DateTime(today.year, today.month, today.day);
    if (examDate.isAtSameMomentAs(onlyToday)) return 'اليوم';
    if (examDate.isAfter(onlyToday)) return 'قادم';
    return 'منتهي';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'اليوم':
        return Colors.orange.shade700;
      case 'قادم':
        return Colors.blue.shade600;
      default: // منتهي
        return Colors.grey.shade500;
    }
  }

  String _countdownText(DateTime examDate) {
    final today = DateTime.now();
    final onlyToday = DateTime(today.year, today.month, today.day);
    final int diff = examDate.difference(onlyToday).inDays;
    if (diff == 0) return 'اليوم';
    if (diff == 1) return 'غدًا';
    return 'بعد $diff أيام';
  }

  String _formatDate(DateTime? d) => formatDzDate(d);

  /// أقرب اختبار لم يَفُت موعده بعد (الأقرب من القادم أو اختبار اليوم).
  Map<String, dynamic>? get _nextExam {
    final upcoming =
        examSchedule
            .where((e) => _statusOf(e['date'] as DateTime) != 'منتهي')
            .toList()
          ..sort(
            (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime),
          );
    return upcoming.isEmpty ? null : upcoming.first;
  }

  @override
  Widget build(BuildContext context) {
    final nextExam = _nextExam;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: _appGradient),
          ),
          actions: [
            IconButton(
              icon: Transform.rotate(
                angle: math.pi,
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).maybePop(),
              tooltip: 'رجوع',
            ),
          ],
          title: const Text(
            'جدول الاختبارات',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (nextExam != null) ...[
                  _buildNextExamCard(nextExam),
                  const SizedBox(height: 18),
                ],
                _buildSectionHeader(),
                const SizedBox(height: 10),
                if (examSchedule.isEmpty)
                  _buildEmptyState()
                else
                  LayoutBuilder(
                    builder: (context, constraints) =>
                        _buildResponsiveList(constraints),
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // بطاقة "أقرب اختبار"
  // ---------------------------------------------------------------------

  Widget _buildNextExamCard(Map<String, dynamic> exam) {
    final DateTime date = exam['date'] as DateTime;
    final String status = _statusOf(date);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: _appGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _gradientStart.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event_available, color: Colors.amber, size: 18),
              const SizedBox(width: 6),
              const Text(
                'أقرب اختبار',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              _statusBadge(status, light: true),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            exam['subject'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 10),
          _infoRow(Icons.calendar_today, _formatDate(date), light: true),
          const SizedBox(height: 6),
          _infoRow(Icons.access_time, exam['time'] as String, light: true),
          const SizedBox(height: 6),
          _infoRow(Icons.location_on, exam['location'] as String, light: true),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
              ),
              child: Text(
                _countdownText(date),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Icon(Icons.assignment_outlined, color: _gradientStart, size: 20),
        const SizedBox(width: 6),
        Text(
          'جميع الاختبارات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.purple.shade900,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // قائمة الاختبارات المتجاوبة
  // ---------------------------------------------------------------------

  Widget _buildResponsiveList(BoxConstraints constraints) {
    final double width = constraints.maxWidth;
    final int columns = width >= 1100 ? 3 : (width >= 700 ? 2 : 1);

    final sorted = [
      ...examSchedule,
    ]..sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    final cards = sorted.map((exam) => _examCard(exam)).toList();

    if (columns == 1) {
      return Column(
        children: cards
            .map(
              (c) =>
                  Padding(padding: const EdgeInsets.only(bottom: 12), child: c),
            )
            .toList(),
      );
    }

    const double spacing = 12;
    final double cardWidth = (width - (columns - 1) * spacing) / columns;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: cards.map((c) => SizedBox(width: cardWidth, child: c)).toList(),
    );
  }

  Widget _examCard(Map<String, dynamic> exam) {
    final DateTime date = exam['date'] as DateTime;
    final String status = _statusOf(date);
    final bool isToday = status == 'اليوم';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isToday ? Colors.orange.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isToday
            ? Border(right: BorderSide(color: Colors.orange.shade400, width: 4))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  exam['subject'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _statusBadge(status),
            ],
          ),
          const SizedBox(height: 8),
          _infoRow(Icons.calendar_today, _formatDate(date)),
          const SizedBox(height: 4),
          _infoRow(Icons.access_time, exam['time'] as String),
          const SizedBox(height: 4),
          _infoRow(Icons.location_on, exam['location'] as String),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // عناصر مساعدة للعرض
  // ---------------------------------------------------------------------

  Widget _infoRow(IconData icon, String text, {bool light = false}) {
    final Color color = light
        ? Colors.white.withValues(alpha: 0.9)
        : Colors.grey[600]!;
    return Row(
      children: [
        Icon(
          icon,
          size: 13,
          color: light
              ? Colors.white.withValues(alpha: 0.85)
              : Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: light ? 13 : 12, color: color),
        ),
      ],
    );
  }

  Widget _statusBadge(String status, {bool light = false}) {
    final Color color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: light ? Colors.white : color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: light ? color : Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Text('📅', style: TextStyle(fontSize: 46)),
            const SizedBox(height: 10),
            Text(
              'لا توجد اختبارات مجدولة حالياً.',
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
