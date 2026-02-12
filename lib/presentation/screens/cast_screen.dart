import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riyobox/services/cast_service.dart';
import 'package:flutter_cast_video/flutter_cast_video.dart';

class CastScreen extends StatefulWidget {
  const CastScreen({super.key});

  @override
  State<CastScreen> createState() => _CastScreenState();
}

class _CastScreenState extends State<CastScreen> {
  final String _sampleVideoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  @override
  Widget build(BuildContext context) {
    final castService = context.watch<CastService>();

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        title: const Text('CAST TO DEVICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cast, size: 100, color: Colors.white10),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Connect to a Chromecast or Android TV to start watching on the big screen.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            const SizedBox(height: 48),
            // The official Cast Button
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: ChromeCastButton(
                size: 40,
                color: Colors.white,
                onButtonCreated: (controller) {
                  castService.setController(controller);
                },
                onSessionStarted: () {
                  castService.updateConnectionStatus(true);
                  // We can't use controller here, we must use the one from setController
                },
                onSessionEnded: () {
                  castService.updateConnectionStatus(false);
                },
                onRequestFailed: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cast failed: $error'), backgroundColor: Colors.red),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'TAP TO CAST',
              style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: castService.isConnected
                ? () => castService.loadMedia(_sampleVideoUrl)
                : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                disabledBackgroundColor: Colors.white10,
              ),
              child: const Text('START CASTING VIDEO'),
            ),
            if (castService.isConnected) ...[
              const SizedBox(height: 16),
              const Text('Connected to TV', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Playing: Big Buck Bunny', style: TextStyle(color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }
}
