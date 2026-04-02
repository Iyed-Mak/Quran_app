import 'package:flutter/material.dart';

import '../models/student_mock_data.dart';

/// وحدة الجداول — مواعيد الاختبارات والتنبيهات.
class ExamScheduleScreen extends StatelessWidget {
  const ExamScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exams = mockScheduledExams;

    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('جدول الاختبارات', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'مواعيد الاختبارات القادمة مع تنبيه عند اقتراب موعد.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ...exams.map((e) => _ExamTile(exam: e)),
        ],
    );
  }
}

class _ExamTile extends StatelessWidget {
  const _ExamTile({required this.exam});

  final ScheduledExam exam;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final urgent = exam.isWithinDays(2);
    final soon = exam.isWithinDays(7);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: urgent
          ? theme.colorScheme.errorContainer.withValues(alpha: 0.35)
          : null,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.event_note, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(exam.subject, style: theme.textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(exam.title),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    scheduleFormat.format(exam.start),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('${exam.room} · ${_relativeLabel(exam)}'),
            if (urgent || soon) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (urgent)
                    Chip(
                      avatar: Icon(
                        Icons.notifications_active,
                        size: 18,
                        color: theme.colorScheme.error,
                      ),
                      label: const Text('تنبيه: موعد قريب'),
                      visualDensity: VisualDensity.compact,
                    )
                  else if (soon)
                    Chip(
                      avatar: Icon(
                        Icons.notifications_none,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      label: const Text('خلال أسبوع'),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _relativeLabel(ScheduledExam exam) {
    final now = DateTime.now();
    final d = exam.start.difference(now);
    if (d.isNegative) return 'انتهى';
    final days = d.inDays;
    final hours = d.inHours % 24;
    if (days > 0) return 'بعد $days يوم تقريبًا';
    if (hours > 0) return 'بعد حوالي $hours ساعة';
    return 'خلال ساعات';
  }
}
