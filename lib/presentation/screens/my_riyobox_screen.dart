
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riyobox/presentation/widgets/shimmer_loading.dart';

class MyRiyoboxScreen extends StatelessWidget {
  const MyRiyoboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentlyWatched = [
      {
        'id': '1',
        'title': 'Inception',
        'details': '2010 • Action • 8.3',
        'image': 'https://image.tmdb.org/t/p/w500/edv5CZvfkjSfm9kfCghQ9KyTM9J.jpg'
      },
      {
        'id': '6',
        'title': 'The Boys',
        'details': '2019 • Sci-Fi • 8.7',
        'image': 'https://image.tmdb.org/t/p/w500/7YvYvS337oNooT5YIrj6i6H8E2C.jpg'
      },
      {
        'id': '3',
        'title': 'Interstellar',
        'details': '2014 • Adventure • 8.4',
        'image': 'https://image.tmdb.org/t/p/w500/gEU2QniE6EwfVDxCzs25vQO2Cq9.jpg'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C2A),
        elevation: 0,
        title: const Text('My RIYOBOX', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.cast, color: Colors.white),
            onPressed: () => context.push('/cast'),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => context.push('/settings'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => context.push('/profile'),
              child: const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                    'https://picsum.photos/seed/profile/100/100'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 24),
            _buildStatsSection(context),
            const SizedBox(height: 32),
            _buildSectionHeader('Recently Watched', onTap: () {
               // Show history
            }),
            const SizedBox(height: 16),
            _buildRecentlyWatchedList(context, recentlyWatched),
            const SizedBox(height: 32),
            _buildSectionHeader('ACCOUNT SETTINGS', showArrow: false),
            const SizedBox(height: 16),
            _buildAccountSettings(context),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => context.push('/profile'),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomRight,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://picsum.photos/seed/mainprofile/200/200'),
              ),
              Positioned(
                right: -5,
                bottom: -5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF1C1C2A), width: 2),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.edit, color: Colors.black, size: 20),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('Jules Engineer', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.yellow.withAlpha(51),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.yellow, width: 1),
          ),
          child: const Text('PREMIUM MEMBER', style: TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(context, '5', 'WATCHLIST', () {}),
        _buildStatItem(context, '10', 'HISTORY', () {}),
        _buildStatItem(context, '12', 'DOWNLOADS', () => context.go('/downloads')),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showArrow = true, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          if (showArrow)
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  Widget _buildRecentlyWatchedList(BuildContext context, List<Map<String, dynamic>> items) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => context.push('/movie/${item['id']}'),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Image.network(
                        item['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                         loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const ShimmerLoading.rectangular(height: 200);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(item['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(item['details']!, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Column(
      children: [
        _buildSettingsButton(
          context,
          icon: Icons.person_outline,
          text: 'Profile Information',
          onTap: () => context.push('/profile'),
        ),
        const SizedBox(height: 12),
        _buildSettingsButton(
          context,
          icon: Icons.settings_outlined,
          text: 'App Settings',
          onTap: () => context.push('/settings'),
        ),
        const SizedBox(height: 12),
         _buildSettingsButton(
          context,
          icon: Icons.subscriptions_outlined,
          text: 'Subscription Plans',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Subscription management coming soon!')),
            );
          },
        ),
        const SizedBox(height: 24),
        _buildSettingsButton(
          context,
          icon: Icons.logout,
          text: 'Logout',
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: () {
             showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFF2A2A3A),
                title: const Text('Logout', style: TextStyle(color: Colors.white)),
                content: const Text('Are you sure you want to logout?', style: TextStyle(color: Colors.grey)),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white))),
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Logout', style: TextStyle(color: Colors.red))),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingsButton(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap, Color iconColor = Colors.yellow, Color textColor = Colors.white}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A3A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withAlpha(13), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Expanded(child: Text(text, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500))),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text('RIYOBOX PREMIUM V2.4.0', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Cloud ID: 9L6k4d38', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}
