import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════
// نموذج بيانات الاختبار
// ═══════════════════════════════════════════════════════════════════

class _Exam {
  int id;
  bool isFemale;
  String group;
  DateTime date;
  String startTime;
  String endTime;
  String location; // المقر
  String room; // الحجرة
  String examType;
  String notes;

  _Exam({
    required this.id,
    required this.isFemale,
    required this.group,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.room,
    required this.examType,
    this.notes = '',
  });

  static const List<String> _days = [
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  String get dayName => _days[date.weekday - 1];

  bool get isPast {
    final t = DateTime.now();
    return date.isBefore(DateTime(t.year, t.month, t.day));
  }

  bool get isToday {
    final t = DateTime.now();
    return date.year == t.year && date.month == t.month && date.day == t.day;
  }

  _Exam copyWith({
    bool? isFemale,
    String? group,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    String? room,
    String? examType,
    String? notes,
  }) => _Exam(
    id: id,
    isFemale: isFemale ?? this.isFemale,
    group: group ?? this.group,
    date: date ?? this.date,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    location: location ?? this.location,
    room: room ?? this.room,
    examType: examType ?? this.examType,
    notes: notes ?? this.notes,
  );
}

// ═══════════════════════════════════════════════════════════════════
// شاشة إدارة برنامج الاختبارات
// ═══════════════════════════════════════════════════════════════════

class ExamScheduleManagementScreen extends StatefulWidget {
  const ExamScheduleManagementScreen({super.key});

  @override
  State<ExamScheduleManagementScreen> createState() =>
      _ExamScheduleManagementScreenState();
}

class _ExamScheduleManagementScreenState
    extends State<ExamScheduleManagementScreen>
    with SingleTickerProviderStateMixin {
  // ── ألوان وحدة الإدارة ──
  static const Color _gradientStart = Color(0xff1565C0);
  static const Color _gradientEnd = Color(0xff42A5F5);
  static const LinearGradient _appGradient = LinearGradient(
    colors: [_gradientStart, _gradientEnd],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ── قوائم الخيارات ──
  static const List<String> _groups = [
    'فوج 1',
    'فوج 2',
    'فوج 3',
    'فوج 4',
    'فوج 5',
  ];
  static const List<String> _locations = ['المقر 1', 'المقر 2'];
  static const List<String> _rooms = [
    'الحجرة 1',
    'الحجرة 2',
    'الحجرة 3',
    'الحجرة 4',
  ];
  static const List<String> _examTypes = [
    'اختبار الحفظ',
    'اختبار التلاوة',
    'اختبار التجويد',
    'اختبار التفسير',
    'اختبار السيرة النبوية',
    'اختبار شفهي',
    'اختبار كتابي',
  ];
  static const List<String> _academicYears = ['2025 / 2026', '2024 / 2025'];

  // ── بيانات تجريبية (قابلة للتعديل محلياً) ──
  late List<_Exam> _allExams;
  int _nextId = 12;

  List<_Exam> _generateMockExams() {
    return [
      _Exam(
        id: 1,
        isFemale: false,
        group: 'فوج 1',
        date: DateTime(2026, 7, 15),
        startTime: '09:00',
        endTime: '11:00',
        location: 'المقر 1',
        room: 'الحجرة 1',
        examType: 'اختبار الحفظ',
        notes: 'مراجعة الجزء الثلاثين',
      ),
      _Exam(
        id: 2,
        isFemale: false,
        group: 'فوج 2',
        date: DateTime(2026, 7, 18),
        startTime: '13:00',
        endTime: '15:00',
        location: 'المقر 1',
        room: 'الحجرة 2',
        examType: 'اختبار التلاوة',
        notes: '',
      ),
      _Exam(
        id: 3,
        isFemale: false,
        group: 'فوج 1',
        date: DateTime(2026, 8, 1),
        startTime: '09:00',
        endTime: '11:00',
        location: 'المقر 2',
        room: 'الحجرة 1',
        examType: 'اختبار التجويد',
        notes: 'أحكام النون الساكنة',
      ),
      _Exam(
        id: 4,
        isFemale: false,
        group: 'فوج 3',
        date: DateTime(2026, 7, 22),
        startTime: '10:00',
        endTime: '12:00',
        location: 'المقر 1',
        room: 'الحجرة 3',
        examType: 'اختبار الحفظ',
        notes: '',
      ),
      _Exam(
        id: 5,
        isFemale: false,
        group: 'فوج 2',
        date: DateTime(2026, 8, 10),
        startTime: '14:00',
        endTime: '16:00',
        location: 'المقر 2',
        room: 'الحجرة 2',
        examType: 'اختبار السيرة النبوية',
        notes: 'الهجرة النبوية',
      ),
      _Exam(
        id: 6,
        isFemale: false,
        group: 'فوج 4',
        date: DateTime(2026, 7, 5),
        startTime: '11:00',
        endTime: '12:30',
        location: 'المقر 1',
        room: 'الحجرة 4',
        examType: 'اختبار شفهي',
        notes: 'اختبار سابق',
      ),
      _Exam(
        id: 7,
        isFemale: true,
        group: 'فوج 1',
        date: DateTime(2026, 7, 16),
        startTime: '09:00',
        endTime: '11:00',
        location: 'المقر 2',
        room: 'الحجرة 3',
        examType: 'اختبار الحفظ',
        notes: '',
      ),
      _Exam(
        id: 8,
        isFemale: true,
        group: 'فوج 2',
        date: DateTime(2026, 7, 19),
        startTime: '13:00',
        endTime: '15:00',
        location: 'المقر 2',
        room: 'الحجرة 4',
        examType: 'اختبار التلاوة',
        notes: '',
      ),
      _Exam(
        id: 9,
        isFemale: true,
        group: 'فوج 3',
        date: DateTime(2026, 8, 5),
        startTime: '09:00',
        endTime: '11:00',
        location: 'المقر 1',
        room: 'الحجرة 2',
        examType: 'اختبار التجويد',
        notes: 'المدود وأحكامها',
      ),
      _Exam(
        id: 10,
        isFemale: true,
        group: 'فوج 1',
        date: DateTime(2026, 7, 25),
        startTime: '10:00',
        endTime: '12:00',
        location: 'المقر 2',
        room: 'الحجرة 1',
        examType: 'اختبار التفسير',
        notes: 'سورة الكهف',
      ),
      _Exam(
        id: 11,
        isFemale: true,
        group: 'فوج 4',
        date: DateTime(2026, 6, 30),
        startTime: '14:00',
        endTime: '15:30',
        location: 'المقر 1',
        room: 'الحجرة 3',
        examType: 'اختبار الحفظ',
        notes: 'اختبار سابق',
      ),
    ];
  }

  // ── حالة الشاشة ──
  late final TabController _tabCtrl;
  String _selectedYear = '2025 / 2026';
  String? _selectedGroup; // null = جميع الأفواج
  String _searchQ = '';
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allExams = _generateMockExams();
    _tabCtrl = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (!_tabCtrl.indexIsChanging) {
          setState(() {
            _selectedGroup = null;
            _searchQ = '';
            _searchCtrl.clear();
          });
        }
      });
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

  // ── فلترة ──
  bool get _isFemale => _tabCtrl.index == 1;

  List<_Exam> _filtered(bool female) {
    return _allExams.where((e) {
      if (e.isFemale != female) return false;
      if (_selectedGroup != null && e.group != _selectedGroup) return false;
      if (_searchQ.isNotEmpty) {
        final q = _searchQ.toLowerCase();
        if (!e.group.contains(q) &&
            !e.examType.contains(q) &&
            !e.location.contains(q) &&
            !e.notes.toLowerCase().contains(q))
          return false;
      }
      return true;
    }).toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  // ── إجماليات ──
  _Exam? _nextExam(bool female) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final list =
        _allExams
            .where((e) => e.isFemale == female && !e.date.isBefore(today))
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    return list.isEmpty ? null : list.first;
  }

  // ── CRUD ──
  void _addExam(_Exam e) => setState(() {
    e.id = _nextId++;
    _allExams.add(e);
  });

  void _editExam(_Exam updated) => setState(() {
    final i = _allExams.indexWhere((e) => e.id == updated.id);
    if (i >= 0) _allExams[i] = updated;
  });

  void _deleteExam(int id) =>
      setState(() => _allExams.removeWhere((e) => e.id == id));

  // ── تنسيق التاريخ ──
  static String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  // ═════════════════════════════════════════════════
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
            'إدارة برنامج الاختبارات',
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
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabCtrl,
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

  // ── شريط التبويب ──
  Widget _buildTabBar() {
    final m = _allExams.where((e) => !e.isFemale).length;
    final f = _allExams.where((e) => e.isFemale).length;
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
          Tab(child: _tabLabel('👦  الطلبة', m)),
          Tab(child: _tabLabel('👧  الطالبات', f)),
        ],
      ),
    );
  }

  Widget _tabLabel(String label, int count) {
    return Row(
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
            '$count',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ── محتوى كل تبويب ──
  Widget _buildContent({required bool female}) {
    final filtered = _filtered(female);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilters(),
          const SizedBox(height: 14),
          _buildSummaryCards(female),
          const SizedBox(height: 14),
          _buildTableHeader(female),
          const SizedBox(height: 10),
          filtered.isEmpty ? _buildEmptyState() : _buildTable(filtered),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── الفلاتر ──
  Widget _buildFilters() {
    return LayoutBuilder(
      builder: (ctx, box) {
        final wide = box.maxWidth >= 700;
        final yearField = _dropdownField(
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
        final groupField = _dropdownField<String?>(
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
        final searchField = TextField(
          controller: _searchCtrl,
          decoration: _inputDeco(
            hint: 'بحث في الاختبارات...',
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
        if (wide) {
          return Row(
            children: [
              Expanded(flex: 2, child: yearField),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: groupField),
              const SizedBox(width: 10),
              Expanded(flex: 3, child: searchField),
            ],
          );
        }
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: yearField),
                const SizedBox(width: 10),
                Expanded(child: groupField),
              ],
            ),
            const SizedBox(height: 10),
            searchField,
          ],
        );
      },
    );
  }

  Widget _dropdownField<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
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

  // ── بطاقات الملخص ──
  Widget _buildSummaryCards(bool female) {
    final total = _allExams.length;
    final genderCnt = _allExams.where((e) => e.isFemale == female).length;
    final groups = _allExams
        .where((e) => e.isFemale == female)
        .map((e) => e.group)
        .toSet()
        .length;
    final next = _nextExam(female);
    final gLabel = female ? 'اختبارات الطالبات' : 'اختبارات الطلبة';

    final cards = [
      _CardData(
        icon: Icons.event_note_outlined,
        label: 'إجمالي الاختبارات',
        value: '$total',
        color: Colors.blue.shade700,
      ),
      _CardData(
        icon: Icons.groups_outlined,
        label: gLabel,
        value: '$genderCnt',
        color: Colors.purple.shade600,
      ),
      _CardData(
        icon: Icons.group_work_outlined,
        label: 'عدد الأفواج',
        value: '$groups',
        color: Colors.teal.shade600,
      ),
      _CardData(
        icon: Icons.calendar_today,
        label: 'أقرب اختبار',
        value: next != null ? _fmtDate(next.date) : 'لا يوجد',
        color: Colors.orange.shade700,
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
          children: cards
              .map((d) => SizedBox(width: cardW, child: _summaryCard(d)))
              .toList(),
        );
      },
    );
  }

  Widget _summaryCard(_CardData d) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: d.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(d.icon, color: d.color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.label,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  d.value,
                  style: TextStyle(
                    fontSize: 15,
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
  }

  // ── رأس قسم الجدول (عنوان + زر إضافة) ──
  Widget _buildTableHeader(bool female) {
    return Row(
      children: [
        Icon(Icons.calendar_month_outlined, color: _gradientStart, size: 20),
        const SizedBox(width: 8),
        Text(
          'برنامج الاختبارات',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        const Spacer(),
        FilledButton.icon(
          onPressed: () => _openForm(context, female: female),
          style: FilledButton.styleFrom(
            backgroundColor: _gradientStart,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('إضافة اختبار', style: TextStyle(fontSize: 13)),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // جدول الاختبارات
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildTable(List<_Exam> exams) {
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
              _buildTHeader(),
              ...exams.asMap().entries.map(
                (e) => _buildTRow(e.value, e.key.isEven),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      color: _gradientStart.withValues(alpha: 0.08),
      child: Row(
        children: [
          _th('الفوج', w: 76),
          _th('تاريخ الاختبار', w: 108),
          _th('اليوم', w: 86),
          _th('وقت الاختبار', w: 120),
          _th('المقر', w: 70),
          _th('الحجرة', w: 82),
          _th('نوع الاختبار', w: 150),
          _th('الملاحظات', w: 160),
          _th('الإجراءات', w: 120),
        ],
      ),
    );
  }

  Widget _th(String label, {required double w}) => SizedBox(
    width: w,
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.blue.shade900,
      ),
    ),
  );

  Widget _buildTRow(_Exam e, bool isEven) {
    Color rowBg = isEven ? Colors.grey.shade50 : Colors.white;
    if (e.isToday) rowBg = Colors.blue.shade50;
    if (e.isPast) rowBg = Colors.grey.shade100;

    return Container(
      color: rowBg,
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
      child: Row(
        children: [
          // الفوج
          SizedBox(width: 76, child: Center(child: _groupChip(e.group))),
          // التاريخ
          SizedBox(
            width: 108,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _fmtDate(e.date),
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                  if (e.isToday)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'اليوم',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (e.isPast && !e.isToday)
                    Text(
                      'منقضي',
                      style: TextStyle(fontSize: 9, color: Colors.grey[500]),
                    ),
                ],
              ),
            ),
          ),
          // اليوم
          SizedBox(
            width: 86,
            child: Center(
              child: Text(e.dayName, style: const TextStyle(fontSize: 12.5)),
            ),
          ),
          // الوقت
          SizedBox(
            width: 120,
            child: Center(
              child: Text(
                '${e.startTime} — ${e.endTime}',
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
          ),
          // المقر
          SizedBox(
            width: 70,
            child: Center(
              child: Text(e.location, style: const TextStyle(fontSize: 12)),
            ),
          ),
          // الحجرة
          SizedBox(
            width: 82,
            child: Center(
              child: Text(e.room, style: const TextStyle(fontSize: 12)),
            ),
          ),
          // نوع الاختبار
          SizedBox(width: 150, child: Center(child: _typeBadge(e.examType))),
          // الملاحظات
          SizedBox(
            width: 160,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                e.notes.isEmpty ? '—' : e.notes,
                style: TextStyle(
                  fontSize: 11.5,
                  color: e.notes.isEmpty ? Colors.grey[400] : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          // الإجراءات
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionBtn(
                  Icons.visibility_outlined,
                  Colors.blue.shade600,
                  'عرض',
                  () => _showDetails(e),
                ),
                _actionBtn(
                  Icons.edit_outlined,
                  Colors.orange.shade600,
                  'تعديل',
                  () => _openForm(context, exam: e, female: e.isFemale),
                ),
                _actionBtn(
                  Icons.delete_outline,
                  Colors.red.shade600,
                  'حذف',
                  () => _confirmDelete(e),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupChip(String group) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _gradientStart.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _gradientStart.withValues(alpha: 0.3)),
      ),
      child: Text(
        group,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _gradientStart,
        ),
      ),
    );
  }

  Widget _typeBadge(String type) {
    final Color c = type.contains('الحفظ')
        ? Colors.green.shade600
        : type.contains('التلاوة')
        ? Colors.teal.shade600
        : type.contains('التجويد')
        ? Colors.blue.shade600
        : type.contains('التفسير')
        ? Colors.purple.shade600
        : type.contains('السيرة')
        ? Colors.indigo.shade600
        : type.contains('شفهي')
        ? Colors.orange.shade700
        : Colors.grey.shade600;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Text(
        type,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: c),
        textAlign: TextAlign.center,
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
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 17, color: color),
        ),
      ),
    );
  }

  // ── الحالة الفارغة ──
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📝', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(
              'لا يوجد برنامج اختبارات حالياً.',
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _openForm(context, female: _isFemale),
              style: FilledButton.styleFrom(
                backgroundColor: _gradientStart,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('إضافة أول اختبار'),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // عرض التفاصيل (Bottom Sheet)
  // ─────────────────────────────────────────────────
  void _showDetails(_Exam e) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Row(
                children: [
                  Icon(
                    Icons.event_note_outlined,
                    color: _gradientStart,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    e.examType,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const Spacer(),
                  _groupChip(e.group),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _detailChip(
                    Icons.calendar_today,
                    _fmtDate(e.date),
                    Colors.blue.shade700,
                  ),
                  _detailChip(Icons.today, e.dayName, Colors.teal.shade600),
                  _detailChip(
                    Icons.access_time,
                    '${e.startTime} — ${e.endTime}',
                    Colors.purple.shade600,
                  ),
                  _detailChip(
                    Icons.location_on,
                    '${e.location} — ${e.room}',
                    Colors.orange.shade700,
                  ),
                ],
              ),
              if (e.notes.isNotEmpty) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.notes, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        e.notes,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // تأكيد الحذف
  // ─────────────────────────────────────────────────
  void _confirmDelete(_Exam e) {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'تأكيد الحذف',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'هل أنت متأكد من حذف اختبار "${e.examType}" للـ${e.group}؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteExam(e.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '✅ تم حذف الاختبار: ${e.examType} - ${e.group}',
                    ),
                    backgroundColor: Colors.green.shade600,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('حذف'),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // نموذج الإضافة / التعديل
  // ─────────────────────────────────────────────────
  void _openForm(BuildContext context, {_Exam? exam, required bool female}) {
    final isWide = MediaQuery.of(context).size.width >= 640;
    if (isWide) {
      showDialog(
        context: context,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: _ExamForm(
                exam: exam,
                defaultFemale: female,
                groups: _groups,
                locations: _locations,
                rooms: _rooms,
                examTypes: _examTypes,
                onSave: (e) {
                  exam == null ? _addExam(e) : _editExam(e);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '✅ تم ${exam == null ? 'إضافة' : 'تعديل'} الاختبار بنجاح',
                      ),
                      backgroundColor: Colors.green.shade600,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onCancel: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: DraggableScrollableSheet(
            initialChildSize: 0.9,
            maxChildSize: 0.95,
            expand: false,
            builder: (_, ctrl) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: _ExamForm(
                exam: exam,
                defaultFemale: female,
                groups: _groups,
                locations: _locations,
                rooms: _rooms,
                examTypes: _examTypes,
                scrollController: ctrl,
                onSave: (e) {
                  exam == null ? _addExam(e) : _editExam(e);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '✅ تم ${exam == null ? 'إضافة' : 'تعديل'} الاختبار بنجاح',
                      ),
                      backgroundColor: Colors.green.shade600,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onCancel: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// نموذج الاختبار (مكوّن مستقل)
// ═══════════════════════════════════════════════════════════════════

class _ExamForm extends StatefulWidget {
  const _ExamForm({
    required this.defaultFemale,
    required this.groups,
    required this.locations,
    required this.rooms,
    required this.examTypes,
    required this.onSave,
    required this.onCancel,
    this.exam,
    this.scrollController,
  });

  final _Exam? exam;
  final bool defaultFemale;
  final List<String> groups;
  final List<String> locations;
  final List<String> rooms;
  final List<String> examTypes;
  final void Function(_Exam) onSave;
  final VoidCallback onCancel;
  final ScrollController? scrollController;

  @override
  State<_ExamForm> createState() => _ExamFormState();
}

class _ExamFormState extends State<_ExamForm> {
  static const Color _accent = Color(0xff1565C0);
  static const LinearGradient _grad = LinearGradient(
    colors: [Color(0xff1565C0), Color(0xff42A5F5)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
  static const List<String> _dayNames = [
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  final _formKey = GlobalKey<FormState>();

  late bool _isFemale;
  late String _group;
  DateTime? _date;
  late String _startTime;
  late String _endTime;
  late String _location;
  late String _room;
  late String _examType;
  late TextEditingController _notesCtrl;
  late TextEditingController _dateCtrl;
  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;

  String get _dayName => _date == null ? '—' : _dayNames[_date!.weekday - 1];

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  void initState() {
    super.initState();
    final e = widget.exam;
    _isFemale = e?.isFemale ?? widget.defaultFemale;
    _group = e?.group ?? widget.groups.first;
    _date = e?.date;
    _startTime = e?.startTime ?? '09:00';
    _endTime = e?.endTime ?? '11:00';
    _location = e?.location ?? widget.locations.first;
    _room = e?.room ?? widget.rooms.first;
    _examType = e?.examType ?? widget.examTypes.first;
    _notesCtrl = TextEditingController(text: e?.notes ?? '');
    _dateCtrl = TextEditingController(text: e != null ? _fmtDate(e.date) : '');
    _startCtrl = TextEditingController(text: _startTime);
    _endCtrl = TextEditingController(text: _endTime);
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _dateCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2028),
      helpText: 'اختر تاريخ الاختبار',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
      builder: (ctx, child) => Theme(
        data: Theme.of(
          ctx,
        ).copyWith(colorScheme: const ColorScheme.light(primary: _accent)),
        child: child!,
      ),
    );
    if (picked != null)
      setState(() {
        _date = picked;
        _dateCtrl.text = _fmtDate(picked);
      });
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = TimeOfDay.fromDateTime(
      DateTime.parse('2000-01-01 ${isStart ? _startTime : _endTime}:00'),
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: isStart ? 'وقت البداية' : 'وقت النهاية',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
      builder: (ctx, child) => Theme(
        data: Theme.of(
          ctx,
        ).copyWith(colorScheme: const ColorScheme.light(primary: _accent)),
        child: child!,
      ),
    );
    if (picked != null) {
      final t =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        if (isStart) {
          _startTime = t;
          _startCtrl.text = t;
        } else {
          _endTime = t;
          _endCtrl.text = t;
        }
      });
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار تاريخ الاختبار'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    widget.onSave(
      _Exam(
        id: widget.exam?.id ?? 0,
        isFemale: _isFemale,
        group: _group,
        date: _date!,
        startTime: _startTime,
        endTime: _endTime,
        location: _location,
        room: _room,
        examType: _examType,
        notes: _notesCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.exam != null;
    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(22),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مقبض (BottomSheet)
            if (widget.scrollController != null)
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

            // ── عنوان النموذج ──
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    gradient: _grad,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.event_note_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isEdit ? 'تعديل الاختبار' : 'إضافة اختبار جديد',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),

            // ── الفئة ──
            _sectionTitle('الفئة', Icons.people_outline),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade50,
              ),
              child: Row(
                children: ['طلبة', 'طالبات'].map((label) {
                  final female = label == 'طالبات';
                  final sel = _isFemale == female;
                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _isFemale = female),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: sel
                              ? _accent.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              female ? '👧' : '👦',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              label,
                              style: TextStyle(
                                fontWeight: sel
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: sel ? _accent : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 6),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: sel ? _accent : Colors.grey[400]!,
                                  width: 2,
                                ),
                                color: sel ? _accent : Colors.transparent,
                              ),
                              child: sel
                                  ? const Icon(
                                      Icons.check,
                                      size: 10,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // ── الفوج + نوع الاختبار ──
            _sectionTitle('تفاصيل الاختبار', Icons.assignment_outlined),
            const SizedBox(height: 8),
            _responsiveRow(context, [
              _formDropdown(
                label: 'الفوج',
                icon: Icons.group_outlined,
                value: _group,
                items: widget.groups,
                onChanged: (v) {
                  if (v != null) setState(() => _group = v);
                },
              ),
            ]),
            const SizedBox(height: 12),

            TextFormField(
              initialValue: _examType,
              decoration: _fd(label: 'نوع الاختبار', icon: Icons.quiz_outlined),
              onChanged: (value) {
                _examType = value;
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال نوع الاختبار';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // ── التاريخ + اليوم ──
            _responsiveRow(context, [
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateCtrl,
                    decoration:
                        _fd(
                          label: 'تاريخ الاختبار',
                          icon: Icons.calendar_today,
                        ).copyWith(
                          suffixIcon: Icon(
                            Icons.edit_calendar_outlined,
                            color: _accent,
                          ),
                        ),
                    validator: (_) =>
                        _date == null ? 'يرجى اختيار تاريخ' : null,
                  ),
                ),
              ),
              TextFormField(
                readOnly: true,
                decoration: _fd(
                  label: 'اليوم (تلقائي)',
                  icon: Icons.today_outlined,
                ),
                controller: TextEditingController(text: _dayName),
              ),
            ]),
            const SizedBox(height: 12),

            // ── وقت البداية + وقت النهاية ──
            _responsiveRow(context, [
              GestureDetector(
                onTap: () => _pickTime(true),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _startCtrl,
                    decoration:
                        _fd(
                          label: 'وقت البداية',
                          icon: Icons.access_time,
                        ).copyWith(
                          suffixIcon: Icon(Icons.schedule, color: _accent),
                        ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _pickTime(false),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _endCtrl,
                    decoration:
                        _fd(
                          label: 'وقت النهاية',
                          icon: Icons.access_time_filled,
                        ).copyWith(
                          suffixIcon: Icon(Icons.schedule, color: _accent),
                        ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 12),

            // ── المقر + الحجرة ──
            _responsiveRow(context, [
              _formDropdown(
                label: 'المقر',
                icon: Icons.location_on_outlined,
                value: _location,
                items: widget.locations,
                onChanged: (v) {
                  if (v != null) setState(() => _location = v);
                },
              ),
              _formDropdown(
                label: 'الحجرة',
                icon: Icons.meeting_room_outlined,
                value: _room,
                items: widget.rooms,
                onChanged: (v) {
                  if (v != null) setState(() => _room = v);
                },
              ),
            ]),
            const SizedBox(height: 16),

            // ── الملاحظات ──
            _sectionTitle('ملاحظات (اختياري)', Icons.notes_outlined),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 2,
              decoration: _fd(
                label: 'أدخل أي ملاحظات إضافية...',
                icon: Icons.notes_outlined,
              ),
            ),
            const SizedBox(height: 24),

            // ── أزرار الإجراءات ──
            LayoutBuilder(
              builder: (ctx, box) {
                final wide = box.maxWidth >= 400;
                final save = _buildSaveBtn();
                final cancel = OutlinedButton.icon(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey.shade400),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('إلغاء'),
                );
                if (wide)
                  return Row(
                    children: [
                      Expanded(child: save),
                      const SizedBox(width: 12),
                      Expanded(child: cancel),
                    ],
                  );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [save, const SizedBox(height: 10), cancel],
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveBtn() {
    return Container(
      decoration: BoxDecoration(
        gradient: _grad,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _save,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.save_outlined, color: Colors.white, size: 18),
        label: const Text(
          'حفظ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _accent),
        const SizedBox(width: 7),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
            color: Colors.blue.shade900,
          ),
        ),
      ],
    );
  }

  Widget _responsiveRow(BuildContext ctx, List<Widget> children) {
    final wide = MediaQuery.of(ctx).size.width >= 480;
    if (wide)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            children
                .map((c) => Expanded(child: c))
                .expand((c) => [c, const SizedBox(width: 12)])
                .toList()
              ..removeLast(),
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children.expand((c) => [c, const SizedBox(height: 12)]).toList()
        ..removeLast(),
    );
  }

  Widget _formDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: _fd(label: label, icon: icon),
      items: items
          .map((i) => DropdownMenuItem(value: i, child: Text(i)))
          .toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  InputDecoration _fd({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 13, color: Colors.grey[700]),
      prefixIcon: Icon(icon, size: 18, color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
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
        borderSide: const BorderSide(color: _accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400),
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
