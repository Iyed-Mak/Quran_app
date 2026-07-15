// ═══════════════════════════════════════════════════════════════════
// نموذج البيانات
// ════════════════════════════════════════
class Student {
  final int id;
  final String name;
  final bool isFemale;
  final String dob; // DD/MM/YYYY
  final String group;
  final String memorization;
  final String username;
  final String password;
  final String? parentName; // null if adult
  final String? parentPhone; // null if adult
  final String? studentPhone; // رقم هاتف الطالب (اختياري)
  final List<bool> docs; // [شهادة ميلاد, بطاقة تعريف, صورة, إقامة]

  const Student({
    required this.id,
    required this.name,
    required this.isFemale,
    required this.dob,
    required this.group,
    required this.memorization,
    required this.username,
    required this.password,
    this.parentName,
    this.parentPhone,
    this.studentPhone,
    required this.docs,
  });

  int get age {
    final p = dob.split('/');
    final birth = DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
    final now = DateTime.now();
    int a = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day))
      a--;
    return a;
  }

  bool get isAdult => age > 16;
}
