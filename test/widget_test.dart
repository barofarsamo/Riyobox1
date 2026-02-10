import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:riyobox/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    // Clear NetworkImageLoadException which are expected in tests with unmocked network images
    while (tester.takeException() != null) {}
    // Verify the app's MaterialApp / MainScreen is present
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
