import 'package:flutter/material.dart';
import 'package:riyobox/services/sports_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class SportsSearchScreen extends StatefulWidget {
  const SportsSearchScreen({super.key});

  @override
  State<SportsSearchScreen> createState() => _SportsSearchScreenState();
}

class _SportsSearchScreenState extends State<SportsSearchScreen> {
  final SportsService _sportsService = SportsService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _results = [];
  bool _isLoading = false;
  String _searchType = 'teams';

  Future<void> _onSearch(String query) async {
    if (query.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final response = await _sportsService.search(_searchType, query);
      setState(() => _results = response['response'] ?? []);
    } catch (e) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search $_searchType...',
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onSubmitted: _onSearch,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) => setState(() {
              _searchType = val;
              _results = [];
              _searchController.clear();
            }),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'teams', child: Text('Teams')),
              const PopupMenuItem(value: 'players', child: Text('Players')),
              const PopupMenuItem(value: 'leagues', child: Text('Leagues')),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, index) {
              final item = _results[index];
              if (_searchType == 'teams') return _buildTeamTile(item);
              if (_searchType == 'players') return _buildPlayerTile(item);
              if (_searchType == 'leagues') return _buildLeagueTile(item);
              return const SizedBox();
            },
          ),
    );
  }

  Widget _buildTeamTile(dynamic data) {
    final team = data['team'];
    return ListTile(
      leading: CachedNetworkImage(imageUrl: team['logo'], width: 40, height: 40),
      title: Text(team['name'], style: const TextStyle(color: Colors.white)),
      subtitle: Text(team['country'], style: const TextStyle(color: Colors.grey)),
      onTap: () => context.push('/sports/team/${team['id']}'),
    );
  }

  Widget _buildPlayerTile(dynamic data) {
    final player = data['player'];
    return ListTile(
      leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(player['photo'])),
      title: Text(player['name'], style: const TextStyle(color: Colors.white)),
      subtitle: Text('${player['nationality']} | ${player['age']} years'),
    );
  }

  Widget _buildLeagueTile(dynamic data) {
    final league = data['league'];
    return ListTile(
      leading: CachedNetworkImage(imageUrl: league['logo'], width: 40, height: 40),
      title: Text(league['name'], style: const TextStyle(color: Colors.white)),
      subtitle: Text(data['country']['name'], style: const TextStyle(color: Colors.grey)),
      onTap: () => context.push('/sports/league/${league['id']}/2023'),
    );
  }
}
