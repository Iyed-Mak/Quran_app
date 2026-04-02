import 'package:flutter_test/flutter_test.dart';

import 'package:quran_app/main.dart';

void main() {
  testWidgets('App shows login', (WidgetTester tester) async {
    await tester.pumpWidget(const QuranApp());
    expect(find.text('Login'), findsWidgets);
    expect(find.text('دخول كطالب'), findsOneWidget);
  });
}
