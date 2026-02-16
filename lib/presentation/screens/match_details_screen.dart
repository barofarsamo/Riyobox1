import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riyobox/providers/sports_provider.dart';
import 'package:riyobox/services/sports_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MatchDetailsScreen extends StatefulWidget {
  final int fixtureId;

  const MatchDetailsScreen({super.key, required this.fixtureId});

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SportsService _sportsService = SportsService();
  dynamic _matchData;
  List<dynamic>? _stats;
  List<dynamic>? _events;
  List<dynamic>? _lineups;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      final results = await Future.wait([
        _sportsService.getMatchDetails(widget.fixtureId),
        _sportsService.getMatchStatistics(widget.fixtureId),
        _sportsService.getMatchEvents(widget.fixtureId),
        _sportsService.getMatchLineups(widget.fixtureId),
      ]);

      if (mounted) {
        setState(() {
          _matchData = results[0]['response'][0];
          _stats = results[1]['response'];
          _events = results[2]['response'];
          _lineups = results[3]['response'];
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
    if (_matchData == null) return const Scaffold(body: Center(child: Text('Match not found')));

    final home = _matchData['teams']['home'];
    final away = _matchData['teams']['away'];
    final goals = _matchData['goals'];
    final provider = Provider.of<SportsProvider>(context);
    final streamUrl = provider.getStreamForMatch(widget.fixtureId);

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: const Color(0xFF1C1C1C),
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                   _buildScoreHeader(home, away, goals, _matchData['fixture']['status']),
                   if (streamUrl != null)
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 24),
                       child: ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/sports/play', arguments: {'url': streamUrl, 'title': '${home['name']} vs ${away['name']}'}),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('WATCH LIVE NOW'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(double.infinity, 40)),
                       ),
                     ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.deepPurpleAccent,
              tabs: const [
                Tab(text: 'INFO'),
                Tab(text: 'STATS'),
                Tab(text: 'LINEUPS'),
                Tab(text: 'EVENTS'),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInfoTab(),
                _buildStatsTab(),
                _buildLineupsTab(),
                _buildEventsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreHeader(dynamic home, dynamic away, dynamic goals, dynamic status) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTeamVertical(home['name'], home['logo']),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${goals['home'] ?? 0} - ${goals['away'] ?? 0}',
                style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(status['long'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          _buildTeamVertical(away['name'], away['logo']),
        ],
      ),
    );
  }

  Widget _buildTeamVertical(String name, String logo) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedNetworkImage(imageUrl: logo, width: 60, height: 60),
        const SizedBox(height: 8),
        SizedBox(width: 100, child: Text(name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2)),
      ],
    );
  }

  Widget _buildInfoTab() {
    final venue = _matchData['fixture']['venue'];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoRow('League', _matchData['league']['name']),
        _buildInfoRow('Round', _matchData['league']['round']),
        _buildInfoRow('Date', _matchData['fixture']['date']),
        _buildInfoRow('Venue', '${venue['name']}, ${venue['city']}'),
        _buildInfoRow('Referee', _matchData['fixture']['referee'] ?? 'N/A'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    if (_stats == null || _stats!.isEmpty) return const Center(child: Text('No stats available', style: TextStyle(color: Colors.white)));
    final homeStats = _stats![0]['statistics'];
    final awayStats = _stats![1]['statistics'];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: homeStats.length,
      itemBuilder: (context, index) {
        final statName = homeStats[index]['type'];
        final homeValue = homeStats[index]['value']?.toString() ?? '0';
        final awayValue = awayStats[index]['value']?.toString() ?? '0';
        return _buildStatBar(statName, homeValue, awayValue);
      },
    );
  }

  Widget _buildStatBar(String name, String homeVal, String awayVal) {
    double h = double.tryParse(homeVal.replaceAll('%', '')) ?? 0;
    double a = double.tryParse(awayVal.replaceAll('%', '')) ?? 0;
    double total = h + a;
    double percent = total == 0 ? 0.5 : h / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(homeVal, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(name, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(awayVal, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: percent, backgroundColor: Colors.blueAccent, color: Colors.deepPurpleAccent, minHeight: 4),
        ],
      ),
    );
  }

  Widget _buildLineupsTab() {
    if (_lineups == null || _lineups!.isEmpty) return const Center(child: Text('Lineups not available'));
    return ListView(
      children: [
        _buildTeamLineup(_lineups![0]),
        const Divider(color: Colors.white10),
        _buildTeamLineup(_lineups![1]),
      ],
    );
  }

  Widget _buildTeamLineup(dynamic teamData) {
    final startXI = teamData['startXI'];
    final coach = teamData['coach'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('${teamData['team']['name']} (${teamData['formation']})', style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        ...startXI.map<Widget>((p) => ListTile(
          leading: CircleAvatar(backgroundColor: Colors.white12, child: Text('${p['player']['number']}', style: const TextStyle(fontSize: 12))),
          title: Text(p['player']['name'], style: const TextStyle(color: Colors.white, fontSize: 14)),
          subtitle: Text(p['player']['pos'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
        )).toList(),
        ListTile(
          leading: const Icon(Icons.person, color: Colors.grey),
          title: Text('Coach: ${coach['name']}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildEventsTab() {
    if (_events == null || _events!.isEmpty) return const Center(child: Text('No events recorded'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _events!.length,
      itemBuilder: (context, index) {
        final event = _events![index];
        final isHome = event['team']['id'] == _matchData['teams']['home']['id'];
        return _buildEventItem(event, isHome);
      },
    );
  }

  Widget _buildEventItem(dynamic event, bool isHome) {
    IconData icon;
    Color color;
    switch (event['type']) {
      case 'Goal': icon = Icons.sports_soccer; color = Colors.green; break;
      case 'Card': icon = Icons.rectangle; color = event['detail'] == 'Yellow Card' ? Colors.yellow : Colors.red; break;
      case 'subst': icon = Icons.sync; color = Colors.blue; break;
      default: icon = Icons.info_outline; color = Colors.grey;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isHome ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isHome) ...[
            Text('${event['time']['elapsed']}\'', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(event['player']['name'], style: const TextStyle(color: Colors.white)),
          ] else ...[
             Text(event['player']['name'], style: const TextStyle(color: Colors.white)),
             const SizedBox(width: 8),
             Icon(icon, color: color, size: 18),
             const SizedBox(width: 12),
             Text('${event['time']['elapsed']}\'', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ],
      ),
    );
  }
}
