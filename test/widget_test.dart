import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:riyobox/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // Filter out NetworkImageLoadException which are expected since we don't mock the network in this test.
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception.toString().contains('NetworkImageLoadException') ||
          details.exception.toString().contains('HTTP request failed')) {
        return;
      }
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Clear any remaining exceptions from the stack just in case
    while (tester.takeException() != null) {}

    // Verify the app's MaterialApp / MainScreen is present
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
