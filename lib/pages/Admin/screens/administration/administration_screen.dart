import 'package:flutter/material.dart';
import '../../widgets/dashboard_card.dart';
import 'fawj_management_screen.dart';
import 'qaa_management_screen.dart';
import 'required_files_screen.dart';
import 'maqarr_management_screen.dart';

class AdministrationScreen extends StatelessWidget {
  const AdministrationScreen({super.key});

  static const _cards = [
    {
      'icon': Icons.calendar_today,
      'title': 'السنة الدراسية',
      'desc': 'إدارة الفصول الدراسية والتواريخ',
      'start': Color(0xff2E7D32),
      'end': Color(0xff66BB6A),
    },
    {
      'icon': Icons.group_work,
      'title': 'إدارة الأفواج',
      'desc': 'إنشاء الأفواج وتعيين الأساتذة',
      'start': Color(0xffE65100),
      'end': Color(0xffFFA726),
    },
    {
      'icon': Icons.location_city,
      'title': 'المقرات',
      'desc': 'مقرات وفروع المدرسة',
      'start': Color(0xff00695C),
      'end': Color(0xff26A69A),
    },
    {
      'icon': Icons.folder_open,
      'title': 'الملفات المطلوبة',
      'desc': 'إدارة الملفات المطلوبة ومتابعة تقديم الطلاب',
      'start': Color(0xff0277BD),
      'end': Color(0xff29B6F6),
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
            _sectionTitle('الإجراءات الإدارية', Icons.admin_panel_settings),
            const SizedBox(height: 12),
            _buildGrid(context),
            const SizedBox(height: 28),
            // _sectionTitle('ملخص النظام', Icons.info_outline),
            // const SizedBox(height: 12),
            // _buildSystemSummary(),
            // const SizedBox(height: 32),
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
        colors: [Color(0xffB71C1C), Color(0xffEF5350)],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Row(
      children: [
        Icon(Icons.admin_panel_settings, color: Colors.white, size: 32),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الأمور الإدارية',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'إعدادات النظام وإدارة الموارد',
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
                  if (c['title'] == 'إدارة الأفواج') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FawjManagementScreen()),
                    );
                  } else if (c['title'] == 'القاعات الدراسية') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QaaManagementScreen()),
                    );
                  } else if (c['title'] == 'الملفات المطلوبة') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RequiredFilesScreen()),
                    );
                  } else if (c['title'] == 'المقرات') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MaqarrManagementScreen()),
                    );
                  }
                },
              );
            },
    );
  }

  // Widget _buildSystemSummary() {
  //   final items = [
  //     {'label': 'إصدار النظام', 'value': '2.1.0', 'icon': Icons.info},
  //     {
  //       'label': 'السنة الدراسية',
  //       'value': '2024 / 2025',
  //       'icon': Icons.calendar_today,
  //     },
  //     {
  //       'label': 'آخر نسخ احتياطي',
  //       'value': '2025-01-10 10:30',
  //       'icon': Icons.backup,
  //     },
  //     {
  //       'label': 'عدد المستخدمين',
  //       'value': '24 مستخدم نشط',
  //       'icon': Icons.people,
  //     },
  //     {
  //       'label': 'مساحة التخزين',
  //       'value': '1.2 GB / 10 GB',
  //       'icon': Icons.storage,
  //     },
  //   ];
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(18),
  //       boxShadow: [BoxShadow(color: Colors.red.shade50, blurRadius: 8)],
  //     ),
  //     child: Column(
  //       children: items.asMap().entries.map((e) {
  //         final item = e.value;
  //         final isLast = e.key == items.length - 1;
  //         return Column(
  //           children: [
  //             ListTile(
  //               leading: Container(
  //                 padding: const EdgeInsets.all(8),
  //                 decoration: BoxDecoration(
  //                   color: Colors.red.shade50,
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Icon(
  //                   item['icon'] as IconData,
  //                   color: Colors.red.shade700,
  //                   size: 20,
  //                 ),
  //               ),
  //               title: Text(
  //                 item['label'] as String,
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 14,
  //                 ),
  //               ),
  //               trailing: Text(
  //                 item['value'] as String,
  //                 style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
  //               ),
  //             ),
  //             if (!isLast) Divider(height: 1, color: Colors.grey.shade100),
  //           ],
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  Widget _sectionTitle(String label, IconData icon) => Row(
    children: [
      Icon(icon, color: Colors.red.shade800, size: 20),
      const SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.red.shade900,
        ),
      ),
    ],
  );
}
