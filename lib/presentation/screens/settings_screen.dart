import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riyobox/providers/settings_provider.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C2A),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Account & Notifications'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications, color: Colors.yellow),
            title: const Text('Notifications', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Receive alerts for new movies', style: TextStyle(color: Colors.grey)),
            value: settings.notificationsEnabled,
            onChanged: (bool value) {
              settings.toggleNotifications(value);
            },
            activeColor: Colors.yellow,
          ),
          _buildDivider(),
          _buildSectionHeader('Preferences'),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.yellow),
            title: const Text('Language', style: TextStyle(color: Colors.white)),
            subtitle: Text(settings.language, style: const TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () => _showLanguageDialog(context, settings),
          ),
          ListTile(
            leading: const Icon(Icons.video_settings, color: Colors.yellow),
            title: const Text('Playback Quality', style: TextStyle(color: Colors.white)),
            subtitle: Text(settings.playbackQuality, style: const TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () => _showPlaybackDialog(context, settings),
          ),
          _buildDivider(),
          _buildSectionHeader('Support & Info'),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.yellow),
            title: const Text('Help Center', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF2A2A3A),
                builder: (modalContext) => _buildSupportContent(modalContext, 'Help Center', 'How can we help you today? Contact us at support@riyobox.com'),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.yellow),
            title: const Text('About RIYOBOX', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
               showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF2A2A3A),
                builder: (modalContext) => _buildSupportContent(modalContext, 'About RIYOBOX', 'RIYOBOX is your ultimate destination for movies and series. Version 2.4.0'),
              );
            },
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Log Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text('RIYOBOX v2.4.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.grey, thickness: 0.2, indent: 16, endIndent: 16);
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3A),
        title: const Text('Select Language', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption(context, 'English', settings.language == 'English', () {
              settings.setLanguage('English');
              Navigator.pop(context);
            }),
            _buildDialogOption(context, 'Arabic', settings.language == 'Arabic', () {
              settings.setLanguage('Arabic');
              Navigator.pop(context);
            }),
             _buildDialogOption(context, 'Somali', settings.language == 'Somali', () {
              settings.setLanguage('Somali');
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  void _showPlaybackDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3A),
        title: const Text('Playback Quality', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption(context, 'Auto', settings.playbackQuality == 'Auto', () {
              settings.setPlaybackQuality('Auto');
              Navigator.pop(context);
            }),
            _buildDialogOption(context, 'Full HD', settings.playbackQuality == 'Full HD', () {
              settings.setPlaybackQuality('Full HD');
              Navigator.pop(context);
            }),
            _buildDialogOption(context, 'HD', settings.playbackQuality == 'HD', () {
              settings.setPlaybackQuality('HD');
              Navigator.pop(context);
            }),
            _buildDialogOption(context, 'Data Saver', settings.playbackQuality == 'Data Saver', () {
              settings.setPlaybackQuality('Data Saver');
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogOption(BuildContext context, String title, bool isSelected, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.yellow) : null,
      onTap: onTap,
    );
  }

  Widget _buildSupportContent(BuildContext context, String title, String content) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(content, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context), // Close the bottom sheet
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, foregroundColor: Colors.black),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3A),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to logout from RIYOBOX?', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              // Perform actual logout logic if needed
              Navigator.pop(context);
              context.go('/home'); // Redirect to home or login screen
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
