import 'package:flutter_test/flutter_test.dart';
import 'package:riyobox/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our title is present.
    // Note: This test might catch pre-existing NetworkImageLoadException
    // because the app makes real network requests during the build.
    expect(find.textContaining('RIYO'), findsWidgets);
  });
}
