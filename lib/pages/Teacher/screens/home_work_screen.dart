// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:quran_app/utils/date_formatter.dart';
import 'package:quran_app/utils/date_widget.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  String selectedGroup = 'فوج 1';
  final List<String> groups = ['فوج 1', 'فوج 2'];

  final Map<String, List<String>> groupStudents = {
    'فوج 1': ['أحمد', 'محمد', 'ليلى', 'فاطمة', 'أيمن', 'جمال'],
    'فوج 2': ['خالد', 'نور', 'ريم', 'عمر', 'هند', 'بلال'],
  };

  List<String> get students => groupStudents[selectedGroup]!;

  final Map<String, TextEditingController> homeworkControllers = {};
  final Map<String, TextEditingController> notesControllers = {};
  final Map<String, DateTime?> dueDates = {};
  final Map<String, bool> showNotes = {};

  TextEditingController _homeworkControllerFor(String student) {
    return homeworkControllers.putIfAbsent(
      student,
      () => TextEditingController(),
    );
  }

  TextEditingController _notesControllerFor(String student) {
    return notesControllers.putIfAbsent(student, () => TextEditingController());
  }

  void _clearGroupState() {
    for (final c in homeworkControllers.values) c.dispose();
    for (final c in notesControllers.values) c.dispose();
    homeworkControllers.clear();
    notesControllers.clear();
    dueDates.clear();
    showNotes.clear();
  }

  @override
  void dispose() {
    for (final c in homeworkControllers.values) c.dispose();
    for (final c in notesControllers.values) c.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) => formatDzDate(date);

  // ── منتقي تاريخ التسليم ──────────────────────────────────────────
  // إصلاح 1: استبدال firstDate/lastDate بـ minYear/maxYear
  // إصلاح 2: حفظ النتيجة في dueDates[student] وليس في متغير now المحلي
  Future<void> _pickDueDate(String student) async {
    final now = DateTime.now();

    final DateTime? picked = await showDzDatePicker(
      context: context,
      initialDate: dueDates[student] ?? now,
      minYear: now.year - 1, // يسمح باختيار من السنة الماضية
      maxYear: now.year + 2, // حتى سنتين قادمتين
      primaryColor: Colors.indigo.shade700,
      endColor: Colors.indigo.shade200,
    );

    if (picked != null) {
      setState(() => dueDates[student] = picked); // ✅ الإصلاح الرئيسي
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignedCount = students
        .where((s) => (homeworkControllers[s]?.text.trim().isNotEmpty ?? false))
        .length;
    final double completed = students.isEmpty
        ? 0
        : assignedCount / students.length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xfff5f5ff),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AppBar(
              title: const Text(
                'الواجب المنزلي',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.indigo.shade700,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ── Group Selector ──
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.indigo.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.shade50,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedGroup,
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down_circle,
                          color: Colors.indigo.shade700,
                        ),
                        items: groups.map((group) {
                          return DropdownMenuItem(
                            value: group,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  group,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.indigo.shade800,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.group,
                                  color: Colors.indigo.shade700,
                                  size: 20,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGroup = value!;
                            _clearGroupState();
                          });
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── Progress Card ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.shade100,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.assignment_turned_in,
                            color: Colors.indigo.shade700,
                          ),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text(
                              'نسبة تكليف الطلاب بالواجب',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          Text('${(completed * 100).toInt()}%'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: completed,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(20),
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation(
                          Colors.indigo.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ── Students List ──
                Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final homeworkController = _homeworkControllerFor(
                        student,
                      );
                      _notesControllerFor(student);
                      final dueDate = dueDates[student];
                      final hasHomework = homeworkController.text
                          .trim()
                          .isNotEmpty;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.indigo.shade50],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.shade100,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Student Header ──
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: Colors.indigo.shade700,
                                    child: Text(
                                      student[0],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      student,
                                      style: const TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    hasHomework
                                        ? Icons.check_circle
                                        : Icons.pending_actions,
                                    color: hasHomework
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              // ── الواجب المنزلي ──
                              const Text(
                                'الواجب المنزلي',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: homeworkController,
                                maxLines: 2,
                                textAlign: TextAlign.right,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: 'أدخل الواجب المطلوب من الطالب',
                                  prefixIcon: const Icon(
                                    Icons.menu_book_outlined,
                                  ),
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Colors.indigo.shade100,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Colors.indigo.shade700,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ── تاريخ التسليم ──
                              const Text(
                                'تاريخ التسليم',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => _pickDueDate(student),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: dueDate != null
                                          ? Colors.indigo.shade300
                                          : Colors.indigo.shade100,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: Colors.indigo.shade700,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          dueDate != null
                                              ? _formatDate(dueDate)
                                              : 'اختر تاريخ التسليم',
                                          style: TextStyle(
                                            color: dueDate != null
                                                ? Colors.black87
                                                : Colors.grey.shade500,
                                            fontWeight: dueDate != null
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      // مؤشر مرئي بعد الاختيار
                                      if (dueDate != null)
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.indigo.shade400,
                                          size: 18,
                                        )
                                      else
                                        Icon(
                                          Icons.arrow_drop_down_circle,
                                          color: Colors.indigo.shade700,
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.indigo.shade700,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم حفظ الواجبات المنزلية بنجاح - $selectedGroup',
                ),
              ),
            );
          },
          icon: const Icon(Icons.save),
          label: const Text('حفظ الواجبات'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
