import 'package:flutter/material.dart';

import 'package:quran_app/services/student_services/annual_report_pdf_service.dart';
import 'package:quran_app/services/student_services/student_info.dart';

// ─────────────────────────────────────────────
// Entry point
// ─────────────────────────────────────────────
class AssessmentResultsScreen extends StatefulWidget {
  const AssessmentResultsScreen({super.key});

  @override
  State<AssessmentResultsScreen> createState() =>
      _AssessmentResultsScreenState();
}

class _AssessmentResultsScreenState extends State<AssessmentResultsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<String> _tabLabels = [
    'الفصل الأول',
    'الفصل الثاني',
    'الفصل الثالث',
    'الدورة الصيفية',
  ];

  // بيانات الطالب التجريبية (Mock) المستخدمة في كشف النقاط السنوي.
  // لا يوجد أي اتصال بقاعدة بيانات أو واجهة خلفية (API).
  final StudentInfo _studentInfo = const StudentInfo(
    name: 'أحمد بن محمد',
    registrationNumber: 'REG-2026-0145',
    group: 'فوج 1',
    academicYear: '2025 / 2026',
  );

  // يُستخدم لتعطيل الزر وعرض مؤشر تحميل أثناء توليد وحفظ الملف.
  bool _isGeneratingPdf = false;

  // ── Mock data: [examScore, continuousScore] per subject per semester ──
  // null = not yet entered (simulates an empty cell)
  final List<String> subjects = [
    'الحفظ',
    'التجويد',
    'التفسير',
    'السيرة النبوية',
  ];

  // Each semester: List<[exam, continuous]>  — index matches subjects list
  final List<List<List<double?>>> semesterGrades = [
    // الفصل الأول
    [
      [16.0, 18.0],
      [14.5, 15.0],
      [17.0, 16.5],
      [13.0, 14.0],
      [15.5, 17.0],
    ],
    // الفصل الثاني
    [
      [18.0, 17.5],
      [16.0, 15.5],
      [14.0, 13.5],
      [15.0, 16.0],
      [17.5, 18.0],
    ],
    // الفصل الثالث
    [
      [15.0, 16.0],
      [13.5, 14.0],
      [16.5, 17.0],
      [14.5, 15.5],
      [18.0, 17.0],
    ],
    // الدورة الصيفية
    [
      [17.0, 18.5],
      [15.5, 16.0],
      [10, 5], // intentionally empty to demo disabled PDF btn
      [16.0, 15.0],
      [14.5, 13.5],
    ],
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Helpers ──
  double? _final(double? exam, double? cont) {
    if (exam == null || cont == null) return null;
    return (exam * 0.5 + cont * 0.5);
  }

  double? _semesterAverage(int semIndex) {
    final grades = semesterGrades[semIndex];
    final finals = grades.map((g) => _final(g[0], g[1])).toList();
    if (finals.any((f) => f == null)) return null;
    return finals.fold(0.0, (sum, f) => sum + f!) / finals.length;
  }

  bool _semesterComplete(int semIndex) =>
      semesterGrades[semIndex].every((g) => g[0] != null && g[1] != null);

  double? _annualAverage() {
    final avgs = List.generate(4, (i) => _semesterAverage(i));
    if (avgs.any((a) => a == null)) return null;
    return avgs.fold(0.0, (sum, a) => sum + a!) / avgs.length;
  }

  Color _gradeColor(double? val) {
    if (val == null) return Colors.grey;
    if (val >= 16) return Colors.green.shade600;
    if (val >= 10) return Colors.orange.shade600;
    return Colors.red.shade400;
  }

  String _fmt(double? v) =>
      v == null ? '—' : v.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');

  String _appreciation(double? v) {
    if (v == null) return '';
    if (v >= 18) return 'ممتاز';
    if (v >= 16) return 'جيد جداً';
    if (v >= 14) return 'جيد';
    if (v >= 10) return 'مقبول';
    return 'ضعيف';
  }

  /// يولّد كشف النقاط السنوي بصيغة PDF ويحفظه على الجهاز، ثم يعرض رسالة
  /// نجاح أو فشل عبر SnackBar. كل منطق إنشاء وحفظ الملف موجود في
  /// AnnualReportPdfService بشكل منفصل تمامًا عن هذه الشاشة.
  Future<void> _handleDownloadAnnualReport() async {
    setState(() => _isGeneratingPdf = true);

    try {
      final file = await AnnualReportPdfService.generateAndSaveAnnualReport(
        studentInfo: _studentInfo,
        tabLabels: _tabLabels,
        subjects: subjects,
        semesterGrades: semesterGrades,
        semesterAverageFn: _semesterAverage,
        annualAverageFn: _annualAverage,
        finalFn: _final,
        fmtFn: _fmt,
        appreciationFn: _appreciation,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          content: Text('✅ تم حفظ كشف النقاط بنجاح في:\n${file.path}'),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          content: Text('حدث خطأ أثناء إنشاء كشف النقاط: $e'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // Annual report card is only unlocked once ALL four periods are complete.
    final bool allSemestersComplete = List.generate(
      _tabLabels.length,
      (i) => _semesterComplete(i),
    ).every((complete) => complete);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffF4FBF6),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),

              backgroundColor: Colors.green.shade600,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'نتائج الاختبارات',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // ── Tab bar ──
            _buildTabBar(),

            // ── Body ──
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                  _tabLabels.length,
                  (i) => _buildTabContent(i),
                ),
              ),
            ),
          ],
        ),

        // ── Annual report-card download button (single, page-level) ──
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: allSemestersComplete
              ? Colors.green.shade600
              : Colors.grey.shade400,
          onPressed: (allSemestersComplete && !_isGeneratingPdf)
              ? _handleDownloadAnnualReport
              : null,
          icon: _isGeneratingPdf
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : null,
          label: Text(
            _isGeneratingPdf
                ? 'جاري التحميل...'
                : '📄  تحميل كشف النقاط السنوي',
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  // ────────────────────────────────────────────
  // Tab bar widget
  // ────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: Colors.green.shade600,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        tabs: _tabLabels.map((t) => Tab(text: t)).toList(),
      ),
    );
  }

  // ────────────────────────────────────────────
  // Per-tab content
  // ────────────────────────────────────────────
  Widget _buildTabContent(int semIndex) {
    final double? semAvg = _semesterAverage(semIndex);
    final bool complete = _semesterComplete(semIndex);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Semester label chip
          _semesterHeader(semIndex),
          const SizedBox(height: 16),

          // Results table
          _buildResultsTable(semIndex),
          const SizedBox(height: 16),

          // Semester average card
          _buildSemesterAverageCard(semAvg, complete),
          const SizedBox(height: 24),

          // Annual summary
          _buildAnnualSummary(),
        ],
      ),
    );
  }

  Widget _semesterHeader(int semIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.lightGreenAccent.shade200],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.school, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Text(
            _tabLabels[semIndex],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${subjects.length} مواد',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────
  // Results table
  // ────────────────────────────────────────────
  Widget _buildResultsTable(int semIndex) {
    final grades = semesterGrades[semIndex];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 32,
          ),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(2.2),
              1: FlexColumnWidth(1.6),
              2: FlexColumnWidth(1.9),
              3: FlexColumnWidth(1.6),
            },
            children: [
              // Header row
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                children: [
                  _headerCell('المادة'),
                  _headerCell('الامتحان\n(/20)'),
                  _headerCell('التقييم المستمر\n(/20)'),
                  _headerCell('المعدل النهائي'),
                ],
              ),
              // Data rows
              ...List.generate(subjects.length, (i) {
                final exam = grades[i][0];
                final cont = grades[i][1];
                final fin = _final(exam, cont);
                final isLast = i == subjects.length - 1;
                return TableRow(
                  decoration: BoxDecoration(
                    color: i.isEven ? Colors.white : Colors.grey.shade50,
                    borderRadius: isLast
                        ? const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          )
                        : null,
                  ),
                  children: [
                    _subjectCell(subjects[i]),
                    _gradeCell(_fmt(exam), _gradeColor(exam)),
                    _gradeCell(_fmt(cont), _gradeColor(cont)),
                    _finalCell(fin, _fmt(fin), _gradeColor(fin)),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Colors.green.shade800,
        ),
      ),
    );
  }

  Widget _subjectCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Row(
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 16,
            color: Colors.green.shade400,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradeCell(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: text == '—'
                ? Colors.grey.shade100
                : color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: text == '—' ? Colors.grey.shade400 : color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _finalCell(double? val, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: val == null
                ? Colors.grey.shade100
                : color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: val == null ? Colors.grey.shade300 : color,
              width: 1.2,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: val == null ? Colors.grey.shade400 : color,
            ),
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────
  // Semester average card
  // ────────────────────────────────────────────
  Widget _buildSemesterAverageCard(double? avg, bool complete) {
    final Color c = _gradeColor(avg);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: complete ? c.withValues(alpha: 0.1) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.calculate_outlined,
              color: complete ? c : Colors.grey.shade400,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'معدل الفصل',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                complete ? '${_fmt(avg)} / 20' : 'بيانات غير مكتملة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: complete ? c : Colors.grey.shade400,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (complete)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: c.withValues(alpha: 0.4)),
              ),
              child: Text(
                _appreciation(avg),
                style: TextStyle(
                  color: c,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────
  // Annual summary section
  // ────────────────────────────────────────────
  Widget _buildAnnualSummary() {
    final double? annualAvg = _annualAverage();
    final List<double?> semAvgs = List.generate(4, (i) => _semesterAverage(i));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.bar_chart,
                color: Colors.green.shade700,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'الملخص السنوي',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Per-semester average chips
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.3,
          children: List.generate(4, (i) {
            final avg = semAvgs[i];
            final c = _gradeColor(avg);
            final complete = _semesterComplete(i);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade50,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _tabLabels[i],
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    complete ? '${_fmt(avg)} / 20' : '—',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: complete ? c : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),

        const SizedBox(height: 16),

        // Annual average highlight card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: annualAvg != null
                  ? [Colors.green.shade600, Colors.lightGreenAccent.shade200]
                  : [Colors.grey.shade300, Colors.grey.shade200],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: annualAvg != null
                    ? Colors.green.shade200
                    : Colors.grey.shade200,
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Big score
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'المعدل السنوي العام',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    annualAvg != null ? '${_fmt(annualAvg)} / 20' : 'غير مكتمل',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (annualAvg != null)
                    Text(
                      _appreciation(annualAvg),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              // Star icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  annualAvg != null
                      ? Icons.emoji_events
                      : Icons.hourglass_empty,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
