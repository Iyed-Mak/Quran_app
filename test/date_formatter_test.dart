import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/utils/date_formatter.dart';

void main() {
  group('formatDzDate', () {
    test('formats a known date with Algerian month names', () {
      final date = DateTime(2025, 1, 15);
      expect(formatDzDate(date), '15 جانفي 2025');
    });

    test('returns a fallback string for null dates', () {
      expect(formatDzDate(null), 'لم يتم تحديد التاريخ');
    });
  });
}
