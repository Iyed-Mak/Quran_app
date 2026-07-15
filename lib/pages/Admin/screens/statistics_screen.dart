import 'package:flutter/material.dart';
import '../widgets/statistics_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  static const _stats = [
    {
      'icon': Icons.people,
      'label': 'إجمالي الطلبة',
      'value': '148',
      'trend': '+6 هذا الشهر',
      'up': true,
      'color': Color(0xff1565C0),
    },
    {
      'icon': Icons.school,
      'label': 'إجمالي الأساتذة',
      'value': '12',
      'trend': '+1 هذا الشهر',
      'up': true,
      'color': Color(0xff2E7D32),
    },
    {
      'icon': Icons.group_work,
      'label': 'الأفواج',
      'value': '8',
      'trend': null,
      'up': null,
      'color': Color(0xffE65100),
    },
    {
      'icon': Icons.check_circle,
      'label': 'نسبة الحضور',
      'value': '94%',
      'trend': '+2% الأسبوع',
      'up': true,
      'color': Color(0xff6A1B9A),
    },
    {
      'icon': Icons.menu_book,
      'label': 'معدل الحفظ',
      'value': '87%',
      'trend': 'الفصل الثالث',
      'up': null,
      'color': Color(0xff00695C),
    },
    {
      'icon': Icons.star,
      'label': 'معدل التقييم',
      'value': '16.4',
      'trend': 'من 20',
      'up': true,
      'color': Color(0xffB71C1C),
    },
  ];

  static const _months = [
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
    'جانفي',
    'فيفري',
    'مارس',
  ];
  static const _attendance = [0.88, 0.91, 0.94, 0.89, 0.96, 0.93, 0.94];
  static const _perf = [0.80, 0.83, 0.87, 0.82, 0.88, 0.86, 0.87];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 20),
            _sectionTitle('إحصائيات عامة', Icons.bar_chart),
            const SizedBox(height: 12),
            _buildStatsGrid(context),
            const SizedBox(height: 24),
            _sectionTitle('إحصائيات الحضور الشهرية', Icons.timeline),
            const SizedBox(height: 12),
            _buildBarChart(
              context,
              'الحضور',
              _attendance,
              Colors.blue.shade600,
            ),
            const SizedBox(height: 20),
            _sectionTitle('مستوى الأداء الشهري', Icons.trending_up),
            const SizedBox(height: 12),
            _buildBarChart(context, 'الأداء', _perf, Colors.green.shade600),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _header() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xff4A148C), Color(0xffAB47BC)],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Row(
      children: [
        Icon(Icons.bar_chart, color: Colors.white, size: 32),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإحصائيات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'تقارير مرئية شاملة عن المدرسة',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildStatsGrid(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w >= 1024
        ? 3
        : w >= 600
        ? 3
        : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.8,
      ),
      itemCount: _stats.length,
      itemBuilder: (_, i) {
        final s = _stats[i];
        return StatisticsCard(
          icon: s['icon'] as IconData,
          label: s['label'] as String,
          value: s['value'] as String,
          color: s['color'] as Color,
          trend: s['trend'] as String?,
          trendUp: s['up'] as bool?,
        );
      },
    );
  }

  Widget _buildBarChart(
    BuildContext context,
    String label,
    List<double> data,
    Color color,
  ) {
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(data.length, (i) {
                final pct = data[i] / maxVal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${(data[i] * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 10,
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 80 * pct,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _months[i],
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String label, IconData icon) => Row(
    children: [
      Icon(icon, color: Colors.purple.shade800, size: 20),
      const SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.purple.shade900,
        ),
      ),
    ],
  );
}
