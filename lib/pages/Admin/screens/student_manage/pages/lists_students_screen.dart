import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './edit_students_screen.dart';
import '../model/student_model.dart';

// ═══════════════════════════════════════════════════════════════════
// شاشة قائمة الطلبة
// ═══════════════════════════════════════════════════════════════════

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen>
    with SingleTickerProviderStateMixin {
  // ── ألوان وحدة الإدارة ──
  static const Color _gradientStart = Color(0xff1565C0);
  static const Color _gradientEnd = Color(0xff42A5F5);
  static const LinearGradient _appGradient = LinearGradient(
    colors: [_gradientStart, _gradientEnd],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ── أسماء الوثائق ──
  static const List<String> _docNames = [
    'شهادة الميلاد',
    'بطاقة التعريف',
    'صورة شخصية',
    'وثيقة الإقامة',
  ];

  // ── معلمو الأفواج (منفصلون حسب الجنس) ──
  static const Map<String, String> _maleTeachers = {
    'فوج 1': 'أحمد بن علي',
    'فوج 2': 'يوسف الإدريسي',
    'فوج 3': 'محمد الأمين',
    'فوج 4': 'خالد بن عمر',
    'فوج 5': 'رشيد مصطفى',
  };
  static const Map<String, String> _femaleTeachers = {
    'فوج 1': 'سارة محمد',
    'فوج 2': 'فاطمة الزهراء',
    'فوج 3': 'نور الإيمان',
    'فوج 4': 'أمينة بوعلام',
    'فوج 5': 'حليمة بن سعيد',
  };

  // ── بيانات تجريبية ──
  static const List<Student> _allStudents = [
    // ── ذكور ──
    Student(
      id: 1,
      name: 'يوسف أمين',
      isFemale: false,
      dob: '15/06/2012',
      group: 'فوج 1',
      memorization: 'جزء عمّ',
      username: '060101',
      password: 'Xk7mP2',
      parentName: 'أمين بن يوسف',
      parentPhone: '0551234567',
      docs: [true, true, true, false],
    ),
    Student(
      id: 2,
      name: 'عمر بن زيد',
      isFemale: false,
      dob: '22/03/2011',
      group: 'فوج 1',
      memorization: 'من 1 إلى 5 أجزاء',
      username: '030202',
      password: 'Nt4wQ9',
      parentName: 'زيد الكريم',
      parentPhone: '0662345678',
      docs: [true, true, false, true],
    ),
    Student(
      id: 3,
      name: 'عبد الله مولاي',
      isFemale: false,
      dob: '08/11/2007',
      group: 'فوج 1',
      memorization: 'من 10 إلى 15 جزءاً',
      studentPhone: '0796969606',
      username: '110303',
      password: 'Bz6rV1',
      docs: [true, true, true, true],
    ),
    Student(
      id: 4,
      name: 'أنس الهاشمي',
      isFemale: false,
      dob: '30/01/2013',
      group: 'فوج 1',
      memorization: 'لا يوجد حفظ سابق',
      username: '010404',
      password: 'Hm8sL3',
      parentName: 'هاشم الأنصاري',
      parentPhone: '0773456789',
      docs: [true, false, true, false],
    ),
    Student(
      id: 5,
      name: 'حمزة بلقاسم',
      isFemale: false,
      dob: '14/07/2010',
      group: 'فوج 2',
      memorization: 'جزء عمّ',
      username: '070505',
      password: 'Jp2dF5',
      parentName: 'بلقاسم حمزة',
      parentPhone: '0554567890',
      docs: [true, true, true, true],
    ),
    Student(
      id: 6,
      name: 'طارق بن صالح',
      isFemale: false,
      dob: '05/09/2006',
      group: 'فوج 2',
      memorization: 'من 5 إلى 10 أجزاء',
      studentPhone: '0791234567',
      username: '090606',
      password: 'Wc9eG7',
      docs: [true, true, true, true],
    ),
    Student(
      id: 7,
      name: 'كريم العلوي',
      isFemale: false,
      dob: '19/04/2012',
      group: 'فوج 2',
      memorization: 'جزء عمّ',
      username: '040707',
      password: 'Ry3kA4',
      parentName: 'العلوي بن خالد',
      parentPhone: '0665678901',
      docs: [false, true, true, false],
    ),
    Student(
      id: 8,
      name: 'بلال التلمساني',
      isFemale: false,
      dob: '25/12/2008',
      group: 'فوج 3',
      memorization: 'من 5 إلى 10 أجزاء',
      studentPhone: '0771234567',
      username: '120808',
      password: 'Lq7tD6',
      docs: [true, true, false, true],
    ),
    Student(
      id: 9,
      name: 'رمزي بوزيد',
      isFemale: false,
      dob: '03/02/2011',
      group: 'فوج 3',
      memorization: 'جزء عمّ',
      username: '020909',
      password: 'Vb5xH8',
      parentName: 'بوزيد حسين',
      parentPhone: '0776789012',
      docs: [true, true, true, true],
    ),
    Student(
      id: 10,
      name: 'محمد نعيم',
      isFemale: false,
      dob: '11/08/2009',
      group: 'فوج 3',
      memorization: 'من 1 إلى 5 أجزاء',
      parentName: 'النعيم عبد القادر',
      parentPhone: '0667890123',
      username: '081010',
      password: 'Md1yJ2',
      docs: [true, false, true, true],
    ),
    Student(
      id: 11,
      name: 'إبراهيم الساحلي',
      isFemale: false,
      dob: '17/05/2013',
      group: 'فوج 4',
      memorization: 'لا يوجد حفظ سابق',
      username: '051111',
      password: 'Sk4uC9',
      parentName: 'الساحلي عبد الرحمن',
      parentPhone: '0557890123',
      docs: [true, true, true, false],
    ),
    Student(
      id: 12,
      name: 'إسلام بن حمو',
      isFemale: false,
      dob: '28/10/2007',
      group: 'فوج 4',
      memorization: 'من 10 إلى 15 جزءاً',
      studentPhone: '0799876543',
      username: '101212',
      password: 'Rq5nK7',
      docs: [true, true, true, true],
    ),
    Student(
      id: 13,
      name: 'أيمن بلحاج',
      isFemale: false,
      dob: '06/06/2012',
      group: 'فوج 4',
      memorization: 'جزء عمّ',
      username: '061313',
      password: 'Xp8vM3',
      parentName: 'بلحاج مصطفى',
      parentPhone: '0668901234',
      docs: [false, true, false, true],
    ),
    Student(
      id: 14,
      name: 'زكريا الوناس',
      isFemale: false,
      dob: '22/03/2010',
      group: 'فوج 5',
      memorization: 'من 1 إلى 5 أجزاء',
      username: '031414',
      password: 'Yw2cE6',
      parentName: 'الوناس نصر الدين',
      parentPhone: '0779012345',
      docs: [true, true, true, true],
    ),
    Student(
      id: 15,
      name: 'عمران بن عودة',
      isFemale: false,
      dob: '14/09/2008',
      group: 'فوج 5',
      memorization: 'من 5 إلى 10 أجزاء',
      studentPhone: '0799876543',

      username: '091515',
      password: 'Dn3tR8',
      docs: [true, true, false, false],
    ),
    // ── إناث ──
    Student(
      id: 16,
      name: 'مريم الحسيني',
      isFemale: true,
      dob: '10/04/2012',
      group: 'فوج 1',
      memorization: 'جزء عمّ',
      username: '041616',
      password: 'Fp6qZ2',
      parentName: 'الحسيني نور الدين',
      parentPhone: '0550123456',
      docs: [true, true, true, false],
    ),
    Student(
      id: 17,
      name: 'سلمى بن عيسى',
      isFemale: true,
      dob: '27/07/2009',
      group: 'فوج 1',
      memorization: 'من 1 إلى 5 أجزاء',
      studentPhone: '0799876543',
      username: '071717',
      password: 'Gw5oA4',
      docs: [true, true, true, true],
    ),
    Student(
      id: 18,
      name: 'ريم بوطبة',
      isFemale: true,
      dob: '02/01/2013',
      group: 'فوج 1',
      memorization: 'لا يوجد حفظ سابق',
      username: '011818',
      password: 'Ht7lB9',
      parentName: 'بوطبة السعيد',
      parentPhone: '0661234567',
      docs: [true, false, true, false],
    ),
    Student(
      id: 19,
      name: 'آمال الشريف',
      isFemale: true,
      dob: '15/11/2011',
      group: 'فوج 2',
      memorization: 'جزء عمّ',
      username: '111919',
      password: 'Kv3mW5',
      parentName: 'الشريف كمال',
      parentPhone: '0772345678',
      docs: [true, true, false, true],
    ),
    Student(
      id: 20,
      name: 'نادية قادري',
      isFemale: true,
      dob: '08/06/2007',
      group: 'فوج 2',
      memorization: 'من 10 إلى 15 جزءاً',
      studentPhone: '0799876543',

      username: '062020',
      password: 'Qb1xN6',
      docs: [true, true, true, true],
    ),
    Student(
      id: 21,
      name: 'هاجر بن محمود',
      isFemale: true,
      dob: '20/09/2012',
      group: 'فوج 2',
      memorization: 'جزء عمّ',
      username: '092121',
      password: 'Uc8yP1',
      parentName: 'بن محمود يحيى',
      parentPhone: '0553456789',
      docs: [false, true, true, false],
    ),
    Student(
      id: 22,
      name: 'لينة بن صالح',
      isFemale: true,
      dob: '12/03/2013',
      group: 'فوج 3',
      memorization: 'لا يوجد حفظ سابق',
      username: '032222',
      password: 'Ie9sC3',
      parentName: 'بن صالح طارق',
      parentPhone: '0664567890',
      docs: [true, true, true, true],
    ),
    Student(
      id: 23,
      name: 'وسيلة بن زيان',
      isFemale: true,
      dob: '05/08/2008',
      group: 'فوج 3',
      memorization: 'من 5 إلى 10 أجزاء',
      studentPhone: '0799876543',

      username: '082323',
      password: 'Jf2rD7',
      docs: [true, false, true, true],
    ),
    Student(
      id: 24,
      name: 'زينب الغزالي',
      isFemale: true,
      dob: '18/12/2010',
      group: 'فوج 4',
      memorization: 'من 1 إلى 5 أجزاء',
      username: '122424',
      password: 'Ag6wF8',
      parentName: 'الغزالي علي',
      parentPhone: '0775678901',
      docs: [true, true, false, false],
    ),
    Student(
      id: 25,
      name: 'أسماء بن ناصر',
      isFemale: true,
      dob: '30/05/2011',
      group: 'فوج 4',
      memorization: 'جزء عمّ',
      username: '052525',
      password: 'Bh4tG2',
      parentName: 'بن ناصر الحاج',
      parentPhone: '0556789012',
      docs: [true, true, true, true],
    ),
    Student(
      id: 26,
      name: 'إيمان بوضياف',
      isFemale: true,
      dob: '14/02/2006',
      group: 'فوج 4',
      memorization: 'أكثر من 20 جزءاً',
      studentPhone: '0776644500',
      username: '022626',
      password: 'Ci7uH5',
      docs: [true, true, true, true],
    ),
    Student(
      id: 27,
      name: 'رحمة التواتي',
      isFemale: true,
      dob: '07/07/2012',
      group: 'فوج 5',
      memorization: 'جزء عمّ',
      username: '072727',
      password: 'Dj9vI3',
      parentName: 'التواتي بكر',
      parentPhone: '0667890123',
      docs: [true, false, false, true],
    ),
    Student(
      id: 28,
      name: 'صفاء الزاهر',
      isFemale: true,
      dob: '25/10/2009',
      group: 'فوج 5',
      memorization: 'من 1 إلى 5 أجزاء',
      studentPhone: '0799876543',

      username: '102828',
      password: 'Ek2wJ6',
      docs: [true, true, true, false],
    ),
  ];

  // ── حالة الشاشة ──
  late final TabController _tabCtrl;
  final _searchCtrl = TextEditingController();
  String _searchQ = '';
  String? _selectedGroup;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (!_tabCtrl.indexIsChanging) {
          setState(() {
            _searchQ = '';
            _searchCtrl.clear();
            // نحتفظ باختيار الفوج للتنقل بين جنسَي نفس الفوج
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

  // ── مساعدات ──
  bool get _isFemale => _tabCtrl.index == 1;

  Map<String, String> get _teachers =>
      _isFemale ? _femaleTeachers : _maleTeachers;

  List<Student> _byGender(bool female) =>
      _allStudents.where((s) => s.isFemale == female).toList();

  List<Student> _groupStudents(bool female) {
    if (_selectedGroup == null) return [];
    return _byGender(female).where((s) => s.group == _selectedGroup).toList();
  }

  List<Student> _displayed(bool female) {
    final gs = _groupStudents(female);
    if (_searchQ.isEmpty) return gs;
    final q = _searchQ.toLowerCase();
    return gs
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              s.username.toLowerCase().contains(q),
        )
        .toList();
  }

  // نسخ مع SnackBar
  void _copy(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ تم نسخ $label'),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
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
            'قائمة الطلبة',
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
    final maleCount = _byGender(false).length;
    final femaleCount = _byGender(true).length;
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
          Tab(child: _tabLabel('👦  الطلبة', maleCount)),
          Tab(child: _tabLabel('👧  الطالبات', femaleCount)),
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

  // ═══════════════════════════════════════════════════════════════════
  // محتوى كل تبويب
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildContent({required bool female}) {
    final teachers = female ? _femaleTeachers : _maleTeachers;
    final displayed = _displayed(female);
    final groupCount = _groupStudents(female).length;
    final totalGender = _byGender(female).length;
    final teacher = _selectedGroup != null
        ? (teachers[_selectedGroup!] ?? '—')
        : '—';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── اختيار الفوج ──
          _buildGroupSelector(teachers),
          const SizedBox(height: 14),

          // ── بطاقات الملخص ──
          _buildSummaryCards(
            totalGender: totalGender,
            groupCount: teachers.length,
            currentGroupCount: groupCount,
            teacher: teacher,
            female: female,
          ),
          const SizedBox(height: 14),

          // ── بنر الفوج (يظهر عند اختيار فوج) ──
          if (_selectedGroup != null) ...[
            _buildGroupBanner(teacher, groupCount, female),
            const SizedBox(height: 14),
            // ── بحث ──
            _buildSearch(),
            const SizedBox(height: 14),
            // ── جدول / حالة فارغة ──
            displayed.isEmpty ? _buildEmptyState() : _buildTable(displayed),
          ] else
            _buildSelectGroupPrompt(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── منتقي الفوج ──
  Widget _buildGroupSelector(Map<String, String> teachers) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedGroup,
      decoration: InputDecoration(
        labelText: 'اختر الفوج',
        prefixIcon: Icon(
          Icons.group_outlined,
          size: 18,
          color: Colors.grey[600],
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _gradientStart, width: 1.5),
        ),
      ),
      items: [
        const DropdownMenuItem<String>(value: null, child: Text('— الكل —')),
        ...teachers.keys.map(
          (g) => DropdownMenuItem<String>(value: g, child: Text(g)),
        ),
      ],
      onChanged: (v) => setState(() => _selectedGroup = v),
    );
  }

  // ── بطاقات الملخص ──
  Widget _buildSummaryCards({
    required int totalGender,
    required int groupCount,
    required int currentGroupCount,
    required String teacher,
    required bool female,
  }) {
    final label = female ? 'إجمالي الطالبات' : 'إجمالي الطلبة';
    final cards = [
      _CardData(
        icon: Icons.people_alt_outlined,
        label: label,
        value: '$totalGender',
        color: Colors.blue.shade700,
      ),
      _CardData(
        icon: Icons.group_work_outlined,
        label: 'عدد الأفواج',
        value: '$groupCount',
        color: Colors.teal.shade600,
      ),
      _CardData(
        icon: Icons.groups_2_outlined,
        label: 'طلبة الفوج الحالي',
        value: _selectedGroup != null ? '$currentGroupCount' : '—',
        color: Colors.purple.shade600,
      ),
      _CardData(
        icon: Icons.school_outlined,
        label: 'الأستاذ المشرف',
        value: teacher,
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
                    fontSize: 17,
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

  // ── بنر الفوج المحدد ──
  Widget _buildGroupBanner(String teacher, int count, bool female) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: _appGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _gradientStart.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.group, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedGroup ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'الأستاذ المشرف: $teacher',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count ${female ? 'طالبة' : 'طالب'}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── حقل البحث ──
  Widget _buildSearch() {
    return TextField(
      controller: _searchCtrl,
      decoration: InputDecoration(
        hintText: 'البحث بالاسم أو اسم المستخدم...',
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: _searchQ.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () {
                  _searchCtrl.clear();
                  setState(() => _searchQ = '');
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
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
      ),
    );
  }

  // ── موجّه اختيار الفوج ──
  Widget _buildSelectGroupPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.touch_app_outlined, size: 54, color: Colors.grey[350]),
            const SizedBox(height: 12),
            Text(
              'اختر فوجًا من القائمة أعلاه لعرض الطلبة.',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  // ── الحالة الفارغة ──
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('👨‍🎓', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(
              'لا يوجد طلبة مسجلون في هذا الفوج.',
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // الجدول
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildTable(List<Student> students) {
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
              ...students.asMap().entries.map(
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
          _hCell('#', w: 44),
          _hCell('الاسم واللقب', w: 158),
          _hCell('تاريخ الميلاد', w: 108),
          _hCell('كمية الحفظ', w: 145),
          _hCell('ولي الأمر', w: 180),
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
          fontSize: 12,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }

  Widget _buildTableRow(Student s, bool isEven) {
    return Container(
      color: isEven ? Colors.grey.shade50 : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          // رقم الطالب
          SizedBox(
            width: 44,
            child: Center(
              child: Text(
                '${s.id}',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
          ),

          // الاسم
          SizedBox(
            width: 158,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: _gradientStart.withValues(alpha: 0.12),
                  child: Text(
                    s.name.isNotEmpty ? s.name[0] : '؟',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _gradientStart,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    s.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // تاريخ الميلاد
          SizedBox(
            width: 108,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    s.dob,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    '${s.age} سنة',
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),

          // كمية الحفظ
          SizedBox(
            width: 145,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Text(
                  s.memorization,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.teal.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

          // ولي الأمر أو رقم الطالب
          SizedBox(
            width: 180,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: s.isAdult
                  ? _adultIdBadge(studentPhone: s.studentPhone)
                  : _parentInfo(s.parentName, s.parentPhone),
            ),
          ),

          // الإجراءات
          SizedBox(
            width: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionBtn(
                  Icons.visibility_outlined,
                  Colors.blue.shade600,
                  'عرض',
                  () => _showDetails(s),
                ),
                _actionBtn(
                  Icons.edit_outlined,
                  Colors.orange.shade600,
                  'تعديل',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditStudentScreen(student: s),
                    ),
                  ),
                ),
                _actionBtn(
                  Icons.delete_outline,
                  Colors.red.shade600,
                  'حذف',
                  () => _confirmDelete(s),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // رقم التعريف للطالب البالغ
  Widget _adultIdBadge({String? studentPhone}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.person_outline, size: 12, color: Colors.grey[500]),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                "رقم الطالب",
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (studentPhone != null)
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 12, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                studentPhone,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
      ],
    );
  }

  // معلومات ولي الأمر
  Widget _parentInfo(String? name, String? phone) {
    if (name == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.person_outline, size: 12, color: Colors.grey[500]),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (phone != null)
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 12, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
      ],
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
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // نافذة التفاصيل الكاملة
  // ═══════════════════════════════════════════════════════════════════
  void _showDetails(Student s) {
    final bool isWide = MediaQuery.of(context).size.width >= 600;
    if (isWide) {
      showDialog(
        context: context,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: _DetailsSheet(
                student: s,
                docNames: _docNames,
                teachers: _teachers,
                onCopy: _copy,
                onClose: () => Navigator.pop(context),
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
            initialChildSize: 0.75,
            maxChildSize: 0.95,
            expand: false,
            builder: (_, ctrl) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: _DetailsSheet(
                student: s,
                docNames: _docNames,
                teachers: _teachers,
                onCopy: _copy,
                onClose: () => Navigator.pop(context),
                scrollController: ctrl,
              ),
            ),
          ),
        ),
      );
    }
  }

  // ── تأكيد الحذف ──
  void _confirmDelete(Student s) {
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
            'هل أنت متأكد من حذف الطالب "${s.name}"؟\nلا يمكن التراجع عن هذا الإجراء.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🗑️ تم حذف الطالب "${s.name}" (تجريبي)'),
                    backgroundColor: Colors.red.shade600,
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
}

// ═══════════════════════════════════════════════════════════════════
// نافذة تفاصيل الطالب — مكوّن مستقل يحمل حالة إظهار/إخفاء كلمة المرور
// ═══════════════════════════════════════════════════════════════════
class _DetailsSheet extends StatefulWidget {
  const _DetailsSheet({
    required this.student,
    required this.docNames,
    required this.teachers,
    required this.onCopy,
    required this.onClose,
    this.scrollController,
  });

  final Student student;
  final List<String> docNames;
  final Map<String, String> teachers;
  final void Function(String, String) onCopy;
  final VoidCallback onClose;
  final ScrollController? scrollController;

  @override
  State<_DetailsSheet> createState() => _DetailsSheetState();
}

class _DetailsSheetState extends State<_DetailsSheet> {
  bool _pwVisible = false;

  static const Color _accent = Color(0xff1565C0);

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // مقبض (للـ BottomSheet)
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

          // ── رأس البطاقة ──
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: _accent.withValues(alpha: 0.12),
                child: Text(
                  s.name.isNotEmpty ? s.name[0] : '؟',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _accent,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      '${s.isFemale ? 'طالبة' : 'طالب'} — ${s.group} — ${s.age} سنة',
                      style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 12),

          // ── قسم 1: معلومات الطالب ──
          _sectionTitle(
            'معلومات الطالب',
            Icons.person_outline,
            Colors.blue.shade700,
          ),
          const SizedBox(height: 10),
          _infoRow(Icons.tag, 'رقم الطالب', '${s.id}'),
          _infoRow(Icons.person, 'الاسم واللقب', s.name),
          _infoRow(Icons.calendar_today, 'تاريخ الميلاد', s.dob),
          _infoRow(Icons.wc, 'الجنس', s.isFemale ? 'أنثى' : 'ذكر'),
          _infoRow(Icons.group_outlined, 'الفوج', s.group),
          _infoRow(Icons.menu_book, 'كمية الحفظ', s.memorization),

          // ── قسم 2: معلومات ولي الأمر (فقط للقاصرين ≤16) ──
          if (!s.isAdult && s.parentName != null) ...[
            const SizedBox(height: 14),
            _sectionTitle(
              'معلومات ولي الأمر',
              Icons.supervisor_account_outlined,
              Colors.teal.shade600,
            ),
            const SizedBox(height: 10),
            _infoRow(Icons.person_outline, 'الاسم', s.parentName!),
            _infoRow(
              Icons.phone_outlined,
              'رقم الهاتف',
              s.parentPhone?.toString() ?? '—',
            ),
          ],

          // ── قسم 3: معلومات الحساب ──
          const SizedBox(height: 14),
          _sectionTitle(
            'معلومات الحساب',
            Icons.lock_outline,
            Colors.purple.shade600,
          ),
          const SizedBox(height: 10),

          // اسم المستخدم
          _credentialBox(
            label: 'اسم المستخدم',
            value: s.username,
            icon: Icons.fingerprint,
            color: Colors.blue.shade700,
            isPassword: false,
            visible: true,
            onToggle: null,
            onCopy: () => widget.onCopy(s.username, 'اسم المستخدم'),
          ),
          const SizedBox(height: 8),
          // كلمة المرور
          _credentialBox(
            label: 'كلمة المرور',
            value: s.password,
            icon: Icons.lock_outline,
            color: Colors.orange.shade700,
            isPassword: true,
            visible: _pwVisible,
            onToggle: () => setState(() => _pwVisible = !_pwVisible),
            onCopy: () => widget.onCopy(s.password, 'كلمة المرور'),
          ),

          // ── قسم 4: الوثائق الإدارية ──
          const SizedBox(height: 14),
          _sectionTitle(
            'الوثائق الإدارية',
            Icons.folder_outlined,
            Colors.green.shade700,
          ),
          const SizedBox(height: 10),
          _buildDocGrid(s.docs),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
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
    );
  }

  Widget _sectionTitle(String label, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Icon(icon, size: 15, color: Colors.grey[500]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _credentialBox({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isPassword,
    required bool visible,
    required VoidCallback? onToggle,
    required VoidCallback onCopy,
  }) {
    final display = (isPassword && !visible) ? '••••••••' : value;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 13),
                    const SizedBox(width: 5),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  display,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: isPassword && !visible ? 2 : 1.2,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          if (isPassword && onToggle != null)
            InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  visible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: Colors.grey[500],
                ),
              ),
            ),
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: onCopy,
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.copy_rounded, size: 16, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocGrid(List<bool> docs) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3.8,
      ),
      itemCount: widget.docNames.length,
      itemBuilder: (_, i) {
        final done = docs[i];
        final color = done ? Colors.green.shade600 : Colors.orange.shade700;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(
                done ? Icons.check_circle : Icons.hourglass_empty,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.docNames[i],
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
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
