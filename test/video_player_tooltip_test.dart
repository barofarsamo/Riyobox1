import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riyobox/presentation/screens/video_player_screen.dart';
import 'package:riyobox/presentation/widgets/custom_controls.dart';
import 'package:video_player/video_player.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

// Mock VideoPlayerPlatform to avoid errors during initialization
class MockVideoPlayerPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements VideoPlayerPlatform {
  @override
  Future<void> init() async {}

  @override
  Future<int> create(DataSource dataSource) async {
    return 1;
  }

  @override
  Future<int> createWithOptions(VideoCreationOptions options) async {
    return 1;
  }

  @override
  Stream<VideoEvent> videoEventsFor(int textureId) {
    return const Stream<VideoEvent>.empty();
  }

  @override
  Future<void> setVolume(int textureId, double volume) async {}

  @override
  Future<void> play(int textureId) async {}

  @override
  Future<void> pause(int textureId) async {}

  @override
  Future<void> dispose(int textureId) async {}
}

void main() {
  setUp(() {
    VideoPlayerPlatform.instance = MockVideoPlayerPlatform();
  });

  testWidgets('VideoPlayerScreen has correct tooltips', (WidgetTester tester) async {
    // Ignore network image errors
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception.toString().contains('NetworkImageLoadException') ||
          details.exception.toString().contains('HTTP request failed')) {
        return;
      }
      originalOnError?.call(details);
    };

    addTearDown(() {
      FlutterError.onError = originalOnError;
    });

    await tester.pumpWidget(const MaterialApp(home: VideoPlayerScreen()));

    // The controls are visible by default
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(find.byTooltip('Replay 10 seconds'), findsOneWidget);
    expect(find.byTooltip('Forward 10 seconds'), findsOneWidget);

    // Check for either Play or Pause tooltip
    expect(
      find.byWidgetPredicate((widget) =>
          widget is IconButton && (widget.tooltip == 'Play' || widget.tooltip == 'Pause')),
      findsOneWidget,
    );
  });

  testWidgets('CustomControls has dynamic Play/Pause tooltip', (WidgetTester tester) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse('https://example.com/video.mp4'));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomControls(controller: controller),
      ),
    ));

    // Initially should be 'Play' because isPlaying is false
    expect(find.byTooltip('Play'), findsOneWidget);
  });
}
