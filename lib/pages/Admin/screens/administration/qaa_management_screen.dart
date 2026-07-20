import 'package:flutter/material.dart';
import 'model/qaa_model.dart';

// شاشة إدارة القاعات الدراسية مع عمليات CRUD كاملة
class QaaManagementScreen extends StatefulWidget {
  const QaaManagementScreen({super.key});

  @override
  State<QaaManagementScreen> createState() => _QaaManagementScreenState();
}

class _QaaManagementScreenState extends State<QaaManagementScreen> {
  late List<Qaa> _qaas;
  int _nextId = 4; // للـ ID التلقائي
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _qaas = List.from(QaaMockData.initialQaas);
    // تحديث nextId بناءً على البيانات الموجودة
    if (_qaas.isNotEmpty) {
      _nextId = _qaas.map((q) => q.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Qaa> get _filteredQaas {
    if (_searchQuery.isEmpty) return _qaas;
    return _qaas.where((q) =>
      q.name.contains(_searchQuery) ||
      (q.description?.contains(_searchQuery) ?? false)
    ).toList();
  }

  // ── إضافة قاعة جديدة ──
  void _showAddQaaDialog() {
    final nameController = TextEditingController();
    final tablesCountController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إضافة قاعة جديدة', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nameController, 'اسم القاعة *', 'مثال: قاعة 1', Icons.meeting_room),
                  const SizedBox(height: 12),
                  _buildTextField(tablesCountController, 'عدد الطاولات *', 'مثال: 15', Icons.table_chart, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  _buildTextField(descriptionController, 'وصف / ملاحظات', 'مثال: قاعة كبرى للحفظ الجماعي', Icons.description),
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
              label: const Text('حفظ القاعة'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade700, foregroundColor: Colors.white),
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('يرجى إدخال اسم القاعة'), backgroundColor: Colors.red),
                  );
                  return;
                }
                final tablesCount = int.tryParse(tablesCountController.text.trim());
                if (tablesCount == null || tablesCount < 0) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('يرجى إدخال عدد طاولات صحيح'), backgroundColor: Colors.red),
                  );
                  return;
                }
                final newQaa = Qaa(
                  id: _nextId++,
                  name: nameController.text.trim(),
                  tablesCount: tablesCount,
                  description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                );
                setState(() => _qaas.insert(0, newQaa));
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم إضافة "${newQaa.name}" بنجاح'), backgroundColor: Colors.green),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── تعديل قاعة موجودة ──
  void _showEditQaaDialog(Qaa qaa) {
    final nameController = TextEditingController(text: qaa.name);
    final tablesCountController = TextEditingController(text: qaa.tablesCount.toString());
    final descriptionController = TextEditingController(text: qaa.description ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('تعديل "${qaa.name}"', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nameController, 'اسم القاعة *', 'مثال: قاعة 1', Icons.meeting_room),
                  const SizedBox(height: 12),
                  _buildTextField(tablesCountController, 'عدد الطاولات *', 'مثال: 15', Icons.table_chart, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  _buildTextField(descriptionController, 'وصف / ملاحظات', 'مثال: قاعة كبرى للحفظ الجماعي', Icons.description),
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
                    const SnackBar(content: Text('يرجى إدخال اسم القاعة'), backgroundColor: Colors.red),
                  );
                  return;
                }
                final tablesCount = int.tryParse(tablesCountController.text.trim());
                if (tablesCount == null || tablesCount < 0) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('يرجى إدخال عدد طاولات صحيح'), backgroundColor: Colors.red),
                  );
                  return;
                }
                final updatedQaa = qaa.copyWith(
                  name: nameController.text.trim(),
                  tablesCount: tablesCount,
                  description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                );
                setState(() {
                  final idx = _qaas.indexWhere((q) => q.id == qaa.id);
                  if (idx != -1) _qaas[idx] = updatedQaa;
                });
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم تحديث "${updatedQaa.name}" بنجاح'), backgroundColor: Colors.green),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── حذف قاعة ──
  void _confirmDeleteQaa(Qaa qaa) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف', style: TextStyle(color: Colors.red)),
        content: Text('هل تريد حقاً حذف "${qaa.name}"؟\nهذا الإجراء لا يمكن التراجع عنه.'),
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
              setState(() => _qaas.removeWhere((q) => q.id == qaa.id));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم حذف "${qaa.name}"'), backgroundColor: Colors.red),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── عرض تفاصيل القاعة ──
  void _showQaaDetails(Qaa qaa) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تفاصيل "${qaa.name}"'),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('اسم القاعة', qaa.name, Icons.meeting_room),
                _detailRow('عدد الطاولات', '${qaa.tablesCount}', Icons.table_chart),
                _detailRow('الوصف', qaa.description ?? 'لا يوجد', Icons.description),
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
        prefixIcon: Icon(icon, color: Colors.purple.shade700),
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
          Icon(icon, color: Colors.purple.shade700, size: 20),
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
          title: const Text('القاعات الدراسية'),
          backgroundColor: Colors.purple.shade700,
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
                          hintText: 'ابحث عن قاعة...',
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
                      '${_filteredQaas.length} / ${_qaas.length}',
                      style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Grid/List of Qaas ──
              if (_filteredQaas.isEmpty)
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
                        Icon(Icons.meeting_room, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'لا توجد قاعات بعد' : 'لا توجد نتائج للبحث',
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty
                              ? 'اضغط على "إضافة قاعة" للبدء'
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
                  itemCount: _filteredQaas.length,
                  itemBuilder: (_, i) => _QaaCard(
                    qaa: _filteredQaas[i],
                    onEdit: _showEditQaaDialog,
                    onDelete: _confirmDeleteQaa,
                    onView: _showQaaDetails,
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

// ── بطاقة القاعة ──
class _QaaCard extends StatelessWidget {
  final Qaa qaa;
  final void Function(Qaa) onEdit;
  final void Function(Qaa) onDelete;
  final void Function(Qaa) onView;

  const _QaaCard({
    required this.qaa,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final hasTables = qaa.tablesCount > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.purple.shade50, blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: hasTables ? [Colors.purple.shade600, Colors.purple.shade400] : [Colors.grey.shade400, Colors.grey.shade300],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Text(
                    qaa.name.replaceAll(RegExp(r'[^0-9]'), '').isEmpty
                        ? 'ق'
                        : qaa.name.replaceAll(RegExp(r'[^0-9]'), ''),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        qaa.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        hasTables ? '$qaa.tablesCount طاولة' : 'بدون طاولات',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
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
                  // عدد الطاولات
                  Row(
                    children: [
                      Icon(Icons.table_chart, size: 18, color: Colors.purple.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'الطاولات: ${qaa.tablesCount}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.purple.shade800),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: hasTables ? Colors.green.shade50 : Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hasTables ? 'جاهزة' : 'فارغة',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: hasTables ? Colors.green.shade700 : Colors.purple.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // الوصف
                  if (qaa.description != null && qaa.description!.isNotEmpty) ...[
                    Text(
                      qaa.description!,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ] else
                    Text(
                      'لا يوجد وصف',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                    ),

                  const Spacer(),
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
                    onPressed: () => onView(qaa),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange.shade700),
                    tooltip: 'تعديل',
                    onPressed: () => onEdit(qaa),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade700),
                    tooltip: 'حذف',
                    onPressed: () => onDelete(qaa),
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
