const List<String> _algerianMonths = [
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

String formatDzDate(DateTime? date) {
  if (date == null) {
    return 'لم يتم تحديد التاريخ';
  }

  final monthName = _algerianMonths[date.month - 1];
  return '${date.day} $monthName ${date.year}';
}
