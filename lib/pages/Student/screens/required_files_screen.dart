import 'package:flutter/material.dart';
import '../../Admin/screens/administration/model/required_file_model.dart';

// ═══════════════════════════════════════════════════════════════════
//  شاشة "الملفات المطلوبة" كما يراها الطالب
//  يعرض الملفات العامة مع الحالة الخاصة بالطالب المسجّل دخوله
// ═══════════════════════════════════════════════════════════════════
class StudentRequiredFilesScreen extends StatefulWidget {
  final String studentName;

  const StudentRequiredFilesScreen({super.key, required this.studentName});

  @override
  State<StudentRequiredFilesScreen> createState() =>
      _StudentRequiredFilesScreenState();
}

class _StudentRequiredFilesScreenState
    extends State<StudentRequiredFilesScreen> {
  late List<RequiredFile> _files;
  late Map<String, bool> _statuses;
  late int _studentId;

  // معرّف الطالب الافتراضي للعرض التوضيحي (يوسف أمين)
  // في النسخة الكاملة سيُستبدل بمعرف الطالب المستخرج من جلسة الدخول
  static const int _defaultStudentId = 1;

  @override
  void initState() {
    super.initState();
    _files = List.from(RequiredFilesStore.initialFiles);
    _statuses = Map.from(RequiredFilesStore.initialStatuses);
    _studentId = _defaultStudentId;
  }

  String _key(int studentId, int fileId) => '$studentId-$fileId';

  bool _isCompleted(int fileId) {
    return _statuses[_key(_studentId, fileId)] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w >= 1200 ? 4 : w >= 900 ? 3 : w >= 600 ? 2 : 1;

    final completedCount = _files.where((f) => _isCompleted(f.id)).length;
    final total = _files.length;
    final percent = total == 0 ? 0 : (completedCount / total * 100).round();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xfff5f9ff),
        appBar: AppBar(
          title: const Text('الملفات المطلوبة'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header / Welcome ──
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade400],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.folder_open, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مرحباً ${widget.studentName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'الملفات التي يجب عليك إحضارها',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$completedCount / $total',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Progress bar ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.blue.shade50, blurRadius: 8),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'تقدّمك في إحضار الملفات',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$percent%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: percent == 100
                                ? Colors.green.shade700
                                : Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: total == 0 ? 0 : completedCount / total,
                        minHeight: 10,
                        backgroundColor: Colors.blue.shade50,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          percent == 100
                              ? Colors.green.shade600
                              : Colors.blue.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Files Grid ──
              if (_files.isEmpty)
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
                        Icon(Icons.folder_off,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد ملفات مطلوبة حالياً',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'عند إدارة المدرسة ملفات مطلوبة ستظهر هنا',
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
                  itemCount: _files.length,
                  itemBuilder: (_, i) {
                    final file = _files[i];
                    final completed = _isCompleted(file.id);
                    return _StudentFileGridCard(
                      fileName: file.name,
                      description: file.description,
                      isCompleted: completed,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  بطاقة الملف كما يراها الطالب (شبكة البطاقات الزرقاء)
// ═══════════════════════════════════════════════════════════════════
class _StudentFileGridCard extends StatelessWidget {
  final String fileName;
  final String? description;
  final bool isCompleted;

  const _StudentFileGridCard({
    required this.fileName,
    required this.description,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isCompleted
                ? Colors.green.shade50
                : Colors.blue.shade50,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isCompleted
              ? Colors.green.shade100
              : Colors.blue.shade100,
        ),
      ),
      child: Column(
        children: [
          // Header gradient — أخضر للمكتمل وأزرق لغير المكتمل
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCompleted
                    ? [Colors.green.shade600, Colors.green.shade400]
                    : [Colors.blue.shade600, Colors.blue.shade400],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Icon(
                    isCompleted ? Icons.check_circle : Icons.description,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    fileName,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (description != null && description!.isNotEmpty)
                    Text(
                      description!,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    Text(
                      'لا يوجد وصف',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          fontStyle: FontStyle.italic),
                    ),
                  const Spacer(),
                  // Status badge
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isCompleted
                            ? Colors.green.shade200
                            : Colors.orange.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isCompleted
                              ? Icons.check_circle
                              : Icons.pending_actions,
                          size: 18,
                          color: isCompleted
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isCompleted ? 'مكتمل' : 'غير مكتمل',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? Colors.green.shade800
                                : Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
