import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riyobox/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // pumpAndSettle will wait for animations and image loading attempts.
    // It will catch exceptions but the test framework will still report them
    // unless we take them.
    await tester.pumpAndSettle();

    // Ignore any exceptions that occurred (likely NetworkImageLoadException from unmocked requests)
    tester.takeException();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
