// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:strapi_intergration/main.dart';

void main() {
  testWidgets('Splash screen transitions to events list', (tester) async {
    await tester.pumpWidget(const TechEventsApp());

    expect(find.text('Global Tech Solutions'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Tech-Events Hub'), findsWidgets);
  });
}
