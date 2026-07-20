import 'package:flutter/material.dart';
import 'model/fawj_model.dart';

// شاشة إدارة الأفواج مع عمليات CRUD كاملة
class FawjManagementScreen extends StatefulWidget {
  const FawjManagementScreen({super.key});

  @override
  State<FawjManagementScreen> createState() => _FawjManagementScreenState();
}

enum _GenderFilter { all, male, female }

class _FawjManagementScreenState extends State<FawjManagementScreen> {
  late List<Fawj> _fawjs;
  int _nextId = 4;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  _GenderFilter _genderFilter = _GenderFilter.all;

  @override
  void initState() {
    super.initState();
    _fawjs = List.from(FawjMockData.initialFawjs);
    if (_fawjs.isNotEmpty) {
      _nextId = _fawjs.map((f) => f.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // الحصول على أعلى رقم ترقيم لفئة جنس معينة
  int _nextNumberForGender(bool isFemale) {
    int maxNum = 0;
    for (final f in _fawjs.where((f) => f.isFemale == isFemale)) {
      final match = RegExp(r'(\d+)').firstMatch(f.name);
      if (match != null) {
        final num = int.parse(match.group(1)!);
        if (num > maxNum) maxNum = num;
      }
    }
    return maxNum + 1;
  }

  String _autoName(bool isFemale) {
    final num = _nextNumberForGender(isFemale);
    return 'فوج $num';
  }

  List<Fawj> get _filteredFawjs {
    List<Fawj> result = _fawjs;
    // تطبيق فلتر الجنس
    if (_genderFilter == _GenderFilter.male) {
      result = result.where((f) => !f.isFemale).toList();
    } else if (_genderFilter == _GenderFilter.female) {
      result = result.where((f) => f.isFemale).toList();
    }
    // تطبيق البحث
    if (_searchQuery.isNotEmpty) {
      result = result.where((f) =>
        f.name.contains(_searchQuery) ||
        (f.teacherName?.contains(_searchQuery) ?? false) ||
        f.studentNames.any((s) => s.contains(_searchQuery)) ||
        (f.description?.contains(_searchQuery) ?? false)
      ).toList();
    }
    return result;
  }

  // ── إضافة فوج جديد ──
  void _showAddFawjDialog() {
    bool isFemale = false;
    final teacherController = TextEditingController();
    final studentsCountController = TextEditingController();
    final descriptionController = TextEditingController();
    final List<String> studentNames = [];
    final studentNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إضافة فوج جديد', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // الاسم التلقائي + اختيار الجنس
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.blue.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _autoName(isFemale),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // اختيار الجنس
                  Row(
                    children: [
                      Expanded(
                        child: _genderChip(
                          label: 'رجال',
                          icon: Icons.male,
                          selected: !isFemale,
                          color: Colors.blue,
                          onTap: () => setDialogState(() => isFemale = false),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _genderChip(
                          label: 'نساء',
                          icon: Icons.female,
                          selected: isFemale,
                          color: Colors.pink,
                          onTap: () => setDialogState(() => isFemale = true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(teacherController, 'اسم الأستاذ/الأستاذة', 'مثال: الأستاذ أحمد', Icons.person),
                  const SizedBox(height: 12),
                  _buildTextField(studentsCountController, 'عدد الطلاب', 'مثال: 15', Icons.people, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  _buildTextField(descriptionController, 'وصف / ملاحظات', 'مثال: فوج المستوى الأول', Icons.description),
                  const SizedBox(height: 16),
                  // قسم إضافة الطلاب
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          studentNameController,
                          'اسم الطالب/الطالبة',
                          'أضف طالباً واحداً تلو الآخر',
                          Icons.person_add,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green, size: 28),
                        onPressed: () {
                          if (studentNameController.text.trim().isNotEmpty) {
                            setDialogState(() {
                              studentNames.add(studentNameController.text.trim());
                              studentNameController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  if (studentNames.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: studentNames.map((name) => Chip(
                        label: Text(name),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => setDialogState(() => studentNames.remove(name)),
                        backgroundColor: isFemale ? Colors.pink.shade50 : Colors.blue.shade50,
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('حفظ الفوج'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isFemale ? Colors.pink.shade700 : Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final name = _autoName(isFemale);
                final newFawj = Fawj(
                  id: _nextId++,
                  name: name,
                  isFemale: isFemale,
                  teacherName: teacherController.text.trim().isEmpty ? null : teacherController.text.trim(),
                  studentsCount: int.tryParse(studentsCountController.text.trim()) ?? studentNames.length,
                  studentNames: studentNames,
                  description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                );
                setState(() => _fawjs.insert(0, newFawj));
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم إضافة "${newFawj.name}" بنجاح'), backgroundColor: Colors.green),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderChip({
    required String label,
    required IconData icon,
    required bool selected,
    required MaterialColor color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color.shade400 : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? color.shade700 : Colors.grey, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? color.shade800 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── تعديل فوج موجود ──
  void _showEditFawjDialog(Fawj fawj) {
    final teacherController = TextEditingController(text: fawj.teacherName ?? '');
    final studentsCountController = TextEditingController(text: fawj.studentsCount.toString());
    final descriptionController = TextEditingController(text: fawj.description ?? '');
    final List<String> studentNames = List.from(fawj.studentNames);
    final studentNameController = TextEditingController();
    bool isFemale = fawj.isFemale;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('تعديل "${fawj.name}"', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // اسم الفوج + الجنس
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (isFemale ? Colors.pink : Colors.blue).shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: (isFemale ? Colors.pink : Colors.blue).shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(isFemale ? Icons.female : Icons.male,
                            color: (isFemale ? Colors.pink : Colors.blue).shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          fawj.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: (isFemale ? Colors.pink : Colors.blue).shade800,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<bool>(
                              value: isFemale,
                              items: const [
                                DropdownMenuItem(value: false, child: Text('رجال', style: TextStyle(fontSize: 13))),
                                DropdownMenuItem(value: true, child: Text('نساء', style: TextStyle(fontSize: 13))),
                              ],
                              onChanged: (v) {
                                if (v != null) setDialogState(() => isFemale = v);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(teacherController, 'اسم الأستاذ/الأستاذة', 'مثال: الأستاذ أحمد', Icons.person),
                  const SizedBox(height: 12),
                  _buildTextField(studentsCountController, 'عدد الطلاب', 'مثال: 15', Icons.people, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  _buildTextField(descriptionController, 'وصف / ملاحظات', 'مثال: فوج المستوى الأول', Icons.description),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          studentNameController,
                          'اسم الطالب/الطالبة',
                          'أضف طالباً واحداً تلو الآخر',
                          Icons.person_add,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green, size: 28),
                        onPressed: () {
                          if (studentNameController.text.trim().isNotEmpty) {
                            setDialogState(() {
                              studentNames.add(studentNameController.text.trim());
                              studentNameController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  if (studentNames.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: studentNames.map((name) => Chip(
                        label: Text(name),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => setDialogState(() => studentNames.remove(name)),
                        backgroundColor: (isFemale ? Colors.pink : Colors.blue).shade50,
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('حفظ التعديلات'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final updatedFawj = fawj.copyWith(
                  isFemale: isFemale,
                  teacherName: teacherController.text.trim().isEmpty ? null : teacherController.text.trim(),
                  studentsCount: int.tryParse(studentsCountController.text.trim()) ?? studentNames.length,
                  studentNames: studentNames,
                  description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                );
                setState(() {
                  final idx = _fawjs.indexWhere((f) => f.id == fawj.id);
                  if (idx != -1) _fawjs[idx] = updatedFawj;
                });
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم تحديث "${updatedFawj.name}" بنجاح'), backgroundColor: Colors.green),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── حذف فوج ──
  void _confirmDeleteFawj(Fawj fawj) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف', style: TextStyle(color: Colors.red)),
        content: Text('هل تريد حقاً حذف "${fawj.name}"؟\nهذا الإجراء لا يمكن التراجع عنه.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('حذف'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              setState(() => _fawjs.removeWhere((f) => f.id == fawj.id));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم حذف "${fawj.name}"'), backgroundColor: Colors.red),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── عرض تفاصيل الفوج ──
  void _showFawjDetails(Fawj fawj) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تفاصيل "${fawj.name}"'),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('اسم الفوج', fawj.name, Icons.group),
                _detailRow('الجنس', fawj.isFemale ? 'نساء' : 'رجال', fawj.isFemale ? Icons.female : Icons.male),
                _detailRow('الأستاذ', fawj.teacherName ?? 'غير معين', Icons.person),
                _detailRow('عدد الطلاب', '${fawj.studentsCount}', Icons.people),
                _detailRow('الوصف', fawj.description ?? 'لا يوجد', Icons.description),
                const SizedBox(height: 16),
                const Text('قائمة الطلاب:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                if (fawj.studentNames.isEmpty)
                  Text('لا يوجد طلاب مسجلين', style: TextStyle(color: Colors.grey.shade600))
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: fawj.studentNames.map((name) => Chip(
                      label: Text(name),
                      backgroundColor: (fawj.isFemale ? Colors.pink : Colors.blue).shade50,
                    )).toList(),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _detailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 12),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w >= 1200 ? 4 : w >= 900 ? 3 : w >= 600 ? 2 : 1;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('إدارة الأفواج'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Action Bar ──
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة فوج'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: _showAddFawjDialog,
                  ),
                  const Spacer(),
                  Text(
                    '${_filteredFawjs.length} / ${_fawjs.length}',
                    style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Gender Filter Chips ──
              Row(
                children: [
                  _filterChip(
                    label: 'الكل',
                    selected: _genderFilter == _GenderFilter.all,
                    color: Colors.grey,
                    onTap: () => setState(() => _genderFilter = _GenderFilter.all),
                  ),
                  const SizedBox(width: 8),
                  _filterChip(
                    label: 'رجال ${_fawjs.where((f) => !f.isFemale).length}',
                    icon: Icons.male,
                    selected: _genderFilter == _GenderFilter.male,
                    color: Colors.blue,
                    onTap: () => setState(() => _genderFilter = _GenderFilter.male),
                  ),
                  const SizedBox(width: 8),
                  _filterChip(
                    label: 'نساء ${_fawjs.where((f) => f.isFemale).length}',
                    icon: Icons.female,
                    selected: _genderFilter == _GenderFilter.female,
                    color: Colors.pink,
                    onTap: () => setState(() => _genderFilter = _GenderFilter.female),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),

              // ── Search Bar ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'ابحث عن فوج، أستاذ، طالب...',
                          border: InputBorder.none,
                        ),
                        onChanged: (v) => setState(() => _searchQuery = v.trim()),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Grid/List of Fawjs ──
              if (_filteredFawjs.isEmpty)
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(_genderFilter == _GenderFilter.female ? Icons.female : Icons.group_work,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'لا توجد أفواج بعد' : 'لا توجد نتائج للبحث',
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty
                              ? 'اضغط على "إضافة فوج" للبدء'
                              : 'جرب كلمات بحث أخرى',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: w >= 900 ? 1.1 : 1.0,
                  ),
                  itemCount: _filteredFawjs.length,
                  itemBuilder: (_, i) => _FawjCard(
                    fawj: _filteredFawjs[i],
                    onEdit: _showEditFawjDialog,
                    onDelete: _confirmDeleteFawj,
                    onView: _showFawjDetails,
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── فلتر الجنس (Chip) ──
Widget _filterChip({
  required String label,
  IconData? icon,
  required bool selected,
  required MaterialColor color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? color.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? color.shade400 : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: selected ? color.shade700 : Colors.grey),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: selected ? color.shade800 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    ),
  );
}

// ── بطاقة الفوج ──
class _FawjCard extends StatelessWidget {
  final Fawj fawj;
  final void Function(Fawj) onEdit;
  final void Function(Fawj) onDelete;
  final void Function(Fawj) onView;

  const _FawjCard({
    required this.fawj,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
  });

  MaterialColor get _accent => fawj.isFemale ? Colors.pink : Colors.blue;
  Color get _accentLight => fawj.isFemale ? Colors.pink.shade50 : Colors.blue.shade50;

  @override
  Widget build(BuildContext context) {
    final hasTeacher = fawj.teacherName != null && fawj.teacherName!.isNotEmpty;
    final hasStudents = fawj.studentNames.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: _accentLight, blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: _accent.shade100),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: hasTeacher
                    ? [_accent.shade600, _accent.shade400]
                    : [Colors.grey.shade400, Colors.grey.shade300],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Icon(
                    fawj.isFemale ? Icons.female : Icons.male,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fawj.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        fawj.isFemale ? 'نساء' : 'رجال',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      if (hasTeacher)
                        Text(
                          fawj.teacherName!,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        )
                      else
                        const Text('بدون أستاذ معين', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عدد الطلاب
                  Row(
                    children: [
                      Icon(Icons.people, size: 18, color: _accent.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'الطلاب: ${fawj.studentsCount}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _accent.shade800),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: hasStudents ? Colors.green.shade50 : _accent.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hasStudents ? 'مكتمل' : 'فارغ',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: hasStudents ? Colors.green.shade700 : _accent.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // قائمة الطلاب (أول 3 فقط)
                  if (hasStudents) ...[
                    const Text('الطلاب:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: fawj.studentNames.take(3).map((name) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _accentLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(name, style: const TextStyle(fontSize: 11)),
                      )).toList(),
                    ),
                    if (fawj.studentNames.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '+ ${fawj.studentNames.length - 3} طالب/ة آخر',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                      ),
                  ] else
                    Text(
                      'لا يوجد طلاب مسجلين',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                    ),

                  const Spacer(),

                  // الوصف
                  if (fawj.description != null && fawj.description!.isNotEmpty) ...[
                    Text(
                      fawj.description!,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.visibility, color: Colors.blue.shade700),
                    tooltip: 'عرض التفاصيل',
                    onPressed: () => onView(fawj),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange.shade700),
                    tooltip: 'تعديل',
                    onPressed: () => onEdit(fawj),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade700),
                    tooltip: 'حذف',
                    onPressed: () => onDelete(fawj),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
