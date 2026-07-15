// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/pages/Admin/screens/teacher_manage/pages/edit_teacher_screen.dart';
import '../model/teacher_model.dart';

// ─────────────────────────────────────────────
// شاشة قائمة الأساتذة
// ─────────────────────────────────────────────
class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen>
    with SingleTickerProviderStateMixin {
  // ── ألوان ──
  static const Color _gradientStart = Color(0xff1565C0);
  static const Color _gradientEnd = Color(0xff42A5F5);
  static const LinearGradient _appGradient = LinearGradient(
    colors: [_gradientStart, _gradientEnd],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ── بيانات تجريبية ──
  static const List<Teacher> _allTeachers = [
    Teacher(
      id: 1,
      isFemale: false,
      name: 'أحمد بن علي',
      username: '060101',
      password: 'Xk7mP2',
      teacherPhone: '0551234567',
      dob: '1985/06/01',
      groups: ['فوج 1', 'فوج 2', 'فوج 3'],
    ),
    Teacher(
      id: 2,
      isFemale: false,
      name: 'يوسف الإدريسي',
      username: '071503',
      password: 'Nt4wQ9',
      teacherPhone: '0662345678',
      dob: '1990/07/15',
      groups: ['فوج 4', 'فوج 5'],
    ),
    Teacher(
      id: 3,
      isFemale: false,
      name: 'محمد الأمين',
      username: '082204',
      password: 'Bz6rV1',
      teacherPhone: '0773456789',
      dob: '1988/08/22',
      groups: ['فوج 6'],
    ),
    Teacher(
      id: 4,
      isFemale: false,
      name: 'عبد الرحمن كريم',
      username: '030505',
      password: 'Hm8sL3',
      teacherPhone: '0554567890',
      dob: '1992/03/05',
      groups: ['فوج 1', 'فوج 7', 'فوج 8'],
    ),
    Teacher(
      id: 5,
      isFemale: false,
      name: 'خالد بن عمر',
      username: '111206',
      password: 'Jp2dF5',
      teacherPhone: '0665678901',
      dob: '1986/11/12',
      groups: ['فوج 2', 'فوج 3', 'فوج 4', 'فوج 5'],
    ),
    Teacher(
      id: 6,
      isFemale: false,
      name: 'رشيد مصطفى',
      username: '040907',
      password: 'Wc9eG7',
      teacherPhone: '0776789012',
      dob: '1994/04/09',
      groups: ['فوج 6', 'فوج 7'],
    ),
    Teacher(
      id: 7,
      isFemale: true,
      name: 'سارة محمد',
      username: '121808',
      password: 'Ry3kA4',
      teacherPhone: '0557890123',
      dob: '1991/12/18',
      groups: ['فوج 1', 'فوج 2'],
    ),
    Teacher(
      id: 8,
      isFemale: true,
      name: 'فاطمة الزهراء',
      username: '050209',
      password: 'Lq7tD6',
      teacherPhone: '0668901234',
      dob: '1989/05/02',
      groups: ['فوج 3', 'فوج 4', 'فوج 5'],
    ),
    Teacher(
      id: 9,
      isFemale: true,
      name: 'نور الإيمان',
      username: '092510',
      password: 'Vb5xH8',
      teacherPhone: '0779012345',
      dob: '1993/09/25',
      groups: ['فوج 6'],
    ),
    Teacher(
      id: 10,
      isFemale: true,
      name: 'أمينة بوعلام',
      username: '010311',
      password: 'Md1yJ2',
      teacherPhone: '0550123456',
      dob: '1987/01/03',
      groups: ['فوج 7', 'فوج 8'],
    ),
    Teacher(
      id: 11,
      isFemale: true,
      name: 'حليمة بن سعيد',
      username: '071412',
      password: 'Sk4uC9',
      teacherPhone: '0661234567',
      dob: '1995/07/14',
      groups: ['فوج 1', 'فوج 2', 'فوج 3', 'فوج 4'],
    ),
  ];

  // ── متغيرات الحالة ──
  late final TabController _tabCtrl;
  final TextEditingController _searchCtrl = TextEditingController();
  String? _selectedGroupFilter; // null = الكل
  String _searchQuery = '';
  // مجموعة IDs الأساتذة الذين تظهر كلمة مرورهم
  final Set<int> _visiblePasswords = {};

  // ── الأفواج المتاحة (للفلتر) ──
  static final List<String> _allGroups = () {
    final Set<String> gs = {};
    for (final t in _allTeachers) {
      gs.addAll(t.groups);
    }
    final list = gs.toList()..sort();
    return list;
  }();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
    _searchCtrl.addListener(
      () => setState(() => _searchQuery = _searchCtrl.text.trim()),
    );
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── فلترة القائمة ──
  List<Teacher> _filtered(bool female) {
    return _allTeachers.where((t) {
      if (t.isFemale != female) return false;
      if (_selectedGroupFilter != null &&
          !t.groups.contains(_selectedGroupFilter)) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!t.name.toLowerCase().contains(q) &&
            !t.username.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  // ── إجماليات ──
  int get _totalMale => _allTeachers.where((t) => !t.isFemale).length;
  int get _totalFemale => _allTeachers.where((t) => t.isFemale).length;
  int get _totalGroupsAssigned =>
      _allTeachers.fold(0, (sum, t) => sum + t.groups.length);
  double get _avgGroupsPerTeacher =>
      _allTeachers.isEmpty ? 0 : _totalGroupsAssigned / _allTeachers.length;

  // ── نسخ للحافظة ──
  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ تم نسخ $label'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }

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
            'قائمة الأساتذة',
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
              // ── المحتوى ──
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

  // ─────────────────────────────────────────────
  // شريط التبويب
  // ─────────────────────────────────────────────
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
                _tabBadge(_totalMale),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('👩  الأستاذات'),
                const SizedBox(width: 8),
                _tabBadge(_totalFemale),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBadge(int count) {
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

  // ─────────────────────────────────────────────
  // محتوى كل تبويب
  // ─────────────────────────────────────────────
  Widget _buildTabContent({required bool female}) {
    final teachers = _filtered(female);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 16),
          _buildSearchAndFilter(),
          const SizedBox(height: 16),
          teachers.isEmpty ? _buildEmptyState() : _buildTable(teachers),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // بطاقات الملخص
  // ─────────────────────────────────────────────
  Widget _buildSummaryCards() {
    final cards = [
      _SummaryCardData(
        icon: Icons.person,
        label: 'إجمالي الأساتذة',
        value: '$_totalMale',
        color: Colors.blue.shade700,
      ),
      _SummaryCardData(
        icon: Icons.person_2,
        label: 'إجمالي الأستاذات',
        value: '$_totalFemale',
        color: Colors.pink.shade600,
      ),
      _SummaryCardData(
        icon: Icons.group_work_outlined,
        label: 'إجمالي الأفواج المسندة',
        value: '$_totalGroupsAssigned',
        color: Colors.teal.shade600,
      ),
      _SummaryCardData(
        icon: Icons.bar_chart,
        label: 'متوسط الأفواج / أستاذ',
        value: _avgGroupsPerTeacher.toStringAsFixed(1),
        color: Colors.purple.shade600,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final int cols = constraints.maxWidth >= 800 ? 4 : 2;
        final double spacing = 12;
        final double cardW =
            (constraints.maxWidth - spacing * (cols - 1)) / cols;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: cards
              .map((c) => SizedBox(width: cardW, child: _buildSummaryCard(c)))
              .toList(),
        );
      },
    );
  }

  Widget _buildSummaryCard(_SummaryCardData data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border(right: BorderSide(color: data.color, width: 4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  data.value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: data.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // شريط البحث والفلتر
  // ─────────────────────────────────────────────
  Widget _buildSearchAndFilter() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 560;
        final searchField = TextField(
          controller: _searchCtrl,
          decoration: InputDecoration(
            hintText: 'البحث بالاسم أو اسم المستخدم...',
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _searchQuery = '');
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

        final filterDropdown = DropdownButtonFormField<String>(
          initialValue: _selectedGroupFilter,
          decoration: InputDecoration(
            labelText: 'الفوج',
            prefixIcon: const Icon(Icons.filter_list, size: 18),
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
          items: [
            const DropdownMenuItem(value: null, child: Text('كل الأفواج')),
            ..._allGroups.map(
              (g) => DropdownMenuItem(value: g, child: Text(g)),
            ),
          ],
          onChanged: (v) => setState(() => _selectedGroupFilter = v),
        );

        if (isWide) {
          return Row(
            children: [
              Expanded(flex: 3, child: searchField),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: filterDropdown),
            ],
          );
        }
        return Column(
          children: [searchField, const SizedBox(height: 10), filterDropdown],
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // الجدول
  // ─────────────────────────────────────────────
  Widget _buildTable(List<Teacher> teachers) {
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
              // ── ترويسة الجدول ──
              _buildTableHeader(),
              // ── صفوف البيانات ──
              ...teachers.asMap().entries.map((entry) {
                return _buildTableRow(entry.value, entry.key.isEven);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: _gradientStart.withValues(alpha: 0.08),
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      child: Row(
        children: [
          _headerCell('#', width: 36),
          _headerCell('الاسم واللقب', width: 160),
          _headerCell('عدد الأفواج', width: 100),
          _headerCell('اسم المستخدم', width: 150),
          _headerCell('كلمة المرور', width: 175),
          _headerCell('رقم الهاتف', width: 130),
          _headerCell('تاريخ الميلاد', width: 115),
          _headerCell('الإجراءات', width: 130),
        ],
      ),
    );
  }

  Widget _headerCell(String text, {required double width}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.5,
          color: Colors.blue.shade900,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableRow(Teacher t, bool isEven) {
    final bool pwVisible = _visiblePasswords.contains(t.id);

    return Container(
      color: isEven ? Colors.grey.shade50 : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          // رقم
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
            width: 160,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: _gradientStart.withValues(alpha: 0.12),
                  child: Text(
                    t.name.characters.first,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _gradientStart,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // عدد الأفواج
          SizedBox(
            width: 100,
            child: Center(child: _groupCountBadge(t.groups.length)),
          ),

          // اسم المستخدم + نسخ
          SizedBox(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  t.username,
                  style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
                ),
                const SizedBox(width: 4),
                _iconCopyBtn(
                  onTap: () =>
                      _copyToClipboard(context, t.username, 'اسم المستخدم'),
                  color: Colors.blue.shade700,
                ),
              ],
            ),
          ),

          // كلمة المرور + إظهار/إخفاء + نسخ
          SizedBox(
            width: 175,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pwVisible ? t.password : '••••••••',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: pwVisible ? 'monospace' : null,
                    letterSpacing: pwVisible ? 1.2 : 2,
                    color: pwVisible ? Colors.black87 : Colors.grey[500],
                  ),
                ),
                const SizedBox(width: 2),
                // إظهار/إخفاء
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () => setState(() {
                    if (pwVisible) {
                      _visiblePasswords.remove(t.id);
                    } else {
                      _visiblePasswords.add(t.id);
                    }
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      pwVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                // نسخ
                _iconCopyBtn(
                  onTap: () =>
                      _copyToClipboard(context, t.password, 'كلمة المرور'),
                  color: Colors.orange.shade700,
                ),
              ],
            ),
          ),

          // رقم الهاتف
          SizedBox(
            width: 130,
            child: Center(
              child: Text(
                t.teacherPhone!.toString(),
                style: const TextStyle(fontSize: 12.5),
              ),
            ),
          ),

          // تاريخ الميلاد
          SizedBox(
            width: 115,
            child: Center(
              child: Text(
                t.dob,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ),

          // الإجراءات
          SizedBox(
            width: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionBtn(
                  icon: Icons.visibility_outlined,
                  color: Colors.blue.shade600,
                  tooltip: 'عرض',
                  onTap: () => _showTeacherDetails(t),
                ),
                // _actionBtn(
                //   icon: Icons.edit_outlined,
                //   color: Colors.orange.shade600,
                //   tooltip: 'تعديل',
                //   onTap: () {},
                // ),
                _actionBtn(
                  icon: Icons.edit_outlined,
                  color: Colors.orange.shade600,
                  tooltip: 'تعديل',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTeacherScreen(teacher: t),
                    ),
                  ),
                ),
                _actionBtn(
                  icon: Icons.delete_outline,
                  color: Colors.red.shade600,
                  tooltip: 'حذف',
                  onTap: () => _confirmDelete(t),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── شارة عدد الأفواج ──
  Widget _groupCountBadge(int count) {
    final Color color;
    if (count == 1) {
      color = Colors.green.shade600;
    } else if (count <= 3)
      color = Colors.blue.shade600;
    else if (count <= 5)
      color = Colors.orange.shade700;
    else
      color = Colors.purple.shade600;

    final String label = count == 1
        ? '1 فوج'
        : count < 11 && count > 2
        ? '$count أفواج'
        : '$count فوجًا';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  // ── زر نسخ صغير ──
  Widget _iconCopyBtn({required VoidCallback onTap, required Color color}) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(Icons.copy_rounded, size: 15, color: color),
      ),
    );
  }

  // ── أزرار الإجراءات ──
  Widget _actionBtn({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
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

  // ─────────────────────────────────────────────
  // الحالة الفارغة
  // ─────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const Text('👨‍🏫', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 14),
            Text(
              'لا يوجد أساتذة مسجلون حالياً.',
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // نافذة تفاصيل الأستاذ
  // ─────────────────────────────────────────────
  void _showTeacherDetails(Teacher t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // مقبض
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // رأس البطاقة
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: _gradientStart.withValues(alpha: 0.12),
                    child: Text(
                      t.name.characters.first,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _gradientStart,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.isFemale ? 'أستاذة' : 'أستاذ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _groupCountBadge(t.groups.length),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              _detailRow(Icons.fingerprint, 'اسم المستخدم', t.username),
              _detailRow(
                Icons.phone_outlined,
                'رقم الهاتف',
                t.teacherPhone!.toString(),
              ),
              _detailRow(Icons.calendar_today, 'تاريخ الميلاد', t.dob),
              const SizedBox(height: 8),
              // الأفواج
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.group_outlined, size: 17, color: Colors.grey[500]),
                  const SizedBox(width: 10),
                  Text(
                    'الأفواج: ',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: t.groups
                          .map(
                            (g) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _gradientStart.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _gradientStart.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                g,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _gradientStart,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 17, color: Colors.grey[500]),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // تأكيد الحذف
  // ─────────────────────────────────────────────
  void _confirmDelete(Teacher t) {
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
            'هل أنت متأكد من حذف ${t.isFemale ? 'الأستاذة' : 'الأستاذ'} "${t.name}"؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
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

// ─────────────────────────────────────────────
// نموذج مساعد لبيانات بطاقة الملخص
// ─────────────────────────────────────────────
class _SummaryCardData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _SummaryCardData({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}
