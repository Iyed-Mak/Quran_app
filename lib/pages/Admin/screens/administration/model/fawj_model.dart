// ═══════════════════════════════════════════════════════════════════
// نموذج الفوج (Group/Class Model)
// ═══════════════════════════════════════════════════════════════════
class Fawj {
  final int id;
  final String name; // اسم الفوج (مثل: فوج 1، فوج 2)
  final bool isFemale; // true = نساء, false = رجال
  final String? teacherName; // اسم الأستاذ المعين
  final int studentsCount; // عدد الطلاب في الفوج
  final List<String> studentNames; // أسماء الطلاب
  final String? description; // وصف أو ملاحظات

  const Fawj({
    required this.id,
    required this.name,
    this.isFemale = false,
    this.teacherName,
    required this.studentsCount,
    required this.studentNames,
    this.description,
  });

  // نسخة مع تحديثات
  Fawj copyWith({
    int? id,
    String? name,
    bool? isFemale,
    String? teacherName,
    int? studentsCount,
    List<String>? studentNames,
    String? description,
  }) {
    return Fawj(
      id: id ?? this.id,
      name: name ?? this.name,
      isFemale: isFemale ?? this.isFemale,
      teacherName: teacherName ?? this.teacherName,
      studentsCount: studentsCount ?? this.studentsCount,
      studentNames: studentNames ?? this.studentNames,
      description: description ?? this.description,
    );
  }

  @override
  String toString() => 'Fawj(id: $id, name: $name, female: $isFemale, teacher: $teacherName, students: $studentsCount)';

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
          isFemale: false,
          teacherName: 'الأستاذ أحمد',
          studentsCount: 15,
          studentNames: [
            'أحمد محمد',
            'خالد عمر',
            'يوسف إبراهيم',
            'عمر خالد',
            'حسين محمد',
            'عبد الرحمن',
            'محمد علي',
            'أنس الهاشمي',
            'حمزة بن صالح',
            'عبد الله مولاي',
            'نور الدين',
            'أمين بن يوسف',
            'زياد خالد',
            'راشد بن عمر',
            'مصطفى أمين',
          ],
          description: 'فوج الرجال الأول - حفظ القرآن',
        ),
        Fawj(
          id: 2,
          name: 'فوج 1',
          isFemale: true,
          teacherName: 'الأستاذة سارة',
          studentsCount: 12,
          studentNames: [
            'سارة أحمد',
            'فاطمة حسن',
            'مريم عبد الله',
            'زينب علي',
            'ليلى أحمد',
            'نور الدين',
            'إيمان سعيد',
            'آية جمال',
            'أمينة بوعلام',
            'حليمة بن سعيد',
            'نور الإيمان',
            'فاطمة الزهراء',
          ],
          description: 'فوج النساء الأول - تجويد',
        ),
        Fawj(
          id: 3,
          name: 'فوج 2',
          isFemale: false,
          teacherName: null,
          studentsCount: 0,
          studentNames: [],
          description: 'فوج رجال جديد - لم يتم تعيين أستاذ بعد',
        ),
      ];
}
