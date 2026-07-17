// ═══════════════════════════════════════════════════════════════════
// نموذج القاعة الدراسية (Classroom Model)
// ═══════════════════════════════════════════════════════════════════
class Qaa {
  final int id;
  final String name; // اسم القاعة (مثل: قاعة 1، قاعة 2)
  final int tablesCount; // عدد الطاولات في القاعة
  final String? description; // وصف أو ملاحظات

  const Qaa({
    required this.id,
    required this.name,
    required this.tablesCount,
    this.description,
  });

  // نسخة مع تحديثات
  Qaa copyWith({
    int? id,
    String? name,
    int? tablesCount,
    String? description,
  }) {
    return Qaa(
      id: id ?? this.id,
      name: name ?? this.name,
      tablesCount: tablesCount ?? this.tablesCount,
      description: description ?? this.description,
    );
  }

  @override
  String toString() => 'Qaa(id: $id, name: $name, tables: $tablesCount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Qaa && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// بيانات تجريبية للقاعات
class QaaMockData {
  static List<Qaa> get initialQaas => [
        Qaa(
          id: 1,
          name: 'قاعة 1',
          tablesCount: 15,
          description: 'قاعة كبرى - للحفظ الجماعي',
        ),
        Qaa(
          id: 2,
          name: 'قاعة 2',
          tablesCount: 12,
          description: 'قاعة للمستوى المتوسط',
        ),
        Qaa(
          id: 3,
          name: 'قاعة 3',
          tablesCount: 0,
          description: 'قاعة جديدة - قيد التجهيز',
        ),
      ];
}
