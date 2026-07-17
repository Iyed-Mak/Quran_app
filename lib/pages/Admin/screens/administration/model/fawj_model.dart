// ═══════════════════════════════════════════════════════════════════
// نموذج الفوج (Group/Class Model)
// ═══════════════════════════════════════════════════════════════════
class Fawj {
  final int id;
  final String name; // اسم الفوج (مثل: فوج 1، فوج 2)
  final String? teacherName; // اسم الأستاذ المعين
  final int studentsCount; // عدد الطلاب في الفوج
  final List<String> studentNames; // أسماء الطلاب
  final String? description; // وصف أو ملاحظات

  const Fawj({
    required this.id,
    required this.name,
    this.teacherName,
    required this.studentsCount,
    required this.studentNames,
    this.description,
  });

  // نسخة مع تحديثات
  Fawj copyWith({
    int? id,
    String? name,
    String? teacherName,
    int? studentsCount,
    List<String>? studentNames,
    String? description,
  }) {
    return Fawj(
      id: id ?? this.id,
      name: name ?? this.name,
      teacherName: teacherName ?? this.teacherName,
      studentsCount: studentsCount ?? this.studentsCount,
      studentNames: studentNames ?? this.studentNames,
      description: description ?? this.description,
    );
  }

  @override
  String toString() => 'Fawj(id: $id, name: $name, teacher: $teacherName, students: $studentsCount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Fawj && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// بيانات تجريبية للأفواج
class FawjMockData {
  static List<Fawj> get initialFawjs => [
        Fawj(
          id: 1,
          name: 'فوج 1',
          teacherName: 'الأستاذ أحمد',
          studentsCount: 15,
          studentNames: [
            'أحمد محمد',
            'محمد علي',
            'ليلى أحمد',
            'فاطمة حسن',
            'خالد عمر',
            'مريم عبد الله',
            'يوسف إبراهيم',
            'زينب علي',
            'عمر خالد',
            'سارة أحمد',
            'حسين محمد',
            'نور الدين',
            'إيمان سعيد',
            'عبد الرحمن',
            'آية جمال',
          ],
          description: 'فوج المستوى الأول - حفظ القرآن',
        ),
        Fawj(
          id: 2,
          name: 'فوج 2',
          teacherName: 'الأستاذ محمد',
          studentsCount: 12,
          studentNames: [
            'سارة أحمد',
            'حسين محمد',
            'نور الدين',
            'إيمان سعيد',
            'عبد الرحمن علي',
            'آية جمال',
            'زينب حسن',
            'عمر خالد',
            'ليلى أحمد',
            'فاطمة محمد',
            'مريم عمر',
            'يوسف إبراهيم',
          ],
          description: 'فوج المستوى الثاني - تجويد',
        ),
        Fawj(
          id: 3,
          name: 'فوج 3',
          teacherName: null,
          studentsCount: 0,
          studentNames: [],
          description: 'فوج جديد - لم يتم تعيين أستاذ بعد',
        ),
      ];
}