import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/pages/Admin/widgets/dashboard_card.dart';

void main() {
  testWidgets('DashboardCard keeps long descriptions compact on small widths', (
    tester,
  ) async {
    const longDescription =
        'قوائم الأساتذة، الحضور، الأداء وملاحظات الإدارة للمتابعة اليومية';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 140,
              child: DashboardCard(
                icon: Icons.school,
                title: 'متابعة الأساتذة',
                description: longDescription,
                gradientStart: const Color(0xff2E7D32),
                gradientEnd: const Color(0xff66BB6A),
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );

    final descriptionText = tester.widget<Text>(find.text(longDescription));
    expect(descriptionText.maxLines, greaterThanOrEqualTo(3));
    expect(descriptionText.overflow, TextOverflow.ellipsis);
  });
}
