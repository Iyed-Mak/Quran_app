import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════
// dz_date_picker.dart
//
// منتقي تاريخ مخصص بالأشهر الجزائرية (جانفي، فيفري ...)
//
// الاستخدام:
//
//   // 1 — دالة مساعدة (الأسهل):
//   final DateTime? picked = await showDzDatePicker(
//     context:     context,
//     initialDate: myDate,           // اختياري
//     minYear:     2000,             // اختياري — افتراضي: currentYear-25
//     maxYear:     2022,             // اختياري — افتراضي: currentYear-4
//   );
//   if (picked != null) { ... }
//
//   // 2 — ويدجت مباشرة داخل Dialog/BottomSheet:
//   DzDatePickerSheet(
//     initialDate: myDate,
//     minYear:     2000,
//     maxYear:     2022,
//     isDialog:    true,
//   )
// ═══════════════════════════════════════════════════════════════════

/// أسماء الأشهر بالطريقة الجزائرية (مستوحاة من الفرنسية)
const List<String> kDzMonths = [
  'جانفي',
  'فيفري',
  'مارس',
  'أفريل',
  'ماي',
  'جوان',
  'جويلية',
  'أوت',
  'سبتمبر',
  'أكتوبر',
  'نوفمبر',
  'ديسمبر',
];

// ── ألوان افتراضية تتبع نظام ألوان وحدة الإدارة ──
const Color _kPrimary = Color(0xff1565C0);
const Color _kEnd = Color(0xff42A5F5);

// ─────────────────────────────────────────────────────────────────
// الدالة المساعدة العامة — هذه هي نقطة الاستخدام الموصى بها
// ─────────────────────────────────────────────────────────────────

/// يعرض منتقي التاريخ الجزائري ويُرجع التاريخ المختار أو null.
///
/// - على الشاشات العريضة (>= 600 px) يظهر كـ Dialog.
/// - على الهاتف يظهر كـ BottomSheet.
///
/// مثال:
/// ```dart
/// final date = await showDzDatePicker(context: context);
/// if (date != null) setState(() => _selectedDate = date);
/// ```
Future<DateTime?> showDzDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  int? minYear,
  int? maxYear,
  Color primaryColor = _kPrimary,
  Color endColor = _kEnd,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final now = DateTime.now();
  final minY = minYear ?? now.year - 100;
  final maxY = maxYear ?? now.year - 4;
  final initDate = initialDate ?? DateTime(now.year - 10);

  final bool isWide = MediaQuery.of(context).size.width >= 600;

  final sheet = DzDatePickerSheet(
    initialDate: initDate,
    minYear: minY,
    maxYear: maxY,
    isDialog: isWide,
    primaryColor: primaryColor,
    endColor: endColor,
  );

  if (isWide) {
    return showDialog<DateTime>(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 60,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: sheet,
          ),
        ),
      ),
    );
  } else {
    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => sheet,
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// DzDatePickerSheet — الويدجت الرئيسية
// ─────────────────────────────────────────────────────────────────

/// ويدجت منتقي التاريخ الجزائري.
/// يمكن تضمينه في Dialog أو BottomSheet أو أي حاوية أخرى.
class DzDatePickerSheet extends StatefulWidget {
  const DzDatePickerSheet({
    super.key,
    required this.initialDate,
    required this.minYear,
    required this.maxYear,
    this.isDialog = false,
    this.primaryColor = _kPrimary,
    this.endColor = _kEnd,
  });

  /// التاريخ الأولي المعروض عند الفتح
  final DateTime initialDate;

  /// أصغر سنة يمكن اختيارها
  final int minYear;

  /// أكبر سنة يمكن اختيارها
  final int maxYear;

  /// true → حواف مستديرة من جميع الجهات (للـ Dialog)
  /// false → حواف مستديرة من الأعلى فقط (للـ BottomSheet)
  final bool isDialog;

  /// لون التدرج الأساسي (يطابق لون وحدة الإدارة أو المعلم)
  final Color primaryColor;

  /// لون التدرج الثانوي
  final Color endColor;

  @override
  State<DzDatePickerSheet> createState() => _DzDatePickerSheetState();
}

class _DzDatePickerSheetState extends State<DzDatePickerSheet> {
  late int _day;
  late int _month;
  late int _year;

  late FixedExtentScrollController _dayCtrl;
  late FixedExtentScrollController _monthCtrl;
  late FixedExtentScrollController _yearCtrl;

  /// قائمة السنوات تنازلياً — الأحدث أولاً
  late List<int> _years;

  @override
  void initState() {
    super.initState();

    _day = widget.initialDate.day;
    _month = widget.initialDate.month;
    _year = widget.initialDate.year.clamp(widget.minYear, widget.maxYear);

    _years = List.generate(
      widget.maxYear - widget.minYear + 1,
      (i) => widget.maxYear - i,
    );

    _dayCtrl = FixedExtentScrollController(initialItem: _day - 1);
    _monthCtrl = FixedExtentScrollController(initialItem: _month - 1);
    _yearCtrl = FixedExtentScrollController(
      initialItem: _years.indexOf(_year).clamp(0, _years.length - 1),
    );
  }

  @override
  void dispose() {
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  // ── حساب عدد أيام الشهر ──
  int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  // ── تصحيح اليوم إذا تجاوز حدود الشهر/السنة الجديد ──
  void _fixDay() {
    final maxDay = _daysInMonth(_year, _month);
    if (_day > maxDay) {
      _day = maxDay;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_dayCtrl.hasClients) _dayCtrl.jumpToItem(_day - 1);
      });
    }
  }

  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final BorderRadius outerRadius = widget.isDialog
        ? BorderRadius.circular(24)
        : const BorderRadius.vertical(top: Radius.circular(24));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: outerRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── مقبض السحب (BottomSheet فقط) ──
            if (!widget.isDialog)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

            // ── رأس التاريخ المحدد ──
            Container(
              margin: EdgeInsets.fromLTRB(12, widget.isDialog ? 12 : 8, 12, 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.primaryColor, widget.endColor],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'اختر التاريخ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  // معاينة التاريخ المحدد
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Text(
                      '$_day ${kDzMonths[_month - 1]} $_year',
                      key: ValueKey('$_day/$_month/$_year'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── رؤوس الأعمدة ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _colHeader('اليوم', flex: 2),
                  _colHeader('الشهر', flex: 3),
                  _colHeader('السنة', flex: 2),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // ── أعجلة التمرير ──
            SizedBox(
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // شريط التمييز المركزي
                  Container(
                    height: 46,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: widget.primaryColor.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: widget.primaryColor.withValues(alpha: 0.18),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // اليوم
                        Expanded(
                          flex: 2,
                          child: DzWheelPicker(
                            controller: _dayCtrl,
                            items: List.generate(
                              _daysInMonth(_year, _month),
                              (i) => '${i + 1}',
                            ),
                            onChanged: (i) => setState(() => _day = i + 1),
                            primaryColor: widget.primaryColor,
                          ),
                        ),

                        _vDivider(),

                        // الشهر
                        Expanded(
                          flex: 3,
                          child: DzWheelPicker(
                            controller: _monthCtrl,
                            items: kDzMonths,
                            onChanged: (i) {
                              setState(() => _month = i + 1);
                              _fixDay();
                            },
                            primaryColor: widget.primaryColor,
                          ),
                        ),

                        _vDivider(),

                        // السنة
                        Expanded(
                          flex: 2,
                          child: DzWheelPicker(
                            controller: _yearCtrl,
                            items: _years.map((y) => '$y').toList(),
                            onChanged: (i) {
                              setState(() => _year = _years[i]);
                              _fixDay();
                            },
                            primaryColor: widget.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: Colors.grey.shade100, height: 1),

            // ── أزرار الإجراءات ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        foregroundColor: Colors.grey.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, DateTime(_year, _month, _day)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'تأكيد',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── ويدجتات مساعدة ──
  Widget _colHeader(String label, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _vDivider() =>
      Container(width: 1, height: 150, color: Colors.grey.shade100);
}

// ─────────────────────────────────────────────────────────────────
// DzWheelPicker — عجلة التمرير الفردية (قابلة لإعادة الاستخدام)
// ─────────────────────────────────────────────────────────────────

/// عجلة تمرير واحدة تُستخدم داخل [DzDatePickerSheet].
/// يمكن استخدامها أيضاً بشكل مستقل لأي قائمة دوّارة.
class DzWheelPicker extends StatelessWidget {
  const DzWheelPicker({
    super.key,
    required this.controller,
    required this.items,
    required this.onChanged,
    this.primaryColor = _kPrimary,
    this.itemExtent = 46.0,
  });

  final FixedExtentScrollController controller;
  final List<String> items;
  final void Function(int) onChanged;
  final Color primaryColor;
  final double itemExtent;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: itemExtent,
      diameterRatio: 2.2,
      perspective: 0.003,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: items.length,
        builder: (context, index) {
          final bool selected =
              controller.hasClients && controller.selectedItem == index;
          return Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                fontSize: selected ? 16 : 14,
                fontWeight: selected ? FontWeight.bold : FontWeight.w400,
                color: selected ? primaryColor : Colors.grey.shade500,
              ),
              child: Text(items[index]),
            ),
          );
        },
      ),
    );
  }
}
