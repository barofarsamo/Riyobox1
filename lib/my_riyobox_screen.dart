
import 'package:flutter/material.dart';
import 'package:riyobox/presentation/widgets/shimmer_loading.dart';

class MyRiyoboxScreen extends StatelessWidget {
  const MyRiyoboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> recentlyWatched = [
      {
        'title': 'Reacher',
        'details': '2022 • 2 Seasons • TV-14',
        'image': 'https://picsum.photos/seed/reacher/400/225'
      },
      {
        'title': 'The Office',
        'details': '2005 • 9 Seasons • TV-14',
        'image': 'https://picsum.photos/seed/theoffice/400/225'
      },
      {
        'title': 'Oppenheimer',
        'details': '2023 • 3h 0m',
        'image': 'https://picsum.photos/seed/oppenheimer/400/225'
      },
    ];

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
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Tooltip(
              message: 'User Profile',
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://picsum.photos/seed/profile/100/100'),
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
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildStatsSection(),
            const SizedBox(height: 32),
            _buildSectionHeader('Recently Watched'),
            const SizedBox(height: 16),
            _buildRecentlyWatchedList(recentlyWatched),
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

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomRight,
          children: [
            Semantics(
              label: 'Profile picture',
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://picsum.photos/seed/mainprofile/200/200'),
              ),
            ),
            Positioned(
              right: -5,
              bottom: -5,
              child: Tooltip(
                message: 'Edit Profile',
                child: Material(
                  color: Colors.yellow,
                  shape: const CircleBorder(side: BorderSide(color: Color(0xFF1C1C2A), width: 2)),
                  child: InkWell(
                    onTap: () {},
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.edit, color: Colors.black, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Mmmm', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text('PREMIUM MEMBER', style: TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('0', 'WATCHLIST'),
        _buildStatItem('10', 'HISTORY'),
        _buildStatItem('12', 'DOWNLOADS'),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {bool showArrow = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        if (showArrow)
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      ],
    );
  }

  Widget _buildRecentlyWatchedList(List<Map<String, String>> items) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Stack(
                      children: [
                        Image.network(
                          item['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const ShimmerLoading.rectangular(height: 180);
                          },
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(item['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(item['details']!, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ],
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
          icon: Icons.settings_outlined,
          text: 'Edit Profile & Account',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        _buildSettingsButton(
          context,
          icon: Icons.logout,
          text: 'Logout',
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: () {},
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
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 16),
            Text(text, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text('RIYOBOX PREMIUM V2.4.0', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Text('Cloud ID: 9L6k4d38', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}
