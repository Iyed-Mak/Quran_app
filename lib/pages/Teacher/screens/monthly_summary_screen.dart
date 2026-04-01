import 'package:flutter/material.dart';

class MonthlySummaryScreen extends StatefulWidget {
  const MonthlySummaryScreen({super.key});

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen> {
  final List<Map<String, dynamic>> students = [
    {"name": "أحمد", "score": 5},
    {"name": "محمد", "score": 88},
    {"name": "ليلى", "score": 56},
    {"name": "فاطمة", "score": 100},
    {"name": "يوسف", "score": 84},
    {"name": "ليلى", "score": 56},
    {"name": "فاطمة", "score": 100},
    {"name": "يوسف", "score": 84},
  ];

  final TextEditingController reportController = TextEditingController();

  double get averageScore {
    double total = students.fold(0, (sum, item) => sum + item["score"]);
    return total / students.length;
  }

  Color getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 75) return Colors.orange;
    return Colors.red;
  }

  void sendReport() {
    String report = reportController.text.trim();

    if (report.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى كتابة تقرير الحلقة أولاً")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تم إرسال تقرير الحلقة بنجاح")),
    );

    reportController.clear();
  }

  @override
  void dispose() {
    reportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F8FB),
      appBar: AppBar(
        title: const Text("ملخص التقييم الشهري للحلقة"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
      ),
      body: Column(
        children: [
          // Average Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  "متوسط تقييم الحلقة",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  averageScore.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Report Input
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "تقرير الحلقة الشهري",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: reportController,
                  maxLines: 5,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: " ...اكتب تقريرك الشهري عن مستوى الحلقة هنا",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: sendReport,
                    icon: const Icon(Icons.send),
                    label: const Text("إرسال التقرير"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Students Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "أداء الطلاب خلال الشهر",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Students List
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final int score = student["score"];

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: getScoreColor(score),
                            child: Text(
                              score.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              student["name"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: score / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        color: getScoreColor(score),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
