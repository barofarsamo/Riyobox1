import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:riyobox/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // Ignore network image errors as they fail during tests without mocking
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception is NetworkImageLoadException ||
          details.exception.toString().contains('HTTP request failed')) {
        return;
      }
      originalOnError?.call(details);
    };

    addTearDown(() {
      FlutterError.onError = originalOnError;
    });

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    // Verify the app's MaterialApp / MainScreen is present
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
