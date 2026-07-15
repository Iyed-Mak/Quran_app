import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DailyEvaluationScreen extends StatefulWidget {
  const DailyEvaluationScreen({super.key});

  @override
  State<DailyEvaluationScreen> createState() => _DailyEvaluationScreenState();
}

class _DailyEvaluationScreenState extends State<DailyEvaluationScreen> {
  String selectedGroup = 'فوج 1';
  final List<String> groups = ['فوج 1', 'فوج 2'];

  final Map<String, List<String>> groupStudents = {
    'فوج 1': ['أحمد', 'محمد', 'ليلى', 'فاطمة', 'أيمن', 'جمال'],
    'فوج 2': ['خالد', 'نور', 'ريم', 'عمر', 'هند', 'بلال'],
  };

  List<String> get students => groupStudents[selectedGroup]!;

  // Memorization options — includes لاشي
  final List<String> memorizationOptions = ['لاشي', 'ثمن', 'ربع', 'نصف', 'حزب'];

  // Revision options — same structure as memorization + حزبين
  final List<String> revisionOptions = [
    'لاشي',
    'ثمن',
    'ربع',
    'نصف',
    'حزب',
    'حزبين',
  ];

  final List<int> hizbList = List.generate(60, (index) => index + 1);

  // Score is now 0–20 (int)
  Map<String, int> scores = {};
  Map<String, String> notes = {};
  Map<String, bool> showNotes = {};
  Map<String, String> memorizationAmount = {};
  Map<String, String> revisionAmount = {};

  // TextEditingControllers for direct score input
  final Map<String, TextEditingController> scoreControllers = {};

  final Map<String, Map<String, int>> groupCurrentHizb = {
    'فوج 1': {
      'أحمد': 40,
      'محمد': 29,
      'ليلى': 28,
      'فاطمة': 27,
      'أيمن': 26,
      'جمال': 25,
    },
    'فوج 2': {'خالد': 15, 'نور': 12, 'ريم': 10, 'عمر': 8, 'هند': 6, 'بلال': 4},
  };

  Map<String, int> hizbReached = {};

  Map<String, int> get currentHizb => groupCurrentHizb[selectedGroup]!;

  TextEditingController _controllerFor(String student) {
    return scoreControllers.putIfAbsent(
      student,
      () => TextEditingController(text: scores[student]?.toString() ?? ''),
    );
  }

  void _clearGroupState() {
    scores.clear();
    hizbReached.clear();
    memorizationAmount.clear();
    revisionAmount.clear();
    showNotes.clear();
    notes.clear();
    for (final c in scoreControllers.values) {
      c.dispose();
    }
    scoreControllers.clear();
  }

  @override
  void dispose() {
    for (final c in scoreControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Color _scoreColor(int score) {
    if (score >= 16) return Colors.green;
    if (score >= 10) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final evaluatedCount = students.where((s) => (scores[s] ?? 0) > 0).length;
    double completed = students.isEmpty ? 0 : evaluatedCount / students.length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xfff5f9ff),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AppBar(
              title: const Text(
                'التقييم اليومي للحلقة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.blue.shade700,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ── Group Selector (forced LTR) ──
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
                    border: Border.all(color: Colors.blue.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade50,
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
                        color: Colors.blue.shade700,
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
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.group,
                                color: Colors.blue.shade700,
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
                    final controller = _controllerFor(student);

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
                            // ── Student Header ──
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
                                  color: score > 0
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // ── مستوى الأداء — score out of 20 ──
                            Row(
                              children: [
                                const Text(
                                  'مستوى الأداء',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                // Live score badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: score > 0
                                        ? _scoreColor(
                                            score,
                                          ).withValues(alpha: 0.12)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: score > 0
                                          ? _scoreColor(score)
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    '$score / 20',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: score > 0
                                          ? _scoreColor(score)
                                          : Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                // Decrement button
                                _ScoreButton(
                                  icon: Icons.remove,
                                  color: Colors.blue.shade700,
                                  onPressed: score > 0
                                      ? () {
                                          final v = score - 1;
                                          setState(() {
                                            scores[student] = v;
                                            controller.text = v.toString();
                                          });
                                        }
                                      : null,
                                ),

                                // Slider
                                Expanded(
                                  child: Slider(
                                    value: score.toDouble(),
                                    min: 0,
                                    max: 20,
                                    divisions: 20,
                                    label: score.toString(),
                                    activeColor: score > 0
                                        ? _scoreColor(score)
                                        : Colors.grey,
                                    onChanged: (val) {
                                      final v = val.round();
                                      setState(() {
                                        scores[student] = v;
                                        controller.text = v.toString();
                                      });
                                    },
                                  ),
                                ),

                                // Increment button
                                _ScoreButton(
                                  icon: Icons.add,
                                  color: Colors.blue.shade700,
                                  onPressed: score < 20
                                      ? () {
                                          final v = score + 1;
                                          setState(() {
                                            scores[student] = v;
                                            controller.text = v.toString();
                                          });
                                        }
                                      : null,
                                ),

                                const SizedBox(width: 8),

                                // Direct numeric input
                                SizedBox(
                                  width: 56,
                                  child: TextField(
                                    controller: controller,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      _MaxValueFormatter(20),
                                    ],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade800,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 10,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.blue.shade200,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.blue.shade700,
                                          width: 1.5,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    onChanged: (val) {
                                      final parsed = int.tryParse(val);
                                      setState(() {
                                        scores[student] =
                                            (parsed != null &&
                                                parsed >= 0 &&
                                                parsed <= 20)
                                            ? parsed
                                            : 0;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // ── كمية الحفظ (with لاشي) ──
                            const Text(
                              'كمية الحفظ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: memorizationOptions.map((option) {
                                final bool selected =
                                    memorizationAmount[student] == option;
                                return ChoiceChip(
                                  label: Text(option),
                                  selected: selected,
                                  selectedColor: Colors.blue.shade200,
                                  onSelected: (_) {
                                    setState(
                                      () =>
                                          memorizationAmount[student] = option,
                                    );
                                  },
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 16),

                            // ── كمية المراجعة (chip structure, with حزبين) ──
                            const Text(
                              'كمية المراجعة في الحصة',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: revisionOptions.map((option) {
                                final bool selected =
                                    revisionAmount[student] == option;
                                return ChoiceChip(
                                  label: Text(option),
                                  selected: selected,
                                  selectedColor: Colors.blue.shade200,
                                  onSelected: (_) {
                                    setState(
                                      () => revisionAmount[student] = option,
                                    );
                                  },
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 16),

                            // ── Hizb reached ──
                            const Text(
                              'الحزب الذي وصل إليه الطالب',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
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
                                    setState(
                                      () => hizbReached[student] = value!,
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // ── Notes ──
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
                                onChanged: (val) => notes[student] = val,
                              ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(
                                    () => showNotes[student] = !notesVisible,
                                  );
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

        // ── Save Button ──
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blue.shade700,
          onPressed: () {
            for (var student in students) {
              if (hizbReached[student] != null) {
                groupCurrentHizb[selectedGroup]![student] =
                    hizbReached[student]!;
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم حفظ تقييم الحلقة بنجاح - $selectedGroup'),
              ),
            );
          },
          icon: const Icon(Icons.save),
          label: const Text('حفظ التقييم'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

// ── +/- icon button ──
class _ScoreButton extends StatelessWidget {
  const _ScoreButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final active = onPressed != null;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? color : Colors.grey.shade300),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? color : Colors.grey.shade400,
        ),
      ),
    );
  }
}

// ── Caps text input at maxValue ──
class _MaxValueFormatter extends TextInputFormatter {
  _MaxValueFormatter(this.maxValue);
  final int maxValue;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final parsed = int.tryParse(newValue.text);
    if (parsed == null || parsed > maxValue) return oldValue;
    return newValue;
  }
}
