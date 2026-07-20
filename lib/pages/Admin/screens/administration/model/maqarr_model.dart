// ═══════════════════════════════════════════════════════════════════
// نموذج المقر (Branch/Location Model)
// ═══════════════════════════════════════════════════════════════════
class Maqarr {
  final int id;
  final String name; // اسم المقر (مثل: المقر الرئيسي، فرع الحي)
  final String? address; // العنوان
  final String? phone; // هاتف المقر
  final String? description; // وصف أو ملاحظات

  const Maqarr({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.description,
  });

  Maqarr copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? description,
  }) {
    return Maqarr(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      description: description ?? this.description,
    );
  }

  @override
  String toString() => 'Maqarr(id: $id, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Maqarr && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// ═══════════════════════════════════════════════════════════════════
// نموذج الحجر (Room Model) - داخل المقر
// ═══════════════════════════════════════════════════════════════════
class Hajar {
  final int id;
  final int maqarrId; // معرف المقر التابع له
  final String name; // اسم الحجر (مثل: حجر 1، حجر 2)
  final int tablesCount; // عدد الطاولات
  final String? description; // وصف أو ملاحظات

  const Hajar({
    required this.id,
    required this.maqarrId,
    required this.name,
    required this.tablesCount,
    this.description,
  });

  Hajar copyWith({
    int? id,
    int? maqarrId,
    String? name,
    int? tablesCount,
    String? description,
  }) {
    return Hajar(
      id: id ?? this.id,
      maqarrId: maqarrId ?? this.maqarrId,
      name: name ?? this.name,
      tablesCount: tablesCount ?? this.tablesCount,
      description: description ?? this.description,
    );
  }

  @override
  String toString() => 'Hajar(id: $id, maqarr: $maqarrId, name: $name, tables: $tablesCount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Hajar && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// ═══════════════════════════════════════════════════════════════════
// مخزن البيانات الوهمي (Mock Data Store)
// ═══════════════════════════════════════════════════════════════════
class MaqarrStore {
  // قائمة المقرات الأولية
  static final List<Maqarr> initialMaqarr = [
    Maqarr(
      id: 1,
      name: 'المقر الرئيسي',
      address: 'شارع الملك فهد، الرياض',
      phone: '011-1234567',
      description: 'المبنى الرئيسي للإدارة والقاعات الكبرى',
    ),
    Maqarr(
      id: 2,
      name: 'فرع الشمال',
      address: 'طريق الملك عبدالله، حي الملقا',
      phone: '011-7654321',
      description: 'فرع الشمال - قاعات للنساء',
    ),
    Maqarr(
      id: 3,
      name: 'فرع الجنوب',
      address: 'طريق الدائري الجنوبي، حي الشفا',
      phone: '011-9876543',
      description: 'فرع الجنوب - قاعات للرجال',
    ),
  ];

  // الحجر الأولية (بعضها مرتبطة بالمقر 1، وبعضها بالمقر 2)
  static final List<Hajar> initialHajar = [
    // حجر المقر الرئيسي (id: 1)
    Hajar(id: 1, maqarrId: 1, name: 'حجر 1', tablesCount: 20, description: 'قاعة كبرى - حفظ'),
    Hajar(id: 2, maqarrId: 1, name: 'حجر 2', tablesCount: 15, description: 'قاعة متوسطة - تجويد'),
    Hajar(id: 3, maqarrId: 1, name: 'حجر 3', tablesCount: 10, description: 'قاعة صغيرة - مراجعة'),

    // حجر فرع الشمال (id: 2)
    Hajar(id: 4, maqarrId: 2, name: 'حجر 1', tablesCount: 18, description: 'قاعة نساء - المستوى الأول'),
    Hajar(id: 5, maqarrId: 2, name: 'حجر 2', tablesCount: 12, description: 'قاعة نساء - المستوى الثاني'),

    // فرع الجنوب (id: 3) - يبدأ بدون حجر (حسب المتطلبات)
  ];
}