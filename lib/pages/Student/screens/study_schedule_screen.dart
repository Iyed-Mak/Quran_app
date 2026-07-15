import 'dart:math' as math;
import 'package:flutter/material.dart';

/// جدول الدراسة الأسبوعي
///
/// يعرض هذا الشاشة الجدول الأسبوعي منظمًا حسب:
/// اليوم -> الفترة (صباحًا / مساءً) -> المقر -> الحجرة
/// مع تمييز فوج الطالب الحالي تلقائيًا داخل الجدول.
///
/// ملاحظة: جميع البيانات هنا بيانات تجريبية (Mock) فقط،
/// لا يوجد أي اتصال بقاعدة بيانات أو واجهة خلفية (API).
class StudyScheduleScreen extends StatefulWidget {
  const StudyScheduleScreen({super.key});

  @override
  State<StudyScheduleScreen> createState() => _StudyScheduleScreenState();
}

class _StudyScheduleScreenState extends State<StudyScheduleScreen> {
  // ---------------------------------------------------------------------
  // بيانات تجريبية (Mock Data)
  // ---------------------------------------------------------------------

  final List<String> days = const [
    'السبت',
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
  ];

  final List<String> periods = const ['صباحًا', 'مساءً'];
  final List<String> locations = const ['المقر 1', 'المقر 2'];
  final List<String> rooms = const ['الحجرة 1', 'الحجرة 2'];

  /// فوج الطالب الحالي (بيانات تجريبية - بدون مصادقة فعلية).
  final String studentGroup = 'فوج 1';

  /// scheduleData[اليوم]['المقر|الحجرة']['صباحًا' | 'مساءً'] = 'فوج X'
  late final Map<String, Map<String, Map<String, String>>> scheduleData =
      _generateMockSchedule();

  Map<String, Map<String, Map<String, String>>> _generateMockSchedule() {
    final List<String> slots = [];
    for (final loc in locations) {
      for (final room in rooms) {
        slots.add('$loc|$room');
      }
    }

    final Map<String, Map<String, Map<String, String>>> data = {};

    for (int dayIndex = 0; dayIndex < days.length; dayIndex++) {
      final day = days[dayIndex];
      final Map<String, Map<String, String>> dayMap = {};

      for (int slotIndex = 0; slotIndex < slots.length; slotIndex++) {
        final morningNum = ((slotIndex + dayIndex) % 8) + 1;
        final eveningNum = ((slotIndex + 4 + dayIndex) % 8) + 1;
        dayMap[slots[slotIndex]] = {
          'صباحًا': 'فوج $morningNum',
          'مساءً': 'فوج $eveningNum',
        };
      }
      data[day] = dayMap;
    }
    return data;
  }

  // ---------------------------------------------------------------------
  // ثوابت تنسيق الجدول
  // ---------------------------------------------------------------------

  static const double _dayColWidth = 84;
  static const double _periodColWidth = 72;
  static const double _roomColWidth = 124;
  static const double _headerRowHeight = 42;
  static const double _bodyRowHeight = 56;

  /// عرض الشاشة الذي يتم اعتماده كحد فاصل بين الهاتف والتابلت/الحاسوب.
  static const double _mobileBreakpoint = 600;

  /// الارتفاع الكلي للجدول (ترويسة + كل صفوف الأيام والفترات) محسوب
  /// مسبقًا بدقة. هذا الارتفاع الصريح ضروري لمنع مشكلة
  /// "BoxConstraints forces an infinite height" التي تحدث عند تداخل
  /// SingleChildScrollView رأسي مع آخر أفقي بدون إعطاء الابن ارتفاعًا محددًا.
  double get _tableHeight =>
      (_headerRowHeight * 2) +
      (days.length * _bodyRowHeight * periods.length) +
      2;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.green[700],
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
          title: const Text(
            'البرنامج الدراسي',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildStudentGroupCard(),
              _buildLegend(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, outerConstraints) {
                    final bool isMobile =
                        outerConstraints.maxWidth < _mobileBreakpoint;
                    final Widget table = _buildTimetableGrid();

                    if (!isMobile) {
                      return _buildDesktopTable(table);
                    }

                    // عرض الهاتف: تدوير الجدول 90 درجة مع إمكانية
                    // التمرير الرأسي والأفقي معًا.
                    return Column(
                      children: [
                        _buildRotateHint(),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, innerConstraints) {
                              return _buildRotatedMobileTable(
                                table,
                                innerConstraints,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // عناصر أعلى الصفحة
  // ---------------------------------------------------------------------

  Widget _buildStudentGroupCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.groups, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'فوجك الحالي: $studentGroup',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.amber[600],
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '(فوجي)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'فوجك يظهر باللون الأخضر مع شعار (فوجي)',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
          Icon(Icons.swap_horiz, size: 16, color: Colors.grey[500]),
          const SizedBox(width: 2),
          Text(
            'مرّر للتمرير',
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildRotateHint() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.green[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.screen_rotation, size: 14, color: Colors.green[800]),
          const SizedBox(width: 6),
          Text(
            'الجدول معروض بشكل أفقي لتسهيل القراءة على الهاتف',
            style: TextStyle(fontSize: 11, color: Colors.green[800]),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // أُطر عرض الجدول (سطح المكتب / الهاتف)
  // ---------------------------------------------------------------------

  Widget _buildDesktopTable(Widget table) {
    return Padding(
      padding: const EdgeInsets.all(12),
      // تمرير رأسي على مستوى الجدول كاملاً (يحمي من الفائض إذا كان
      // الجدول أطول من المساحة المتاحة على الشاشة).
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          // ارتفاع صريح وثابت لتفادي تمرير ارتفاع غير منتهٍ (Infinity)
          // إلى SingleChildScrollView الأفقي بالأسفل.
          height: _tableHeight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: table,
          ),
        ),
      ),
    );
  }

  /// على الهاتف: نُدوّر الجدول 90 درجة (عرض أفقي) لتسهيل قراءته،
  /// مع الحفاظ على إمكانية التمرير الرأسي والأفقي وعدم اقتطاع أي نص.
  Widget _buildRotatedMobileTable(Widget table, BoxConstraints constraints) {
    return RotatedBox(
      quarterTurns: 1,
      child: SizedBox(
        width: constraints.maxHeight,
        height: constraints.maxWidth,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            // نفس الحل: ارتفاع صريح يمنع وصول قيد ارتفاع غير منتهٍ
            // إلى SingleChildScrollView الأفقي الداخلي.
            height: _tableHeight + 24, // + هامش الـ Padding أدناه
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(padding: const EdgeInsets.all(12), child: table),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // بناء شبكة الجدول
  // ---------------------------------------------------------------------

  Widget _buildTimetableGrid() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRows(),
          ...days.map((day) => _buildDayBlock(day)),
        ],
      ),
    );
  }

  Widget _buildHeaderRows() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "اليوم" و"الفترة" يمتدان على ارتفاع صفّي الترويسة معًا.
        _headerCell(
          'اليوم',
          width: _dayColWidth,
          height: _headerRowHeight * 2,
          background: Colors.green[800]!,
        ),
        _headerCell(
          'الفترة',
          width: _periodColWidth,
          height: _headerRowHeight * 2,
          background: Colors.green[800]!,
        ),
        Column(
          children: [
            // الصف الأول: المقر 1 / المقر 2
            Row(
              children: locations
                  .map(
                    (loc) => _headerCell(
                      loc,
                      width: _roomColWidth * rooms.length,
                      height: _headerRowHeight,
                      background: Colors.green[700]!,
                    ),
                  )
                  .toList(),
            ),
            // الصف الثاني: الحجرة 1 / الحجرة 2 تحت كل مقر
            Row(
              children: locations
                  .expand(
                    (loc) => rooms.map(
                      (room) => _headerCell(
                        room,
                        width: _roomColWidth,
                        height: _headerRowHeight,
                        background: Colors.green[600]!,
                        fontSize: 12,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _headerCell(
    String text, {
    required double width,
    required double height,
    required Color background,
    double fontSize = 13,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: Colors.green[900]!.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }

  /// كل يوم = خلية "اليوم" تمتد على ارتفاع صفّي الفترة (صباحًا / مساءً).
  Widget _buildDayBlock(String day) {
    return Row(
      children: [
        Container(
          width: _dayColWidth,
          height: _bodyRowHeight * periods.length,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.green[50],
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
              left: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
              fontSize: 13,
            ),
          ),
        ),
        Column(
          children: periods
              .map((period) => _buildPeriodRow(day, period))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPeriodRow(String day, String period) {
    return Row(
      children: [
        _periodLabelCell(period),
        ...locations.expand(
          (loc) => rooms.map((room) {
            final slotKey = '$loc|$room';
            final group = scheduleData[day]![slotKey]![period]!;
            return _dataCell(group);
          }),
        ),
      ],
    );
  }

  Widget _periodLabelCell(String period) {
    final bool isMorning = period == 'صباحًا';
    return Container(
      width: _periodColWidth,
      height: _bodyRowHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.green[100],
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
          left: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMorning ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            size: 13,
            color: Colors.green[800],
          ),
          const SizedBox(width: 4),
          Text(
            period,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.green[900],
            ),
          ),
        ],
      ),
    );
  }

  /// خلية تعرض اسم الفوج، وتُميَّز بصريًا إذا كانت تطابق فوج الطالب.
  Widget _dataCell(String group) {
    final bool isMine = group == studentGroup;

    return Container(
      width: _roomColWidth,
      height: _bodyRowHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isMine ? Colors.green[700] : Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
          left: BorderSide(color: Colors.grey.shade300),
        ),
        boxShadow: isMine
            ? [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.4),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            group,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isMine ? FontWeight.bold : FontWeight.normal,
              color: isMine ? Colors.white : Colors.black87,
            ),
          ),
          if (isMine)
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.amber[600],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '(فوجي)',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
