import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  static const _announcements = [
    {
      'icon': Icons.campaign,
      'color': Color(0xff1565C0),
      'title': 'بداية الفصل الدراسي الثاني',
      'body':
          'يُعلَم جميع الطلاب والأساتذة بأن الفصل الدراسي الثاني يبدأ يوم الأحد الموافق 15 جانفي 2025.',
      'date': '2025-01-10',
      'type': 'إعلان',
    },
    {
      'icon': Icons.event,
      'color': Color(0xff2E7D32),
      'title': 'مسابقة حفظ القرآن الكريم',
      'body':
          'تُعلن إدارة المدرسة عن إقامة مسابقة سنوية لحفظ القرآن الكريم بتاريخ 20 فيفري 2025.',
      'date': '2025-01-08',
      'type': 'فعالية',
    },
    {
      'icon': Icons.notifications,
      'color': Color(0xffE65100),
      'title': 'تذكير: تسليم الوثائق الإدارية',
      'body':
          'يُذكَّر أولياء الأمور الذين لم يسلّموا الوثائق الإدارية بضرورة تسليمها قبل نهاية الأسبوع.',
      'date': '2025-01-05',
      'type': 'تنبيه',
    },
    {
      'icon': Icons.beach_access,
      'color': Color(0xff6A1B9A),
      'title': 'عطلة نصف الفصل الدراسي',
      'body':
          'تُعلم الإدارة بأن عطلة نصف الفصل ستكون من 27 جانفي إلى 31 جانفي 2025.',
      'date': '2025-01-03',
      'type': 'إعلان',
    },
    {
      'icon': Icons.history_edu,
      'color': Color(0xff00695C),
      'title': 'نتائج تقييم الفصل الأول',
      'body':
          'تمّ رفع نتائج التقييم الدوري للفصل الأول. يُرجى مراجعة النتائج في قسم كشف النقاط.',
      'date': '2024-12-28',
      'type': 'تنبيه',
    },
  ];

  static const _events = [
    {
      'title': 'مسابقة حفظ القرآن',
      'date': '20 فيفري 2025',
      'icon': Icons.emoji_events,
      'color': Color(0xffE65100),
    },
    {
      'title': 'اجتماع أولياء الأمور',
      'date': '5 فيفري 2025',
      'icon': Icons.groups,
      'color': Color(0xff1565C0),
    },
    {
      'title': 'التقييم الشهري',
      'date': '15 فيفري 2025',
      'icon': Icons.assignment,
      'color': Color(0xff2E7D32),
    },
    {
      'title': 'نهاية الفصل الثاني',
      'date': '30 أفريل 2025',
      'icon': Icons.flag,
      'color': Color(0xff6A1B9A),
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
            _sectionTitle('الفعاليات القادمة', Icons.event),
            const SizedBox(height: 12),
            _buildEvents(context),
            const SizedBox(height: 24),
            _sectionTitle('الإعلانات والتنبيهات', Icons.campaign),
            const SizedBox(height: 12),
            ..._announcements.map((a) => _buildAnnouncementCard(a)),
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
        colors: [Color(0xff00695C), Color(0xff26A69A)],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Row(
      children: [
        Icon(Icons.campaign, color: Colors.white, size: 32),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التنبيهات والإعلانات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'إعلانات المدرسة والفعاليات القادمة',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildEvents(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: _events.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final e = _events[i];
          final color = e['color'] as Color;
          return Container(
            width: 160,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(e['icon'] as IconData, color: Colors.white, size: 26),
                const Spacer(),
                Text(
                  e['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  e['date'] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnnouncementCard(Map<String, dynamic> a) {
    final color = a['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border(right: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(a['icon'] as IconData, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  a['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  a['type'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            a['body'] as String,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            a['date'] as String,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String label, IconData icon) => Row(
    children: [
      Icon(icon, color: Colors.teal.shade800, size: 20),
      const SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.teal.shade900,
        ),
      ),
    ],
  );
}
