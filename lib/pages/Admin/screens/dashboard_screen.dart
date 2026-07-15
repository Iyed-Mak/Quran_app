import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/statistics_card.dart';
import '../widgets/responsive_layout.dart';

class DashboardScreen extends StatelessWidget {
  final String adminName;
  final void Function(int) onNavigate;

  const DashboardScreen({
    super.key,
    required this.adminName,
    required this.onNavigate,
  });

  // ── Quick stats (mock) ──
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
      'trend': 'فوج جديد قريباً',
      'up': null,
      'color': Color(0xffE65100),
    },
    {
      'icon': Icons.check_circle,
      'label': 'نسبة الحضور',
      'value': '94%',
      'trend': '+2% هذا الأسبوع',
      'up': true,
      'color': Color(0xff6A1B9A),
    },
  ];

  // ── Section cards ──
  static const _sections = [
    {
      'icon': Icons.app_registration,
      'title': 'التسجيل',
      'desc': 'تسجيل الطلاب والأساتذة',
      'start': Color(0xff1565C0),
      'end': Color(0xff42A5F5),
      'badge': null,
      'navIndex': 1,
    },
    {
      'icon': Icons.school,
      'title': 'متابعة الأساتذة',
      'desc': 'قوائم الأساتذة، الحضور، الأداء',
      'start': Color(0xff2E7D32),
      'end': Color(0xff66BB6A),
      'badge': '12',
      'navIndex': 3,
    },
    {
      'icon': Icons.people,
      'title': 'متابعة الطلبة',
      'desc': 'الطلاب، الحضور، التقدم الدراسي',
      'start': Color(0xffE65100),
      'end': Color(0xffFFA726),
      'badge': '148',
      'navIndex': 2,
    },
    {
      'icon': Icons.bar_chart,
      'title': 'الإحصائيات',
      'desc': 'إحصائيات شاملة وتقارير مرئية',
      'start': Color(0xff6A1B9A),
      'end': Color(0xffAB47BC),
      'badge': null,
      'navIndex': 4,
    },
    {
      'icon': Icons.campaign,
      'title': 'التنبيهات',
      'desc': 'إعلانات المدرسة والفعاليات القادمة',
      'start': Color(0xff00695C),
      'end': Color(0xff26A69A),
      'badge': '3',
      'navIndex': 5,
    },
    {
      'icon': Icons.admin_panel_settings,
      'title': 'الأمور الإدارية',
      'desc': 'الإعدادات، السنة الدراسية، الأدوار',
      'start': Color(0xffB71C1C),
      'end': Color(0xffEF5350),
      'badge': null,
      'navIndex': 6,
    },
  ];

  // ── Recent activities (mock) ──
  static const _activities = [
    {
      'icon': Icons.person_add,
      'color': Color(0xff1565C0),
      'text': 'تم تسجيل طالب جديد: يوسف أمين',
      'time': 'منذ 10 دقائق',
    },
    {
      'icon': Icons.check_circle,
      'color': Color(0xff2E7D32),
      'text': 'تم تسجيل حضور فوج 1 بنجاح',
      'time': 'منذ 30 دقيقة',
    },
    {
      'icon': Icons.assignment,
      'color': Color(0xffE65100),
      'text': 'تم رفع نتائج التقييم الشهري لفوج 3',
      'time': 'منذ ساعة',
    },
    {
      'icon': Icons.campaign,
      'color': Color(0xff6A1B9A),
      'text': 'إشعار جديد: إجازة نهاية الفصل الدراسي',
      'time': 'منذ 3 ساعات',
    },
    {
      'icon': Icons.group_add,
      'color': Color(0xff00695C),
      'text': 'تم إنشاء فوج جديد: فوج 9',
      'time': 'أمس',
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
            // ── Welcome card ──
            _buildWelcomeCard(context),
            const SizedBox(height: 24),

            // ── Quick stats ──
            _sectionLabel(context, 'الإحصائيات السريعة', Icons.speed),
            const SizedBox(height: 12),
            _buildStatsRow(context),
            const SizedBox(height: 28),

            // ── Dashboard cards ──
            _sectionLabel(context, 'أقسام لوحة التحكم', Icons.grid_view),
            const SizedBox(height: 12),
            ResponsiveGrid(
              childAspectRatio: MediaQuery.of(context).size.width >= 1024
                  ? 1.16
                  : MediaQuery.of(context).size.width >= 600
                  ? 1.08
                  : 1.02,
              children: _sections.map((s) {
                return DashboardCard(
                  icon: s['icon'] as IconData,
                  title: s['title'] as String,
                  description: s['desc'] as String,
                  gradientStart: s['start'] as Color,
                  gradientEnd: s['end'] as Color,
                  badge: s['badge'] as String?,
                  onTap: () => onNavigate(s['navIndex'] as int),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // ── Recent activities ──
            _sectionLabel(context, 'آخر الأنشطة', Icons.history),
            const SizedBox(height: 12),
            _buildActivities(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Welcome card ──
  Widget _buildWelcomeCard(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'صباح الخير'
        : hour < 17
        ? 'مساء الخير'
        : 'مساء النور';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0D47A1), Color(0xff1976D2)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting،',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  adminName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '📅 السنة الدراسية 2024 / 2025',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats row ──
  Widget _buildStatsRow(BuildContext context) {
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

  // ── Activities ──
  Widget _buildActivities(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade50,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: _activities.asMap().entries.map((entry) {
          final i = entry.key;
          final a = entry.value;
          final isLast = i == _activities.length - 1;
          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (a['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    a['icon'] as IconData,
                    color: a['color'] as Color,
                    size: 20,
                  ),
                ),
                title: Text(
                  a['text'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  a['time'] as String,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ),
              if (!isLast) Divider(height: 1, color: Colors.grey.shade100),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Section label ──
  Widget _sectionLabel(BuildContext context, String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade800, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
      ],
    );
  }
}
