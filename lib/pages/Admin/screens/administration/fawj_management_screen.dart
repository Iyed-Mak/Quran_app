import 'package:flutter/material.dart';
import 'model/fawj_model.dart';

// شاشة إدارة الأفواج مع عمليات CRUD كاملة
class FawjManagementScreen extends StatefulWidget {
  const FawjManagementScreen({super.key});

  @override
  State<FawjManagementScreen> createState() => _FawjManagementScreenState();
}

class _FawjManagementScreenState extends State<FawjManagementScreen> {
  late List<Fawj> _fawjs;
  int _nextId = 4; // للـ ID التلقائي
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fawjs = List.from(FawjMockData.initialFawjs);
    // تحديث nextId بناءً على البيانات الموجودة
    if (_fawjs.isNotEmpty) {
      _nextId = _fawjs.map((f) => f.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Fawj> get _filteredFawjs {
    if (_searchQuery.isEmpty) return _fawjs;
    return _fawjs.where((f) =>
      f.name.contains(_searchQuery) ||
      (f.teacherName?.contains(_searchQuery) ?? false) ||
      f.studentNames.any((s) => s.contains(_searchQuery)) ||
      (f.description?.contains(_searchQuery) ?? false)
    ).toList();
  }

  // ── إضافة فوج جديد ──
  void _showAddFawjDialog() {
    final nameController = TextEditingController();
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
                  _buildTextField(nameController, 'اسم الفوج *', 'مثال: فوج 1', Icons.group),
                  const SizedBox(height: 12),
                  _buildTextField(teacherController, 'اسم الأستاذ', 'مثال: الأستاذ أحمد', Icons.person),
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
                          'اسم الطالب',
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
                        backgroundColor: Colors.blue.shade50,
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white),
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('يرجى إدخال اسم الفوج'), backgroundColor: Colors.red),
                  );
                  return;
                }
                final newFawj = Fawj(
                  id: _nextId++,
                  name: nameController.text.trim(),
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

  // ── تعديل فوج موجود ──
  void _showEditFawjDialog(Fawj fawj) {
    final nameController = TextEditingController(text: fawj.name);
    final teacherController = TextEditingController(text: fawj.teacherName ?? '');
    final studentsCountController = TextEditingController(text: fawj.studentsCount.toString());
    final descriptionController = TextEditingController(text: fawj.description ?? '');
    final List<String> studentNames = List.from(fawj.studentNames);
    final studentNameController = TextEditingController();

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
                  _buildTextField(nameController, 'اسم الفوج *', 'مثال: فوج 1', Icons.group),
                  const SizedBox(height: 12),
                  _buildTextField(teacherController, 'اسم الأستاذ', 'مثال: الأستاذ أحمد', Icons.person),
                  const SizedBox(height: 12),
                  _buildTextField(studentsCountController, 'عدد الطلاب', 'مثال: 15', Icons.people, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  _buildTextField(descriptionController, 'وصف / ملاحظات', 'مثال: فوج المستوى الأول', Icons.description),
                  const SizedBox(height: 16),
                  // قسم إدارة الطلاب
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          studentNameController,
                          'اسم الطالب',
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
                        backgroundColor: Colors.blue.shade50,
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700, foregroundColor: Colors.white),
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('يرجى إدخال اسم الفوج'), backgroundColor: Colors.red),
                  );
                  return;
                }
                final updatedFawj = fawj.copyWith(
                  name: nameController.text.trim(),
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
                      backgroundColor: Colors.blue.shade50,
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.orange.shade700, Colors.orange.shade400]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.group_work, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'إدارة الأفواج',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                        Text(
                          'إنشاء الأفواج، تعيين الأساتذة، وإدارة الطلاب',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة فوج'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: _showAddFawjDialog,
                  ),
                ],
              ),

              const SizedBox(height: 24),

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
                    Text(
                      '${_filteredFawjs.length} / ${_fawjs.length}',
                      style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
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
                        Icon(Icons.group_work, size: 64, color: Colors.grey.shade300),
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

  @override
  Widget build(BuildContext context) {
    final hasTeacher = fawj.teacherName != null && fawj.teacherName!.isNotEmpty;
    final hasStudents = fawj.studentNames.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.orange.shade50, blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: hasTeacher ? [Colors.orange.shade600, Colors.orange.shade400] : [Colors.grey.shade400, Colors.grey.shade300],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Text(
                    fawj.name.replaceAll(RegExp(r'[^0-9]'), '').isEmpty
                        ? 'ف'
                        : fawj.name.replaceAll(RegExp(r'[^0-9]'), ''),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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
                      Icon(Icons.people, size: 18, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'الطلاب: ${fawj.studentsCount}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.orange.shade800),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: hasStudents ? Colors.green.shade50 : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hasStudents ? 'مكتمل' : 'فارغ',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: hasStudents ? Colors.green.shade700 : Colors.orange.shade700,
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
                          color: Colors.blue.shade50,
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