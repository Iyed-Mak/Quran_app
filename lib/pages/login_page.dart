import 'package:flutter/material.dart';

import 'Admin/admin_page.dart';
import 'Parent/parent_page.dart';
import 'Student/student_page.dart';
import 'Teacher/teacher_page.dart';

/// Roles supported by the app. Used for the local/mock role selector since
/// there is no backend authentication in this demo.
enum UserRole { admin, teacher, student, parent }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  // Mock/local role selection — no backend involved.
  UserRole _selectedRole = UserRole.teacher;

  final Map<UserRole, String> _roleLabels = const {
    UserRole.admin: 'مدير',
    UserRole.teacher: 'معلم',
    UserRole.student: 'طالب',
    UserRole.parent: 'ولي أمر',
  };

  final Map<UserRole, IconData> _roleIcons = const {
    UserRole.admin: Icons.admin_panel_settings_outlined,
    UserRole.teacher: Icons.school_outlined,
    UserRole.student: Icons.menu_book_outlined,
    UserRole.parent: Icons.family_restroom_outlined,
  };

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulated delay to mimic a real login flow (UI demonstration only).
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _navigateToRolePage(_selectedRole);
    });
  }

  void _navigateToRolePage(UserRole role) {
    // The username typed in is reused as the display name passed to
    // each role page (mock/local only — no real authentication).
    final String displayName = _usernameController.text.trim().isEmpty
        ? 'المستخدم'
        : _usernameController.text.trim();

    Widget destination;
    switch (role) {
      case UserRole.admin:
        destination = AdminPage(adminName: displayName);
        break;
      case UserRole.teacher:
        destination = TeacherDashboard(teacherName: displayName);
        break;
      case UserRole.student:
        destination = StudentPage(studentName: displayName);
        break;
      case UserRole.parent:
        destination = ParentPage(parentName: displayName);
        break;
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => destination));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xfff5f9ff),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double screenWidth = constraints.maxWidth;
              final bool isTablet = screenWidth >= 600 && screenWidth < 1000;
              final bool isDesktop = screenWidth >= 1000;

              // Card max width adapts to the device class.
              final double maxCardWidth = isDesktop
                  ? 460
                  : isTablet
                  ? 480
                  : double.infinity;

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxCardWidth),
                    child: _LoginCard(
                      formKey: _formKey,
                      usernameController: _usernameController,
                      passwordController: _passwordController,
                      obscurePassword: _obscurePassword,
                      onToggleObscure: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      selectedRole: _selectedRole,
                      roleLabels: _roleLabels,
                      roleIcons: _roleIcons,
                      onRoleChanged: (role) {
                        setState(() => _selectedRole = role);
                      },
                      isLoading: _isLoading,
                      onLoginPressed: _handleLogin,
                      isDesktop: isDesktop,
                      isTablet: isTablet,
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
}

/// The visual login card: logo, fields, role selector, and submit button.
class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.selectedRole,
    required this.roleLabels,
    required this.roleIcons,
    required this.onRoleChanged,
    required this.isLoading,
    required this.onLoginPressed,
    required this.isDesktop,
    required this.isTablet,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final UserRole selectedRole;
  final Map<UserRole, String> roleLabels;
  final Map<UserRole, IconData> roleIcons;
  final ValueChanged<UserRole> onRoleChanged;
  final bool isLoading;
  final VoidCallback onLoginPressed;
  final bool isDesktop;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final double cardPadding = isDesktop || isTablet ? 36 : 24;
    final double logoSize = isDesktop || isTablet ? 110 : 88;
    final double titleSize = isDesktop || isTablet ? 26 : 22;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Logo placeholder ──
            Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: logoSize * 0.5,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'تطبيق القرآن الكريم',
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'سجّل الدخول للمتابعة',
              style: TextStyle(
                fontSize: isDesktop || isTablet ? 15 : 13,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            // ── Username field ──
            TextFormField(
              controller: usernameController,
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'اسم المستخدم',
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: const Color(0xfff5f9ff),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.blue.shade100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.blue.shade700,
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال اسم المستخدم';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // ── Password field with show/hide toggle ──
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.blue.shade700,
                  ),
                  onPressed: onToggleObscure,
                  tooltip: obscurePassword
                      ? 'إظهار كلمة المرور'
                      : 'إخفاء كلمة المرور',
                ),
                filled: true,
                fillColor: const Color(0xfff5f9ff),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.blue.shade100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.blue.shade700,
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال كلمة المرور';
                }
                return null;
              },
              onFieldSubmitted: (_) => onLoginPressed(),
            ),

            const SizedBox(height: 22),

            // ── Role selector (UI demonstration only — no backend) ──
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'تسجيل الدخول كـ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: UserRole.values.map((role) {
                final bool selected = role == selectedRole;
                return ChoiceChip(
                  avatar: Icon(
                    roleIcons[role],
                    size: 18,
                    color: selected ? Colors.white : Colors.blue.shade700,
                  ),
                  label: Text(roleLabels[role]!),
                  selected: selected,
                  selectedColor: Colors.blue.shade700,
                  backgroundColor: const Color(0xfff5f9ff),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.blue.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: selected
                          ? Colors.blue.shade700
                          : Colors.blue.shade100,
                    ),
                  ),
                  onSelected: (_) => onRoleChanged(role),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // ── Login button ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : onLoginPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  disabledBackgroundColor: Colors.blue.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              'يرجى مراجعة إدارة المدرسة للحصول على اسم المستخدم وكلمة المرور الخاصة بكم',
              style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
