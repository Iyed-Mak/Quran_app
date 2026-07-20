import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/required_file_model.dart';
import 'dart:ui' as ui;

// ═══════════════════════════════════════════════════════════════════
// شاشة الملفات المطلوبة (إدارة + حالة الطلاب)
// ═══════════════════════════════════════════════════════════════════
class RequiredFilesScreen extends StatefulWidget {
  const RequiredFilesScreen({super.key});

  @override
  State<RequiredFilesScreen> createState() => _RequiredFilesScreenState();
}

class _RequiredFilesScreenState extends State<RequiredFilesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ── بيانات الملفات المطلوبة ──
  late List<RequiredFile> _files;
  int _nextFileId = 4;
  final TextEditingController _fileSearchController = TextEditingController();
  String _fileSearchQuery = '';

  // ── بيانات الطلاب + الحالات ──
  late final List<Map<String, dynamic>> _students;
  late Map<String, bool> _statuses; // مفتاح: "studentId-fileId"
  final TextEditingController _studentSearchController = TextEditingController();
  String _studentSearchQuery = '';
  int? _selectedStudentId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _files = List.from(RequiredFilesStore.initialFiles);
    if (_files.isNotEmpty) {
      _nextFileId =
          _files.map((f) => f.id).reduce((a, b) => a > b ? a : b) + 1;
    }
    _students = RequiredFilesStore.initialStudents;
    _statuses = Map.from(RequiredFilesStore.initialStatuses);
    _selectedStudentId = _students.isNotEmpty ? _students.first['id'] as int : null;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fileSearchController.dispose();
    _studentSearchController.dispose();
    super.dispose();
  }

  // مفتاح الحالة لطالب وملف معينين
  String _key(int studentId, int fileId) => '$studentId-$fileId';

  bool _isCompleted(int studentId, int fileId) {
    return _statuses[_key(studentId, fileId)] ?? false;
  }

  void _toggleStatus(int studentId, int fileId) {
    setState(() {
      _statuses[_key(studentId, fileId)] =
          !(_statuses[_key(studentId, fileId)] ?? false);
    });
  }

  List<RequiredFile> get _filteredFiles {
    if (_fileSearchQuery.isEmpty) return _files;
    final q = _fileSearchQuery;
    return _files
        .where((f) =>
            f.name.contains(q) || (f.description?.contains(q) ?? false))
        .toList();
  }

  List<Map<String, dynamic>> get _filteredStudents {
    if (_studentSearchQuery.isEmpty) return _students;
    final q = _studentSearchQuery;
    return _students.where((s) {
      final name = s['name'] as String;
      final group = s['group'] as String;
      return name.contains(q) || group.contains(q);
    }).toList();
  }

  Map<String, dynamic>? get _selectedStudent {
    if (_selectedStudentId == null) return null;
    return _students.firstWhere(
      (s) => (s['id'] as int) == _selectedStudentId,
      orElse: () => <String, dynamic>{},
    );
  }

  // ── إضافة ملف جديد ──
  void _showAddFileDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title:
            const Text('إضافة ملف مطلوب', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'اسم الملف *', 'مثال: شهادة الميلاد',
                    Icons.description),
                const SizedBox(height: 12),
                _buildTextField(descController, 'وصف / ملاحظات',
                    'مثال: نسخة أصلية مصادق عليها', Icons.note),
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
            label: const Text('حفظ الملف'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white),
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                      content: Text('يرجى إدخال اسم الملف'),
                      backgroundColor: Colors.red),
                );
                return;
              }
              final newFile = RequiredFile(
                id: _nextFileId++,
                name: nameController.text.trim(),
                description: descController.text.trim().isEmpty
                    ? null
                    : descController.text.trim(),
                createdAt: DateTime.now(),
              );
              setState(() {
                _files.insert(0, newFile);
                // إضافة الملف كـ "غير مكتمل" لكل الطلاب تلقائياً
                for (final s in _students) {
                  _statuses[_key(s['id'] as int, newFile.id)] = false;
                }
              });
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('تم إضافة "${newFile.name}" بنجاح'),
                    backgroundColor: Colors.green),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── تعديل ملف ──
  void _showEditFileDialog(RequiredFile file) {
    final nameController = TextEditingController(text: file.name);
    final descController = TextEditingController(text: file.description ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('تعديل "${file.name}"',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'اسم الملف *', 'مثال: شهادة الميلاد',
                    Icons.description),
                const SizedBox(height: 12),
                _buildTextField(descController, 'وصف / ملاحظات',
                    'مثال: نسخة أصلية مصادق عليها', Icons.note),
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
                foregroundColor: Colors.white),
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                      content: Text('يرجى إدخال اسم الملف'),
                      backgroundColor: Colors.red),
                );
                return;
              }
              final updated = file.copyWith(
                name: nameController.text.trim(),
                description: descController.text.trim().isEmpty
                    ? null
                    : descController.text.trim(),
              );
              setState(() {
                final idx = _files.indexWhere((f) => f.id == file.id);
                if (idx != -1) _files[idx] = updated;
              });
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('تم تحديث "${updated.name}" بنجاح'),
                    backgroundColor: Colors.green),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── حذف ملف ──
  void _confirmDeleteFile(RequiredFile file) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف', style: TextStyle(color: Colors.red)),
        content: Text(
            'هل تريد حقاً حذف "${file.name}"؟\nسيتم حذف حالة هذا الملف لكل الطلاب.\nهذا الإجراء لا يمكن التراجع عنه.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('حذف'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                _files.removeWhere((f) => f.id == file.id);
                // حذف حالات هذا الملف لكل الطلاب
                for (final s in _students) {
                  _statuses.remove(_key(s['id'] as int, file.id));
                }
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('تم حذف "${file.name}"'),
                    backgroundColor: Colors.red),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─ـ عرض تفاصيل الملف ──
  void _showFileDetails(RequiredFile file) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تفاصيل "${file.name}"'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('اسم الملف', file.name, Icons.description),
              _detailRow('الوصف', file.description ?? 'لا يوجد', Icons.note),
              _detailRow(
                  'تاريخ الإضافة',
                  DateFormat('yyyy/MM/dd').format(file.createdAt),
                  Icons.event),
            ],
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
          Text('$label:',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('الملفات المطلوبة'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.blue.shade700,
                unselectedLabelColor: Colors.grey.shade600,
                indicatorColor: Colors.blue.shade700,
                tabs: const [
                  Tab(icon: Icon(Icons.folder), text: 'الملفات المطلوبة'),
                  Tab(icon: Icon(Icons.people), text: 'حالة الطلاب'),
                ],
              ),
            ),

            // ── Tab Content ──
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFilesTab(),
                  _buildStudentsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  تبويب الملفات المطلوبة (CRUD)
  // ════════════════════════════════════════════════════════════════
  Widget _buildFilesTab() {
    final w = MediaQuery.of(context).size.width;
    final cols = w >= 1200 ? 4 : w >= 900 ? 3 : w >= 600 ? 2 : 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Action bar
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('إضافة ملف مطلوب'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: _showAddFileDialog,
              ),
              const Spacer(),
              Text('${_files.length} ملف',
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),

          // Search
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
                    controller: _fileSearchController,
                    decoration: const InputDecoration(
                      hintText: 'ابحث عن ملف...',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) =>
                        setState(() => _fileSearchQuery = v.trim()),
                  ),
                ),
                if (_fileSearchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _fileSearchController.clear();
                      setState(() => _fileSearchQuery = '');
                    },
                  ),
                Text('${_filteredFiles.length} / ${_files.length}',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Files Grid
          if (_filteredFiles.isEmpty)
            _buildEmptyState(
              icon: Icons.folder_off,
              title: _fileSearchQuery.isEmpty
                  ? 'لا توجد ملفات بعد'
                  : 'لا توجد نتائج للبحث',
              hint: _fileSearchQuery.isEmpty
                  ? 'اضغط على "إضافة ملف مطلوب" للبدء'
                  : 'جرب كلمات بحث أخرى',
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: w >= 900 ? 1.15 : 1.05,
              ),
              itemCount: _filteredFiles.length,
              itemBuilder: (_, i) => _FileCard(
                file: _filteredFiles[i],
                onEdit: _showEditFileDialog,
                onDelete: _confirmDeleteFile,
                onView: _showFileDetails,
              ),
            ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  تبويب حالة الطلاب (تبديل حالة الملفات لكل طالب)
  // ════════════════════════════════════════════════════════════════
  Widget _buildStudentsTab() {
    final student = _selectedStudent;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Row(
              children: [
                const Icon(Icons.person_search, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<int>(
                    value: _selectedStudentId,
                    hint: const Text('اختر طالباً'),
                    isExpanded: true,
                    items: _filteredStudents.map((s) {
                      return DropdownMenuItem<int>(
                        value: s['id'] as int,
                        child: Text('${s['name']} - ${s['group']}'),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedStudentId = v),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _studentSearchController,
                    decoration: const InputDecoration(
                      hintText: 'بحث عن طالب...',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      prefixIcon: Icon(Icons.search, size: 18),
                    ),
                    onChanged: (v) =>
                        setState(() => _studentSearchQuery = v.trim()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (student == null)
            _buildEmptyState(
              icon: Icons.person,
              title: 'اختر طالباً لعرض ملفاته',
              hint: 'استخدم القائمة بالأعلى لاختيار طالب',
            )
          else if (_files.isEmpty)
            _buildEmptyState(
              icon: Icons.folder_off,
              title: 'لا توجد ملفات مطلوبة',
              hint: 'أضف ملفات من تبويب "الملفات المطلوبة" أولاً',
            )
          else ...[
            // Student info bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade400],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student['name'] as String,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          student['group'] as String,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  _buildProgressChip(
                      student['id'] as int, _files.length),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Files list with toggle switches
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12, right: 4),
                    child: Row(
                      children: const [
                        Icon(Icons.checklist, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'الملفات والتقديم',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ..._files.map((f) {
                    final completed =
                        _isCompleted(student['id'] as int, f.id);
                    return _StudentFileToggle(
                      fileName: f.name,
                      fileDescription: f.description,
                      isCompleted: completed,
                      onToggle: () =>
                          _toggleStatus(student['id'] as int, f.id),
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressChip(int studentId, int totalFiles) {
    if (totalFiles == 0) {
      return Container();
    }
    int completed = 0;
    for (final f in _files) {
      if (_isCompleted(studentId, f.id)) completed++;
    }
    final percent = (completed / totalFiles * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$completed / $totalFiles  ($percent%)',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(hint, style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  بطاقة الملف (في تبويب الملفات)
// ═══════════════════════════════════════════════════════════════════
class _FileCard extends StatelessWidget {
  final RequiredFile file;
  final void Function(RequiredFile) onEdit;
  final void Function(RequiredFile) onDelete;
  final void Function(RequiredFile) onView;

  const _FileCard({
    required this.file,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.blue.shade50, blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade400],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(Icons.description, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    file.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    overflow: TextOverflow.ellipsis,
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
                  Row(
                    children: [
                      Icon(Icons.event, size: 16, color: Colors.blue.shade700),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('yyyy/MM/dd').format(file.createdAt),
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (file.description != null && file.description!.isNotEmpty)
                    Expanded(
                      child: Text(
                        file.description!,
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade700),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  else
                    Expanded(
                      child: Text(
                        'لا يوجد وصف',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.visibility, color: Colors.blue.shade700),
                    tooltip: 'عرض التفاصيل',
                    onPressed: () => onView(file),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange.shade700),
                    tooltip: 'تعديل',
                    onPressed: () => onEdit(file),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade700),
                    tooltip: 'حذف',
                    onPressed: () => onDelete(file),
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

// ═══════════════════════════════════════════════════════════════════
//  عنصر قائمة حالة ملف لطالب (في تبويب حالة الطلاب)
// ═══════════════════════════════════════════════════════════════════
class _StudentFileToggle extends StatelessWidget {
  final String fileName;
  final String? fileDescription;
  final bool isCompleted;
  final VoidCallback onToggle;

  const _StudentFileToggle({
    required this.fileName,
    required this.fileDescription,
    required this.isCompleted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          isCompleted ? Icons.check_circle : Icons.pending_actions,
          color: isCompleted ? Colors.green.shade700 : Colors.orange.shade700,
          size: 24,
        ),
      ),
      title: Text(
        fileName,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (fileDescription != null && fileDescription!.isNotEmpty)
            Text(fileDescription!, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green.shade100 : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isCompleted ? 'مكتمل' : 'غير مكتمل',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color:
                    isCompleted ? Colors.green.shade800 : Colors.orange.shade800,
              ),
            ),
          ),
        ],
      ),
      trailing: Switch(
        value: isCompleted,
        activeThumbColor: Colors.green.shade700,
        inactiveThumbColor: Colors.orange.shade700,
        inactiveTrackColor: Colors.orange.shade100,
        onChanged: (_) => onToggle(),
      ),
    );
  }
}
