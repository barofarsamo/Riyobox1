import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://picsum.photos/seed/avatar/200/200'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'User Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'user@example.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildProfileSection(
              title: 'My List',
              icon: Icons.add,
              onTap: () {},
            ),
            _buildProfileSection(
              title: 'App Settings',
              icon: Icons.settings,
              onTap: () {},
            ),
            _buildProfileSection(
              title: 'Account',
              icon: Icons.person_outline,
              onTap: () {},
            ),
            _buildProfileSection(
              title: 'Sign Out',
              icon: Icons.logout,
              onTap: () {},
              textColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.white),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.white),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
