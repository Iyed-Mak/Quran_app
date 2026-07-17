// ═══════════════════════════════════════════════════════════════════
// نموذج الملفات المطلوبة (Required Files Model)
// ═══════════════════════════════════════════════════════════════════

// يمثل ملفاً مطلوباً واحداً (مثل: شهادة الميلاد، صورة شخصية...)
class RequiredFile {
  final int id;
  final String name; // اسم الملف (مثل: شهادة الميلاد)
  final String? description; // وصف أو ملاحظات اختيارية
  final DateTime createdAt; // تاريخ الإضافة

  const RequiredFile({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  RequiredFile copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
  }) {
    return RequiredFile(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'RequiredFile(id: $id, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequiredFile && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// يمثل حالة ملف معين لطالب معين
// (fileId, studentId) -> isCompleted
class StudentFileStatus {
  final int studentId;
  final int fileId;
  final bool isCompleted;

  const StudentFileStatus({
    required this.studentId,
    required this.fileId,
    required this.isCompleted,
  });

  StudentFileStatus copyWith({bool? isCompleted}) {
    return StudentFileStatus(
      studentId: studentId,
      fileId: fileId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// مخزن البيانات المؤقت (Mock) للملفات المطلوبة وحالاتها لكل طالب
// نستخدم SchoolData المستقل مع قائمة طلاب وهمية مستنسخة من نمط student_manage
class RequiredFilesStore {
  // قائمة الملفات المطلوبة العامة (تُعرض لكل الطلاب)
  static final List<RequiredFile> initialFiles = [
    RequiredFile(
      id: 1,
      name: 'شهادة الميلاد',
      description: 'نسخة أصلية أو مصادق عليها',
      createdAt: DateTime(2025, 9, 1),
    ),
    RequiredFile(
      id: 2,
      name: 'بطاقة التعريف',
      description: 'بطاقة وطنية أو جواز سفر',
      createdAt: DateTime(2025, 9, 1),
    ),
    RequiredFile(
      id: 3,
      name: 'صورة شخصية',
      description: 'صورة حديثة بخلفية بيضاء',
      createdAt: DateTime(2025, 9, 2),
    ),
  ];

  // قائمة الطلاب (مستنسخة كموك من student_manage)
  // المعرفات يجب أن تتطابق مع IDs المستخدمة في ظهور الحالات
  static final List<Map<String, dynamic>> initialStudents = [
    {'id': 1, 'name': 'يوسف أمين', 'group': 'فوج 1'},
    {'id': 2, 'name': 'عمر بن زيد', 'group': 'فوج 1'},
    {'id': 3, 'name': 'عبد الله مولاي', 'group': 'فوج 1'},
    {'id': 4, 'name': 'أنس الهاشمي', 'group': 'فوج 1'},
    {'id': 5, 'name': 'حمزة بن صالح', 'group': 'فوج 2'},
    {'id': 6, 'name': 'سارة محمد', 'group': 'فوج 2'},
    {'id': 7, 'name': 'فاطمة الزهراء', 'group': 'فوج 3'},
    {'id': 8, 'name': 'نور الإيمان', 'group': 'فوج 3'},
    {'id': 9, 'name': 'آية جمال', 'group': 'فوج 4'},
    {'id': 10, 'name': 'عبد الرحمن خالد', 'group': 'فوج 5'},
  ];

  // الحالة الافتراضية لكل طالب × ملف. كلها "غير مكتمل" افتراضياً.
  // المفتاح: "studentId-fileId"
  static final Map<String, bool> initialStatuses = {
    // مثال على طالب أحضر بعض الملفات (للعرض التوضيحي)
    '1-1': true, // يوسف - شهادة الميلاد ✓
    '1-2': true, // يوسف - بطاقة التعريف ✓
    '1-3': false, // يوسف - صورة شخصية ✗
    '2-1': true,
    '2-2': false,
    '2-3': false,
    '3-1': true,
    '3-2': true,
    '3-3': true,
  };
}
