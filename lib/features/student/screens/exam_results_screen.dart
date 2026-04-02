import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/student_mock_data.dart';

/// وحدة النتائج — عرض نتائج الاختبارات وتحليل الأداء.
class ExamResultsScreen extends StatelessWidget {
  const ExamResultsScreen({super.key});

  static final _dateFmt = DateFormat('yyyy/MM/dd', 'ar');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('نتائج الامتحانات', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'عرض درجاتك ونسبة الأداء مع ملخص تحليلي لكل اختبار.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ...mockExamResults.map((e) => _ResultCard(item: e, dateFmt: _dateFmt)),
        ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.item, required this.dateFmt});

  final ExamResultItem item;
  final DateFormat dateFmt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = item.percentage;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showAnalysis(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.subject,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text('${pct.toStringAsFixed(0)}%'),
                    avatar: Icon(
                      pct >= 80
                          ? Icons.sentiment_satisfied_alt
                          : Icons.sentiment_neutral,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(item.examTitle, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text(
                dateFmt.format(item.date),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: pct / 100,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.score.toStringAsFixed(1)} / ${item.maxScore.toStringAsFixed(1)}',
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'اضغط لعرض التحليل',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.insights,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAnalysis(BuildContext context) {
    final theme = Theme.of(context);
    final text = item.analysisHint ??
        'لا يوجد تحليل مفصل لهذا الاختبار في العرض التجريبي.';

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('تحليل الأداء', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('${item.subject} — ${item.examTitle}'),
              const SizedBox(height: 16),
              Text(text, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
