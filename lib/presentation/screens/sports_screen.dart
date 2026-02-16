import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riyobox/providers/sports_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class SportsScreen extends StatelessWidget {
  const SportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        title: const Text('FOOTBALL LIVE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => context.push('/sports/search')),
          IconButton(icon: const Icon(Icons.calendar_today_outlined), onPressed: () {}),
        ],
      ),
      body: Consumer<SportsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.todayMatches.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchTodayMatches(),
            child: CustomScrollView(
              slivers: [
                if (provider.liveMatches.isNotEmpty) ...[
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.live_tv, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text('LIVE MATCHES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.liveMatches.length,
                        itemBuilder: (context, index) {
                          return _buildLiveMatchCard(context, provider.liveMatches[index]);
                        },
                      ),
                    ),
                  ),
                ],
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('TODAY\'S MATCHES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildMatchTile(context, provider.todayMatches[index]);
                    },
                    childCount: provider.todayMatches.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLiveMatchCard(BuildContext context, dynamic match) {
    final home = match['teams']['home'];
    final away = match['teams']['away'];
    final goals = match['goals'];
    final status = match['fixture']['status'];
    final provider = Provider.of<SportsProvider>(context, listen: false);
    final streamUrl = provider.getStreamForMatch(match['fixture']['id']);

    return GestureDetector(
      onTap: () => context.push('/sports/match/${match['fixture']['id']}'),
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.redAccent.withAlpha(50)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(match['league']['name'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTeamVertical(home['name'], home['logo']),
                Column(
                  children: [
                    Text('${goals['home'] ?? 0} - ${goals['away'] ?? 0}',
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                      child: Text('${status['elapsed']}\'', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                _buildTeamVertical(away['name'], away['logo']),
              ],
            ),
            if (streamUrl != null) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => context.push('/sports/play?url=$streamUrl&title=${home['name']} vs ${away['name']}'),
                icon: const Icon(Icons.play_arrow, size: 16),
                label: const Text('WATCH LIVE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 36),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMatchTile(BuildContext context, dynamic match) {
    final home = match['teams']['home'];
    final away = match['teams']['away'];
    final goals = match['goals'];
    final status = match['fixture']['status'];
    final timeStr = match['fixture']['date'];
    final time = DateTime.parse(timeStr);
    final provider = Provider.of<SportsProvider>(context, listen: false);
    final streamUrl = provider.getStreamForMatch(match['fixture']['id']);

    return ListTile(
      onTap: () => context.push('/sports/match/${match['fixture']['id']}'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: SizedBox(
        width: 50,
        child: Text(
          status['short'] == 'NS'
            ? '${time.hour}:${time.minute.toString().padLeft(2, '0')}'
            : status['short'],
          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      title: Row(
        children: [
          Expanded(child: Text(home['name'], style: const TextStyle(color: Colors.white, fontSize: 14), textAlign: TextAlign.end, maxLines: 1, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 12),
          CachedNetworkImage(imageUrl: home['logo'], width: 24, height: 24, memCacheWidth: 48),
          const SizedBox(width: 8),
          Text(
            status['short'] == 'NS' ? 'vs' : '${goals['home']} - ${goals['away']}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          CachedNetworkImage(imageUrl: away['logo'], width: 24, height: 24, memCacheWidth: 48),
          const SizedBox(width: 12),
          Expanded(child: Text(away['name'], style: const TextStyle(color: Colors.white, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
        ],
      ),
      trailing: streamUrl != null
        ? const Icon(Icons.live_tv, color: Colors.red, size: 18)
        : const Icon(Icons.arrow_forward_ios, color: Colors.white10, size: 14),
    );
  }

  Widget _buildTeamVertical(String name, String logo) {
    return Column(
      children: [
        CachedNetworkImage(imageUrl: logo, width: 48, height: 48, memCacheWidth: 96),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(name,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
