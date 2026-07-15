import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/utils/date_formatter.dart';
import 'package:quran_app/utils/date_widget.dart';
import '../model/teacher_model.dart';

// ══════════════════════════════════════════════════════════════════
// شاشة تعديل بيانات الطالب — وحدة الإدارة
// واجهة فقط — لا يوجد أي منطق خلفي أو قاعدة بيانات
// ══════════════════════════════════════════════════════════════════

class EditTeacherScreen extends StatefulWidget {
  /// جميع البيانات تُمرَّر من شاشة قائمة الطلبة
  const EditTeacherScreen({
    super.key,
    // ignore: library_private_types_in_public_api
    required this.teacher,
  });
  // ignore: library_private_types_in_public_api
  final Teacher teacher;

  int get teacherId => teacher.id;
  String get teacherName => teacher.name;
  bool get isFemale => teacher.isFemale;
  String get dob => teacher.dob;
  List<String> get groups => teacher.groups;
  String get username => teacher.username;
  String get password => teacher.password;
  String? get teacherPhone => teacher.teacherPhone;

  @override
  State<EditTeacherScreen> createState() => _EditTeacherScreenState();
}

class _EditTeacherScreenState extends State<EditTeacherScreen>
    with SingleTickerProviderStateMixin {
  // ── ألوان الوحدة ──
  static const Color _primary = Color(0xff1565C0);
  static const Color _primaryLight = Color(0xff42A5F5);
  static const LinearGradient _grad = LinearGradient(
    colors: [_primary, _primaryLight],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ── TabController ──
  late final TabController _tabCtrl;

  // ── مفاتيح النماذج ──
  final _personalKey = GlobalKey<FormState>();
  final _accountKey = GlobalKey<FormState>();

  // ── تبويب 1 ──
  late TextEditingController _nameCtrl;

  late TextEditingController _dobCtrl;
  late DateTime _dob;
  String? _gender;

  // ── تبويب 2 ──
  late TextEditingController _guardianNameCtrl;
  late TextEditingController _guardianPhoneCtrl;
  late TextEditingController _teacherPhoneCtrl;

  // ── تبويب 3 ──
  late TextEditingController _usernameCtrl;
  late TextEditingController _passwordCtrl;
  bool _pwVisible = false;

  // ── تبويب 4 ──
  // late List<bool> _docs;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);

    _dob = _parseDob(widget.dob);
    _dobCtrl = TextEditingController(text: widget.dob);
    _nameCtrl = TextEditingController(text: widget.teacherName);
    _gender = widget.isFemale ? 'أستاذة' : 'أستاذ';
    // _group = _groups.contains(widget.group) ? widget.group : _groups.first;

    _teacherPhoneCtrl = TextEditingController(text: widget.teacherPhone ?? '');

    _usernameCtrl = TextEditingController(text: widget.username);
    _passwordCtrl = TextEditingController(text: widget.password);

    // _docs = List<bool>.from(widget.docs);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _nameCtrl.dispose();
    _dobCtrl.dispose();
    _guardianNameCtrl.dispose();
    _guardianPhoneCtrl.dispose();
    _teacherPhoneCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── مساعدات ──────────────────────────────────
  DateTime _parseDob(String dob) {
    final p = dob.split('/');
    return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
  }

  // bool get _isAdult => _age > 16;

  String _generatePassword() {
    const upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    const lower = 'abcdefghjkmnpqrstuvwxyz';
    const digits = '23456789';
    const all = upper + lower + digits;
    final rng = Random.secure();
    final length = 5 + rng.nextInt(4);
    final chars = <String>[
      upper[rng.nextInt(upper.length)],
      lower[rng.nextInt(lower.length)],
      digits[rng.nextInt(digits.length)],
      ...List.generate(length - 3, (_) => all[rng.nextInt(all.length)]),
    ]..shuffle(rng);
    return chars.join();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDzDatePicker(
      context: context,
      initialDate: _dob,
      minYear: now.year - 30,
      maxYear: now.year - 4,
      primaryColor: _primary,
      endColor: _primaryLight,
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobCtrl.text = formatDzDate(picked);
      });
    }
  }

  void _copyText(String text, String label) {
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

  void _handleSave() {
    final v1 = _personalKey.currentState?.validate() ?? true;
    final v2 = _accountKey.currentState?.validate() ?? true;
    if (!v1 || !v2) {
      if (!v1)
        _tabCtrl.animateTo(0);
      else if (!v2)
        _tabCtrl.animateTo(1);
      else
        _tabCtrl.animateTo(2);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تصحيح الأخطاء في جميع الأقسام'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    _showSuccessDialog();
  }

  void _handleReset() {
    _personalKey.currentState?.reset();
    _accountKey.currentState?.reset();
    setState(() {
      _nameCtrl.text = widget.teacherName;
      _dob = _parseDob(widget.dob);
      _dobCtrl.text = widget.dob;
      _gender = widget.isFemale ? 'أنثى' : 'ذكر';
      // _groups = List<String>.from(widget.groups);
      _teacherPhoneCtrl.text = widget.teacherPhone ?? '';
      _usernameCtrl.text = widget.username;
      _passwordCtrl.text = widget.password;
      // _docs = List<bool>.from(widget.docs);
      _pwVisible = false;
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 520),
                curve: Curves.elasticOut,
                builder: (_, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade700],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.shade200,
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'تم تحديث بيانات الطالب بنجاح ✅',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'تم حفظ تعديلات بيانات الطالب "${_nameCtrl.text.trim()}" بنجاح.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق الحوار
                Navigator.pop(context); // العودة إلى القائمة
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: const Text('إغلاق'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // يغلق الـ Dialog
                Navigator.pop(context); // يغلق EditteacherScreen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: const Text('عرض بيانات الطالب'),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F7FA),
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [
                    _buildPersonalTab(),
                    // _buildParentTab(),
                    _buildAccountTab(),
                    // _buildDocsTab(),
                  ],
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // ── AppBar مع TabBar ──────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: _grad),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'تعديل بيانات المعلم',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 17,
            ),
          ),
          Text(
            widget.teacherName,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
      bottom: TabBar(
        controller: _tabCtrl,
        isScrollable: false, // تجعل التبويبات تملأ العرض بالكامل
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        tabs: const [
          Tab(icon: Icon(Icons.person_outline, size: 18), text: 'الشخصية'),
          Tab(icon: Icon(Icons.lock_outline, size: 18), text: 'الحساب'),
        ],
      ),
    );
  }

  // ════════════════════════════════════════
  // تبويب 1 — المعلومات الشخصية
  // ════════════════════════════════════════
  Widget _buildPersonalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Form(
            key: _personalKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 560;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionCard(
                      title: 'المعلومات الشخصية',
                      icon: Icons.person_outline,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // رقم المعلم (للقراءة فقط)
                          _readOnlyField(
                            label: 'رقم المعلم',
                            value: '${widget.teacherId}',
                            icon: Icons.tag,
                          ),
                          const SizedBox(height: 14),

                          // الاسم واللقب
                          TextFormField(
                            controller: _nameCtrl,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (_) => setState(() {}),
                            decoration: _decor(
                              label: 'الاسم واللقب',
                              hint: 'أدخل الاسم واللقب',
                              icon: Icons.person,
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'هذا الحقل مطلوب'
                                : null,
                          ),
                          const SizedBox(height: 14),

                          // تاريخ الميلاد + الجنس
                          if (wide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildDobField()),
                                const SizedBox(width: 16),
                                Expanded(child: _buildGenderField()),
                              ],
                            )
                          else ...[
                            _buildDobField(),
                            const SizedBox(height: 14),
                            _buildGenderField(),
                          ],

                          const SizedBox(height: 14),
                          _sectionCard(
                            title: 'رقم الهاتف ',
                            icon: Icons.smartphone_outlined,
                            child: TextFormField(
                              controller: _teacherPhoneCtrl,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9+\s\-]'),
                                ),
                                LengthLimitingTextInputFormatter(15),
                              ],
                              decoration: _decor(
                                label: 'رقم هاتف أستاذ',
                                hint: 'مثال: 0791234567',
                                icon: Icons.phone_outlined,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDobField() => TextFormField(
    controller: _dobCtrl,
    readOnly: true,
    onTap: _pickDob,
    decoration: _decor(
      label: 'تاريخ الميلاد',
      hint: 'اضغط لاختيار التاريخ',
      icon: Icons.calendar_today,
    ).copyWith(suffixIcon: Icon(Icons.edit_calendar_outlined, color: _primary)),
  );

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Icon(Icons.wc_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                'الجنس',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
          ),
          child: Row(
            children: ['أستاذ', 'أستاذة'].map((g) {
              final sel = _gender == g;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() => _gender = g),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: sel
                          ? _primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          g == 'أستاذ' ? Icons.male : Icons.female,
                          size: 18,
                          color: sel ? _primary : Colors.grey[500],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          g,
                          style: TextStyle(
                            fontWeight: sel
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: sel ? _primary : Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: sel ? _primary : Colors.grey[400]!,
                              width: 2,
                            ),
                            color: sel ? _primary : Colors.transparent,
                          ),
                          child: sel
                              ? const Icon(
                                  Icons.check,
                                  size: 9,
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
      ],
    );
  }

  // ════════════════════════════════════════
  // تبويب 3 — معلومات الحساب
  // ════════════════════════════════════════
  Widget _buildAccountTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Form(
            key: _accountKey,
            child: Column(
              children: [
                _sectionCard(
                  title: 'معلومات الحساب',
                  icon: Icons.manage_accounts_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── اسم المستخدم ──
                      TextFormField(
                        controller: _usernameCtrl,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) => setState(() {}),
                        decoration:
                            _decor(
                              label: 'اسم المستخدم',
                              hint: 'أدخل اسم المستخدم',
                              icon: Icons.account_circle_outlined,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.copy_rounded,
                                  color: _primary,
                                  size: 20,
                                ),
                                tooltip: 'نسخ اسم المستخدم',
                                onPressed: () => _copyText(
                                  _usernameCtrl.text,
                                  'اسم المستخدم',
                                ),
                              ),
                            ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'هذا الحقل مطلوب';
                          if (v.trim().length < 4)
                            return 'يجب أن يكون 4 أحرف على الأقل';
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // ── كلمة المرور ──
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: !_pwVisible,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => setState(() {}),
                        decoration:
                            _decor(
                              label: 'كلمة المرور',
                              hint: '••••••••',
                              icon: Icons.lock_outline,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _pwVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                onPressed: () =>
                                    setState(() => _pwVisible = !_pwVisible),
                                tooltip: _pwVisible ? 'إخفاء' : 'إظهار',
                              ),
                            ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
                          if (v.length < 5)
                            return 'كلمة المرور قصيرة جداً (5 أحرف على الأقل)';
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // ── أزرار كلمة المرور ──
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _copyText(_passwordCtrl.text, 'كلمة المرور'),
                              icon: const Icon(Icons.copy_rounded, size: 16),
                              label: const Text(
                                'نسخ كلمة المرور',
                                style: TextStyle(fontSize: 13),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _primary,
                                side: BorderSide(
                                  color: _primary.withValues(alpha: 0.45),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final pw = _generatePassword();
                                setState(() {
                                  _passwordCtrl.text = pw;
                                  _pwVisible = true;
                                });
                              },
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text(
                                'توليد كلمة مرور',
                                style: TextStyle(fontSize: 13),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── معاينة بيانات الدخول ──
                      _credentialPreview(),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _credentialPreview() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معاينة بيانات الدخول',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _previewRow(
            label: 'اسم المستخدم',
            value: _usernameCtrl.text.isEmpty ? '—' : _usernameCtrl.text,
            icon: Icons.fingerprint,
            color: _primary,
          ),
          const SizedBox(height: 6),
          _previewRow(
            label: 'كلمة المرور',
            value: _pwVisible
                ? (_passwordCtrl.text.isEmpty ? '—' : _passwordCtrl.text)
                : '•' * (_passwordCtrl.text.length.clamp(1, 12)),
            icon: Icons.lock_outline,
            color: Colors.orange.shade700,
          ),
        ],
      ),
    );
  }

  Widget _previewRow({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'monospace',
              letterSpacing: 1,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════
  // تبويب 4 — الوثائق الإدارية
  // ════════════════════════════════════════
  // Widget _buildDocsTab() {
  //   // final completed = _docs.where((d) => d).length;
  //   final total = _docNames.length;
  //   final allDone = completed == total;
  //   final pct = total == 0 ? 0.0 : completed / total;

  //   final Color barColor = pct == 1.0
  //       ? Colors.green.shade600
  //       : pct >= 0.5
  //       ? Colors.orange.shade600
  //       : Colors.red.shade400;

  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.all(16),
  //     child: Center(
  //       child: ConstrainedBox(
  //         constraints: const BoxConstraints(maxWidth: 700),
  //         child: Column(
  //           children: [
  //             // ── بطاقة التقدم ──
  //             Container(
  //               width: double.infinity,
  //               padding: const EdgeInsets.all(18),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(18),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withValues(alpha: 0.06),
  //                     blurRadius: 10,
  //                     offset: const Offset(0, 4),
  //                   ),
  //                 ],
  //               ),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Icon(
  //                         Icons.folder_open_outlined,
  //                         color: _primary,
  //                         size: 22,
  //                       ),
  //                       const SizedBox(width: 10),
  //                       Text(
  //                         'الوثائق الإدارية',
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16,
  //                           color: Colors.blue.shade900,
  //                         ),
  //                       ),
  //                       const Spacer(),
  //                       // شارة الاكتمال
  //                       AnimatedSwitcher(
  //                         duration: const Duration(milliseconds: 300),
  //                         child: allDone
  //                             ? Container(
  //                                 key: const ValueKey('done'),
  //                                 padding: const EdgeInsets.symmetric(
  //                                   horizontal: 10,
  //                                   vertical: 4,
  //                                 ),
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.green.shade50,
  //                                   borderRadius: BorderRadius.circular(10),
  //                                   border: Border.all(
  //                                     color: Colors.green.shade300,
  //                                   ),
  //                                 ),
  //                                 child: Row(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: [
  //                                     Icon(
  //                                       Icons.check_circle,
  //                                       size: 13,
  //                                       color: Colors.green.shade700,
  //                                     ),
  //                                     const SizedBox(width: 4),
  //                                     Text(
  //                                       'الملف الإداري مكتمل ✓',
  //                                       style: TextStyle(
  //                                         fontSize: 11,
  //                                         fontWeight: FontWeight.bold,
  //                                         color: Colors.green.shade700,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               )
  //                             : Container(
  //                                 key: const ValueKey('incomplete'),
  //                                 padding: const EdgeInsets.symmetric(
  //                                   horizontal: 10,
  //                                   vertical: 4,
  //                                 ),
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.orange.shade50,
  //                                   borderRadius: BorderRadius.circular(10),
  //                                   border: Border.all(
  //                                     color: Colors.orange.shade300,
  //                                   ),
  //                                 ),
  //                                 child: Text(
  //                                   'الملف الإداري غير مكتمل',
  //                                   style: TextStyle(
  //                                     fontSize: 11,
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.orange.shade700,
  //                                   ),
  //                                 ),
  //                               ),
  //                       ),
  //                     ],
  //                   ),

  //                   const SizedBox(height: 14),

  //                   Row(
  //                     children: [
  //                       Text(
  //                         'الوثائق المكتملة:',
  //                         style: TextStyle(
  //                           fontSize: 13,
  //                           color: Colors.grey.shade600,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                       const SizedBox(width: 8),
  //                       Text(
  //                         '$completed / $total',
  //                         style: TextStyle(
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.bold,
  //                           color: barColor,
  //                         ),
  //                       ),
  //                       const Spacer(),
  //                       Text(
  //                         '${(pct * 100).toInt()}%',
  //                         style: TextStyle(
  //                           fontSize: 13,
  //                           fontWeight: FontWeight.bold,
  //                           color: barColor,
  //                         ),
  //                       ),
  //                     ],
  //                   ),

  //                   const SizedBox(height: 8),

  //                   ClipRRect(
  //                     borderRadius: BorderRadius.circular(8),
  //                     child: LinearProgressIndicator(
  //                       value: pct,
  //                       minHeight: 9,
  //                       backgroundColor: Colors.grey.shade200,
  //                       valueColor: AlwaysStoppedAnimation(barColor),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),

  //             const SizedBox(height: 14),

  //             // ── قائمة الوثائق (Checkbox) ──
  //             Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(18),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withValues(alpha: 0.05),
  //                     blurRadius: 8,
  //                     offset: const Offset(0, 3),
  //                   ),
  //                 ],
  //               ),
  //               child: Column(
  //                 children: _docNames.asMap().entries.map((entry) {
  //                   final i = entry.key;
  //                   final name = entry.value;
  //                   final done = _docs[i];
  //                   final isLast = i == _docNames.length - 1;
  //                   final color = done
  //                       ? Colors.green.shade600
  //                       : Colors.orange.shade700;

  //                   return Column(
  //                     children: [
  //                       CheckboxListTile(
  //                         value: done,
  //                         onChanged: (v) =>
  //                             setState(() => _docs[i] = v ?? false),
  //                         activeColor: Colors.green.shade600,
  //                         checkColor: Colors.white,
  //                         controlAffinity: ListTileControlAffinity.leading,
  //                         contentPadding: const EdgeInsets.symmetric(
  //                           horizontal: 16,
  //                           vertical: 4,
  //                         ),
  //                         title: Row(
  //                           children: [
  //                             Container(
  //                               padding: const EdgeInsets.all(6),
  //                               decoration: BoxDecoration(
  //                                 color: color.withValues(alpha: 0.1),
  //                                 borderRadius: BorderRadius.circular(8),
  //                               ),
  //                               child: Icon(
  //                                 done
  //                                     ? Icons.description_outlined
  //                                     : Icons.hourglass_empty_rounded,
  //                                 size: 16,
  //                                 color: color,
  //                               ),
  //                             ),
  //                             const SizedBox(width: 10),
  //                             Expanded(
  //                               child: Text(
  //                                 name,
  //                                 style: TextStyle(
  //                                   fontWeight: FontWeight.w600,
  //                                   fontSize: 14,
  //                                   color: done
  //                                       ? Colors.grey.shade800
  //                                       : Colors.grey.shade600,
  //                                 ),
  //                               ),
  //                             ),
  //                             // شارة الحالة
  //                             Container(
  //                               padding: const EdgeInsets.symmetric(
  //                                 horizontal: 8,
  //                                 vertical: 3,
  //                               ),
  //                               decoration: BoxDecoration(
  //                                 color: color.withValues(alpha: 0.1),
  //                                 borderRadius: BorderRadius.circular(8),
  //                                 border: Border.all(
  //                                   color: color.withValues(alpha: 0.3),
  //                                 ),
  //                               ),
  //                               child: Text(
  //                                 done ? 'مكتملة ✓' : 'غير مستلمة ⏳',
  //                                 style: TextStyle(
  //                                   fontSize: 10,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: color,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       if (!isLast)
  //                         Divider(height: 1, color: Colors.grey.shade100),
  //                     ],
  //                   );
  //                 }).toList(),
  //               ),
  //             ),

  //             const SizedBox(height: 80),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // ════════════════════════════════════════
  // أزرار الإجراءات (ثابتة في الأسفل)
  // ════════════════════════════════════════
  Widget _buildActionButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 480;

          final saveBtn = Container(
            decoration: BoxDecoration(
              gradient: _grad,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: _primary.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _handleSave,
              icon: const Icon(
                Icons.save_outlined,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'حفظ التعديلات',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          );

          final cancelBtn = OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, size: 17),
            label: const Text('إلغاء', style: TextStyle(fontSize: 14)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
              foregroundColor: Colors.grey[700],
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          );

          final resetBtn = OutlinedButton.icon(
            onPressed: _handleReset,
            icon: const Icon(Icons.refresh, size: 17),
            label: const Text('إعادة تعيين', style: TextStyle(fontSize: 14)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: _primary.withValues(alpha: 0.5)),
              foregroundColor: _primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          );

          if (wide) {
            return Row(
              children: [
                Expanded(flex: 2, child: saveBtn),
                const SizedBox(width: 10),
                Expanded(child: cancelBtn),
                const SizedBox(width: 10),
                Expanded(child: resetBtn),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              saveBtn,
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: cancelBtn),
                  const SizedBox(width: 10),
                  Expanded(child: resetBtn),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ════════════════════════════════════════
  // ويدجتات مساعدة مشتركة
  // ════════════════════════════════════════
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey.shade100, height: 20),
          child,
        ],
      ),
    );
  }

  Widget _readOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[500]),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 11, color: Colors.grey[500]),
                const SizedBox(width: 3),
                Text(
                  'للقراءة فقط',
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decor({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 20, color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderSide: const BorderSide(color: _primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
      ),
      labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
      errorStyle: const TextStyle(fontSize: 12),
    );
  }
}
