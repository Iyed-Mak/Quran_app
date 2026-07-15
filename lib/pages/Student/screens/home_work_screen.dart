import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quran_app/utils/date_formatter.dart';

/// شاشة الواجبات المنزلية
///
/// تعرض بطاقة ملخص في الأعلى (عدد الواجبات / المنجزة / المتبقية)،
/// ثم قائمة بكل الواجبات كبطاقات متجاوبة مع إمكانية عرض التفاصيل
/// الكاملة لكل واجب (التعليمات، التواريخ، اسم المعلم).
///
/// ملاحظة: جميع البيانات هنا بيانات تجريبية (Mock) فقط،
/// لا يوجد أي اتصال بقاعدة بيانات أو واجهة خلفية (API).
class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  // ---------------------------------------------------------------------
  // بيانات تجريبية (Mock Data)
  // ---------------------------------------------------------------------
  //
  // التواريخ محسوبة بشكل نسبي من تاريخ اليوم (DateTime.now) بدل تواريخ
  // ثابتة، حتى تبقى حالات "جديد" و"متأخر" منطقية بغض النظر عن وقت
  // تشغيل التطبيق.

  late final List<Map<String, dynamic>> homeworkList = _generateMockHomework();

  List<Map<String, dynamic>> _generateMockHomework() {
    final now = DateTime.now();
    return [
      {
        'title': 'الأحكام النونية في التجويد',
        'description':
            'حل تمارين الكتاب من صفحة 12 إلى 15 المتعلقة بأحكام النون الساكنة والتنوين.',
        'instructions':
            'يرجى حل جميع التمارين في صفحات 12 إلى 15 من كتاب التجويد، مع كتابة الإجابات '
            'بخط واضح في الدفتر المخصص. التركيز بشكل خاص على تمييز حالات الإخفاء '
            'والإقلاب والإدغام، وإرفاق مثال واحد على الأقل من القرآن لكل حكم.',
        'assignedDate': now.subtract(const Duration(days: 5)),
        'dueDate': now.add(const Duration(days: 2)),
        'status': 'قيد الإنجاز',
        'teacherName': 'الأستاذ عمر يوبي',
      },
      {
        'title': 'حفظ سورة البقرة (الآيات 1-10)',
        'description':
            'حفظ الآيات العشر الأولى من سورة البقرة مع مراعاة أحكام التجويد.',
        'instructions':
            'حفظ الآيات من 1 إلى 10 من سورة البقرة حفظًا متينًا، مع مراجعتها مع أحد '
            'الوالدين يوميًا قبل الحصة القادمة. سيتم التسميع الفردي أمام المعلم.',
        'assignedDate': now.subtract(const Duration(hours: 20)),
        'dueDate': now.add(const Duration(days: 5)),
        'status': 'لم يبدأ',
        'teacherName': 'الأستاذة مهدي قمرة',
      },
      {
        'title': 'تفسير آية الكرسي',
        'description': 'كتابة تقرير مختصر عن معاني آية الكرسي وفضائلها.',
        'instructions':
            'كتابة تقرير لا يقل عن صفحة واحدة يتضمن: معنى آية الكرسي، أسباب تسميتها '
            'بهذا الاسم، وثلاثة فضائل واردة في الأحاديث الصحيحة. يُسلَّم التقرير مكتوبًا '
            'بخط اليد.',
        'assignedDate': now.subtract(const Duration(days: 8)),
        'dueDate': now.subtract(const Duration(days: 2)),
        'status': 'لم يبدأ',
        'teacherName': 'الأستاذ  عبد الرحمان',
      },
      {
        'title': 'الهجرة النبوية - السيرة',
        'description':
            'الإجابة عن أسئلة الكتاب المتعلقة بأحداث الهجرة النبوية.',
        'instructions':
            'الإجابة عن الأسئلة من 1 إلى 8 في نهاية فصل "الهجرة النبوية"، مع ذكر '
            'التواريخ والأحداث الرئيسية بالترتيب الزمني الصحيح.',
        'assignedDate': now.subtract(const Duration(days: 10)),
        'dueDate': now.subtract(const Duration(days: 6)),
        'status': 'مكتمل',
        'teacherName': 'الأستاذة سارة محمد',
      },
      {
        'title': 'مخارج الحروف - تطبيق عملي',
        'description':
            'تسجيل صوتي لقراءة الصفحة المحددة مع مراعاة مخارج الحروف.',
        'instructions':
            'تسجيل قراءة صوتية للصفحة 20 من المصحف مع مراعاة مخارج الحروف ومراعاة '
            'الغنة والقلقلة، وإرسال التسجيل إلى المعلم عبر القناة المعتمدة في المركز.',
        'assignedDate': now.subtract(const Duration(days: 4)),
        'dueDate': now.add(const Duration(days: 1)),
        'status': 'مكتمل',
        'teacherName': 'الأستاذ أحمد بن علي',
      },
      {
        'title': 'مراجعة الجزء الأول',
        'description':
            'مراجعة شاملة لما تم حفظه من الجزء الأول استعدادًا للتسميع العام.',
        'instructions':
            'مراجعة جميع السور المحفوظة من الجزء الأول، مع التركيز على المواضع التي '
            'تكررت فيها الأخطاء خلال الحصص السابقة. التسميع العام سيكون أمام لجنة من '
            'معلمي المقر.',
        'assignedDate': now.subtract(const Duration(hours: 6)),
        'dueDate': now.add(const Duration(days: 7)),
        'status': 'لم يبدأ',
        'teacherName': 'الأستاذ يوسف الإدريسي',
      },
    ];
  }

  // ---------------------------------------------------------------------
  // أدوات مساعدة (حالة الواجب / الشارات / التنسيق)
  // ---------------------------------------------------------------------

  static final Color _gradientStart = Colors.pink.shade600;
  static final Color _gradientEnd = Colors.pinkAccent.shade200;

  static final LinearGradient _appGradient = LinearGradient(
    colors: [_gradientStart, _gradientEnd],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  Color _statusColor(String status) {
    switch (status) {
      case 'مكتمل':
        return Colors.green.shade600;
      case 'قيد الإنجاز':
        return Colors.amber.shade700;
      default: // لم يبدأ
        return Colors.red.shade600;
    }
  }

  String _statusEmoji(String status) {
    switch (status) {
      case 'مكتمل':
        return '🟢';
      case 'قيد الإنجاز':
        return '🟡';
      default:
        return '🔴';
    }
  }

  bool _isNew(Map<String, dynamic> hw) {
    final DateTime assigned = hw['assignedDate'] as DateTime;
    return DateTime.now().difference(assigned).inHours <= 48;
  }

  bool _isOverdue(Map<String, dynamic> hw) {
    final DateTime due = hw['dueDate'] as DateTime;
    final String status = hw['status'] as String;
    return status != 'مكتمل' && DateTime.now().isAfter(due);
  }

  String _formatDate(DateTime? d) => formatDzDate(d);

  int get _completedCount =>
      homeworkList.where((h) => h['status'] == 'مكتمل').length;

  int get _remainingCount => homeworkList.length - _completedCount;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: _appGradient),
          ),
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
          title: const Text(
            'الواجبات المنزلية',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(),
                const SizedBox(height: 18),
                _buildSectionHeader(),
                const SizedBox(height: 10),
                if (homeworkList.isEmpty)
                  _buildEmptyState()
                else
                  LayoutBuilder(
                    builder: (context, constraints) =>
                        _buildResponsiveList(constraints),
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
  // بطاقة الملخص
  // ---------------------------------------------------------------------

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        gradient: _appGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _gradientStart.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryStat(
              icon: Icons.assignment_outlined,
              value: '${homeworkList.length}',
              label: 'عدد الواجبات',
            ),
          ),
          _summaryDivider(),
          Expanded(
            child: _summaryStat(
              icon: Icons.check_circle_outline,
              value: '$_completedCount',
              label: 'الواجبات المنجزة',
            ),
          ),
          _summaryDivider(),
          Expanded(
            child: _summaryStat(
              icon: Icons.pending_actions_outlined,
              value: '$_remainingCount',
              label: 'الواجبات المتبقية',
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryDivider() => Container(
    width: 1,
    height: 44,
    color: Colors.white.withValues(alpha: 0.3),
  );

  Widget _summaryStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Icon(Icons.menu_book_outlined, color: _gradientStart, size: 20),
        const SizedBox(width: 6),
        Text(
          'قائمة الواجبات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.pink.shade900,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // قائمة الواجبات المتجاوبة
  // ---------------------------------------------------------------------

  Widget _buildResponsiveList(BoxConstraints constraints) {
    final double width = constraints.maxWidth;
    final int columns = width >= 1100 ? 3 : (width >= 700 ? 2 : 1);

    final cards = homeworkList
        .map(
          (hw) => _HomeworkCard(
            homework: hw,
            statusColor: _statusColor(hw['status'] as String),
            statusEmoji: _statusEmoji(hw['status'] as String),
            isNew: _isNew(hw),
            isOverdue: _isOverdue(hw),
            accentColor: _gradientStart,
            formatDate: _formatDate,
            onShowDetails: () => _showDetails(hw),
          ),
        )
        .toList();

    if (columns == 1) {
      return Column(
        children: cards
            .map(
              (c) =>
                  Padding(padding: const EdgeInsets.only(bottom: 12), child: c),
            )
            .toList(),
      );
    }

    const double spacing = 12;
    final double cardWidth = (width - (columns - 1) * spacing) / columns;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: cards.map((c) => SizedBox(width: cardWidth, child: c)).toList(),
    );
  }

  // ---------------------------------------------------------------------
  // الحالة الفارغة
  // ---------------------------------------------------------------------

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Text('📚', style: TextStyle(fontSize: 46)),
            const SizedBox(height: 10),
            Text(
              'لا توجد واجبات منزلية حالياً.',
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // تفاصيل الواجب (Bottom Sheet)
  // ---------------------------------------------------------------------

  void _showDetails(Map<String, dynamic> hw) {
    final String status = hw['status'] as String;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              hw['title'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _statusBadgeWidget(status),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _detailRow(
                        Icons.calendar_today,
                        'تاريخ التكليف',
                        _formatDate(hw['assignedDate'] as DateTime),
                      ),
                      const SizedBox(height: 8),
                      _detailRow(
                        Icons.event_busy,
                        'تاريخ التسليم',
                        _formatDate(hw['dueDate'] as DateTime),
                      ),
                      const SizedBox(height: 8),
                      _detailRow(
                        Icons.person_outline,
                        'اسم المعلم',
                        hw['teacherName'] as String,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'التعليمات',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: _gradientStart,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hw['instructions'] as String,
                        style: const TextStyle(
                          fontSize: 14,
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
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _statusBadgeWidget(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _statusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${_statusEmoji(status)} $status',
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

// =========================================================================
// بطاقة الواجب (Widget مستقل يحتفظ بحالة "عرض المزيد / أقل" الخاصة به)
// =========================================================================

class _HomeworkCard extends StatefulWidget {
  const _HomeworkCard({
    required this.homework,
    required this.statusColor,
    required this.statusEmoji,
    required this.isNew,
    required this.isOverdue,
    required this.accentColor,
    required this.formatDate,
    required this.onShowDetails,
  });

  final Map<String, dynamic> homework;
  final Color statusColor;
  final String statusEmoji;
  final bool isNew;
  final bool isOverdue;
  final Color accentColor;
  final String Function(DateTime) formatDate;
  final VoidCallback onShowDetails;

  @override
  State<_HomeworkCard> createState() => _HomeworkCardState();
}

class _HomeworkCardState extends State<_HomeworkCard> {
  bool _expanded = false;

  static const int _collapsedMaxChars = 90;

  @override
  Widget build(BuildContext context) {
    final hw = widget.homework;
    final String title = hw['title'] as String;
    final String description = hw['description'] as String;
    final String status = hw['status'] as String;
    final DateTime assignedDate = hw['assignedDate'] as DateTime;
    final DateTime dueDate = hw['dueDate'] as DateTime;
    final bool isLongDescription = description.length > _collapsedMaxChars;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: widget.isOverdue ? Colors.red.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: widget.isOverdue
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
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _statusBadge(status),
            ],
          ),
          if (widget.isNew || widget.isOverdue) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (widget.isNew)
                  _tagBadge('جديد', Colors.blue.shade600, Icons.new_releases),
                if (widget.isOverdue)
                  _tagBadge(
                    'متأخر',
                    Colors.red.shade700,
                    Icons.warning_amber_rounded,
                  ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 13, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                'تاريخ التكليف: ${widget.formatDate(assignedDate)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.event_busy,
                size: 13,
                color: widget.isOverdue ? Colors.red[600] : Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                'آخر موعد للتسليم: ${widget.formatDate(dueDate)}',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.isOverdue ? Colors.red[600] : Colors.grey[600],
                  fontWeight: widget.isOverdue
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Text(
              description,
              maxLines: _expanded ? null : 2,
              overflow: _expanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
          if (isLongDescription)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? 'عرض أقل' : 'عرض المزيد من الوصف',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.accentColor,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: widget.onShowDetails,
              style: TextButton.styleFrom(foregroundColor: widget.accentColor),
              icon: const Icon(Icons.arrow_back_ios_new, size: 12),
              label: const Text('عرض التفاصيل'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.statusColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${widget.statusEmoji} $status',
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _tagBadge(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
