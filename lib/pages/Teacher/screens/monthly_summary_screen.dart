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
    _scrollController.dispose();
    super.dispose();
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

    return Scaffold(
      // KEY FIX: let Scaffold resize when keyboard appears
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF4F8FB),
      appBar: AppBar(
        title: Text(
          "ملخص التقييم الشهري للحلقة",
          style: TextStyle(fontSize: isTablet ? 22 : (isSmall ? 15 : 18)),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        toolbarHeight: isTablet ? 64 : kToolbarHeight,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          // ── Average Card ────────────────────────────────────────────
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

          // ── Report Input ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: hPadding),
              padding: EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(cardRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "تقرير الحلقة الشهري",
                    style: TextStyle(
                      fontSize: sectionTitleSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: isSmall ? 8 : 12),
                  TextField(
                    controller: reportController,
                    maxLines: isTablet ? 6 : 5,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: isSmall ? 13 : 15),
                    decoration: InputDecoration(
                      hintText: " ...اكتب تقريرك الشهري عن مستوى الحلقة هنا",
                      hintStyle: TextStyle(fontSize: isSmall ? 12 : 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isSmall ? 10 : 14,
                        vertical: isSmall ? 8 : 12,
                      ),
                    ),
                  ),
                  SizedBox(height: isSmall ? 10 : 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: sendReport,
                      icon: Icon(Icons.send, size: isSmall ? 16 : 20),
                      label: Text(
                        "إرسال التقرير",
                        style: TextStyle(fontSize: isSmall ? 13 : 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: EdgeInsets.symmetric(
                          vertical: isSmall ? 10 : 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: isSmall ? 10 : 16)),

          // ── Section Title ────────────────────────────────────────────
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

          // ── Students List ────────────────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              // Add bottom padding after last item
              final bool isLast = index == students.length - 1;
              final student = students[index];
              final int score = student["score"];

              return Container(
                margin: EdgeInsets.fromLTRB(
                  hPadding,
                  cardVMargin,
                  hPadding,
                  isLast ? hPadding + cardVMargin : cardVMargin,
                ),
                padding: EdgeInsets.all(cardPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(cardRadius),
                ),
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
                              fontSize: isSmall ? 11 : (isTablet ? 16 : 13),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: isSmall ? 8 : 12),
                        Expanded(
                          child: Text(
                            student["name"],
                            style: TextStyle(
                              fontSize: studentNameSize,
                              fontWeight: FontWeight.w600,
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
              );
            }, childCount: students.length),
          ),
        ],
      ),
    );
  }
}
