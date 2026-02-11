import 'package:flutter/material.dart';

class CastScreen extends StatelessWidget {
  const CastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to device'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Searching for devices...',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.tv),
            title: const Text('Living Room TV'),
            subtitle: const Text('Ready to cast'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Connecting to Living Room TV...')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.tv),
            title: const Text('Bedroom TV'),
            subtitle: const Text('Ready to cast'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Connecting to Bedroom TV...')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Learn more about casting'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
