import 'dart:math' as math;

import 'package:flutter/material.dart';

/// شاشة الإعلانات
///
/// تعرض إعلانًا مثبّتًا (الأهم) في الأعلى، ثم قائمة بكل الإعلانات
/// كبطاقات متجاوبة، مع تمييز الإعلانات الهامة بلون مختلف.
///
/// ملاحظة: جميع البيانات هنا بيانات تجريبية (Mock) فقط،
/// لا يوجد أي اتصال بقاعدة بيانات أو واجهة خلفية (API).
class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  // ---------------------------------------------------------------------
  // الألوان الرئيسية للصفحة (ترويسة، بطاقة مثبّتة، أزرار رئيسية)
  // ---------------------------------------------------------------------

  static final Color _gradientStart = Colors.teal.shade600;
  static final Color _gradientEnd = Colors.cyan.shade200;

  static final LinearGradient _appGradient = LinearGradient(
    colors: [_gradientStart, _gradientEnd],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ---------------------------------------------------------------------
  // بيانات تجريبية (Mock Data)
  // ---------------------------------------------------------------------

  final List<Map<String, dynamic>> announcementsList = [
    {
      'title': 'تأجيل امتحان الحفظ الشهري',
      'type': 'هام',
      'date': '2026-06-25',
      'description':
          'تم تأجيل امتحان الحفظ الشهري إلى يوم الأحد القادم بسبب ظروف تقنية في المركز.',
      'fullDescription':
          'تم تأجيل امتحان الحفظ الشهري الذي كان مقررًا اليوم إلى يوم الأحد القادم '
          'الموافق 28 يونيو، وذلك بسبب ظروف تقنية طارئة في المركز. سيتم إعلام جميع '
          'الطلاب بالموعد الجديد عبر المعلمين المسؤولين. نأمل التفاعل والاستعداد الجيد.',
      'isPinned': true,
    },
    {
      'title': 'بدء التسجيل في الفصل الصيفي',
      'type': 'دراسي',
      'date': '2026-06-20',
      'description':
          'يبدأ التسجيل في الفصل الصيفي ابتداءً من الأسبوع القادم، يرجى التواصل مع الإدارة.',
      'fullDescription':
          'تعلن إدارة المركز عن بدء التسجيل في الفصل الصيفي ابتداءً من الأسبوع القادم. '
          'يرجى من جميع الطلاب الراغبين في التسجيل التواصل مع إدارة المركز لاستكمال '
          'الإجراءات اللازمة قبل تاريخ 5 يوليو.',
      'isPinned': false,
    },
    {
      'title': 'مسابقة حفظ القرآن السنوية',
      'type': 'نشاط',
      'date': '2026-06-18',
      'description':
          'تنطلق مسابقة الحفظ السنوية الأسبوع القادم بمشاركة جميع الأفواج.',
      'fullDescription':
          'تنطلق مسابقة حفظ القرآن الكريم السنوية الأسبوع القادم، وتشارك فيها جميع '
          'الأفواج في المقرّين. تتضمن المسابقة عدة مستويات حسب الفئة العمرية، وستُمنح '
          'جوائز قيّمة للفائزين الثلاثة الأوائل في كل فئة.',
      'isPinned': false,
    },
    {
      'title': 'حفل تكريم الطلاب المتميزين',
      'type': 'مناسبة',
      'date': '2026-06-15',
      'description':
          'يسر إدارة المركز دعوتكم لحضور حفل تكريم الطلاب المتميزين هذا الأسبوع.',
      'fullDescription':
          'يسر إدارة المركز دعوتكم لحضور حفل تكريم الطلاب المتميزين الذي سيقام هذا '
          'الأسبوع بمناسبة ختام الفصل الدراسي. الحضور يشمل الطلاب وأولياء الأمور، '
          'وسيتم توزيع شهادات التقدير على الفائزين.',
      'isPinned': false,
    },
    {
      'title': 'تنبيه بخصوص مواعيد الدوام',
      'type': 'تنبيه',
      'date': '2026-06-12',
      'description':
          'يرجى الالتزام بمواعيد الدوام الجديدة المعتمدة من قبل الإدارة.',
      'fullDescription':
          'تنبّه إدارة المركز جميع الطلاب وأولياء الأمور إلى ضرورة الالتزام بمواعيد '
          'الدوام الجديدة المعتمدة هذا الفصل، حيث تم تعديل مواعيد الفترة المسائية '
          'بمقدار نصف ساعة. يرجى مراجعة الجدول الدراسي للتفاصيل.',
      'isPinned': false,
    },
    {
      'title': 'تحديث في المنهج الدراسي',
      'type': 'دراسي',
      'date': '2026-06-08',
      'description':
          'تم تحديث خطة المنهج الدراسي لهذا الفصل، يرجى مراجعة التفاصيل مع المعلم.',
      'fullDescription':
          'تم تحديث خطة المنهج الدراسي لهذا الفصل بإضافة وحدة جديدة في التفسير '
          'الموضوعي. يرجى من جميع الطلاب مراجعة التفاصيل الكاملة مع معلم الفوج '
          'الخاص بهم في أقرب حصة.',
      'isPinned': false,
    },
  ];

  // ---------------------------------------------------------------------
  // بيانات تصنيفات الإعلانات (الألوان والأيقونات)
  // ---------------------------------------------------------------------

  static final Map<String, Color> _categoryColors = {
    'هام': Colors.red.shade600,
    'دراسي': Colors.blue.shade600,
    'نشاط': Colors.purple.shade500,
    'مناسبة': Colors.pink.shade400,
    'تنبيه': Colors.deepOrange.shade600,
  };

  static final Map<String, IconData> _categoryIcons = {
    'هام': Icons.priority_high,
    'دراسي': Icons.school,
    'نشاط': Icons.emoji_events,
    'مناسبة': Icons.celebration,
    'تنبيه': Icons.notifications_active,
  };

  Color _colorOf(String type) => _categoryColors[type] ?? Colors.grey.shade600;
  IconData _iconOf(String type) => _categoryIcons[type] ?? Icons.campaign;

  Map<String, dynamic>? get _pinnedAnnouncement {
    for (final a in announcementsList) {
      if (a['isPinned'] == true) return a;
    }
    return null;
  }

  List<Map<String, dynamic>> get _otherAnnouncements =>
      announcementsList.where((a) => a['isPinned'] != true).toList();

  @override
  Widget build(BuildContext context) {
    final pinned = _pinnedAnnouncement;
    final others = _otherAnnouncements;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   centerTitle: true,
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(gradient: _appGradient),
      //   ),
      //   title: const Directionality(
      //     textDirection: TextDirection.ltr,
      //     child: Text(
      //       'الإعلانات',
      //       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Transform.rotate(
              angle: math.pi,
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).maybePop(),
            tooltip: 'رجوع',
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: _appGradient),
        ),
        title: const Text(
          'الإعلانات',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pinned != null) ...[
                  _buildPinnedCard(pinned),
                  const SizedBox(height: 18),
                ],
                _buildSectionHeader(),
                const SizedBox(height: 10),
                if (announcementsList.isEmpty)
                  _buildEmptyState()
                else if (others.isEmpty && pinned != null)
                  _buildAllCaughtUpState()
                else
                  LayoutBuilder(
                    builder: (context, constraints) =>
                        _buildResponsiveList(constraints, others),
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // عناصر الصفحة
  // ---------------------------------------------------------------------

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Icon(Icons.campaign, color: _gradientStart, size: 20),
        const SizedBox(width: 6),
        Text(
          'جميع الإعلانات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.teal.shade900,
          ),
        ),
      ],
    );
  }

  /// بطاقة الإعلان المثبّت (الأهم) في أعلى الصفحة.
  Widget _buildPinnedCard(Map<String, dynamic> a) {
    final String type = a['type'] as String;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: _appGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _gradientStart.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.push_pin, color: Colors.amber, size: 18),
              const SizedBox(width: 6),
              const Text(
                'إعلان مثبّت',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              _categoryBadge(type, light: true),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            a['title'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 13,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 4),
              Text(
                a['date'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            a['description'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: OutlinedButton.icon(
              onPressed: () => _showDetails(a),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.arrow_back_ios_new, size: 13),
              label: const Text('عرض المزيد'),
            ),
          ),
        ],
      ),
    );
  }

  /// يبني قائمة الإعلانات بشكل متجاوب: عمود واحد على الهاتف،
  /// وأعمدة متعددة (Wrap) على الشاشات الأوسع (تابلت/حاسوب).
  Widget _buildResponsiveList(
    BoxConstraints constraints,
    List<Map<String, dynamic>> items,
  ) {
    final double width = constraints.maxWidth;
    final int columns = width >= 1100 ? 3 : (width >= 700 ? 2 : 1);

    if (columns == 1) {
      return Column(
        children: items
            .map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _announcementCard(a),
              ),
            )
            .toList(),
      );
    }

    const double spacing = 12;
    final double cardWidth = (width - (columns - 1) * spacing) / columns;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: items
          .map((a) => SizedBox(width: cardWidth, child: _announcementCard(a)))
          .toList(),
    );
  }

  Widget _announcementCard(Map<String, dynamic> a) {
    final String type = a['type'] as String;
    final bool isImportant = type == 'هام';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isImportant ? Colors.red.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isImportant
            ? Border(right: BorderSide(color: Colors.red.shade400, width: 4))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  a['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _categoryBadge(type),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 13, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                a['date'] as String,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            a['description'] as String,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.5,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: () => _showDetails(a),
              style: TextButton.styleFrom(foregroundColor: _gradientStart),
              icon: const Icon(Icons.arrow_back_ios_new, size: 12),
              label: const Text('عرض المزيد'),
            ),
          ),
        ],
      ),
    );
  }

  /// شارة تعرض نوع الإعلان بلون مخصص لكل تصنيف.
  /// [light] تُستخدم فوق خلفية ملوّنة (مثل البطاقة المثبّتة) فتعرض
  /// خلفية بيضاء بدل اللون الملوّن لضمان وضوح التباين.
  Widget _categoryBadge(String type, {bool light = false}) {
    final Color color = _colorOf(type);
    final IconData icon = _iconOf(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: light ? Colors.white : color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: light ? color : Colors.white),
          const SizedBox(width: 3),
          Text(
            type,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: light ? color : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // الحالات الخاصة (فراغ / تفاصيل)
  // ---------------------------------------------------------------------

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Text('🔔', style: TextStyle(fontSize: 46)),
            const SizedBox(height: 10),
            Text(
              'لا توجد إعلانات حالياً.',
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  /// يظهر عندما يكون الإعلان المثبّت هو الإعلان الوحيد المتوفر.
  Widget _buildAllCaughtUpState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.check_circle_outline, size: 36, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'لا توجد إعلانات إضافية حاليًا.',
              style: TextStyle(fontSize: 13.5, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(Map<String, dynamic> a) {
    final String type = a['type'] as String;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        a['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _categoryBadge(type),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 13,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      a['date'] as String,
                      style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  (a['fullDescription'] ?? a['description']) as String,
                  style: const TextStyle(
                    fontSize: 14.5,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _gradientStart,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('إغلاق'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
