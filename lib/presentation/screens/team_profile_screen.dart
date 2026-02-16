import 'package:flutter/material.dart';
import 'package:riyobox/services/sports_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TeamProfileScreen extends StatefulWidget {
  final int teamId;

  const TeamProfileScreen({super.key, required this.teamId});

  @override
  State<TeamProfileScreen> createState() => _TeamProfileScreenState();
}

class _TeamProfileScreenState extends State<TeamProfileScreen> {
  final SportsService _sportsService = SportsService();
  dynamic _teamData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeamInfo();
  }

  Future<void> _loadTeamInfo() async {
    try {
      final response = await _sportsService.getTeamInfo(widget.teamId);
      if (mounted) {
        setState(() {
          _teamData = response['response'][0];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(backgroundColor: Color(0xFF141414), body: Center(child: CircularProgressIndicator()));
    if (_teamData == null) return const Scaffold(body: Center(child: Text('Team not found')));

    final team = _teamData['team'];
    final venue = _teamData['venue'];

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        title: Text(team['name'].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: CachedNetworkImage(imageUrl: team['logo'], height: 120, width: 120),
            ),
            const SizedBox(height: 24),
            Text(team['name'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            Text('${team['country']}, Founded in ${team['founded']}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _buildSectionHeader('VENUE'),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.deepPurpleAccent),
              title: Text(venue['name'], style: const TextStyle(color: Colors.white)),
              subtitle: Text('${venue['city']}, Capacity: ${venue['capacity']}'),
              trailing: CachedNetworkImage(imageUrl: venue['image'], width: 80, height: 60, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white10,
      child: Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
