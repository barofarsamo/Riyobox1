import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'dart:async';
import 'dart:developer' as developer;

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isControlsVisible = true;
  Timer? _hideControlsTimer;
  double _currentVolume = 0.5;
  double _currentBrightness = 0.5;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
    )..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
          _startHideControlsTimer();
        }
      });

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _initVolume();
    _initBrightness();
  }

  Future<void> _initVolume() async {
    _currentVolume = await FlutterVolumeController.getVolume() ?? 0.5;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initBrightness() async {
    try {
      _currentBrightness = await ScreenBrightness().application;
    } catch (e) {
      developer.log('Failed to get current brightness: $e', name: 'video_player_screen');
      _currentBrightness = 0.5;
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleControls() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
    });
    if (_isControlsVisible) {
      _startHideControlsTimer();
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() {
          _isControlsVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _controller.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: <Widget>[
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const CircularProgressIndicator(),
            ),
            if (_isControlsVisible) _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      color: Colors.black54,
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Back',
            ),
          ),
          const Spacer(),
          _buildPlaybackControls(),
          const Spacer(),
          _buildSliders(),
        ],
      ),
    );
  }

  Widget _buildPlaybackControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10, color: Colors.white, size: 40),
          tooltip: 'Rewind 10 seconds',
          onPressed: () {
            _controller.seekTo(
              _controller.value.position - const Duration(seconds: 10),
            );
          },
        ),
        IconButton(
          icon: Icon(
            _controller.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
            color: Colors.white,
            size: 60,
          ),
          tooltip: _controller.value.isPlaying ? 'Pause' : 'Play',
          onPressed: () {
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
              _startHideControlsTimer();
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.forward_10, color: Colors.white, size: 40),
          tooltip: 'Fast forward 10 seconds',
          onPressed: () {
            _controller.seekTo(
              _controller.value.position + const Duration(seconds: 10),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSliders() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.volume_up, color: Colors.white),
              Expanded(
                child: Slider(
                  value: _currentVolume,
                  label: 'Volume: ${(_currentVolume * 100).toInt()}%',
                  divisions: 100,
                  onChanged: (value) {
                    setState(() {
                      _currentVolume = value;
                      FlutterVolumeController.setVolume(_currentVolume);
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.brightness_6, color: Colors.white),
              Expanded(
                child: Slider(
                  value: _currentBrightness,
                  label: 'Brightness: ${(_currentBrightness * 100).toInt()}%',
                  divisions: 100,
                  onChanged: (value) {
                    setState(() {
                      _currentBrightness = value;
                      ScreenBrightness().setApplicationScreenBrightness(_currentBrightness);
                    });
                  },
                ),
              ),
            ],
          ),
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Colors.red,
              bufferedColor: Colors.grey,
              backgroundColor: Colors.white24,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_controller.value.position),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                _formatDuration(_controller.value.duration),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
