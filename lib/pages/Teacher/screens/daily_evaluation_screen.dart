import 'package:flutter/material.dart';

class DailyEvaluationScreen extends StatefulWidget {
  const DailyEvaluationScreen({super.key});

  @override
  State<DailyEvaluationScreen> createState() => _DailyEvaluationScreenState();
}

class _DailyEvaluationScreenState extends State<DailyEvaluationScreen> {
  final List<String> students = [
    'أحمد',
    'محمد',
    'ليلى',
    'فاطمة',
    'أيمن',
    'جمال',
  ];

  final List<String> memorizationOptions = ['ثمن', 'ربع', 'نصف', 'حزب'];

  final List<int> hizbList = List.generate(60, (index) => index + 1);

  Map<String, double> scores = {};
  Map<String, String> notes = {};
  Map<String, bool> showNotes = {};
  Map<String, String> memorizationAmount = {};
  Map<String, String> revisionAmount = {};
  Map<String, int> currentHizb = {
    'أحمد': 40,
    'محمد': 29,
    'ليلى': 28,
    'فاطمة': 27,
    'أيمن': 26,
    'جمال': 25,
  };
  Map<String, int> hizbReached = {};

  @override
  Widget build(BuildContext context) {
    double completed =
        scores.values.where((v) => v > 0).length / students.length;

    return Scaffold(
      backgroundColor: const Color(0xfff5f9ff),
      appBar: AppBar(
        title: const Text(
          'التقييم اليومي للحلقة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.analytics, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'نسبة إكمال التقييم',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
                    valueColor: AlwaysStoppedAnimation(Colors.blue.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  final score = scores[student] ?? 0;
                  final notesVisible = showNotes[student] ?? false;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.blue.shade50],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100,
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
                          // Student Header
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.blue.shade700,
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
                                score > 0
                                    ? Icons.check_circle
                                    : Icons.pending_actions,
                                color: score > 0 ? Colors.green : Colors.orange,
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Score Slider
                          const Text(
                            'مستوى الأداء',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Slider(
                            value: score,
                            min: 0,
                            max: 5,
                            divisions: 5,
                            label: score.toString(),
                            activeColor: Colors.blue.shade700,
                            onChanged: (val) {
                              setState(() {
                                scores[student] = val;
                              });
                            },
                          ),

                          const SizedBox(height: 12),

                          // Memorization amount
                          const Text(
                            'كمية الحفظ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            children: memorizationOptions.map((option) {
                              bool selected =
                                  memorizationAmount[student] == option;
                              return ChoiceChip(
                                label: Text(option),
                                selected: selected,
                                selectedColor: Colors.blue.shade200,
                                onSelected: (_) {
                                  setState(() {
                                    memorizationAmount[student] = option;
                                  });
                                },
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 16),

                          // Revision amount
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'كمية المراجعة في الحصة',
                              prefixIcon: const Icon(Icons.menu_book),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onChanged: (val) {
                              revisionAmount[student] = val;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Hizb reached
                          const Text(
                            'الحزب الذي وصل إليه الطالب',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.blue.shade100),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value:
                                    hizbReached[student] ??
                                    currentHizb[student],
                                isExpanded: true,
                                hint: const Text('اختر الحزب'),
                                icon: Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.blue.shade700,
                                ),
                                items: hizbList.map((hizb) {
                                  return DropdownMenuItem(
                                    value: hizb,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.menu_book,
                                          color: Colors.blue.shade700,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Text('الحزب $hizb'),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    hizbReached[student] = value!;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Notes
                          if (notesVisible)
                            TextField(
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'ملاحظات إضافية',
                                prefixIcon: const Icon(Icons.edit_note),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              onChanged: (val) {
                                notes[student] = val;
                              },
                            ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  showNotes[student] = !notesVisible;
                                });
                              },
                              icon: Icon(
                                notesVisible
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Colors.blue.shade700,
                              ),
                              label: Text(
                                notesVisible
                                    ? 'إخفاء الملاحظات'
                                    : 'إضافة ملاحظة',
                                style: TextStyle(color: Colors.blue.shade700),
                              ),
                            ),
                          ),
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

      // Save Button
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue.shade700,
        onPressed: () {
          // Update current Hizb for each student
          for (var student in students) {
            if (hizbReached[student] != null) {
              currentHizb[student] = hizbReached[student]!;
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ تقييم الحلقة بنجاح')),
          );
        },
        icon: const Icon(Icons.save),
        label: const Text('حفظ التقييم'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
