// اختبار دخان بسيط: يتأكد أن التطبيق يُقلع دون أخطاء بناء.
import 'package:flutter_test/flutter_test.dart';

import 'package:skincare/main.dart';

void main() {
  testWidgets('App boots without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const DermalyzeApp());
    // أول إطار: يجب أن تظهر بوابة الدخول (مؤشر تحميل أثناء فحص التوكن).
    await tester.pump();
    expect(find.byType(DermalyzeApp), findsOneWidget);
  });
}
