// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════
// نماذج البيانات (Mock Data Models)
// ═══════════════════════════════════════════════════════════════════

class _AbsenceRecord {
  final String date; // DD/MM/YYYY
  final String day; // السبت، الأحد…
  final String period; // صباحًا / مساءً
  final String group; // فوج X
  final String reason; // سبب الغياب
  final String justification; // نوع التبرير
  final bool isJustified;

  const _AbsenceRecord({
    required this.date,
    required this.day,
    required this.period,
    required this.group,
    required this.reason,
    required this.justification,
    required this.isJustified,
  });
}

class _TeacherAttendance {
  final int id;
  final String name;
  final bool isFemale;
  final int totalSessions;
  final List<_AbsenceRecord> absences;

  const _TeacherAttendance({
    required this.id,
    required this.name,
    required this.isFemale,
    required this.totalSessions,
    required this.absences,
  });

  int get absentCount => absences.length;
  int get presentCount => totalSessions - absentCount;
  double get attendanceRate =>
      totalSessions == 0 ? 100.0 : (presentCount / totalSessions * 100);

  /// حالة الغياب: none / justified / unjustified
  String get statusKey {
    if (absences.isEmpty) return 'none';
    if (absences.every((a) => a.isJustified)) return 'justified';
    return 'unjustified';
  }

  bool hasAbsenceInMonth(int month) =>
      absences.any((a) => int.tryParse(a.date.split('/')[1]) == month);
}

// ═══════════════════════════════════════════════════════════════════
// شاشة سجل حضور الأساتذة
// ═══════════════════════════════════════════════════════════════════

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen>
    with SingleTickerProviderStateMixin {
  // ── ألوان ──
  static const Color _gradientStart = Color(0xff2E7D32);
  static const Color _gradientEnd = Color(0xff66BB6A);
  static const LinearGradient _appGradient = LinearGradient(
    colors: [_gradientStart, _gradientEnd],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ── بيانات تجريبية ──
  static final List<_TeacherAttendance> _allTeachers = [
    _TeacherAttendance(
      id: 1,
      name: 'أحمد بن علي',
      isFemale: false,
      totalSessions: 45,
      absences: [],
    ),
    _TeacherAttendance(
      id: 2,
      name: 'يوسف الإدريسي',
      isFemale: false,
      totalSessions: 48,
      absences: [
        _AbsenceRecord(
          date: '12/09/2025',
          day: 'الجمعة',
          period: 'صباحًا',
          group: 'فوج 2',
          reason: 'مرض',
          justification: 'شهادة طبية',
          isJustified: true,
        ),
        _AbsenceRecord(
          date: '05/10/2025',
          day: 'الأحد',
          period: 'مساءً',
          group: 'فوج 4',
          reason: 'ظرف عائلي',
          justification: 'وثيقة رسمية',
          isJustified: true,
        ),
      ],
    ),
    _TeacherAttendance(
      id: 3,
      name: 'محمد الأمين',
      isFemale: false,
      totalSessions: 40,
      absences: [
        _AbsenceRecord(
          date: '18/09/2025',
          day: 'الخميس',
          period: 'مساءً',
          group: 'فوج 6',
          reason: 'مرض',
          justification: 'شهادة طبية',
          isJustified: true,
        ),
        _AbsenceRecord(
          date: '02/10/2025',
          day: 'الخميس',
          period: 'صباحًا',
          group: 'فوج 6',
          reason: 'غياب بدون سبب',
          justification: 'غير مبرر',
          isJustified: false,
        ),
        _AbsenceRecord(
          date: '20/10/2025',
          day: 'الإثنين',
          period: 'مساءً',
          group: 'فوج 3',
          reason: 'غياب بدون سبب',
          justification: 'غير مبرر',
          isJustified: false,
        ),
      ],
    ),
    _TeacherAttendance(
      id: 4,
      name: 'عبد الرحمن كريم',
      isFemale: false,
      totalSessions: 52,
      absences: [
        _AbsenceRecord(
          date: '25/09/2025',
          day: 'الخميس',
          period: 'صباحًا',
          group: 'فوج 1',
          reason: 'سفر',
          justification: 'إذن مسبق',
          isJustified: true,
        ),
      ],
    ),
    _TeacherAttendance(
      id: 5,
      name: 'خالد بن عمر',
      isFemale: false,
      totalSessions: 44,
      absences: [],
    ),
    _TeacherAttendance(
      id: 6,
      name: 'رشيد مصطفى',
      isFemale: false,
      totalSessions: 38,
      absences: [
        _AbsenceRecord(
          date: '10/10/2025',
          day: 'الجمعة',
          period: 'مساءً',
          group: 'فوج 7',
          reason: 'غياب بدون سبب',
          justification: 'غير مبرر',
          isJustified: false,
        ),
      ],
    ),
    _TeacherAttendance(
      id: 7,
      name: 'سارة محمد',
      isFemale: true,
      totalSessions: 36,
      absences: [
        _AbsenceRecord(
          date: '08/09/2025',
          day: 'الإثنين',
          period: 'صباحًا',
          group: 'فوج 1',
          reason: 'مرض',
          justification: 'شهادة طبية',
          isJustified: true,
        ),
        _AbsenceRecord(
          date: '22/09/2025',
          day: 'الإثنين',
          period: 'مساءً',
          group: 'فوج 2',
          reason: 'غياب بدون سبب',
          justification: 'غير مبرر',
          isJustified: false,
        ),
        _AbsenceRecord(
          date: '14/10/2025',
          day: 'الثلاثاء',
          period: 'صباحًا',
          group: 'فوج 1',
          reason: 'ظرف عائلي',
          justification: 'مبرر شفهي',
          isJustified: true,
        ),
        _AbsenceRecord(
          date: '28/10/2025',
          day: 'الثلاثاء',
          period: 'مساءً',
          group: 'فوج 2',
          reason: 'غياب بدون سبب',
          justification: 'غير مبرر',
          isJustified: false,
        ),
      ],
    ),
    _TeacherAttendance(
      id: 8,
      name: 'فاطمة الزهراء',
      isFemale: true,
      totalSessions: 40,
      absences: [
        _AbsenceRecord(
          date: '15/09/2025',
          day: 'الإثنين',
          period: 'مساءً',
          group: 'فوج 3',
          reason: 'مرض',
          justification: 'شهادة طبية',
          isJustified: true,
        ),
      ],
    ),
    _TeacherAttendance(
      id: 9,
      name: 'نور الإيمان',
      isFemale: true,
      totalSessions: 32,
      absences: [],
    ),
    _TeacherAttendance(
      id: 10,
      name: 'أمينة بوعلام',
      isFemale: true,
      totalSessions: 42,
      absences: [
        _AbsenceRecord(
          date: '03/10/2025',
          day: 'الجمعة',
          period: 'صباحًا',
          group: 'فوج 7',
          reason: 'مرض',
          justification: 'شهادة طبية',
          isJustified: true,
        ),
        _AbsenceRecord(
          date: '17/10/2025',
          day: 'الجمعة',
          period: 'مساءً',
          group: 'فوج 8',
          reason: 'ظرف عائلي',
          justification: 'وثيقة رسمية',
          isJustified: true,
        ),
      ],
    ),
  ];

  // ── فلاتر الأشهر ──
  static const List<Map<String, dynamic>> _months = [
    {'label': 'كل الأشهر', 'value': null},
    {'label': 'سبتمبر', 'value': 9},
    {'label': 'أكتوبر', 'value': 10},
    {'label': 'نوفمبر', 'value': 11},
    {'label': 'ديسمبر', 'value': 12},
    {'label': 'يناير', 'value': 1},
    {'label': 'فبراير', 'value': 2},
    {'label': 'مارس', 'value': 3},
    {'label': 'أبريل', 'value': 4},
    {'label': 'مايو', 'value': 5},
    {'label': 'يونيو', 'value': 6},
  ];

  static const List<String> _academicYears = [
    'كل السنوات',
    '2025 / 2026',
    '2024 / 2025',
  ];

  // ── حالة الفلاتر ──
  late final TabController _tabCtrl;
  final _searchCtrl = TextEditingController();
  String _searchQ = '';
  int? _selectedMonth; // null = الكل
  String _selectedYear = '2025 / 2026';
  String _selectedStatus = 'الكل'; // الكل / يوجد غياب / بدون غياب

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));
    _searchCtrl.addListener(
      () => setState(() => _searchQ = _searchCtrl.text.trim()),
    );
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── تطبيق الفلاتر ──
  // [female] يحدد التبويب النشط: false = الأساتذة، true = الأستاذات
  List<_TeacherAttendance> _filtered(bool female) {
    return _allTeachers.where((t) {
      if (t.isFemale != female) return false;
      // بحث بالاسم
      if (_searchQ.isNotEmpty &&
          !t.name.toLowerCase().contains(_searchQ.toLowerCase()))
        return false;
      // فلتر الشهر
      if (_selectedMonth != null && !t.hasAbsenceInMonth(_selectedMonth!)) {
        if (t.absences.isNotEmpty) return false;
      }
      // فلتر الحالة
      if (_selectedStatus == 'يوجد غياب' && t.absences.isEmpty) return false;
      if (_selectedStatus == 'بدون غياب' && t.absences.isNotEmpty) return false;
      return true;
    }).toList();
  }

  // ── إجماليات (على القائمة المفلترة للتبويب النشط) ──
  List<_TeacherAttendance> get _currentFiltered =>
      _filtered(_tabCtrl.index == 1);
  int get _totalTeachers => _currentFiltered.length;
  int get _totalSessions =>
      _currentFiltered.fold(0, (s, t) => s + t.totalSessions);
  int get _totalAbsences =>
      _currentFiltered.fold(0, (s, t) => s + t.absentCount);
  double get _overallRate => _totalSessions == 0
      ? 100.0
      : ((_totalSessions - _totalAbsences) / _totalSessions * 100);

  // أعداد للشارات في التبويب
  int get _maleCount => _allTeachers.where((t) => !t.isFemale).length;
  int get _femaleCount => _allTeachers.where((t) => t.isFemale).length;

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
            decoration: const BoxDecoration(gradient: _appGradient),
          ),
          title: const Text(
            'سجل حضور الأساتذة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // ── شريط التبويب ──
              _buildTabBar(),
              // ── المحتوى بحسب التبويب ──
              Expanded(
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [
                    _buildTabContent(female: false),
                    _buildTabContent(female: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── شريط التبويب ──
  Widget _buildTabBar() {
    return Container(
      color: _gradientStart,
      child: TabBar(
        controller: _tabCtrl,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('👨  الأساتذة'),
                const SizedBox(width: 8),
                _tabCountBadge(_maleCount),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('👩  الأستاذات'),
                const SizedBox(width: 8),
                _tabCountBadge(_femaleCount),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabCountBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ── محتوى كل تبويب ──
  Widget _buildTabContent({required bool female}) {
    final filtered = _filtered(female);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilters(),
          const SizedBox(height: 16),
          _buildSummaryCards(),
          const SizedBox(height: 16),
          _buildSectionLabel('سجل الحضور', Icons.assignment_outlined),
          const SizedBox(height: 10),
          filtered.isEmpty ? _buildEmptyState() : _buildTable(filtered),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // شريط الفلاتر
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildFilters() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 700;

        final search = TextField(
          controller: _searchCtrl,
          decoration: _inputDeco(
            hint: 'البحث باسم الأستاذ...',
            icon: Icons.search,
            suffix: _searchQ.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _searchQ = '');
                    },
                  )
                : null,
          ),
        );

        final monthFilter = _buildDropdown<int?>(
          label: 'الشهر',
          icon: Icons.calendar_month_outlined,
          value: _selectedMonth,
          items: _months
              .map(
                (m) => DropdownMenuItem<int?>(
                  value: m['value'] as int?,
                  child: Text(m['label'] as String),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _selectedMonth = v),
        );

        final yearFilter = _buildDropdown<String>(
          label: 'السنة الدراسية',
          icon: Icons.school_outlined,
          value: _selectedYear,
          items: _academicYears
              .map((y) => DropdownMenuItem(value: y, child: Text(y)))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selectedYear = v);
          },
        );

        final statusFilter = _buildDropdown<String>(
          label: 'الحالة',
          icon: Icons.filter_list,
          value: _selectedStatus,
          items: [
            'الكل',
            'يوجد غياب',
            'بدون غياب',
          ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selectedStatus = v);
          },
        );

        if (isWide) {
          return Row(
            children: [
              Expanded(flex: 3, child: search),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: monthFilter),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: yearFilter),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: statusFilter),
            ],
          );
        }
        return Column(
          children: [
            search,
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: monthFilter),
                const SizedBox(width: 10),
                Expanded(child: yearFilter),
              ],
            ),
            const SizedBox(height: 10),
            statusFilter,
          ],
        );
      },
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: _inputDeco(hint: label, icon: icon),
      items: items,
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  InputDecoration _inputDeco({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),
      prefixIcon: Icon(icon, size: 18, color: Colors.grey[600]),
      suffixIcon: suffix,
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
        borderSide: const BorderSide(color: _gradientStart, width: 1.5),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // بطاقات الملخص
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildSummaryCards() {
    final items = [
      _CardData(
        icon: Icons.people_alt_outlined,
        label: 'إجمالي الأساتذة',
        value: '$_totalTeachers',
        color: Colors.blue.shade700,
      ),
      _CardData(
        icon: Icons.event_note_outlined,
        label: 'إجمالي الحصص المجدولة',
        value: '$_totalSessions',
        color: Colors.teal.shade600,
      ),
      _CardData(
        icon: Icons.event_busy_outlined,
        label: 'إجمالي حصص الغياب',
        value: '$_totalAbsences',
        color: Colors.red.shade600,
      ),
      _CardData(
        icon: Icons.verified_outlined,
        label: 'نسبة الحضور العامة',
        value: '${_overallRate.toStringAsFixed(1)}%',
        color: _rateColor(_overallRate),
      ),
    ];
    return LayoutBuilder(
      builder: (ctx, box) {
        final cols = box.maxWidth >= 800 ? 4 : 2;
        const gap = 12.0;
        final cardW = (box.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: items
              .map((d) => SizedBox(width: cardW, child: _summaryCard(d)))
              .toList(),
        );
      },
    );
  }

  Widget _summaryCard(_CardData d) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(right: BorderSide(color: d.color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: d.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(d.icon, color: d.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  d.value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: d.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // الجدول الرئيسي
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildTable(List<_TeacherAttendance> teachers) {
    return Container(
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
              _buildTableHeader(),
              ...teachers.asMap().entries.map(
                (e) => _buildTableRow(e.value, e.key.isEven),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      color: _gradientStart.withValues(alpha: 0.08),
      child: Row(
        children: [
          _hCell('#', w: 36),
          _hCell('اسم الأستاذ', w: 170),
          _hCell('الحصص المجدولة', w: 120),
          _hCell('حصص الغياب', w: 110),
          _hCell('نسبة الحضور', w: 140),
          _hCell('الحالة', w: 130),
          _hCell('الإجراءات', w: 130),
        ],
      ),
    );
  }

  Widget _hCell(String t, {required double w}) {
    return SizedBox(
      width: w,
      child: Text(
        t,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.5,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }

  Widget _buildTableRow(_TeacherAttendance t, bool isEven) {
    return Container(
      color: isEven ? Colors.grey.shade50 : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        children: [
          // #
          SizedBox(
            width: 36,
            child: Center(
              child: Text(
                '${t.id}',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
          ),

          // الاسم
          SizedBox(
            width: 170,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: _gradientStart.withValues(alpha: 0.12),
                  child: Text(
                    t.name.isNotEmpty ? t.name[0] : '؟',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _gradientStart,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        t.isFemale ? 'أستاذة' : 'أستاذ',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // الحصص المجدولة
          SizedBox(
            width: 120,
            child: Center(
              child: Text(
                '${t.totalSessions}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // حصص الغياب
          SizedBox(
            width: 110,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: t.absentCount == 0
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${t.absentCount}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: t.absentCount == 0
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
              ),
            ),
          ),

          // نسبة الحضور
          SizedBox(
            width: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${t.attendanceRate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _rateColor(t.attendanceRate),
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: t.attendanceRate / 100,
                    minHeight: 5,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(
                      _rateColor(t.attendanceRate),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // الحالة
          SizedBox(width: 130, child: Center(child: _statusBadge(t.statusKey))),

          // الإجراءات
          SizedBox(
            width: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionBtn(
                  Icons.receipt_long_outlined,
                  Colors.teal.shade600,
                  'عرض سجل الحضور',
                  () => _showAttendanceLog(t),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // الشارات والمساعدات
  // ═══════════════════════════════════════════════════════════════════
  Widget _statusBadge(String key) {
    switch (key) {
      case 'none':
        return _badge('🟢 بدون غياب', Colors.green.shade600);
      case 'justified':
        return _badge('🟡 غياب مبرر', Colors.amber.shade700);
      default:
        return _badge('🔴 غياب غير مبرر', Colors.red.shade600);
    }
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _actionBtn(
    IconData icon,
    Color color,
    String tooltip,
    VoidCallback onTap,
  ) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 17, color: color),
        ),
      ),
    );
  }

  Color _rateColor(double rate) {
    if (rate >= 90) return Colors.green.shade600;
    if (rate >= 75) return Colors.orange.shade700;
    return Colors.red.shade600;
  }

  // ═══════════════════════════════════════════════════════════════════
  // نافذة تفاصيل الغياب
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildNoAbsenceState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✅', style: TextStyle(fontSize: 44)),
            const SizedBox(height: 12),
            Text(
              'لا توجد حالات غياب لهذا الأستاذ.',
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbsenceTable(List<_AbsenceRecord> absences) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(14),
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.red.shade50),
        dataRowMinHeight: 48,
        dataRowMaxHeight: 56,
        columnSpacing: 20,
        headingTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.5,
          color: Colors.red.shade900,
        ),
        dataTextStyle: const TextStyle(fontSize: 12.5),
        border: TableBorder.all(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        columns: const [
          DataColumn(label: Text('التاريخ')),
          DataColumn(label: Text('اليوم')),
          DataColumn(label: Text('الفترة')),
          DataColumn(label: Text('الفوج')),
          DataColumn(label: Text('سبب الغياب')),
        ],
        rows: absences.map((a) {
          return DataRow(
            cells: [
              DataCell(
                Text(
                  a.date,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
              DataCell(Text(a.day)),
              DataCell(_periodChip(a.period)),
              DataCell(Text(a.group)),
              DataCell(Text(a.reason)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _periodChip(String period) {
    final bool isMorning = period == 'صباحًا';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isMorning ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 13,
          color: isMorning ? Colors.orange.shade600 : Colors.indigo.shade400,
        ),
        const SizedBox(width: 4),
        Text(period, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // نافذة سجل الحضور الكامل
  // ═══════════════════════════════════════════════════════════════════
  void _showAttendanceLog(_TeacherAttendance t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.92,
          expand: false,
          builder: (_, ctrl) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                _sheetHandle(),
                _sheetHeader(
                  icon: Icons.receipt_long_outlined,
                  title: 'سجل الحضور',
                  subtitle: t.name,
                  color: Colors.teal.shade600,
                  trailing: null,
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    controller: ctrl,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ملخص إحصائي
                        _buildLogSummary(t),
                        const SizedBox(height: 18),
                        // شريط التقدم التفصيلي
                        _buildAttendanceBar(t),
                        const SizedBox(height: 18),
                        // تفاصيل الغياب إن وجدت
                        if (t.absences.isNotEmpty) ...[
                          Text(
                            'سجل الغيابات (${t.absentCount})',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildAbsenceTable(t.absences),
                        ] else
                          _buildNoAbsenceState(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                _sheetCloseButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogSummary(_TeacherAttendance t) {
    return Row(
      children: [
        Expanded(
          child: _logStatCard(
            'الحصص المجدولة',
            '${t.totalSessions}',
            Colors.blue.shade700,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _logStatCard(
            'حضر',
            '${t.presentCount}',
            Colors.green.shade600,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _logStatCard('غاب', '${t.absentCount}', Colors.red.shade600),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _logStatCard(
            'نسبة الحضور',
            '${t.attendanceRate.toStringAsFixed(1)}%',
            _rateColor(t.attendanceRate),
          ),
        ),
      ],
    );
  }

  Widget _logStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceBar(_TeacherAttendance t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معدل الحضور ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: t.attendanceRate / 100,
            minHeight: 16,
            backgroundColor: Colors.red.shade100,
            valueColor: AlwaysStoppedAnimation(_rateColor(t.attendanceRate)),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0%', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
            Text(
              '${t.attendanceRate.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: _rateColor(t.attendanceRate),
              ),
            ),
            Text(
              '100%',
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // الحالة الفارغة
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('👨‍🏫', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(
              'لا يوجد أساتذة مطابقون لمعايير البحث.',
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // عناصر Bottom Sheet المشتركة
  // ═══════════════════════════════════════════════════════════════════
  Widget _sheetHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _sheetHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  Widget _sheetCloseButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: _gradientStart,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'إغلاق',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _gradientStart, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
      ],
    );
  }
}

// ── نموذج بطاقة الملخص ──
class _CardData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _CardData({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}
