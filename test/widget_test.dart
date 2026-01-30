import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riyobox/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Use pump instead of pumpAndSettle to avoid waiting for images that will fail
    await tester.pump();

    // Verify the app's MaterialApp is present
    expect(find.byType(MaterialApp), findsOneWidget);

    // Ignore any exceptions from network images during teardown
    tester.takeException();
  });
}
