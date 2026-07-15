import 'package:flutter/material.dart';
import '../../widgets/dashboard_card.dart';
import './pages/lists_students_screen.dart';
import './pages/monthly_student_screen.dart';
import './pages/exam_schedual_screen.dart';
import './pages/exam_results_screen.dart';

class StudentManagementScreen extends StatelessWidget {
  const StudentManagementScreen({super.key});

  static const _cards = [
    {
      'icon': Icons.list_alt,
      'title': 'قائمة الطلاب',
      'desc': 'عرض وإدارة جميع الطلاب',
      'start': Color(0xff1565C0),
      'end': Color(0xff42A5F5),
    },
    {
      'icon': Icons.trending_up,
      'title': 'التقييم الشهري',
      'desc': 'متابعة مستوى الطلاب وتقدمهم',
      'start': Color(0xffE65100),
      'end': Color(0xffFFA726),
    },
    {
      'icon': Icons.fact_check,
      'title': 'تاريخ الامتحانات',
      'desc': 'عمل جدول الامتحانات',
      'start': Color(0xff2E7D32),
      'end': Color(0xff66BB6A),
    },
    {
      'icon': Icons.assignment,
      'title': 'نتائج الامتحانات',
      'desc': 'تأكيد نتائج الامتحانات',
      'start': Color(0xff6A1B9A),
      'end': Color(0xffAB47BC),
    },
    // {
    //   'icon': Icons.grading,
    //   'title': 'نتائج التقييمات',
    //   'desc': 'عرض نتائج الامتحانات الدورية',
    //   'start': Color(0xff00695C),
    //   'end': Color(0xff26A69A),
    // },
  ];

  static const _students = [
    {'name': 'أحمد', 'group': 'فوج 1', 'hizb': '40', 'attendance': '96%'},
    {'name': 'محمد', 'group': 'فوج 1', 'hizb': '29', 'attendance': '100%'},
    {'name': 'ليلى', 'group': 'فوج 1', 'hizb': '28', 'attendance': '88%'},
    {'name': 'فاطمة', 'group': 'فوج 2', 'hizb': '15', 'attendance': '92%'},
    {'name': 'خالد', 'group': 'فوج 2', 'hizb': '12', 'attendance': '95%'},
  ];

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
            _sectionTitle('الإجراءات', Icons.manage_accounts),
            const SizedBox(height: 12),
            _buildGrid(context),
            const SizedBox(height: 24),
            _sectionTitle('قائمة أفضل 5 طلاب', Icons.people),
            const SizedBox(height: 12),
            _buildStudentList(),
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
        colors: [Color(0xffE65100), Color(0xffFFA726)],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Row(
      children: [
        Icon(Icons.people, color: Colors.white, size: 32),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'متابعة الطلبة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'إدارة الطلاب، الحضور، التقدم والتقييمات',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildGrid(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w >= 1024
        ? 4
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
        childAspectRatio: w >= 1024
            ? 1.16
            : w >= 600
            ? 1.08
            : 1.02,
      ),
      itemCount: _cards.length,
      itemBuilder: (_, i) {
        final c = _cards[i];
        return DashboardCard(
          icon: c['icon'] as IconData,
          title: c['title'] as String,
          description: c['desc'] as String,
          gradientStart: c['start'] as Color,
          gradientEnd: c['end'] as Color,
          onTap: () {
            if (c['title'] == 'قائمة الطلاب') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentListScreen()),
              );
            } else if (c['title'] == 'التقييم الشهري') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MonthlySummaryScreen()),
              );
            } else if (c['title'] == 'تاريخ الامتحانات') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExamScheduleManagementScreen(),
                ),
              );
            } else if (c['title'] == 'نتائج الامتحانات') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExamResultsScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم الضغط على "${c['title']}"')),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildStudentList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.orange.shade50, blurRadius: 8)],
      ),
      child: Column(
        children: _students.asMap().entries.map((e) {
          final s = e.value;
          final isLast = e.key == _students.length - 1;
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.shade600,
                  child: Text(
                    s['name']![0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  s['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${s['group']} — الحزب ${s['hizb']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    s['attendance']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              if (!isLast) Divider(height: 1, color: Colors.grey.shade100),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _sectionTitle(String label, IconData icon) => Row(
    children: [
      Icon(icon, color: Colors.orange.shade800, size: 20),
      const SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.orange.shade900,
        ),
      ),
    ],
  );
}
