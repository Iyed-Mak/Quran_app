// ═══════════════════════════════════════════════════════════════════
// نموذج البيانات
// ════════════════════════════════════════
class Teacher {
  final int id;
  final String name;
  final String username;
  final String password;
  final String? teacherPhone; // رقم هاتف المعلم
  final String dob; // DD/MM/YYYY
  final List<String> groups;
  final bool isFemale;

  const Teacher({
    required this.id,
    required this.name,
    required this.isFemale,
    required this.teacherPhone,
    required this.dob,
    required this.groups,
    required this.username,
    required this.password,
  });
}
