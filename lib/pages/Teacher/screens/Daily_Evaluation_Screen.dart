import 'package:flutter/material.dart';

class DailyEvaluationScreen extends StatefulWidget {
  @override
  _DailyEvaluationScreenState createState() => _DailyEvaluationScreenState();
}

class _DailyEvaluationScreenState extends State<DailyEvaluationScreen> {
  final List<String> students = [
    'أحمد',
    'محمد',
    'ليلى',
    'فاطمة',
    'ايمن',
    'جمال',
  ];
  Map<String, double> scores = {};
  Map<String, String> notes = {};
  Map<String, bool> showNotes = {};

  Color getScoreColor(double score) {
    if (score >= 4) return Colors.blue.shade700;
    if (score >= 2) return Colors.blue.shade400;
    return Colors.red.shade400;
  }

  @override
  Widget build(BuildContext context) {
    double completed =
        scores.values.where((v) => v > 0).length / students.length;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('التقييم اليومي'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top progress indicator
            LinearProgressIndicator(
              value: completed,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  String student = students[index];
                  double score = scores[student] ?? 0;
                  bool notesVisible = showNotes[student] ?? false;

                  return AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Student header with avatar
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.blue.shade300,
                                child: Text(
                                  student[0],
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  student,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(
                                score > 0 ? Icons.check_circle : Icons.pending,
                                color: score > 0 ? Colors.green : Colors.orange,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Slider with icons
                          Row(
                            children: [
                              Icon(
                                Icons.sentiment_very_dissatisfied,
                                color: Colors.red.shade400,
                              ),
                              Expanded(
                                child: Slider(
                                  value: score,
                                  min: 0,
                                  max: 5,
                                  divisions: 5,
                                  activeColor: Colors.blue.shade700,
                                  inactiveColor: Colors.grey.shade300,
                                  label: score.toString(),
                                  onChanged: (val) {
                                    setState(() {
                                      scores[student] = val;
                                    });
                                  },
                                ),
                              ),
                              Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.blue.shade700,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Expandable notes
                          if (notesVisible)
                            TextField(
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'ملاحظات',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
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
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade400],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم حفظ التقييم لجميع الطلاب')),
            );
            print('Scores: $scores');
            print('Notes: $notes');
          },
          icon: Icon(Icons.save),
          label: Text('حفظ التقييم'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
