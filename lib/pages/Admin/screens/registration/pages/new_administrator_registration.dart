import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// شاشة تسجيل مدير / مسؤول — وحدة الإدارة
/// واجهة فقط — لا يوجد أي منطق خلفي أو قاعدة بيانات
class RegisterAdminScreen extends StatefulWidget {
  const RegisterAdminScreen({super.key});

  @override
  State<RegisterAdminScreen> createState() => _RegisterAdminScreenState();
}

class _RegisterAdminScreenState extends State<RegisterAdminScreen> {
  // ── ألوان الوحدة الإدارية ──
  static const Color _primary = Color(0xff1565C0);
  static const Color _primaryLight = Color(0xff42A5F5);
  static const LinearGradient _grad = LinearGradient(
    colors: [_primary, _primaryLight],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ── مفتاح النموذج ──
  final _formKey = GlobalKey<FormState>();

  // ── وحدات التحكم ──
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  // ── حالة الرؤية ──
  bool _showPassword = false;
  bool _showConfirm = false;
  bool _isFormReady = false;

  // ── قوة كلمة المرور ──
  _PasswordStrength _strength = _PasswordStrength.none;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ── حساب قوة كلمة المرور ──
  _PasswordStrength _calcStrength(String p) {
    if (p.isEmpty) return _PasswordStrength.none;
    int score = 0;
    if (p.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(p)) score++;
    if (RegExp(r'[a-z]').hasMatch(p)) score++;
    if (RegExp(r'[0-9]').hasMatch(p)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(p)) score++;
    if (score <= 2) return _PasswordStrength.weak;
    if (score == 3) return _PasswordStrength.medium;
    return _PasswordStrength.strong;
  }

  void _onPasswordChanged(String val) {
    setState(() => _strength = _calcStrength(val));
    _checkReady();
  }

  void _checkReady() {
    final ok =
        _nameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _usernameController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmController.text.isNotEmpty;
    if (ok != _isFormReady) setState(() => _isFormReady = ok);
  }

  // ── حفظ ──
  void _handleSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _showSuccessDialog(
      adminName: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );
  }

  // ── إعادة تعيين ──
  void _handleReset() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _phoneController.clear();
    _usernameController.clear();
    _passwordController.clear();
    _confirmController.clear();
    setState(() {
      _showPassword = false;
      _showConfirm = false;
      _strength = _PasswordStrength.none;
      _isFormReady = false;
    });
  }

  // ── حوار النجاح ──
  void _showSuccessDialog({
    required String adminName,
    required String username,
    required String password,
  }) {
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
            horizontal: 24,
            vertical: 40,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: _SuccessDialog(
              adminName: adminName,
              username: username,
              password: password,
              onDone: () {
                Navigator.of(context).pop();
                _handleReset();
              },
            ),
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Container(decoration: BoxDecoration(gradient: _grad)),
          title: const Text(
            'تسجيل مدير / مسؤول',
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
              final double maxW = constraints.maxWidth >= 720
                  ? 720
                  : double.infinity;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxW),
                    child: Form(
                      key: _formKey,
                      onChanged: _checkReady,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── بانر الترحيب ──
                          _buildTopBanner(),
                          const SizedBox(height: 20),

                          // ── المعلومات الشخصية ──
                          _buildCard(
                            title: 'المعلومات الشخصية',
                            icon: Icons.person_outline,
                            children: _buildPersonalFields(constraints),
                          ),
                          const SizedBox(height: 16),

                          // ── معلومات الحساب ──
                          _buildCard(
                            title: 'معلومات الحساب',
                            icon: Icons.manage_accounts_outlined,
                            children: _buildAccountFields(constraints),
                          ),
                          const SizedBox(height: 24),

                          // ── أزرار الإجراءات ──
                          _buildActions(constraints),
                          const SizedBox(height: 32),
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

  // ── بانر علوي ──
  Widget _buildTopBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: _grad,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _primary.withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.admin_panel_settings_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إضافة مسؤول جديد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'أدخل بيانات المسؤول وبيانات الدخول إلى النظام',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── بطاقة قسم ──
  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
          // عنوان القسم
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
          const SizedBox(height: 4),
          Divider(color: Colors.grey.shade100, height: 20),
          ...children,
        ],
      ),
    );
  }

  // ── حقول المعلومات الشخصية ──
  List<Widget> _buildPersonalFields(BoxConstraints c) {
    final wide = c.maxWidth >= 600;
    final nameF = _textField(
      controller: _nameController,
      label: 'الاسم واللقب',
      hint: 'مثال: عبد الرحمن يوربيع',
      icon: Icons.person,
      action: TextInputAction.next,
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
    );
    final phoneF = _textField(
      controller: _phoneController,
      label: 'رقم الهاتف',
      hint: 'مثال: 0551234567',
      icon: Icons.phone_outlined,
      action: TextInputAction.next,
      inputType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
        if (v.trim().length < 9) return 'رقم هاتف غير صالح';
        return null;
      },
    );

    if (wide) {
      return [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: nameF),
            const SizedBox(width: 16),
            Expanded(child: phoneF),
          ],
        ),
      ];
    }
    return [nameF, const SizedBox(height: 14), phoneF];
  }

  // ── حقول معلومات الحساب ──
  List<Widget> _buildAccountFields(BoxConstraints c) {
    return [
      // اسم المستخدم
      _textField(
        controller: _usernameController,
        label: 'اسم المستخدم',
        hint: 'مثال: admin_abdou',
        icon: Icons.account_circle_outlined,
        action: TextInputAction.next,
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
          if (v.trim().length < 4) return 'يجب أن يكون 4 أحرف على الأقل';
          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v.trim())) {
            return 'يُسمح فقط بالحروف والأرقام والشرطة السفلية';
          }
          return null;
        },
      ),
      const SizedBox(height: 14),

      // كلمة المرور
      _passwordField(
        controller: _passwordController,
        label: 'كلمة المرور',
        isVisible: _showPassword,
        onToggle: () => setState(() => _showPassword = !_showPassword),
        onChanged: _onPasswordChanged,
        validator: (v) {
          if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
          if (v.length < 6) return 'كلمة المرور قصيرة جداً (6 أحرف على الأقل)';
          return null;
        },
      ),

      // مؤشر قوة كلمة المرور
      if (_strength != _PasswordStrength.none) ...[
        const SizedBox(height: 8),
        _buildStrengthIndicator(),
      ],

      const SizedBox(height: 14),

      // تأكيد كلمة المرور
      _passwordField(
        controller: _confirmController,
        label: 'تأكيد كلمة المرور',
        isVisible: _showConfirm,
        onToggle: () => setState(() => _showConfirm = !_showConfirm),
        onChanged: (_) => _checkReady(),
        validator: (v) {
          if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
          if (v != _passwordController.text) {
            return 'كلمتا المرور غير متطابقتين';
          }
          return null;
        },
      ),
    ];
  }

  // ── مؤشر قوة كلمة المرور ──
  Widget _buildStrengthIndicator() {
    final cfg = _strengthConfig(_strength);
    final double filled = _strength == _PasswordStrength.weak
        ? 1 / 3
        : _strength == _PasswordStrength.medium
        ? 2 / 3
        : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // أشرطة
        Row(
          children: List.generate(3, (i) {
            final active = (i + 1) / 3 <= filled;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 5,
                margin: EdgeInsets.only(left: i < 2 ? 6 : 0),
                decoration: BoxDecoration(
                  color: active ? cfg['color'] as Color : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 5),
        // نص
        Row(
          children: [
            Icon(
              cfg['icon'] as IconData,
              size: 13,
              color: cfg['color'] as Color,
            ),
            const SizedBox(width: 5),
            Text(
              cfg['label'] as String,
              style: TextStyle(
                fontSize: 12,
                color: cfg['color'] as Color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<String, dynamic> _strengthConfig(_PasswordStrength s) {
    switch (s) {
      case _PasswordStrength.weak:
        return {
          'color': Colors.red.shade500,
          'icon': Icons.sentiment_dissatisfied,
          'label': 'ضعيفة',
        };
      case _PasswordStrength.medium:
        return {
          'color': Colors.orange.shade600,
          'icon': Icons.sentiment_neutral,
          'label': 'متوسطة',
        };
      case _PasswordStrength.strong:
        return {
          'color': Colors.green.shade600,
          'icon': Icons.sentiment_satisfied_alt,
          'label': 'قوية',
        };
      default:
        return {'color': Colors.grey, 'icon': Icons.remove, 'label': ''};
    }
  }

  // ── أزرار الإجراءات ──
  Widget _buildActions(BoxConstraints c) {
    final wide = c.maxWidth >= 480;
    final saveBtn = _buildSaveBtn();
    final resetBtn = OutlinedButton.icon(
      onPressed: _handleReset,
      icon: const Icon(Icons.refresh, size: 18),
      label: const Text('إعادة تعيين'),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: _primary.withValues(alpha: 0.5)),
        foregroundColor: _primary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
    final cancelBtn = OutlinedButton.icon(
      onPressed: () {
        if (Navigator.canPop(context)) Navigator.pop(context);
      },
      icon: const Icon(Icons.close, size: 18),
      label: const Text('إلغاء'),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade400),
        foregroundColor: Colors.grey[700],
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );

    if (wide) {
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
  }

  Widget _buildSaveBtn() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _isFormReady ? 1.0 : 0.45,
      child: Container(
        decoration: BoxDecoration(
          gradient: _isFormReady ? _grad : null,
          color: _isFormReady ? null : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(14),
          boxShadow: _isFormReady
              ? [
                  BoxShadow(
                    color: _primary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton.icon(
          onPressed: _isFormReady ? _handleSave : null,
          icon: const Icon(Icons.save_outlined, color: Colors.white, size: 19),
          label: const Text(
            'حفظ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  // ── حقل نصي عام ──
  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputAction action = TextInputAction.next,
    TextInputType? inputType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      textInputAction: action,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: _decor(label: label, hint: hint, icon: icon),
    );
  }

  // ── حقل كلمة المرور ──
  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
    required void Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      onChanged: onChanged,
      validator: validator,
      textInputAction: TextInputAction.next,
      decoration:
          _decor(
            label: label,
            hint: '••••••••',
            icon: Icons.lock_outline,
          ).copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                isVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey[600],
                size: 20,
              ),
              onPressed: onToggle,
              tooltip: isVisible ? 'إخفاء' : 'إظهار',
            ),
          ),
    );
  }

  // ── تنسيق موحّد للحقول ──
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

// ══════════════════════════════════════════════════════════════════
// حوار النجاح
// ══════════════════════════════════════════════════════════════════
class _SuccessDialog extends StatefulWidget {
  const _SuccessDialog({
    required this.adminName,
    required this.username,
    required this.password,
    required this.onDone,
  });

  final String adminName;
  final String username;
  final String password;
  final VoidCallback onDone;

  @override
  State<_SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<_SuccessDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  bool _usernameCopied = false;
  bool _passwordVisible = false; // مخفية افتراضياً

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 440),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _copyUsername() async {
    await Clipboard.setData(ClipboardData(text: widget.username));
    setState(() => _usernameCopied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _usernameCopied = false);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
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
                // ── أيقونة النجاح ──
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 650),
                  curve: Curves.elasticOut,
                  builder: (_, v, child) =>
                      Transform.scale(scale: v, child: child),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade200,
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 46,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── عنوان ──
                const Text(
                  'تم تسجيل المسؤول بنجاح ✅',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2E7D32),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 6),
                Text(
                  'يمكن للمسؤول الآن تسجيل الدخول إلى النظام',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // ── معلومات المسؤول ──
                _infoRow(
                  Icons.badge_outlined,
                  'اسم المسؤول',
                  widget.adminName,
                  Colors.blue.shade700,
                ),
                const SizedBox(height: 10),

                // ── اسم المستخدم ──
                _credentialBox(
                  label: 'اسم المستخدم',
                  value: widget.username,
                  icon: Icons.account_circle_outlined,
                  color: const Color(0xff1565C0),
                  masked: false,
                  copied: _usernameCopied,
                  onCopy: _copyUsername,
                  onToggleVisibility: null,
                ),

                const SizedBox(height: 10),

                // ── كلمة المرور ──
                _credentialBox(
                  label: 'كلمة المرور',
                  value: widget.password,
                  icon: Icons.lock_outline,
                  color: Colors.orange.shade700,
                  masked: !_passwordVisible,
                  copied: false,
                  onCopy: null, // لا يُسمح بالنسخ وهي مخفية
                  onToggleVisibility: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                ),

                const SizedBox(height: 10),

                // ── تنبيه ──
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
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
                          'احتفظ ببيانات الدخول في مكان آمن.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.amber.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // ── أزرار ──
                Row(
                  children: [
                    const SizedBox(width: 10),
                    // إنهاء
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: widget.onDone,
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: const Text(
                          'إنهاء',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── صف معلومات ──
  Widget _infoRow(IconData icon, String label, String value, Color color) {
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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ── صندوق بيانات اعتماد ──
  Widget _credentialBox({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool masked,
    required bool copied,
    required VoidCallback? onCopy,
    required VoidCallback? onToggleVisibility,
  }) {
    final display = masked ? '•' * value.length : value;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          // معلومات
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
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: SelectableText(
                    display,
                    key: ValueKey(masked),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: masked ? Colors.grey.shade400 : color,
                      letterSpacing: masked ? 2.5 : 1.2,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // أزرار الجانب
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // إظهار/إخفاء (لكلمة المرور فقط)
              if (onToggleVisibility != null)
                IconButton(
                  icon: Icon(
                    masked
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: color,
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                  tooltip: masked ? 'إظهار' : 'إخفاء',
                  style: IconButton.styleFrom(
                    backgroundColor: color.withValues(alpha: 0.1),
                    padding: const EdgeInsets.all(7),
                  ),
                ),

              // نسخ (متاح فقط عند الكشف أو لاسم المستخدم)
              if (onCopy != null ||
                  (!masked && onToggleVisibility != null)) ...[
                const SizedBox(width: 6),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: copied
                      ? Container(
                          key: const ValueKey('done'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.green.shade600,
                                size: 13,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'تم',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : IconButton(
                          key: const ValueKey('copy'),
                          // نسخ متاح فقط إذا ظهرت كلمة المرور
                          onPressed: (!masked && onToggleVisibility != null)
                              ? () => Clipboard.setData(
                                  ClipboardData(text: value),
                                )
                              : onCopy,
                          tooltip: masked
                              ? 'أظهر كلمة المرور أولاً للنسخ'
                              : 'نسخ',
                          icon: Icon(
                            Icons.copy_rounded,
                            color: masked ? Colors.grey.shade400 : color,
                            size: 20,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: masked
                                ? Colors.grey.shade100
                                : color.withValues(alpha: 0.1),
                            padding: const EdgeInsets.all(7),
                          ),
                        ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── تعداد قوة كلمة المرور ──
enum _PasswordStrength { none, weak, medium, strong }
