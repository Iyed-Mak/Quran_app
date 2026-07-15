import 'package:flutter/material.dart';
import '../../widgets/dashboard_card.dart';
import './pages/teacher_list_screen.dart';
import './pages/teacher_attendance_screen.dart';

class TeacherManagementScreen extends StatelessWidget {
  const TeacherManagementScreen({super.key});

  static const _cards = [
    {
      'icon': Icons.list,
      'title': 'قائمة الأساتذة',
      'desc': 'عرض جميع الأساتذة المسجلين',
      'start': Color(0xff1565C0),
      'end': Color(0xff42A5F5),
    },
    {
      'icon': Icons.fact_check,
      'title': 'سجل الحضور',
      'desc': 'متابعة حضور وغياب الأساتذة',
      'start': Color(0xff2E7D32),
      'end': Color(0xff66BB6A),
    },
    // {
    //   'icon': Icons.insights,
    //   'title': 'تقييم الأداء',
    //   'desc': 'تقارير الأداء والإنجاز',
    //   'start': Color(0xffE65100),
    //   'end': Color(0xffFFA726),
    // },
    // {
    //   'icon': Icons.group_work,
    //   'title': 'الأفواج المسندة',
    //   'desc': 'الأفواج المخصصة لكل أستاذ',
    //   'start': Color(0xff6A1B9A),
    //   'end': Color(0xffAB47BC),
    // },
  ];

  static const _teachers = [
    {
      'name': 'الأستاذ عبد الرحمن',
      'groups': 'فوج 1، فوج 2',
      'attendance': '95%',
      'status': 'نشط',
    },
    {
      'name': 'الأستاذة مريم',
      'groups': 'فوج 3',
      'attendance': '98%',
      'status': 'نشط',
    },
    {
      'name': 'الأستاذ يوسف',
      'groups': 'فوج 4، فوج 5',
      'attendance': '88%',
      'status': 'نشط',
    },
    {
      'name': 'الأستاذة سارة',
      'groups': 'فوج 6',
      'attendance': '100%',
      'status': 'نشط',
    },
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
            _sectionTitle('قائمة الأساتذة', Icons.people),
            const SizedBox(height: 12),
            _buildTeacherList(),
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
        colors: [Color(0xff1B5E20), Color(0xff43A047)],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Row(
      children: [
        Icon(Icons.school, color: Colors.white, size: 32),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'متابعة الأساتذة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'إدارة الأساتذة والحضور والأداء',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildGrid(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w >= 1024 ? 4 : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: w >= 1024 ? 1.18 : 1.05,
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
            if (c['title'] == 'قائمة الأساتذة') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TeacherListScreen()),
              );
            } else if (c['title'] == 'سجل الحضور') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TeacherAttendanceScreen(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم الضغط على "${c['title']}"'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildTeacherList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.green.shade50, blurRadius: 8)],
      ),
      child: Column(
        children: _teachers.asMap().entries.map((e) {
          final t = e.value;
          final isLast = e.key == _teachers.length - 1;
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade700,
                  child: Text(
                    t['name']![2],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  t['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'الأفواج: ${t['groups']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t['attendance']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    Text(
                      'الحضور',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
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
      Icon(icon, color: Colors.green.shade800, size: 20),
      const SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade900,
        ),
      ),
    ],
  );
}
