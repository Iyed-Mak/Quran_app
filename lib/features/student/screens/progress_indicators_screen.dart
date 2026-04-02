import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/student_mock_data.dart';

/// وحدة متابعة الأداء — أداء يومي/شهري مع رسوم بيانية.
class ProgressIndicatorsScreen extends StatefulWidget {
  const ProgressIndicatorsScreen({super.key});

  @override
  State<ProgressIndicatorsScreen> createState() =>
      _ProgressIndicatorsScreenState();
}

class _ProgressIndicatorsScreenState extends State<ProgressIndicatorsScreen> {
  bool _monthly = false;

  List<double> get _scores => _monthly ? mockMonthlyScores : mockDailyScores;

  double get _average {
    if (_scores.isEmpty) return 0;
    return _scores.reduce((a, b) => a + b) / _scores.length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('مؤشرات التقدم', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'مقارنة أدائك اليومي أو الشهري مع متوسط بسيط ورسوم بيانية.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment<bool>(
                value: false,
                label: Text('يومي'),
                icon: Icon(Icons.today_outlined),
              ),
              ButtonSegment<bool>(
                value: true,
                label: Text('شهري'),
                icon: Icon(Icons.calendar_month_outlined),
              ),
            ],
            selected: {_monthly},
            onSelectionChanged: (s) {
              setState(() => _monthly = s.first);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'المتوسط',
                  value: _average.toStringAsFixed(1),
                  subtitle: 'من 100',
                  icon: Icons.analytics_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: 'عدد النقاط',
                  value: '${_scores.length}',
                  subtitle: _monthly ? 'أشهر' : 'أيام',
                  icon: Icons.show_chart,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('المنحنى', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 240,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 100,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (v) => FlLine(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          interval: 20,
                          getTitlesWidget: (v, m) => Text(
                            v.toInt().toString(),
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (v, m) {
                            final i = v.toInt();
                            if (i < 0 || i >= _scores.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '${i + 1}',
                                style: theme.textTheme.labelSmall,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        left: BorderSide(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        color: primary,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                        spots: [
                          for (var i = 0; i < _scores.length; i++)
                            FlSpot(i.toDouble(), _scores[i]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(value, style: theme.textTheme.headlineSmall),
            Text(subtitle, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
