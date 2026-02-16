import 'package:flutter/material.dart';
import 'package:riyobox/services/sports_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LeagueStandingsScreen extends StatefulWidget {
  final int leagueId;
  final int season;

  const LeagueStandingsScreen({super.key, required this.leagueId, required this.season});

  @override
  State<LeagueStandingsScreen> createState() => _LeagueStandingsScreenState();
}

class _LeagueStandingsScreenState extends State<LeagueStandingsScreen> {
  final SportsService _sportsService = SportsService();
  List<dynamic>? _standings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStandings();
  }

  Future<void> _loadStandings() async {
    try {
      final response = await _sportsService.getStandings(widget.leagueId, widget.season);
      if (mounted) {
        setState(() {
          _standings = response['response'][0]['league']['standings'][0];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        title: const Text('STANDINGS', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _standings == null
          ? const Center(child: Text('Standings not available'))
          : Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _standings!.length,
                    itemBuilder: (context, index) {
                      return _buildStandingRow(_standings![index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white10,
      child: const Row(
        children: [
          SizedBox(width: 30, child: Text('#', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
          Expanded(child: Text('TEAM', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
          SizedBox(width: 30, child: Text('PL', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
          SizedBox(width: 30, child: Text('GD', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
          SizedBox(width: 40, child: Text('PTS', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildStandingRow(dynamic item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text('${item['rank']}', style: const TextStyle(color: Colors.white))),
          Expanded(
            child: Row(
              children: [
                CachedNetworkImage(imageUrl: item['team']['logo'], width: 20, height: 20),
                const SizedBox(width: 12),
                Text(item['team']['name'], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          SizedBox(width: 30, child: Text('${item['all']['played']}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey))),
          SizedBox(width: 30, child: Text('${item['goalsDiff']}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey))),
          SizedBox(width: 40, child: Text('${item['points']}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
