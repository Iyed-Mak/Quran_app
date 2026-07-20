import 'package:flutter/material.dart';
import 'model/maqarr_model.dart';
import 'hajar_management_screen.dart';

// ═══════════════════════════════════════════════════════════════════
// شاشة إدارة المقرات والفروع (Branches Management)
// ═══════════════════════════════════════════════════════════════════
class MaqarrManagementScreen extends StatefulWidget {
  const MaqarrManagementScreen({super.key});

  @override
  State<MaqarrManagementScreen> createState() => _MaqarrManagementScreenState();
}

class _MaqarrManagementScreenState extends State<MaqarrManagementScreen> {
  late List<Maqarr> _maqarr;
  int _nextMaqarrId = 4;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _maqarr = List.from(MaqarrStore.initialMaqarr);
    if (_maqarr.isNotEmpty) {
      _nextMaqarrId = _maqarr.map((m) => m.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Maqarr> get _filteredMaqarr {
    if (_searchQuery.isEmpty) return _maqarr;
    final q = _searchQuery;
    return _maqarr.where((m) =>
      m.name.contains(q) ||
      (m.address?.contains(q) ?? false) ||
      (m.phone?.contains(q) ?? false) ||
      (m.description?.contains(q) ?? false)
    ).toList();
  }

  // ── إضافة مقر جديد ──
  void _showAddMaqarrDialog() {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إضافة مقر جديد', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'اسم المقر *', 'مثال: المقر الرئيسي، فرع الشمال', Icons.location_city),
                const SizedBox(height: 12),
                _buildTextField(addressController, 'العنوان', 'مثال: شارع الملك فهد، الرياض', Icons.map),
                const SizedBox(height: 12),
                _buildTextField(phoneController, 'الهاتف', 'مثال: 011-1234567', Icons.phone, keyboardType: TextInputType.phone),
                const SizedBox(height: 12),
                _buildTextField(descController, 'وصف / ملاحظات', 'مثال: المبنى الرئيسي للإدارة', Icons.description),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('حفظ المقر'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade700, foregroundColor: Colors.white),
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('يرجى إدخال اسم المقر'), backgroundColor: Colors.red),
                );
                return;
              }
              final newMaqarr = Maqarr(
                id: _nextMaqarrId++,
                name: nameController.text.trim(),
                address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
                phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                description: descController.text.trim().isEmpty ? null : descController.text.trim(),
              );
              setState(() => _maqarr.insert(0, newMaqarr));
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم إضافة "${newMaqarr.name}" بنجاح'), backgroundColor: Colors.green),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── تعديل مقر ──
  void _showEditMaqarrDialog(Maqarr maqarr) {
    final nameController = TextEditingController(text: maqarr.name);
    final addressController = TextEditingController(text: maqarr.address ?? '');
    final phoneController = TextEditingController(text: maqarr.phone ?? '');
    final descController = TextEditingController(text: maqarr.description ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('تعديل "${maqarr.name}"', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'اسم المقر *', 'مثال: المقر الرئيسي، فرع الشمال', Icons.location_city),
                const SizedBox(height: 12),
                _buildTextField(addressController, 'العنوان', 'مثال: شارع الملك فهد، الرياض', Icons.map),
                const SizedBox(height: 12),
                _buildTextField(phoneController, 'الهاتف', 'مثال: 011-1234567', Icons.phone, keyboardType: TextInputType.phone),
                const SizedBox(height: 12),
                _buildTextField(descController, 'وصف / ملاحظات', 'مثال: المبنى الرئيسي للإدارة', Icons.description),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('حفظ التعديلات'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700, foregroundColor: Colors.white),
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('يرجى إدخال اسم المقر'), backgroundColor: Colors.red),
                );
                return;
              }
              final updated = maqarr.copyWith(
                name: nameController.text.trim(),
                address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
                phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                description: descController.text.trim().isEmpty ? null : descController.text.trim(),
              );
              setState(() {
                final idx = _maqarr.indexWhere((m) => m.id == maqarr.id);
                if (idx != -1) _maqarr[idx] = updated;
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

  // ── حذف مقر ──
  void _confirmDeleteMaqarr(Maqarr maqarr) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف', style: TextStyle(color: Colors.red)),
        content: Text('هل تريد حقاً حذف "${maqarr.name}"؟\nسيتم حذف جميع الحجر التابعة لهذا المقر أيضاً.\nهذا الإجراء لا يمكن التراجع عنه.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('حذف'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                _maqarr.removeWhere((m) => m.id == maqarr.id);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم حذف "${maqarr.name}"'), backgroundColor: Colors.red),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── عرض تفاصيل المقر ──
  void _showMaqarrDetails(Maqarr maqarr) {
    final roomsCount = MaqarrStore.initialHajar.where((h) => h.maqarrId == maqarr.id).length;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تفاصيل "${maqarr.name}"'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('اسم المقر', maqarr.name, Icons.location_city),
              _detailRow('العنوان', maqarr.address ?? 'غير محدد', Icons.map),
              _detailRow('الهاتف', maqarr.phone ?? 'غير محدد', Icons.phone),
              _detailRow('عدد الحجر', '$roomsCount', Icons.meeting_room),
              _detailRow('الوصف', maqarr.description ?? 'لا يوجد', Icons.description),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إغلاق')),
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
          title: const Text('المقرات و فروع المدرسة'),
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
              // ── Action Bar ──
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة مقر'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: _showAddMaqarrDialog,
                  ),
                  const Spacer(),
                  Text('${_maqarr.length} مقر',
                      style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),

              // ── Search ──
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
                          hintText: 'ابحث عن مقر...',
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
                    Text('${_filteredMaqarr.length} / ${_maqarr.length}',
                        style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Grid/List of Maqarr ──
              if (_filteredMaqarr.isEmpty)
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
                        Icon(Icons.location_city, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'لا توجد مقرات بعد' : 'لا توجد نتائج للبحث',
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty ? 'اضغط على "إضافة مقر" للبدء' : 'جرب كلمات بحث أخرى',
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
                  itemCount: _filteredMaqarr.length,
                  itemBuilder: (_, i) => _MaqarrCard(
                    maqarr: _filteredMaqarr[i],
                    onEdit: _showEditMaqarrDialog,
                    onDelete: _confirmDeleteMaqarr,
                    onView: _showMaqarrDetails,
                    onOpenRooms: (m) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HajarManagementScreen(maqarr: m)),
                    ),
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
// بطاقة المقر
// ═══════════════════════════════════════════════════════════════════
class _MaqarrCard extends StatelessWidget {
  final Maqarr maqarr;
  final void Function(Maqarr) onEdit;
  final void Function(Maqarr) onDelete;
  final void Function(Maqarr) onView;
  final void Function(Maqarr) onOpenRooms;

  const _MaqarrCard({
    required this.maqarr,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
    required this.onOpenRooms,
  });

  @override
  Widget build(BuildContext context) {
    final roomsCount = MaqarrStore.initialHajar.where((h) => h.maqarrId == maqarr.id).length;

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
              gradient: LinearGradient(
                colors: [Colors.teal.shade600, Colors.teal.shade400],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(Icons.location_city, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maqarr.name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$roomsCount حجر',
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
                  if (maqarr.address != null && maqarr.address!.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.map, size: 16, color: Colors.teal.shade700),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            maqarr.address!,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (maqarr.phone != null && maqarr.phone!.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16, color: Colors.teal.shade700),
                        const SizedBox(width: 6),
                        Text(
                          maqarr.phone!,
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$roomsCount ${roomsCount == 1 ? 'حجر' : 'حجر'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
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
                    onPressed: () => onView(maqarr),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.meeting_room, color: Colors.teal.shade700),
                    tooltip: 'الحجر (الغرف)',
                    onPressed: () => onOpenRooms(maqarr),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange.shade700),
                    tooltip: 'تعديل',
                    onPressed: () => onEdit(maqarr),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade700),
                    tooltip: 'حذف',
                    onPressed: () => onDelete(maqarr),
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