import 'package:flutter/material.dart';
import '../../widgets/dashboard_card.dart';
import "./pages/new_student_registration.dart";
import "./pages/new_teacher_registration.dart";
import "./pages/new_administrator_registration.dart";

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  static const _cards = [
    {
      'icon': Icons.person_add,
      'title': 'تسجيل طالب',
      'desc': 'إضافة طالب جديد',
      'start': Color(0xff1565C0),
      'end': Color(0xff42A5F5),
    },
    {
      'icon': Icons.school,
      'title': 'تسجيل أستاذ',
      'desc': 'إضافة أستاذ جديد',
      'start': Color(0xff2E7D32),
      'end': Color(0xff66BB6A),
    },
    // {
    //   'icon': Icons.family_restroom,
    //   'title': 'تسجيل ولي أمر',
    //   'desc': 'ربط ولي الأمر بملف الطالب',
    //   'start': Color(0xffE65100),
    //   'end': Color(0xffFFA726),
    // },
    {
      'icon': Icons.admin_panel_settings,
      'title': 'تسجيل اداري',
      'desc': 'إنشاء حساب اداري جديد',
      'start': Color(0xffE65100),
      'end': Color(0xffFFA726),
    },
  ];

  // ── Mock registered students table ──
  static const _students = [
    {
      'name': 'أحمد بن علي',
      'group': 'فوج 1',
      'date': '2024-09-01',
      'status': 'مسجل',
    },
    {
      'name': 'محمد السعيد',
      'group': 'فوج 2',
      'date': '2024-09-03',
      'status': 'مسجل',
    },
    {
      'name': 'ليلى حمدان',
      'group': 'فوج 1',
      'date': '2024-09-05',
      'status': 'معلق',
    },
    {
      'name': 'فاطمة الزهراء',
      'group': 'فوج 3',
      'date': '2024-09-06',
      'status': 'مسجل',
    },
    {
      'name': 'أيمن بلقاسم',
      'group': 'فوج 2',
      'date': '2024-09-08',
      'status': 'مسجل',
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
            _sectionTitle('خيارات التسجيل', Icons.app_registration),
            const SizedBox(height: 12),
            _buildCardGrid(context),
            const SizedBox(height: 28),
            _sectionTitle('آخر التسجيلات', Icons.list_alt),
            const SizedBox(height: 12),
            _buildRecentTable(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0D47A1), Color(0xff1976D2)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.app_registration, color: Colors.white, size: 32),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'قسم التسجيل',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'إدارة تسجيل الطلاب والأساتذة',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardGrid(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w >= 1024
        ? 4
        : w >= 600
        ? 2
        : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.1,
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
            if (c['title'] == 'تسجيل طالب') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RegisterStudentScreen(),
                ),
              );
            } else if (c['title'] == 'تسجيل أستاذ') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RegisterTeacherScreen(),
                ),
              );
            } else if (c['title'] == 'تسجيل اداري') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterAdminScreen()),
              );
            } else {
              _showMockDialog(context, c['title'] as String);
            }
          },
        );
      },
    );
  }

  Widget _buildRecentTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade50,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.blue.shade50),
          columns: const [
            DataColumn(
              label: Text(
                'الاسم',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'الفوج',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'تاريخ التسجيل',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'الحالة',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: _students.map((s) {
            final isPending = s['status'] == 'معلق';
            return DataRow(
              cells: [
                DataCell(Text(s['name']!)),
                DataCell(Text(s['group']!)),
                DataCell(Text(s['date']!)),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isPending
                          ? Colors.orange.shade50
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isPending
                            ? Colors.orange.shade300
                            : Colors.green.shade300,
                      ),
                    ),
                    child: Text(
                      s['status']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isPending
                            ? Colors.orange.shade700
                            : Colors.green.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showMockDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(title),
          content: Text('نموذج $title — (واجهة تجريبية، لا يوجد حفظ فعلي)'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تمت عملية $title بنجاح (تجريبي)')),
                );
              },
              child: const Text('حفظ', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade800, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
      ],
    );
  }
}
