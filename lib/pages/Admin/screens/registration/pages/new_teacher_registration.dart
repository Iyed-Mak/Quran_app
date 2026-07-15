import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/utils/date_widget.dart';

/// شاشة تسجيل معلم جديد — وحدة الإدارة
///
/// الحقول: رقم المعلم (تلقائي)، الاسم واللقب، رقم الهاتف،
///         تاريخ الميلاد، الجنس، الأفواج (اختيار متعدد).
class RegisterTeacherScreen extends StatefulWidget {
  const RegisterTeacherScreen({super.key});

  @override
  State<RegisterTeacherScreen> createState() => _RegisterTeacherScreenState();
}

class _RegisterTeacherScreenState extends State<RegisterTeacherScreen> {
  // ── ألوان الصفحة ──
  static const Color _gradientStart = Color(0xff1565C0);
  static const Color _gradientEnd = Color(0xff42A5F5);
  static const LinearGradient _appGradient = LinearGradient(
    colors: [_gradientStart, _gradientEnd],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ── بيانات تجريبية ──
  static const int _lastTeacherNumber = 12;
  final int _nextTeacherId = _lastTeacherNumber + 1;

  static const List<String> _availableGroups = [
    'فوج 1',
    'فوج 2',
    'فوج 3',
    'فوج 4',
    'فوج 5',
    'فوج 6',
    'فوج 7',
    'فوج 8',
  ];

  // ── مفتاح النموذج ──
  final _formKey = GlobalKey<FormState>();

  // ── وحدات التحكم بالحقول ──
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  // ── حالة النموذج ──
  DateTime? _selectedDob;
  Set<String> _selectedGroups = {}; // اختيار متعدد
  String? _selectedGender;
  bool _isFormReadyToSave = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // ── هل كل الحقول المطلوبة مكتملة؟ ──
  void _checkFormCompleteness() {
    final ready =
        _nameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _selectedDob != null &&
        _selectedGender != null &&
        _selectedGroups.isNotEmpty;
    if (ready != _isFormReadyToSave) setState(() => _isFormReadyToSave = ready);
  }

  // ── توليد اسم المستخدم: MMDD + رقم المعلم ──
  String _generateSerial(DateTime dob, int teacherId) {
    final mm = dob.month.toString().padLeft(2, '0');
    final dd = dob.day.toString().padLeft(2, '0');
    return '$mm$dd$teacherId';
  }

  // ── توليد كلمة مرور عشوائية (5–8 أحرف) ──
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

  // ── فتح منتقي التاريخ ──
  Future<void> _pickDate() async {
    final DateTime? picked = await showDzDatePicker(
      context: context,
      initialDate: _selectedDob,
      minYear: 1960,
      maxYear: 2022,
      primaryColor: Colors.blue.shade700,
      endColor: Colors.blueAccent.shade200,
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text =
            '${picked.day} ${kDzMonths[picked.month - 1]} ${picked.year}';
      });
      _checkFormCompleteness();
    }
  }

  // ── حفظ ──
  void _handleSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final serial = _generateSerial(_selectedDob!, _nextTeacherId);
    final password = _generatePassword();
    _showSuccessSheet(
      teacherName: _nameController.text.trim(),
      teacherId: _nextTeacherId,
      serial: serial,
      password: password,
    );
  }

  // ── إعادة تعيين ──
  void _handleReset() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _phoneController.clear();
    _dobController.clear();
    setState(() {
      _selectedDob = null;
      _selectedGender = null;
      _selectedGroups = {};
      _isFormReadyToSave = false;
    });
  }

  // ── بطاقة النجاح ──
  void _showSuccessSheet({
    required String teacherName,
    required int teacherId,
    required String serial,
    required String password,
  }) {
    final bool isWide = MediaQuery.of(context).size.width >= 600;
    final card = _SuccessCard(
      teacherName: teacherName,
      teacherId: teacherId,
      serial: serial,
      password: password,
      groups: _selectedGroups.toList(),
      onDone: () {
        Navigator.of(context).pop();
        _handleReset();
      },
    );

    if (isWide) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 40,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: card,
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (_) =>
            Directionality(textDirection: TextDirection.rtl, child: card),
      );
    }
  }

  // ─────────────────────────────────────────────
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
            'تسجيل معلم جديد',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double formMaxWidth = constraints.maxWidth >= 700
                  ? 700
                  : double.infinity;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: formMaxWidth),
                    child: Form(
                      key: _formKey,
                      onChanged: _checkFormCompleteness,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTeacherNumberBanner(),
                          const SizedBox(height: 16),
                          _buildFormCard(constraints),
                          const SizedBox(height: 20),
                          _buildActionButtons(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ── شريط رقم المعلم التلقائي ──
  Widget _buildTeacherNumberBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        gradient: _appGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _gradientStart.withValues(alpha: 0.3),
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
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'رقم المعلم التالي',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                ),
              ),
              Text(
                '$_nextTeacherId',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock_outline, color: Colors.white, size: 13),
                SizedBox(width: 4),
                Text(
                  'تلقائي',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── البطاقة الرئيسية للنموذج ──
  Widget _buildFormCard(BoxConstraints constraints) {
    final bool isWide = constraints.maxWidth >= 600;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardSectionTitle('بيانات المعلم', Icons.person_outline),
          const SizedBox(height: 18),

          // الاسم + الهاتف
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildNameField()),
                const SizedBox(width: 16),
                Expanded(child: _buildPhoneField()),
              ],
            )
          else ...[
            _buildNameField(),
            const SizedBox(height: 14),
            _buildPhoneField(),
          ],

          const SizedBox(height: 14),

          // تاريخ الميلاد + الجنس
          if (isWide)
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

          // الأفواج — اختيار متعدد (عرض كامل دائمًا)
          _buildGroupsField(),
        ],
      ),
    );
  }

  Widget _cardSectionTitle(String label, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: _gradientStart.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _gradientStart, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.blue.shade900,
          ),
        ),
      ],
    );
  }

  // ── حقول النموذج ──

  Widget _buildNameField() => TextFormField(
    controller: _nameController,
    textInputAction: TextInputAction.next,
    textCapitalization: TextCapitalization.words,
    decoration: _inputDecoration(
      label: 'الاسم واللقب',
      hint: 'مثال: عبد الرحمان بوربيع',
      icon: Icons.person,
    ),
    validator: (v) =>
        (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
  );

  Widget _buildPhoneField() => TextFormField(
    controller: _phoneController,
    textInputAction: TextInputAction.next,
    keyboardType: TextInputType.phone,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-]')),
      LengthLimitingTextInputFormatter(15),
    ],
    decoration: _inputDecoration(
      label: 'رقم الهاتف',
      hint: 'مثال: 0551234567',
      icon: Icons.phone_outlined,
    ),
    validator: (v) {
      if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
      if (v.trim().replaceAll(RegExp(r'[\s\-+]'), '').length < 8) {
        return 'رقم الهاتف غير صحيح';
      }
      return null;
    },
  );

  Widget _buildDobField() => TextFormField(
    controller: _dobController,
    readOnly: true,
    onTap: _pickDate,
    decoration:
        _inputDecoration(
          label: 'تاريخ الميلاد',
          hint: 'اضغط لاختيار التاريخ',
          icon: Icons.calendar_today,
        ).copyWith(
          suffixIcon: Icon(Icons.edit_calendar_outlined, color: _gradientStart),
        ),
    validator: (_) => _selectedDob == null ? 'يرجى اختيار تاريخ الميلاد' : null,
  );

  Widget _buildGenderField() {
    return FormField<String>(
      initialValue: _selectedGender,
      validator: (_) => _selectedGender == null ? 'يرجى تحديد الجنس' : null,
      builder: (state) => Column(
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
              border: Border.all(
                color: state.hasError
                    ? Colors.red.shade400
                    : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: ['ذكر', 'أنثى'].map((gender) {
                final selected = _selectedGender == gender;
                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() => _selectedGender = gender);
                      state.didChange(gender);
                      _checkFormCompleteness();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selected
                            ? _gradientStart.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            gender == 'ذكر' ? Icons.male : Icons.female,
                            size: 18,
                            color: selected ? _gradientStart : Colors.grey[500],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            gender,
                            style: TextStyle(
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: selected
                                  ? _gradientStart
                                  : Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected
                                    ? _gradientStart
                                    : Colors.grey[400]!,
                                width: 2,
                              ),
                              color: selected
                                  ? _gradientStart
                                  : Colors.transparent,
                            ),
                            child: selected
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
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 12),
              child: Text(
                state.errorText!,
                style: TextStyle(color: Colors.red.shade600, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  /// حقل الأفواج — اختيار متعدد عبر FilterChip
  Widget _buildGroupsField() {
    return FormField<Set<String>>(
      initialValue: _selectedGroups,
      validator: (_) =>
          _selectedGroups.isEmpty ? 'يرجى اختيار فوج واحد على الأقل' : null,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── ترويسة الحقل ──
            Row(
              children: [
                Icon(Icons.group_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  'الأفواج',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                const SizedBox(width: 8),
                if (_selectedGroups.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _gradientStart,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_selectedGroups.length} مختار',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const Spacer(),
                // زر تحديد الكل / إلغاء الكل
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      if (_selectedGroups.length == _availableGroups.length) {
                        _selectedGroups = {};
                      } else {
                        _selectedGroups = Set.from(_availableGroups);
                      }
                    });
                    state.didChange(_selectedGroups);
                    _checkFormCompleteness();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: _gradientStart,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: Icon(
                    _selectedGroups.length == _availableGroups.length
                        ? Icons.deselect
                        : Icons.select_all,
                    size: 14,
                  ),
                  label: Text(
                    _selectedGroups.length == _availableGroups.length
                        ? 'إلغاء الكل'
                        : 'تحديد الكل',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── شبكة الأفواج (FilterChip) ──
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: state.hasError
                      ? Colors.red.shade400
                      : Colors.grey.shade300,
                  width: state.hasError ? 1.2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade50,
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableGroups.map((group) {
                  final isSelected = _selectedGroups.contains(group);
                  return FilterChip(
                    label: Text(
                      group,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedGroups = {..._selectedGroups, group};
                        } else {
                          _selectedGroups = _selectedGroups
                              .where((g) => g != group)
                              .toSet();
                        }
                      });
                      state.didChange(_selectedGroups);
                      _checkFormCompleteness();
                    },
                    selectedColor: _gradientStart,
                    backgroundColor: Colors.white,
                    checkmarkColor: Colors.white,
                    showCheckmark: true,
                    side: BorderSide(
                      color: isSelected ? _gradientStart : Colors.grey.shade300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                  );
                }).toList(),
              ),
            ),

            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 12),
                child: Text(
                  state.errorText!,
                  style: TextStyle(color: Colors.red.shade600, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  InputDecoration _inputDecoration({
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
        borderSide: const BorderSide(color: _gradientStart, width: 1.5),
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

  // ── أزرار الإجراءات ──
  Widget _buildActionButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 480;
        final saveBtn = _buildSaveButton();
        final cancelBtn = _buildCancelButton();
        final resetBtn = _buildResetButton();

        if (isWide) {
          return Row(
            children: [
              Expanded(child: saveBtn),
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
    );
  }

  Widget _buildSaveButton() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _isFormReadyToSave ? 1.0 : 0.5,
      child: Container(
        decoration: BoxDecoration(
          gradient: _isFormReadyToSave ? _appGradient : null,
          color: _isFormReadyToSave ? null : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(14),
          boxShadow: _isFormReadyToSave
              ? [
                  BoxShadow(
                    color: _gradientStart.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton.icon(
          onPressed: _isFormReadyToSave ? _handleSave : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.save_outlined, color: Colors.white, size: 19),
          label: const Text(
            'حفظ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() => OutlinedButton.icon(
    onPressed: () {
      if (Navigator.canPop(context)) Navigator.pop(context);
    },
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: Colors.grey.shade400),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      foregroundColor: Colors.grey[700],
    ),
    icon: const Icon(Icons.close, size: 18),
    label: const Text('إلغاء', style: TextStyle(fontSize: 14)),
  );

  Widget _buildResetButton() => OutlinedButton.icon(
    onPressed: _handleReset,
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: _gradientStart.withValues(alpha: 0.5)),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      foregroundColor: _gradientStart,
    ),
    icon: const Icon(Icons.refresh, size: 18),
    label: const Text('إعادة تعيين', style: TextStyle(fontSize: 14)),
  );
}

// ═══════════════════════════════════════════════════════════════════
// بطاقة النجاح
// ═══════════════════════════════════════════════════════════════════
class _SuccessCard extends StatefulWidget {
  const _SuccessCard({
    required this.teacherName,
    required this.teacherId,
    required this.serial,
    required this.password,
    required this.groups,
    required this.onDone,
  });

  final String teacherName;
  final int teacherId;
  final String serial;
  final String password;
  final List<String> groups;
  final VoidCallback onDone;

  @override
  State<_SuccessCard> createState() => _SuccessCardState();
}

class _SuccessCardState extends State<_SuccessCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  bool _serialCopied = false;
  bool _passwordCopied = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _copy(String text, bool isSerial) async {
    await Clipboard.setData(ClipboardData(text: text));
    setState(() {
      if (isSerial) {
        _serialCopied = true;
      } else {
        _passwordCopied = true;
      }
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        if (isSerial) {
          _serialCopied = false;
        } else {
          _passwordCopied = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // أيقونة النجاح
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (_, v, child) =>
                      Transform.scale(scale: v, child: child),
                  child: Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade700],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200,
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),

                const SizedBox(height: 14),
                Text(
                  'تم تسجيل المعلم بنجاح ✅',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 18),

                _buildInfoRow(
                  Icons.person,
                  'اسم المعلم',
                  widget.teacherName,
                  Colors.blue.shade700,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.tag,
                  'رقم المعلم',
                  '${widget.teacherId}',
                  Colors.purple.shade600,
                ),
                const SizedBox(height: 8),

                // الأفواج المسندة
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.group_outlined,
                        color: Colors.teal.shade700,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'الأفواج:',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: widget.groups
                            .map(
                              (g) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.teal.shade200,
                                  ),
                                ),
                                child: Text(
                                  g,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal.shade800,
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

                const SizedBox(height: 16),

                _buildCredentialBox(
                  label: 'اسم المستخدم',
                  value: widget.serial,
                  icon: Icons.fingerprint,
                  color: Colors.blue.shade700,
                  copied: _serialCopied,
                  onCopy: () => _copy(widget.serial, true),
                ),
                const SizedBox(height: 12),
                _buildCredentialBox(
                  label: 'كلمة المرور',
                  value: widget.password,
                  icon: Icons.lock_outline,
                  color: Colors.orange.shade700,
                  copied: _passwordCopied,
                  onCopy: () => _copy(widget.password, false),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.amber.shade700,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'احتفظ بكلمة المرور في مكان آمن. لن يتم عرضها مجدداً.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.amber.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: widget.onDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text(
                      'إنهاء',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCredentialBox({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool copied,
    required VoidCallback onCopy,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SelectableText(
                value,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 1.4,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const Spacer(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: copied
                ? Container(
                    key: const ValueKey('done'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.blue.shade600,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'تم النسخ',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : IconButton(
                    key: const ValueKey('copy'),
                    onPressed: onCopy,
                    tooltip: 'نسخ',
                    icon: Icon(Icons.copy_rounded, color: color, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: color.withValues(alpha: 0.1),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
