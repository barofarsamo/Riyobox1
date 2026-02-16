import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class SportsVideoPlayer extends StatefulWidget {
  final String url;
  final String title;

  const SportsVideoPlayer({super.key, required this.url, required this.title});

  @override
  State<SportsVideoPlayer> createState() => _SportsVideoPlayerState();
}

class _SportsVideoPlayerState extends State<SportsVideoPlayer> {
  // HIGH-PERFORMANCE C++ VIDEO ENGINE (libmpv)
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    player.open(Media(widget.url));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Video(
          controller: controller,
          fill: Colors.black,
        ),
      ),
    );
  }
}
