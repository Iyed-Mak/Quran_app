import 'package:flutter/material.dart';
import 'evaluation_settings_screen.dart';

// ═══════════════════════════════════════════════════════════════════
// نماذج البيانات (محفوظة كما هي)
// ═══════════════════════════════════════════════════════════════════

class _PeriodData {
  final List<double?> examScores; // للقراءة فقط — أدخلها المعلم
  final double? contEval; // للقراءة فقط — أدخلها المعلم

  const _PeriodData({required this.examScores, this.contEval});

  double? examAvg(int count) {
    final padded = [
      ...examScores,
      ...List<double?>.filled(
        (count - examScores.length).clamp(0, count),
        null,
      ),
    ].take(count).toList();
    if (padded.any((s) => s == null)) return null;
    final vals = padded.whereType<double>().toList();
    return vals.isEmpty ? null : vals.reduce((a, b) => a + b) / count;
  }

  double? periodRate(EvalSettings s) {
    final avg = examAvg(s.examsPerPeriod);
    if (avg == null || contEval == null) return null;
    return avg * s.examWeight + contEval! * s.contWeight;
  }

  bool isComplete(EvalSettings s) => periodRate(s) != null;
}

class _StudentResult {
  final int id;
  final String name;
  final bool isFemale;
  final String group;
  final Map<String, _PeriodData> periods;

  const _StudentResult({
    required this.id,
    required this.name,
    required this.isFemale,
    required this.group,
    required this.periods,
  });

  static const _periodKeys = [
    'الفصل الأول',
    'الفصل الثاني',
    'الفصل الثالث',
    'الدورة الصيفية',
  ];

  double? annualRate(EvalSettings s) {
    final keys = s.summerEnabled ? _periodKeys : _periodKeys.take(3).toList();
    final rates = keys.map((k) => periods[k]?.periodRate(s)).toList();
    if (rates.any((r) => r == null)) return null;
    return rates.whereType<double>().reduce((a, b) => a + b) / keys.length;
  }
}

// ═══════════════════════════════════════════════════════════════════
// شاشة عرض وتأكيد نتائج الاختبارات
// (الإدارة تعرض النتائج وتؤكّدها — لا تعدّل)
// ═══════════════════════════════════════════════════════════════════

class ExamResultsScreen extends StatefulWidget {
  const ExamResultsScreen({super.key});

  @override
  State<ExamResultsScreen> createState() => _ExamResultsScreenState();
}

class _ExamResultsScreenState extends State<ExamResultsScreen>
    with SingleTickerProviderStateMixin {
  // ── ألوان ──
  static const Color _gs = Color(0xff1565C0);
  static const Color _ge = Color(0xff42A5F5);
  static const LinearGradient _grad = LinearGradient(
    colors: [_gs, _ge],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ── ثوابت ──
  static const _ordinals = ['الأول', 'الثاني', 'الثالث', 'الرابع', 'الخامس'];
  static const _groups = ['فوج 1', 'فوج 2', 'فوج 3', 'فوج 4'];
  static const _periods = [
    'الفصل الأول',
    'الفصل الثاني',
    'الفصل الثالث',
    'الدورة الصيفية',
  ];
  static const _years = ['2025 / 2026', '2024 / 2025'];

  // ── حالة الشاشة ──
  late final TabController _tab;
  EvalSettings _settings = const EvalSettings();
  String _selectedYear = '2025 / 2026';
  String? _selectedGroup;
  String _selectedPeriod = 'الفصل الأول';

  // ── حالة التأكيد: مفتاح = الفترة، قيمة = مجموعة معرّفات الطلبة المؤكَّدين ──
  final Map<String, Set<int>> _confirmed = {};

  // ── البيانات (للقراءة فقط — بيانات تجريبية) ──
  late final List<_StudentResult> _allStudents;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (!_tab.indexIsChanging) setState(() {});
      });
    _allStudents = _generateMock();
    for (final p in _periods) _confirmed[p] = {};
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════
  // بيانات تجريبية (للقراءة فقط — أدخلها المعلم)
  // ═══════════════════════════════════════════════════════════════
  _PeriodData _pd(List<double?> s, double? c) =>
      _PeriodData(examScores: s, contEval: c);

  List<_StudentResult> _generateMock() => [
    _StudentResult(
      id: 1,
      name: 'أحمد بن علي',
      isFemale: false,
      group: 'فوج 1',
      periods: {
        'الفصل الأول': _pd([15.0, 17.0, 14.5], 16.0),
        'الفصل الثاني': _pd([16.0, 15.5, 17.0], 15.5),
        'الفصل الثالث': _pd([14.0, 13.5, 15.0], 15.0),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 2,
      name: 'يوسف الإدريسي',
      isFemale: false,
      group: 'فوج 1',
      periods: {
        'الفصل الأول': _pd([18.0, 17.5, 19.0], 18.0),
        'الفصل الثاني': _pd([17.0, 18.0, 16.5], 17.5),
        'الفصل الثالث': _pd([16.0, 17.0, 18.0], 17.0),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 3,
      name: 'محمد الأمين',
      isFemale: false,
      group: 'فوج 2',
      periods: {
        'الفصل الأول': _pd([12.0, 13.5, 11.0], 13.0),
        'الفصل الثاني': _pd([13.0, 12.0, 14.0], 13.5),
        'الفصل الثالث': _pd([12.5, 11.0, 13.5], 12.5),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 4,
      name: 'عبد الرحمن كريم',
      isFemale: false,
      group: 'فوج 2',
      periods: {
        'الفصل الأول': _pd([9.0, 8.5, 10.0], 10.0),
        'الفصل الثاني': _pd([10.5, 11.0, 9.5], 10.5),
        'الفصل الثالث': _pd([10.0, 9.0, 11.0], 11.0),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 5,
      name: 'خالد بن عمر',
      isFemale: false,
      group: 'فوج 3',
      periods: {
        'الفصل الأول': _pd([16.5, 17.0, 15.5], 16.5),
        'الفصل الثاني': _pd([15.0, 16.0, 17.0], 16.0),
        'الفصل الثالث': _pd([14.5, 15.5, 16.0], 15.5),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 6,
      name: 'رشيد مصطفى',
      isFemale: false,
      group: 'فوج 3',
      periods: {
        'الفصل الأول': _pd([14.0, 13.0, 15.0], 14.0),
        'الفصل الثاني': _pd([13.5, 14.5, 13.0], 14.5),
        'الفصل الثالث': _pd([14.0, 13.5, 14.5], 14.0),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 7,
      name: 'بلال التلمساني',
      isFemale: false,
      group: 'فوج 4',
      periods: {
        'الفصل الأول': _pd([19.0, 18.5, 20.0], 19.0),
        'الفصل الثاني': _pd([18.0, 19.0, 18.5], 18.5),
        'الفصل الثالث': _pd([17.5, 18.0, 19.0], 18.0),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 8,
      name: 'زكريا الوناس',
      isFemale: false,
      group: 'فوج 4',
      periods: {
        'الفصل الأول': _pd([11.0, 10.5, 12.0], 11.5),
        'الفصل الثاني': _pd([12.0, 11.5, 13.0], 12.0),
        'الفصل الثالث': _pd([11.5, 12.0, 12.5], 12.0),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 9,
      name: 'مريم الحسيني',
      isFemale: true,
      group: 'فوج 1',
      periods: {
        'الفصل الأول': _pd([17.0, 16.5, 18.0], 17.5),
        'الفصل الثاني': _pd([16.0, 17.0, 16.5], 17.0),
        'الفصل الثالث': _pd([15.0, 16.0, 17.0], 16.5),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 10,
      name: 'سلمى بن عيسى',
      isFemale: true,
      group: 'فوج 1',
      periods: {
        'الفصل الأول': _pd([14.0, 15.5, 13.5], 15.0),
        'الفصل الثاني': _pd([15.0, 14.5, 16.0], 15.5),
        'الفصل الثالث': _pd([13.5, 14.5, 15.0], 14.5),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 11,
      name: 'آمال الشريف',
      isFemale: true,
      group: 'فوج 2',
      periods: {
        'الفصل الأول': _pd([8.5, 9.0, 10.0], 10.0),
        'الفصل الثاني': _pd([10.0, 9.5, 11.0], 10.5),
        'الفصل الثالث': _pd([10.5, 11.0, 10.0], 11.0),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 12,
      name: 'فاطمة الزهراء',
      isFemale: true,
      group: 'فوج 2',
      periods: {
        'الفصل الأول': _pd([19.5, 20.0, 18.5], 19.0),
        'الفصل الثاني': _pd([18.5, 19.0, 20.0], 19.5),
        'الفصل الثالث': _pd([18.0, 19.5, 19.0], 19.0),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 13,
      name: 'زينب الغزالي',
      isFemale: true,
      group: 'فوج 3',
      periods: {
        'الفصل الأول': _pd([13.0, 14.0, 12.5], 13.5),
        'الفصل الثاني': _pd([14.0, 13.5, 15.0], 14.0),
        'الفصل الثالث': _pd([13.5, 14.0, 14.5], 13.5),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 14,
      name: 'هاجر بن محمود',
      isFemale: true,
      group: 'فوج 3',
      periods: {
        'الفصل الأول': _pd([16.0, 15.5, 17.0], 16.0),
        'الفصل الثاني': _pd([15.5, 16.5, 16.0], 16.5),
        'الفصل الثالث': _pd([14.5, 15.0, 16.0], 15.5),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 15,
      name: 'لينة بن صالح',
      isFemale: true,
      group: 'فوج 4',
      periods: {
        'الفصل الأول': _pd([11.0, 12.5, 10.0], 12.0),
        'الفصل الثاني': _pd([12.0, 11.5, 13.0], 12.5),
        'الفصل الثالث': _pd([11.5, 12.0, 12.5], 12.0),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
    _StudentResult(
      id: 16,
      name: 'أمينة بوعلام',
      isFemale: true,
      group: 'فوج 4',
      periods: {
        'الفصل الأول': _pd([17.5, 18.0, 16.5], 17.0),
        'الفصل الثاني': _pd([16.5, 17.5, 18.0], 17.5),
        'الفصل الثالث': _pd([15.5, 16.0, 17.0], 16.5),
        'الدورة الصيفية': _pd([null, null, null], null),
      },
    ),
  ];

  // ═══════════════════════════════════════════════════════════════
  // مساعدات الفلترة والتأكيد
  // ═══════════════════════════════════════════════════════════════

  List<_StudentResult> _filtered(bool female) => _allStudents.where((s) {
    if (s.isFemale != female) return false;
    if (_selectedGroup != null && s.group != _selectedGroup) return false;
    return true;
  }).toList();

  bool _isConfirmed(int id) =>
      _confirmed[_selectedPeriod]?.contains(id) ?? false;

  int _confirmedCount(List<_StudentResult> students) =>
      students.where((s) => _isConfirmed(s.id)).length;

  void _toggleConfirm(int id) {
    setState(() {
      final set = _confirmed[_selectedPeriod] ??= {};
      if (set.contains(id)) {
        set.remove(id);
      } else {
        set.add(id);
      }
    });
  }

  void _confirmAll(List<_StudentResult> students) {
    setState(() {
      _confirmed[_selectedPeriod] = students.map((s) => s.id).toSet();
    });
  }

  Color _gradeColor(double v) {
    if (v >= 16) return Colors.green.shade600;
    if (v >= 14) return Colors.lightGreen.shade700;
    if (v >= 10) return Colors.orange.shade700;
    return Colors.red.shade600;
  }

  String _appreciation(double v) {
    if (v >= 18) return 'ممتاز';
    if (v >= 16) return 'جيد جداً';
    if (v >= 14) return 'جيد';
    if (v >= 10) return 'مقبول';
    return 'ضعيف';
  }

  String _fmt(double v) => v.toStringAsFixed(2);

  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: _grad),
          ),
          title: const Text(
            'عرض وتأكيد نتائج الاختبارات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 17,
            ),
          ),
          actions: [
            Tooltip(
              message: 'إعدادات صيغة الاحتساب',
              child: IconButton(
                icon: const Icon(Icons.tune_outlined, color: Colors.white),
                onPressed: _openSettings,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tab,
                  children: [
                    _buildContent(female: false),
                    _buildContent(female: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── شريط التبويب ──────────────────────────────────────────────
  Widget _buildTabBar() {
    final m = _allStudents.where((s) => !s.isFemale).length;
    final f = _allStudents.where((s) => s.isFemale).length;
    return Container(
      color: _gs,
      child: TabBar(
        controller: _tab,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        tabs: [
          Tab(child: _tabLabel('👦  الطلبة', m)),
          Tab(child: _tabLabel('👧  الطالبات', f)),
        ],
      ),
    );
  }

  Widget _tabLabel(String label, int n) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(label),
      const SizedBox(width: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '$n',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );

  // ── محتوى التبويب ─────────────────────────────────────────────
  Widget _buildContent({required bool female}) {
    final students = _filtered(female);
    final completed = students
        .where((s) => s.periods[_selectedPeriod]?.isComplete(_settings) == true)
        .length;
    final confirmed = _confirmedCount(students);
    final rates = students
        .map((s) => s.periods[_selectedPeriod]?.periodRate(_settings))
        .whereType<double>()
        .toList();
    final avgRate = rates.isEmpty
        ? null
        : rates.reduce((a, b) => a + b) / rates.length;
    final annuals = students
        .map((s) => s.annualRate(_settings))
        .whereType<double>()
        .toList();
    final avgAnnual = annuals.isEmpty
        ? null
        : annuals.reduce((a, b) => a + b) / annuals.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilters(),
          const SizedBox(height: 14),
          _buildFormulaChip(),
          const SizedBox(height: 14),
          _buildSummaryCards(
            total: students.length,
            examCount: _settings.examsPerPeriod,
            completed: completed,
            confirmed: confirmed,
            avgRate: avgRate,
            avgAnnual: avgAnnual,
          ),
          const SizedBox(height: 14),
          _buildSectionHeader(students),
          const SizedBox(height: 10),
          if (students.isEmpty) _buildEmptyState() else _buildTable(students),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── شريحة الصيغة ─────────────────────────────────────────────
  Widget _buildFormulaChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.functions_outlined, size: 15, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Flexible(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 12, color: Colors.blue.shade800),
                children: [
                  const TextSpan(text: 'معدل الفترة = '),
                  TextSpan(
                    text: '(متوسط الامتحانات × ${_settings.examPct}%)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' + '),
                  TextSpan(
                    text: '(التقييم المستمر × ${_settings.contPct}%)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── فلاتر ─────────────────────────────────────────────────────
  Widget _buildFilters() {
    return LayoutBuilder(
      builder: (ctx, box) {
        final wide = box.maxWidth >= 700;
        final year = _dd(
          label: 'السنة',
          icon: Icons.school_outlined,
          value: _selectedYear,
          items: _years
              .map((y) => DropdownMenuItem(value: y, child: Text(y)))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selectedYear = v);
          },
        );
        final group = _dd<String?>(
          label: 'الفوج',
          icon: Icons.group_outlined,
          value: _selectedGroup,
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('جميع الأفواج'),
            ),
            ..._groups.map(
              (g) => DropdownMenuItem<String?>(value: g, child: Text(g)),
            ),
          ],
          onChanged: (v) => setState(() => _selectedGroup = v),
        );
        final period = _dd(
          label: 'الفترة',
          icon: Icons.calendar_view_week_outlined,
          value: _selectedPeriod,
          items: _periods
              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selectedPeriod = v);
          },
        );
        if (wide)
          return Row(
            children: [
              Expanded(flex: 2, child: year),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: group),
              const SizedBox(width: 10),
              Expanded(flex: 3, child: period),
            ],
          );
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: year),
                const SizedBox(width: 10),
                Expanded(child: group),
              ],
            ),
            const SizedBox(height: 10),
            period,
          ],
        );
      },
    );
  }

  Widget _dd<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) => DropdownButtonFormField<T>(
    value: value,
    isExpanded: true,
    decoration: InputDecoration(
      hintText: label,
      hintStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),
      prefixIcon: Icon(icon, size: 17, color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _gs, width: 1.5),
      ),
    ),
    items: items,
    onChanged: onChanged,
  );

  // ── بطاقات الملخص ─────────────────────────────────────────────
  Widget _buildSummaryCards({
    required int total,
    required int examCount,
    required int completed,
    required int confirmed,
    required double? avgRate,
    required double? avgAnnual,
  }) {
    final cards = [
      _CardData(
        icon: Icons.people_alt_outlined,
        label: 'عدد الطلبة',
        value: '$total',
        color: Colors.blue.shade700,
      ),
      _CardData(
        icon: Icons.quiz_outlined,
        label: 'عدد الاختبارات',
        value: '$examCount',
        color: Colors.teal.shade600,
      ),
      _CardData(
        icon: Icons.assignment_turned_in_outlined,
        label: 'نتائج مكتملة',
        value: '$completed / $total',
        color: Colors.indigo.shade600,
      ),
      _CardData(
        icon: Icons.verified_outlined,
        label: 'نتائج مؤكَّدة',
        value: '$confirmed / $total',
        color: confirmed == total && total > 0
            ? Colors.green.shade700
            : Colors.orange.shade700,
      ),
      _CardData(
        icon: Icons.bar_chart_outlined,
        label: 'متوسط الفترة',
        value: avgRate != null ? '${_fmt(avgRate)} / 20' : '—',
        color: avgRate != null ? _gradeColor(avgRate) : Colors.grey.shade500,
      ),
      _CardData(
        icon: Icons.emoji_events_outlined,
        label: 'المعدل السنوي العام',
        value: avgAnnual != null ? '${_fmt(avgAnnual)} / 20' : 'غير مكتمل',
        color: avgAnnual != null
            ? _gradeColor(avgAnnual)
            : Colors.grey.shade500,
      ),
    ];
    return LayoutBuilder(
      builder: (ctx, box) {
        final cols = box.maxWidth >= 900 ? 6 : (box.maxWidth >= 600 ? 3 : 2);
        const gap = 10.0;
        final w = (box.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: cards
              .map((d) => SizedBox(width: w, child: _summaryCard(d)))
              .toList(),
        );
      },
    );
  }

  Widget _summaryCard(_CardData d) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      border: Border(right: BorderSide(color: d.color, width: 4)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: d.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(d.icon, color: d.color, size: 18),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                d.label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              Text(
                d.value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: d.color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ── رأس القسم + زر "تأكيد الجميع" ────────────────────────────
  Widget _buildSectionHeader(List<_StudentResult> students) {
    final allConfirmed =
        students.isNotEmpty && students.every((s) => _isConfirmed(s.id));
    return Row(
      children: [
        Icon(Icons.table_chart_outlined, color: _gs, size: 20),
        const SizedBox(width: 8),
        Text(
          'نتائج $_selectedPeriod',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        const Spacer(),
        // أسطورة الألوان
        Wrap(
          spacing: 10,
          children: [
            _legendChip(Icons.lock_outline, 'من المعلم', Colors.blue.shade700),
            _legendChip(Icons.functions, 'محسوب', Colors.indigo.shade600),
            _legendChip(Icons.check_circle, 'مؤكَّدة', Colors.green.shade600),
          ],
        ),
        const SizedBox(width: 12),
        // زر تأكيد / إلغاء تأكيد الجميع
        if (students.isNotEmpty)
          FilledButton.icon(
            onPressed: allConfirmed
                ? () => setState(() => _confirmed[_selectedPeriod]?.clear())
                : () => _confirmAll(students),
            style: FilledButton.styleFrom(
              backgroundColor: allConfirmed
                  ? Colors.grey.shade500
                  : Colors.green.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(
              allConfirmed ? Icons.remove_done : Icons.done_all,
              size: 16,
            ),
            label: Text(
              allConfirmed ? 'إلغاء تأكيد الكل' : 'تأكيد الجميع',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _legendChip(IconData icon, String label, Color color) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 11, color: color),
      const SizedBox(width: 3),
      Text(label, style: TextStyle(fontSize: 10, color: color)),
    ],
  );

  // ═══════════════════════════════════════════════════════════════
  // الجدول
  // ═══════════════════════════════════════════════════════════════

  // عروض الأعمدة
  static const double _wName = 152;
  static const double _wExam = 84;
  static const double _wAvg = 100;
  static const double _wCont = 112;
  static const double _wRate = 100;
  static const double _wAnnual = 112; // المعدل السنوي (جديد)
  static const double _wStatus = 100; // حالة التأكيد (جديد)
  static const double _wAct = 72;

  Widget _buildTable(List<_StudentResult> students) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 32,
        ),
        child: Column(
          children: [
            _buildHeader(),
            ...students.asMap().entries.map(
              (e) => _buildRow(e.value, e.key.isEven),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    color: _gs.withValues(alpha: 0.08),
    child: Row(
      children: [
        _th('#', w: 36),
        _th('اسم الطالب', w: _wName),
        for (int i = 0; i < _settings.examsPerPeriod; i++)
          _th('الاختبار ${_ordinals[i]}', w: _wExam),
        _th('متوسط الامتحانات', w: _wAvg),
        _th('التقييم المستمر', w: _wCont),
        _th('معدل الفترة', w: _wRate),
        _th('المعدل السنوي', w: _wAnnual),
        _th('حالة التأكيد', w: _wStatus),
        _th('الإجراءات', w: _wAct),
      ],
    ),
  );

  Widget _th(String t, {required double w}) => SizedBox(
    width: w,
    child: Text(
      t,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 11.5,
        color: Colors.blue.shade900,
      ),
    ),
  );

  Widget _buildRow(_StudentResult s, bool even) {
    final data = s.periods[_selectedPeriod];
    final avg = data?.examAvg(_settings.examsPerPeriod);
    final rate = data?.periodRate(_settings);
    final annual = s.annualRate(_settings);
    final conf = _isConfirmed(s.id);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: conf
          ? Colors.green.shade50.withValues(alpha: 0.5)
          : (even ? Colors.grey.shade50 : Colors.white),
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
      child: Row(
        children: [
          // #
          SizedBox(
            width: 36,
            child: Center(
              child: Text(
                '${s.id}',
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
            ),
          ),
          // الاسم
          SizedBox(
            width: _wName,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: _gs.withValues(alpha: 0.1),
                  child: Text(
                    s.name.isNotEmpty ? s.name[0] : '؟',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _gs,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        s.group,
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // علامات الامتحانات (للقراءة فقط — من المعلم)
          for (int i = 0; i < _settings.examsPerPeriod; i++)
            SizedBox(
              width: _wExam,
              child: Center(
                child: _teacherScoreCell(
                  data != null && i < data.examScores.length
                      ? data.examScores[i]
                      : null,
                ),
              ),
            ),
          // متوسط الامتحانات (محسوب)
          SizedBox(
            width: _wAvg,
            child: Center(child: _calculatedCell(avg)),
          ),
          // التقييم المستمر (من المعلم)
          SizedBox(
            width: _wCont,
            child: Center(child: _contEvalCell(data?.contEval)),
          ),
          // معدل الفترة (محسوب)
          SizedBox(
            width: _wRate,
            child: Center(child: _calculatedCell(rate, isBold: true)),
          ),
          // المعدل السنوي (محسوب)
          SizedBox(
            width: _wAnnual,
            child: Center(child: _annualCell(annual)),
          ),
          // حالة التأكيد
          SizedBox(
            width: _wStatus,
            child: Center(child: _statusBadge(conf)),
          ),
          // الإجراءات
          SizedBox(
            width: _wAct,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionBtn(
                  conf ? Icons.check_circle : Icons.pending_actions,
                  conf ? Colors.green.shade600 : Colors.orange.shade700,
                  conf ? 'إلغاء التأكيد' : 'تأكيد النتائج',
                  () => _toggleConfirm(s.id),
                ),
                _actionBtn(
                  Icons.visibility_outlined,
                  Colors.purple.shade600,
                  'عرض الملف السنوي',
                  () => _showDetails(s),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── خلية علامة المعلم (للقراءة فقط — زرقاء) ──
  Widget _teacherScoreCell(double? v) {
    final c = v != null ? _gradeColor(v) : Colors.grey.shade400;
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: v != null ? c.withValues(alpha: 0.07) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: v != null ? c.withValues(alpha: 0.35) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            size: 10,
            color: v != null ? c : Colors.grey.shade400,
          ),
          const SizedBox(width: 3),
          Text(
            v != null ? v.toStringAsFixed(1) : '—',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: c,
            ),
          ),
        ],
      ),
    );
  }

  // ── خلية التقييم المستمر (من المعلم — برتقالية) ──
  Widget _contEvalCell(double? v) => Container(
    width: 96,
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
    decoration: BoxDecoration(
      color: v != null ? Colors.orange.shade50 : Colors.grey.shade50,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: v != null ? Colors.orange.shade200 : Colors.grey.shade200,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.lock_outline,
          size: 10,
          color: v != null ? Colors.orange.shade500 : Colors.grey.shade400,
        ),
        const SizedBox(width: 3),
        Text(
          v != null ? '${v.toStringAsFixed(1)}/20' : '—',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: v != null ? Colors.orange.shade800 : Colors.grey.shade400,
          ),
        ),
      ],
    ),
  );

  // ── خلية محسوبة (متوسط / معدل الفترة) ──
  Widget _calculatedCell(double? v, {bool isBold = false}) {
    final c = v != null ? _gradeColor(v) : Colors.grey.shade400;
    return Container(
      width: 88,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: v != null ? c.withValues(alpha: 0.07) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.functions,
            size: 10,
            color: v != null ? c : Colors.grey.shade400,
          ),
          const SizedBox(width: 3),
          Text(
            v != null ? '${_fmt(v)}/20' : '—',
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: c,
            ),
          ),
        ],
      ),
    );
  }

  // ── خلية المعدل السنوي ──
  Widget _annualCell(double? v) {
    final c = v != null ? _gradeColor(v) : Colors.grey.shade400;
    if (v == null) {
      return Container(
        width: 96,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          'غير مكتمل',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
        ),
      );
    }
    return Container(
      width: 96,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c.withValues(alpha: 0.12), c.withValues(alpha: 0.05)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withValues(alpha: 0.4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_fmt(v)}/20',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: c,
            ),
          ),
          Text(_appreciation(v), style: TextStyle(fontSize: 9, color: c)),
        ],
      ),
    );
  }

  // ── شارة حالة التأكيد ──
  Widget _statusBadge(bool confirmed) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: confirmed ? Colors.green.shade50 : Colors.orange.shade50,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: confirmed ? Colors.green.shade300 : Colors.orange.shade300,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          confirmed ? Icons.check_circle : Icons.pending_actions,
          size: 12,
          color: confirmed ? Colors.green.shade700 : Colors.orange.shade700,
        ),
        const SizedBox(width: 4),
        Text(
          confirmed ? 'مؤكَّدة' : 'قيد المراجعة',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: confirmed ? Colors.green.shade700 : Colors.orange.shade700,
          ),
        ),
      ],
    ),
  );

  Widget _actionBtn(
    IconData icon,
    Color color,
    String tooltip,
    VoidCallback onTap,
  ) => Tooltip(
    message: tooltip,
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    ),
  );

  Widget _buildEmptyState() => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📊', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'لا يوجد طلبة في هذا الفوج.',
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );

  // ═══════════════════════════════════════════════════════════════
  // إعدادات صيغة الاحتساب (الأوزان فقط — لا تعديل للعلامات)
  // ═══════════════════════════════════════════════════════════════
  Future<void> _openSettings() async {
    final result = await Navigator.push<EvalSettings>(
      context,
      MaterialPageRoute(
        builder: (_) => EvaluationSettingsScreen(settings: _settings),
      ),
    );
    if (result != null) setState(() => _settings = result);
  }

  // ═══════════════════════════════════════════════════════════════
  // الملف السنوي الكامل للطالب (Bottom Sheet)
  // ═══════════════════════════════════════════════════════════════
  void _showDetails(_StudentResult s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: DraggableScrollableSheet(
          initialChildSize: 0.70,
          maxChildSize: 0.94,
          expand: false,
          builder: (_, ctrl) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: _AnnualDetailsSheet(
              student: s,
              settings: _settings,
              isConfirmed: _isConfirmed(s.id),
              gradeColor: _gradeColor,
              appreciation: _appreciation,
              fmt: _fmt,
              scrollController: ctrl,
              onClose: () => Navigator.pop(context),
              onConfirm: () {
                _toggleConfirm(s.id);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// ورقة الملف السنوي الكامل للطالب
// ═══════════════════════════════════════════════════════════════════

class _AnnualDetailsSheet extends StatelessWidget {
  const _AnnualDetailsSheet({
    required this.student,
    required this.settings,
    required this.isConfirmed,
    required this.scrollController,
    required this.gradeColor,
    required this.appreciation,
    required this.fmt,
    required this.onClose,
    required this.onConfirm,
  });

  final _StudentResult student;
  final EvalSettings settings;
  final bool isConfirmed;
  final ScrollController scrollController;
  final Color Function(double) gradeColor;
  final String Function(double) appreciation;
  final String Function(double) fmt;
  final VoidCallback onClose;
  final VoidCallback onConfirm;

  static const _allPeriods = [
    'الفصل الأول',
    'الفصل الثاني',
    'الفصل الثالث',
    'الدورة الصيفية',
  ];
  static const Color _gs = Color(0xff1565C0);
  static const Color _ge = Color(0xff42A5F5);

  @override
  Widget build(BuildContext context) {
    final annual = student.annualRate(settings);
    final periods = _allPeriods
        .where((p) => p != 'الدورة الصيفية' || settings.summerEnabled)
        .toList();

    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // مقبض
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // رأس الطالب + شارة التأكيد
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: _gs.withValues(alpha: 0.1),
                child: Text(
                  student.name.isNotEmpty ? student.name[0] : '؟',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _gs,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      '${student.group}  •  ${student.isFemale ? "طالبة" : "طالب"}',
                      style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              // شارة تأكيد
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isConfirmed
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isConfirmed
                        ? Colors.green.shade300
                        : Colors.orange.shade300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isConfirmed ? Icons.verified : Icons.pending_actions,
                      size: 14,
                      color: isConfirmed
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isConfirmed ? 'نتائج مؤكَّدة' : 'قيد المراجعة',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isConfirmed
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 12),

          // ── ملخص الفصول الأربعة ────────────────────────────────
          Text(
            'ملخص نتائج الفصول الدراسية',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.blue.shade900,
            ),
          ),
          const SizedBox(height: 12),
          ...periods.map((p) => _periodCard(p)),

          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 10),

          // ── المعدل السنوي العام ─────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: annual != null
                  ? const LinearGradient(
                      colors: [_gs, _ge],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    )
                  : LinearGradient(
                      colors: [Colors.grey.shade300, Colors.grey.shade200],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: annual != null
                      ? Colors.blue.shade200.withValues(alpha: 0.4)
                      : Colors.grey.shade200,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'المعدل السنوي العام',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        annual != null ? '${fmt(annual)} / 20' : 'غير مكتمل',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (annual != null)
                        Text(
                          appreciation(annual),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  annual != null ? Icons.emoji_events : Icons.hourglass_empty,
                  color: Colors.white,
                  size: 38,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── أزرار ──────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onClose,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                    foregroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.close, size: 17),
                  label: const Text('إغلاق'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: onConfirm,
                  style: FilledButton.styleFrom(
                    backgroundColor: isConfirmed
                        ? Colors.orange.shade600
                        : Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    isConfirmed ? Icons.undo : Icons.check_circle_outline,
                    size: 17,
                  ),
                  label: Text(
                    isConfirmed ? 'إلغاء التأكيد' : 'تأكيد النتائج',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _periodCard(String period) {
    final data = student.periods[period];
    final rate = data?.periodRate(settings);
    final c = rate != null ? gradeColor(rate) : Colors.grey.shade400;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: rate != null ? c.withValues(alpha: 0.05) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: rate != null
                ? c.withValues(alpha: 0.3)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // اسم الفترة + المعدل
            Row(
              children: [
                Container(
                  width: 4,
                  height: 36,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        period,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.grey[800],
                        ),
                      ),
                      if (rate != null) ...[
                        const SizedBox(height: 3),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: rate / 20,
                            minHeight: 4,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation(c),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rate != null ? '${fmt(rate)}/20' : 'لم تكتمل',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: c,
                      ),
                    ),
                    if (rate != null)
                      Text(
                        appreciation(rate),
                        style: TextStyle(fontSize: 10, color: c),
                      ),
                  ],
                ),
              ],
            ),

            // تفصيل الامتحانات
            if (data != null && data.examScores.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  // علامات الامتحانات
                  ...data.examScores.asMap().entries.map((e) {
                    final v = e.value;
                    final vc = v != null ? gradeColor(v) : Colors.grey.shade400;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: vc.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: vc.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock_outline, size: 10, color: vc),
                          const SizedBox(width: 4),
                          Text(
                            'اختبار ${e.key + 1}: ${v != null ? v.toStringAsFixed(1) : "—"}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: vc,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  // التقييم المستمر
                  if (data.contEval != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 10,
                            color: Colors.orange.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'تقييم مستمر: ${data.contEval!.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── نموذج بطاقة الملخص ──
class _CardData {
  final IconData icon;
  final String label, value;
  final Color color;
  const _CardData({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}
