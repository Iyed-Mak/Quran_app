import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/student_mock_data.dart';

/// وحدة كشوف النقاط — تفصيل النقاط لكل اختبار.
class GradeReportsScreen extends StatelessWidget {
  const GradeReportsScreen({super.key});

  static final _dateFmt = DateFormat('yyyy/MM/dd', 'ar');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('كشوف النقاط', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'تفصيل النقاط حسب أجزاء الاختبار لكل مادة.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ...mockGradeReports.map((r) => _ReportTile(report: r, dateFmt: _dateFmt)),
        ],
    );
  }
}

class _ReportTile extends StatefulWidget {
  const _ReportTile({required this.report, required this.dateFmt});

  final GradeReportItem report;
  final DateFormat dateFmt;

  @override
  State<_ReportTile> createState() => _ReportTileState();
}

class _ReportTileState extends State<_ReportTile> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = widget.report;
    final totalGot = r.breakdown.fold<double>(0, (s, b) => s + b.points);
    final totalMax = r.breakdown.fold<double>(0, (s, b) => s + b.maxPoints);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            onTap: () => setState(() => _expanded = !_expanded),
            title: Text(r.subject, style: theme.textTheme.titleMedium),
            subtitle: Text(
              '${widget.dateFmt.format(r.date)} · ${r.examTitle}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${totalGot.toStringAsFixed(1)} / ${totalMax.toStringAsFixed(1)}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: r.breakdown.map((b) {
                  final ratio = b.maxPoints == 0 ? 0.0 : b.points / b.maxPoints;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(b.label)),
                            Text(
                              '${b.points.toStringAsFixed(1)} / ${b.maxPoints.toStringAsFixed(1)}',
                              style: theme.textTheme.labelLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: ratio.clamp(0.0, 1.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
