
import 'package:flutter/material.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C2A),
        elevation: 0,
        title: const Text('RIYOBOX', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.cast, color: Colors.white),
            onPressed: () {},
            tooltip: 'Cast to device',
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
            tooltip: 'Settings',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Semantics(
              label: 'User profile',
              child: const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://picsum.photos/seed/profile/100/100'),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.download,
                  size: 80,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No Downloads Yet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Movies and TV shows you download will appear here so you can watch them offline.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // In a real app, this might navigate to Home or Categories
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Find something to watch',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
