
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riyobox/presentation/screens/video_player_screen.dart';
import 'package:riyobox/presentation/widgets/custom_controls.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVideoPlayerPlatform extends VideoPlayerPlatform {
  @override
  Future<void> init() async {}

  @override
  Future<int?> create(DataSource dataSource) async {
    return 1;
  }

  @override
  Future<int?> createWithOptions(VideoCreationOptions options) async {
    return 1;
  }

  @override
  Stream<VideoEvent> videoEventsFor(int textureId) {
    return Stream<VideoEvent>.fromIterable([
      VideoEvent(
        eventType: VideoEventType.initialized,
        duration: const Duration(minutes: 1),
        size: const Size(1920, 1080),
      ),
    ]);
  }

  @override
  Future<void> initialize(int textureId) async {}
  @override
  Future<void> play(int textureId) async {}
  @override
  Future<void> pause(int textureId) async {}
  @override
  Future<void> setVolume(int textureId, double volume) async {}
  @override
  Future<void> setLooping(int textureId, bool looping) async {}
  @override
  Future<void> setPlaybackSpeed(int textureId, double speed) async {}
  @override
  Future<Duration> getPosition(int textureId) async => Duration.zero;
}

void main() {
  setUp(() {
    VideoPlayerPlatform.instance = MockVideoPlayerPlatform();
  });

  testWidgets('VideoPlayerScreen has tooltips and semantics', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VideoPlayerScreen()));
    await tester.pump();

    // Check tooltips in VideoPlayerScreen
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(find.byTooltip('Rewind 10 seconds'), findsOneWidget);
    expect(find.byTooltip('Fast forward 10 seconds'), findsOneWidget);
    expect(find.byTooltip('Play'), findsOneWidget);

    // Check semantics and slider enhancements
    expect(find.bySemanticsLabel('Volume'), findsOneWidget);
    expect(find.bySemanticsLabel('Brightness'), findsOneWidget);

    final volumeSlider = tester.widget<Slider>(find.descendant(
      of: find.bySemanticsLabel('Volume'),
      matching: find.byType(Slider),
    ));
    expect(volumeSlider.divisions, 100);
    expect(volumeSlider.label, isNotNull);
  });

  testWidgets('CustomControls has dynamic tooltip', (WidgetTester tester) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse('http://example.com/video.mp4'));
    await controller.initialize();

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: CustomControls(controller: controller))));

    // Initially playing is false, should show 'Play'
    expect(find.byTooltip('Play'), findsOneWidget);

    // We don't need to test the toggle logic here as we're focusing on the UX addition (the tooltip existence)
  });
}
