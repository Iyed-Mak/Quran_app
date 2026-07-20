import 'package:flutter/material.dart';
import 'model/maqarr_model.dart';

// ═══════════════════════════════════════════════════════════════════
// شاشة إدارة الحجر (Rooms Management) داخل مقر معين
// ═══════════════════════════════════════════════════════════════════
class HajarManagementScreen extends StatefulWidget {
  final Maqarr maqarr;

  const HajarManagementScreen({super.key, required this.maqarr});

  @override
  State<HajarManagementScreen> createState() => _HajarManagementScreenState();
}

class _HajarManagementScreenState extends State<HajarManagementScreen> {
  late List<Hajar> _hajar;
  int _nextHajarId = 100;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _hajar = List.from(MaqarrStore.initialHajar.where((h) => h.maqarrId == widget.maqarr.id));
    if (_hajar.isNotEmpty) {
      _nextHajarId = _hajar.map((h) => h.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // الحصول على الرقم التلقائي التالي للحجر في هذا المقر
  int _nextHajarNumber() {
    int maxNum = 0;
    for (final h in _hajar) {
      final match = RegExp(r'(\d+)').firstMatch(h.name);
      if (match != null) {
        final num = int.parse(match.group(1)!);
        if (num > maxNum) maxNum = num;
      }
    }
    return maxNum + 1;
  }

  String _autoHajarName() => 'حجر ${_nextHajarNumber()}';

  List<Hajar> get _filteredHajar {
    if (_searchQuery.isEmpty) return _hajar;
    final q = _searchQuery;
    return _hajar.where((h) =>
      h.name.contains(q) ||
      (h.description?.contains(q) ?? false)
    ).toList();
  }

  // ── إضافة حجر جديد ──
  void _showAddHajarDialog() {
    final tablesController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إضافة حجر جديد', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الاسم التلقائي
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.teal.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _autoHajarName(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(tablesController, 'عدد الطاولات *', 'مثال: 15', Icons.table_chart, keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                _buildTextField(descController, 'وصف / ملاحظات', 'مثال: قاعة كبرى - حفظ', Icons.description),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('حفظ الحجر'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade700, foregroundColor: Colors.white),
            onPressed: () {
              final tables = int.tryParse(tablesController.text.trim());
              if (tables == null || tables < 0) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('يرجى إدخال عدد طاولات صحيح'), backgroundColor: Colors.red),
                );
                return;
              }
              final name = _autoHajarName();
              final newHajar = Hajar(
                id: _nextHajarId++,
                maqarrId: widget.maqarr.id,
                name: name,
                tablesCount: tables,
                description: descController.text.trim().isEmpty ? null : descController.text.trim(),
              );
              setState(() => _hajar.insert(0, newHajar));
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم إضافة "$name" بنجاح'), backgroundColor: Colors.green),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── تعديل حجر ──
  void _showEditHajarDialog(Hajar hajar) {
    final tablesController = TextEditingController(text: hajar.tablesCount.toString());
    final descController = TextEditingController(text: hajar.description ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('تعديل "${hajar.name}"', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(tablesController, 'عدد الطاولات *', 'مثال: 15', Icons.table_chart, keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField(descController, 'وصف / ملاحظات', 'مثال: قاعة كبرى - حفظ', Icons.description),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('حفظ التعديلات'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700, foregroundColor: Colors.white),
            onPressed: () {
              final tables = int.tryParse(tablesController.text.trim());
              if (tables == null || tables < 0) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('يرجى إدخال عدد طاولات صحيح'), backgroundColor: Colors.red),
                );
                return;
              }
              final updated = hajar.copyWith(
                tablesCount: tables,
                description: descController.text.trim().isEmpty ? null : descController.text.trim(),
              );
              setState(() {
                final idx = _hajar.indexWhere((h) => h.id == hajar.id);
                if (idx != -1) _hajar[idx] = updated;
              });
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم تحديث "${updated.name}" بنجاح'), backgroundColor: Colors.green),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── حذف حجر ──
  void _confirmDeleteHajar(Hajar hajar) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف', style: TextStyle(color: Colors.red)),
        content: Text('هل تريد حقاً حذف "${hajar.name}"؟\nهذا الإجراء لا يمكن التراجع عنه.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('حذف'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              setState(() => _hajar.removeWhere((h) => h.id == hajar.id));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم حذف "${hajar.name}"'), backgroundColor: Colors.red),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── عرض تفاصيل ──
  void _showHajarDetails(Hajar hajar) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تفاصيل "${hajar.name}"'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('اسم الحجر', hajar.name, Icons.meeting_room),
              _detailRow('المقر', widget.maqarr.name, Icons.location_city),
              _detailRow('عدد الطاولات', '${hajar.tablesCount}', Icons.table_chart),
              _detailRow('الوصف', hajar.description ?? 'لا يوجد', Icons.description),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إغلاق'))],
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
        prefixIcon: Icon(icon, color: Colors.teal.shade700),
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
          Icon(icon, color: Colors.teal.shade700, size: 20),
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
          title: Text('الحجر - ${widget.maqarr.name}'),
          backgroundColor: Colors.teal.shade700,
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
              // Action Bar
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة حجر'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: _showAddHajarDialog,
                  ),
                  const Spacer(),
                  Text('${_hajar.length} حجر',
                      style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
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
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'ابحث عن حجر...',
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
                    Text('${_filteredHajar.length} / ${_hajar.length}',
                        style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Grid of Hajar
              if (_filteredHajar.isEmpty)
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
                          _searchQuery.isEmpty ? 'لا توجد حجر بعد' : 'لا توجد نتائج للبحث',
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty ? 'اضغط على "إضافة حجر" للبدء' : 'جرب كلمات بحث أخرى',
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
                    childAspectRatio: w >= 900 ? 1.15 : 1.05,
                  ),
                  itemCount: _filteredHajar.length,
                  itemBuilder: (_, i) => _HajarCard(
                    hajar: _filteredHajar[i],
                    onEdit: _showEditHajarDialog,
                    onDelete: _confirmDeleteHajar,
                    onView: _showHajarDetails,
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

// ═══════════════════════════════════════════════════════════════════
// بطاقة الحجر
// ═══════════════════════════════════════════════════════════════════
class _HajarCard extends StatelessWidget {
  final Hajar hajar;
  final void Function(Hajar) onEdit;
  final void Function(Hajar) onDelete;
  final void Function(Hajar) onView;

  const _HajarCard({
    required this.hajar,
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
          BoxShadow(color: Colors.teal.shade50, blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: Colors.teal.shade100),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.teal.shade600, Colors.teal.shade400]),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(Icons.meeting_room, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hajar.name,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text('حجر', style: TextStyle(color: Colors.white70, fontSize: 12)),
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
                  Row(
                    children: [
                      Icon(Icons.table_chart, size: 18, color: Colors.teal.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'الطاولات: ${hajar.tablesCount}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.teal.shade800),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: hajar.tablesCount > 0 ? Colors.green.shade50 : Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hajar.tablesCount > 0 ? 'مُجهزة' : 'فارغة',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: hajar.tablesCount > 0 ? Colors.green.shade700 : Colors.teal.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (hajar.description != null && hajar.description!.isNotEmpty)
                    Expanded(
                      child: Text(
                        hajar.description!,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  else
                    Expanded(
                      child: Text(
                        'لا يوجد وصف',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
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
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.visibility, color: Colors.blue.shade700),
                    tooltip: 'عرض التفاصيل',
                    onPressed: () => onView(hajar),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange.shade700),
                    tooltip: 'تعديل',
                    onPressed: () => onEdit(hajar),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade700),
                    tooltip: 'حذف',
                    onPressed: () => onDelete(hajar),
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