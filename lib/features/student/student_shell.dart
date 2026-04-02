import 'package:flutter/material.dart';

import 'screens/exam_results_screen.dart';
import 'screens/exam_schedule_screen.dart';
import 'screens/grade_reports_screen.dart';
import 'screens/personal_record_screen.dart';
import 'screens/progress_indicators_screen.dart';

/// شريط تنقل الطالب للوحدات الخمس حسب الجدول المعطى.
class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _index = 0;

  static const _titles = [
    'سجل الطالب',
    'مؤشرات التقدم',
    'النتائج',
    'كشوف النقاط',
    'جدول الاختبارات',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_index]),
        ),
        body: IndexedStack(
          index: _index,
          children: const [
            PersonalRecordScreen(),
            ProgressIndicatorsScreen(),
            ExamResultsScreen(),
            GradeReportsScreen(),
            ExamScheduleScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.badge_outlined),
              selectedIcon: Icon(Icons.badge),
              label: 'السجل',
            ),
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights),
              label: 'المؤشرات',
            ),
            NavigationDestination(
              icon: Icon(Icons.fact_check_outlined),
              selectedIcon: Icon(Icons.fact_check),
              label: 'النتائج',
            ),
            NavigationDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon: Icon(Icons.list_alt),
              label: 'النقاط',
            ),
            NavigationDestination(
              icon: Icon(Icons.event_outlined),
              selectedIcon: Icon(Icons.event),
              label: 'الجدول',
            ),
          ],
        ),
      ),
    );
  }
}
