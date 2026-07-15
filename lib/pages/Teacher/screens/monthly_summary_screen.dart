import 'package:flutter/material.dart';

class MonthlySummaryScreen extends StatefulWidget {
  const MonthlySummaryScreen({super.key});

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen> {
  String selectedGroup = 'فوج 1';
  final List<String> groups = ['فوج 1', 'فوج 2'];

  final Map<String, List<Map<String, dynamic>>> groupStudents = {
    'فوج 1': [
      {"name": "أحمد", "score": 5},
      {"name": "محمد", "score": 88},
      {"name": "ليلى", "score": 56},
      {"name": "فاطمة", "score": 100},
      {"name": "يوسف", "score": 84},
      {"name": "سارة", "score": 72},
    ],
    'فوج 2': [
      {"name": "خالد", "score": 91},
      {"name": "نور", "score": 65},
      {"name": "ريم", "score": 78},
      {"name": "عمر", "score": 45},
      {"name": "هند", "score": 88},
      {"name": "بلال", "score": 55},
    ],
  };

  // ── Mock session records per student per group ──────────────────────────
  // Each record: { date, attendance, memorization, revision, score }
  final Map<String, Map<String, List<Map<String, dynamic>>>>
  groupSessionRecords = {
    'فوج 1': {
      'أحمد': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '18',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'نصف',
          'score': '15',
        },
        {
          'date': '10/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '17',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزبين',
          'score': '19',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
      ],
      'محمد': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '14',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '16',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'نصف',
          'score': '15',
        },
        {
          'date': '15/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '17',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزبين',
          'score': '18',
        },
      ],
      'ليلى': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'لاشي',
          'revision': 'حزب',
          'score': '10',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'نصف',
          'score': '12',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'ربع',
          'score': '13',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'حزب',
          'score': '11',
        },
        {
          'date': '20/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '14',
        },
      ],
      'فاطمة': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '19',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '19',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
      ],
      'يوسف': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '16',
        },
        {
          'date': '05/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '17',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '15',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '18',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '19',
        },
      ],
      'سارة': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '13',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '14',
        },
        {
          'date': '10/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '12',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '15',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '16',
        },
      ],
    },
    'فوج 2': {
      'خالد': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '19',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '18',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '25/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
      ],
      'نور': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '12',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '13',
        },
        {
          'date': '10/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'حزب',
          'score': '14',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '13',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '15',
        },
      ],
      'ريم': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '16',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'نصف',
          'score': '15',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '16',
        },
        {
          'date': '15/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزبين',
          'score': '17',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '18',
        },
      ],
      'عمر': [
        {
          'date': '01/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'لاشي',
          'revision': 'ثمن',
          'score': '8',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '10',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '11',
        },
        {
          'date': '20/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '9',
        },
      ],
      'هند': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '18',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '19',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '17',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '20/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '18',
        },
      ],
      'بلال': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '11',
        },
        {
          'date': '05/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '12',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '10',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '13',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '12',
        },
      ],
    },
  };

  List<Map<String, dynamic>> get students => groupStudents[selectedGroup]!;

  // ── Maps an Arabic memorization/revision label to a fraction of a حزب ──
  double _labelToHizbValue(String label) {
    switch (label) {
      case 'لاشي':
        return 0;
      case 'ثمن':
        return 0.125;
      case 'ربع':
        return 0.25;
      case 'نصف':
        return 0.5;
      case 'حزب':
        return 1;
      case 'حزبين':
        return 2;
      default: // '—' (absent / no value)
        return 0;
    }
  }

  // ── Formats a total hizb value back into Arabic text (e.g. "2 حزب ونصف") ──
  String _formatHizbTotal(double total) {
    if (total <= 0) return 'لاشي';

    final int whole = total.floor();
    final double fraction = total - whole;

    String fractionLabel = '';
    if (fraction >= 0.875) {
      // Rounds up to next whole حزب
      return '${whole + 1} حزب';
    } else if (fraction >= 0.375) {
      fractionLabel = 'ونصف';
    } else if (fraction >= 0.1875) {
      fractionLabel = 'وربع';
    } else if (fraction >= 0.0625) {
      fractionLabel = 'وثمن';
    }

    if (whole == 0) {
      // Less than a full حزب
      if (fraction >= 0.375) return 'نصف حزب';
      if (fraction >= 0.1875) return 'ربع حزب';
      if (fraction >= 0.0625) return 'ثمن حزب';
      return 'لاشي';
    }

    return fractionLabel.isEmpty ? '$whole حزب' : '$whole حزب $fractionLabel';
  }

  // ── Computes group-wide monthly totals directly from session records ──
  List<Map<String, dynamic>> get groupMonthlyTotals {
    final sessionsForGroup = groupSessionRecords[selectedGroup] ?? {};
    final result = <Map<String, dynamic>>[];

    for (final student in students) {
      final name = student['name'] as String;
      final records = sessionsForGroup[name] ?? [];

      int absences = 0;
      double memorizationTotal = 0;
      double revisionTotal = 0;
      int scoreSum = 0;
      int scoredSessions = 0;

      for (final record in records) {
        if (record['attendance'] == 'غائب') {
          absences++;
          continue;
        }
        memorizationTotal += _labelToHizbValue(
          record['memorization'] as String,
        );
        revisionTotal += _labelToHizbValue(record['revision'] as String);

        final scoreVal = int.tryParse(record['score'].toString());
        if (scoreVal != null) {
          scoreSum += scoreVal;
          scoredSessions++;
        }
      }

      final average = scoredSessions > 0 ? (scoreSum / scoredSessions) : 0.0;

      result.add({
        'name': name,
        'absences': absences,
        'totalMemorization': _formatHizbTotal(memorizationTotal),
        'totalRevision': _formatHizbTotal(revisionTotal),
        'average': average.toStringAsFixed(1),
      });
    }

    return result;
  }

  // Which student's table is expanded (null = none)
  String? expandedStudent;

  final Map<String, TextEditingController> reportControllers = {
    'فوج 1': TextEditingController(),
    'فوج 2': TextEditingController(),
  };

  final ScrollController _scrollController = ScrollController();

  double get averageScore {
    double total = students.fold(0, (sum, item) => sum + item["score"]);
    return total / students.length;
  }

  Color getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 75) return Colors.orange;
    return Colors.red;
  }

  Color _sessionScoreColor(String score) {
    final v = int.tryParse(score);
    if (v == null) return Colors.grey.shade400;
    if (v >= 16) return Colors.green;
    if (v >= 10) return Colors.orange;
    return Colors.red;
  }

  void sendReport() {
    final controller = reportControllers[selectedGroup]!;
    String report = controller.text.trim();

    if (report.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى كتابة تقرير الحلقة أولاً")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("تم إرسال تقرير الحلقة بنجاح - $selectedGroup")),
    );

    controller.clear();
  }

  @override
  void dispose() {
    reportControllers.forEach((_, c) => c.dispose());
    _scrollController.dispose();
    super.dispose();
  }

  // ── Session records table for a student ───────────────────────────────
  Widget _buildSessionTable(String studentName, bool isSmall, bool isTablet) {
    final records = groupSessionRecords[selectedGroup]?[studentName] ?? [];

    final double labelSize = isTablet ? 13.0 : (isSmall ? 11.0 : 12.0);
    final double cellSize = isTablet ? 14.0 : (isSmall ? 12.0 : 13.0);

    // Column header style
    TextStyle headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: labelSize,
      color: Colors.blue.shade800,
    );

    TextStyle cellStyle = TextStyle(fontSize: cellSize, color: Colors.black87);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 340),
          child: Table(
            border: TableBorder(
              horizontalInside: BorderSide(
                color: Colors.blue.shade50,
                width: 1,
              ),
              bottom: BorderSide(color: Colors.blue.shade100, width: 0.5),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FixedColumnWidth(100), // تاريخ الحلقة
              1: FixedColumnWidth(72), // الحضور
              2: FixedColumnWidth(140), // التقدم
              3: FixedColumnWidth(70), // التقييم
            },
            children: [
              // Header row
              TableRow(
                decoration: BoxDecoration(color: Colors.blue.shade50),
                children: [
                  _tableCell('تاريخ الحلقة', headerStyle, isHeader: true),
                  _tableCell('الحضور', headerStyle, isHeader: true),
                  _tableCell('التقدم', headerStyle, isHeader: true),
                  _tableCell('التقييم', headerStyle, isHeader: true),
                ],
              ),
              // Data rows
              ...records.asMap().entries.map((entry) {
                final i = entry.key;
                final record = entry.value;
                final isAbsent = record['attendance'] == 'غائب';
                final rowBg = i.isEven
                    ? Colors.white
                    : Colors.blue.shade50.withValues(alpha: 0.4);

                // Progress column combines memorization + revision

                return TableRow(
                  decoration: BoxDecoration(color: rowBg),
                  children: [
                    // Date
                    _tableCell(record['date']!, cellStyle),

                    // Attendance chip
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isAbsent
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isAbsent
                                  ? Colors.red.shade200
                                  : Colors.green.shade200,
                            ),
                          ),
                          child: Text(
                            record['attendance']!,
                            style: TextStyle(
                              fontSize: labelSize,
                              fontWeight: FontWeight.w600,
                              color: isAbsent
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Progress (memorization + revision)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      child: isAbsent
                          ? Center(
                              child: Text(
                                '—',
                                style: cellStyle.copyWith(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _progressChip(
                                  'ح: ${record["memorization"]}',
                                  Colors.blue.shade700,
                                  Colors.blue.shade50,
                                  Colors.blue.shade200,
                                  labelSize,
                                ),
                                const SizedBox(height: 3),
                                _progressChip(
                                  'م: ${record["revision"]}',
                                  Colors.indigo.shade700,
                                  Colors.indigo.shade50,
                                  Colors.indigo.shade100,
                                  labelSize,
                                ),
                              ],
                            ),
                    ),

                    // Score
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      child: Center(
                        child: isAbsent
                            ? Text(
                                '—',
                                style: cellStyle.copyWith(
                                  color: Colors.grey.shade400,
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _sessionScoreColor(
                                    record['score']!,
                                  ).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _sessionScoreColor(
                                      record['score']!,
                                    ).withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Text(
                                  '${record["score"]}/20',
                                  style: TextStyle(
                                    fontSize: labelSize,
                                    fontWeight: FontWeight.bold,
                                    color: _sessionScoreColor(record['score']!),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ── Group-wide monthly totals table (one row per student) ─────────────
  Widget _buildMonthlyTotalsTable(bool isSmall, bool isTablet) {
    final totals = groupMonthlyTotals;

    final double labelSize = isTablet ? 13.0 : (isSmall ? 11.0 : 12.0);
    final double cellSize = isTablet ? 14.0 : (isSmall ? 12.0 : 13.0);

    TextStyle headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: labelSize,
      color: Colors.blue.shade800,
    );

    TextStyle cellStyle = TextStyle(fontSize: cellSize, color: Colors.black87);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 410),
          child: Table(
            border: TableBorder(
              horizontalInside: BorderSide(
                color: Colors.blue.shade50,
                width: 1,
              ),
              bottom: BorderSide(color: Colors.blue.shade100, width: 0.5),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FixedColumnWidth(110), // اسم الطالب
              1: FixedColumnWidth(100), // عدد الغيابات
              2: FixedColumnWidth(140), // التقدم الإجمالي
              3: FixedColumnWidth(90), // متوسط التقييم
            },
            children: [
              // Header row
              TableRow(
                decoration: BoxDecoration(color: Colors.blue.shade50),
                children: [
                  _tableCell('اسم الطالب', headerStyle, isHeader: true),
                  _tableCell(
                    'عدد الغيابات في الشهر',
                    headerStyle,
                    isHeader: true,
                  ),
                  _tableCell(
                    'التقدم الإجمالي في الشهر',
                    headerStyle,
                    isHeader: true,
                  ),
                  _tableCell(
                    'متوسط التقييم في الشهر',
                    headerStyle,
                    isHeader: true,
                  ),
                ],
              ),
              // Data rows
              ...totals.asMap().entries.map((entry) {
                final i = entry.key;
                final row = entry.value;
                final rowBg = i.isEven
                    ? Colors.white
                    : Colors.blue.shade50.withValues(alpha: 0.4);
                final avgScore =
                    double.tryParse(row['average'].toString()) ?? 0;

                return TableRow(
                  decoration: BoxDecoration(color: rowBg),
                  children: [
                    // Student name
                    _tableCell(
                      row['name']!,
                      cellStyle.copyWith(fontWeight: FontWeight.w600),
                    ),

                    // Absences count
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: row['absences'] == 0
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: row['absences'] == 0
                                  ? Colors.green.shade200
                                  : Colors.red.shade200,
                            ),
                          ),
                          child: Text(
                            '${row["absences"]}',
                            style: TextStyle(
                              fontSize: labelSize,
                              fontWeight: FontWeight.w600,
                              color: row['absences'] == 0
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Total progress (memorization + revision, stacked)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _progressChip(
                            'الحفظ: ${row["totalMemorization"]}',
                            Colors.blue.shade700,
                            Colors.blue.shade50,
                            Colors.blue.shade200,
                            labelSize,
                          ),
                          const SizedBox(height: 4),
                          _progressChip(
                            'المراجعة: ${row["totalRevision"]}',
                            Colors.indigo.shade700,
                            Colors.indigo.shade50,
                            Colors.indigo.shade100,
                            labelSize,
                          ),
                        ],
                      ),
                    ),

                    // Average score
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _sessionScoreColor(
                              avgScore.round().toString(),
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _sessionScoreColor(
                                avgScore.round().toString(),
                              ).withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            '${row["average"]}/20',
                            style: TextStyle(
                              fontSize: labelSize,
                              fontWeight: FontWeight.bold,
                              color: _sessionScoreColor(
                                avgScore.round().toString(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tableCell(String text, TextStyle style, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isHeader ? 10 : 7, horizontal: 8),
      child: Text(text, style: style, textAlign: TextAlign.right),
    );
  }

  Widget _progressChip(
    String label,
    Color textColor,
    Color bg,
    Color border,
    double fontSize,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;
    final isTablet = screenWidth >= 600;

    final double hPadding = isTablet ? 32.0 : (isSmall ? 10.0 : 16.0);
    final double cardRadius = isTablet ? 24.0 : 18.0;
    final double avgFontSize = isTablet ? 52.0 : (isSmall ? 34.0 : 42.0);
    final double avgLabelSize = isTablet ? 24.0 : (isSmall ? 16.0 : 20.0);
    final double sectionTitleSize = isTablet ? 22.0 : (isSmall ? 15.0 : 18.0);
    final double studentNameSize = isTablet ? 20.0 : (isSmall ? 15.0 : 18.0);
    final double avatarRadius = isTablet ? 28.0 : (isSmall ? 20.0 : 24.0);
    final double progressHeight = isTablet ? 10.0 : 8.0;
    final double cardVMargin = isTablet ? 10.0 : 8.0;
    final double cardPadding = isTablet ? 20.0 : (isSmall ? 12.0 : 16.0);
    final double topCardPaddingV = isTablet ? 28.0 : (isSmall ? 14.0 : 20.0);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xffF4F8FB),
        appBar: AppBar(
          title: Text(
            "ملخص التقييم الشهري للحلقة",
            style: TextStyle(
              fontSize: isTablet ? 22 : (isSmall ? 15 : 18),
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue.shade800,
          toolbarHeight: isTablet ? 64 : kToolbarHeight,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            // ── Group Selector ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPadding, hPadding, hPadding, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(cardRadius),
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
                                  fontSize: isSmall ? 14 : 16,
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
                          expandedStudent = null;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),

            // ── Average Card ──
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(hPadding),
                padding: EdgeInsets.symmetric(
                  horizontal: hPadding,
                  vertical: topCardPaddingV,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(cardRadius + 2),
                ),
                child: Column(
                  children: [
                    Text(
                      "متوسط تقييم الحلقة",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: avgLabelSize,
                      ),
                    ),
                    SizedBox(height: isSmall ? 6 : 10),
                    Text(
                      averageScore.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: avgFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Section Title ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "أداء الطلاب خلال الشهر",
                    style: TextStyle(
                      fontSize: sectionTitleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: isSmall ? 6 : 10)),

            // ── Students List + expandable session table ──
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final bool isLast = index == students.length - 1;
                final student = students[index];
                final int score = student["score"];
                final String name = student["name"];
                final bool expanded = expandedStudent == name;

                return Container(
                  margin: EdgeInsets.fromLTRB(
                    hPadding,
                    cardVMargin,
                    hPadding,
                    isLast ? hPadding + cardVMargin : cardVMargin,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(cardRadius),
                    boxShadow: expanded
                        ? [
                            BoxShadow(
                              color: Colors.blue.shade100,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    children: [
                      // ── Student summary row ──
                      Padding(
                        padding: EdgeInsets.all(cardPadding),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: avatarRadius,
                                  backgroundColor: getScoreColor(score),
                                  child: Text(
                                    score.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isSmall
                                          ? 11
                                          : (isTablet ? 16 : 13),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: isSmall ? 8 : 12),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: studentNameSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // Toggle button
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      expandedStudent = expanded ? null : name;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: expanded
                                          ? Colors.blue.shade700
                                          : Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.blue.shade200,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          expanded ? 'إخفاء' : 'السجل',
                                          style: TextStyle(
                                            fontSize: isSmall ? 11 : 12,
                                            fontWeight: FontWeight.bold,
                                            color: expanded
                                                ? Colors.white
                                                : Colors.blue.shade700,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          expanded
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          size: 16,
                                          color: expanded
                                              ? Colors.white
                                              : Colors.blue.shade700,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isSmall ? 8 : 12),
                            LinearProgressIndicator(
                              value: score / 100,
                              minHeight: progressHeight,
                              backgroundColor: Colors.grey.shade300,
                              color: getScoreColor(score),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ],
                        ),
                      ),

                      // ── Expandable session records table ──
                      if (expanded) ...[
                        Divider(
                          height: 1,
                          color: Colors.blue.shade100,
                          thickness: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            cardPadding,
                            12,
                            cardPadding,
                            cardPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Table section header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'سجل الحلقات الشهرية',
                                    style: TextStyle(
                                      fontSize: isSmall ? 13 : 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.table_chart_outlined,
                                    size: 16,
                                    color: Colors.blue.shade700,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Legend row
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 4,
                                  children: [
                                    _legendItem(
                                      'ح: الحفظ',
                                      Colors.blue.shade700,
                                      Colors.blue.shade50,
                                      Colors.blue.shade200,
                                      isSmall,
                                    ),
                                    _legendItem(
                                      'م: المراجعة',
                                      Colors.indigo.shade700,
                                      Colors.indigo.shade50,
                                      Colors.indigo.shade100,
                                      isSmall,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Table
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blue.shade100,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: _buildSessionTable(
                                    name,
                                    isSmall,
                                    isTablet,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }, childCount: students.length),
            ),

            SliverToBoxAdapter(child: SizedBox(height: isSmall ? 16 : 22)),

            // ── Monthly Totals Summary Table Section ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "الملخص الإجمالي الشهري للحلقة",
                    style: TextStyle(
                      fontSize: sectionTitleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: isSmall ? 6 : 10)),

            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.fromLTRB(hPadding, 0, hPadding, hPadding),
                padding: EdgeInsets.all(cardPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(cardRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'إحصائيات $selectedGroup خلال الشهر',
                          style: TextStyle(
                            fontSize: isSmall ? 13 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.summarize_outlined,
                          size: 16,
                          color: Colors.blue.shade700,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue.shade100,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _buildMonthlyTotalsTable(isSmall, isTablet),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(
    String label,
    Color text,
    Color bg,
    Color border,
    bool isSmall,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: isSmall ? 11 : 12,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }
}
