import 'package:flutter/material.dart';
import 'dart:async';

class CastScreen extends StatefulWidget {
  const CastScreen({super.key});

  @override
  State<CastScreen> createState() => _CastScreenState();
}

class _CastScreenState extends State<CastScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isScanning = true;
  final List<Map<String, String>> _devices = [];
  String? _connectedDeviceId;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _startScanning();
  }

  void _startScanning() {
    setState(() {
      _devices.clear();
      _isScanning = true;
    });

    // Simulate device discovery
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _devices.add({'id': '1', 'name': 'Living Room TV', 'type': 'Samsung Smart TV'});
        });
      }
    });
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _devices.add({'id': '2', 'name': 'Bedroom Chromecast', 'type': 'Google Cast'});
          _isScanning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _connectToDevice(Map<String, String> device) {
    setState(() {
      _isConnecting = true;
      _connectedDeviceId = device['id'];
    });

    // Simulate connection process
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connected to ${device['name']}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C2A),
        title: const Text('Cast to Device', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (!_isScanning)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.yellow),
              onPressed: _startScanning,
            ),
        ],
      ),
      body: Column(
        children: [
          if (_isScanning)
            _buildScanningIndicator()
          else if (_devices.isEmpty)
            _buildNoDevicesFound()
          else
            Expanded(child: _buildDeviceList()),

          _buildHelpSection(),
        ],
      ),
    );
  }

  Widget _buildScanningIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        children: [
          RotationTransition(
            turns: _controller,
            child: const Icon(Icons.track_changes, size: 80, color: Colors.yellow),
          ),
          const SizedBox(height: 24),
          const Text(
            'Scanning for devices...',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Make sure your TV is on the same Wi-Fi',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDevicesFound() {
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tv_off, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('No devices found', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _devices.length,
      itemBuilder: (context, index) {
        final device = _devices[index];
        final isConnectingThis = _isConnecting && _connectedDeviceId == device['id'];
        final isConnectedThis = !_isConnecting && _connectedDeviceId == device['id'];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A3A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isConnectedThis ? Colors.yellow : Colors.transparent,
              width: 1,
            ),
          ),
          child: ListTile(
            leading: Icon(
              device['type']!.contains('Chromecast') ? Icons.cast : Icons.tv,
              color: isConnectedThis ? Colors.yellow : Colors.white,
            ),
            title: Text(device['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(
              isConnectingThis ? 'Connecting...' : (isConnectedThis ? 'Connected' : device['type']!),
              style: TextStyle(color: isConnectingThis || isConnectedThis ? Colors.yellow : Colors.grey),
            ),
            trailing: isConnectingThis
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.yellow))
              : (isConnectedThis ? const Icon(Icons.check_circle, color: Colors.yellow) : const Icon(Icons.chevron_right, color: Colors.grey)),
            onTap: isConnectingThis || isConnectedThis ? null : () => _connectToDevice(device),
          ),
        );
      },
    );
  }

  Widget _buildHelpSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF232334),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.help_outline, color: Colors.grey),
            title: Text('Trouble connecting?', style: TextStyle(color: Colors.white)),
            subtitle: Text('Get help with casting to your TV', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Open Troubleshooting Guide'),
            ),
          ),
        ],
      ),
    );
  }
}
