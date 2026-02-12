import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riyobox/models/movie.dart';
import 'package:riyobox/services/api_service.dart';
import 'package:riyobox/presentation/widgets/movie_card.dart';
import 'package:riyobox/presentation/widgets/shimmer_loading.dart';

class MovieDetailsScreen extends StatefulWidget {
  final String movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final ApiService _apiService = ApiService();
  Season? _selectedSeason;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2A),
      body: FutureBuilder<Movie>(
        future: _apiService.getMovieDetails(widget.movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.yellow));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          }
          final movie = snapshot.data!;
          if (movie.isTvShow && movie.seasons != null && _selectedSeason == null) {
            _selectedSeason = movie.seasons![0];
          }

          return CustomScrollView(
            slivers: [
              _buildHeroSection(movie),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBadges(),
                      const SizedBox(height: 24),
                      _buildSynopsis(movie),
                      const SizedBox(height: 24),
                      _buildCastAndCrew(movie),
                      const SizedBox(height: 24),
                      _buildMoreInfo(movie),
                      const SizedBox(height: 32),
                      if (movie.isTvShow) _buildSeasonSelector(movie),
                      if (movie.isTvShow) _buildEpisodeList(),
                      const SizedBox(height: 32),
                      _buildActionsBar(context),
                      const SizedBox(height: 32),
                      _buildRecommendationsSection("MORE LIKE THIS"),
                      const SizedBox(height: 32),
                      _buildRecommendationsSection("FROM THE SAME DIRECTOR"),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(Movie movie) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: const Color(0xFF1C1C2A),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://image.tmdb.org/t/p/original${movie.backdropPath ?? movie.posterPath}',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF1C1C2A).withAlpha(204),
                    const Color(0xFF1C1C2A),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '⭐ ${movie.voteAverage.toStringAsFixed(1)}/10 • ${movie.releaseDate.split('-')[0]} • ${movie.isTvShow ? 'TV Series' : '${movie.runtime} min'} • ${movie.contentRating ?? 'PG-13'}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeroButton(Icons.play_arrow, 'PLAY', Colors.white, Colors.black, () {
                        context.push('/movie/${movie.id}/play');
                      }),
                      const SizedBox(width: 12),
                      _buildHeroButton(Icons.download, 'DOWNLOAD', const Color(0xFF2A2A3A), Colors.white, () {}),
                    ],
                  ),
                  const SizedBox(height: 12),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeroButton(Icons.add, 'MY LIST', const Color(0xFF2A2A3A), Colors.white, () {}),
                      const SizedBox(width: 12),
                      _buildHeroButton(Icons.share, 'SHARE', const Color(0xFF2A2A3A), Colors.white, () => _showShareOptions(context)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroButton(IconData icon, String label, Color bgColor, Color textColor, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: textColor, size: 18),
        label: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildBadges() {
    return const Wrap(
      spacing: 8,
      children: [
        _Badge(text: '🏆 RIYOBOX ORIGINAL', color: Colors.yellow),
        _Badge(text: '🔥 TRENDING', color: Colors.redAccent),
        _Badge(text: '🎯 NEW', color: Colors.blueAccent),
      ],
    );
  }

  Widget _buildSynopsis(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📖 SYNOPSIS', style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Text(
          movie.overview,
          style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildCastAndCrew(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🎭 CAST & CREW', style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movie.cast?.length ?? 0,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFF2A2A3A), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.grey, size: 16),
                    const SizedBox(width: 6),
                    Text(movie.cast![index], style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMoreInfo(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🏷️ MORE INFO', style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        _buildInfoRow('Genre', movie.genres?.join(', ') ?? 'N/A'),
        _buildInfoRow('Duration', movie.isTvShow ? 'Various' : '${movie.runtime} min'),
        _buildInfoRow('Release Date', movie.releaseDate),
        _buildInfoRow('Director', movie.director ?? 'N/A'),
        _buildInfoRow('Languages', 'English, Somali, Arabic'),
        _buildInfoRow('Subtitles', '15 languages available'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• $label: ', style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildSeasonSelector(Movie movie) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF2A2A3A), borderRadius: BorderRadius.circular(8)),
      child: DropdownButton<Season>(
        value: _selectedSeason,
        dropdownColor: const Color(0xFF2A2A3A),
        underline: const SizedBox(),
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.yellow),
        items: movie.seasons!.map((Season season) {
          return DropdownMenuItem<Season>(
            value: season,
            child: Text(season.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          );
        }).toList(),
        onChanged: (Season? newValue) {
          setState(() {
            _selectedSeason = newValue;
          });
        },
      ),
    );
  }

  Widget _buildEpisodeList() {
    if (_selectedSeason == null) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text('EPISODES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        ..._selectedSeason!.episodes.map((episode) => _buildEpisodeItem(episode)).toList(),
        const SizedBox(height: 16),
        Row(
          children: [
             _buildSmallActionBtn(Icons.download, 'Download All'),
             const SizedBox(width: 12),
             _buildSmallActionBtn(Icons.sync, 'Auto-download'),
          ],
        ),
      ],
    );
  }

  Widget _buildEpisodeItem(Episode episode) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 100,
        height: 60,
        color: Colors.grey[800],
        child: const Icon(Icons.play_circle_outline, color: Colors.white),
      ),
      title: Text('${episode.number}. ${episode.title}', style: const TextStyle(color: Colors.white, fontSize: 14)),
      subtitle: Text(episode.duration, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.play_arrow, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download, color: Colors.white), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildSmallActionBtn(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[700]!), borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActionsBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionBtn(Icons.remove_red_eye_outlined, 'Watchlist'),
        _buildActionBtn(Icons.thumb_up_outlined, 'Rate'),
        _buildActionBtn(Icons.thumb_down_outlined, 'Not for me'),
        _buildActionBtn(Icons.share_outlined, 'Share', onTap: () => _showShareOptions(context)),
        _buildActionBtn(Icons.flag_outlined, 'Report'),
      ],
    );
  }

  Widget _buildActionBtn(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        FutureBuilder<List<Movie>>(
          future: _apiService.getTrendingMovies(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox(height: 180, child: ShimmerLoading.rectangular(height: 180));
            final movies = snapshot.data!;
            return SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return MovieCard(movie: movies[index], height: 180);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A3A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('SHARE OPTIONS', style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildShareItem(Icons.link, 'Copy Link'),
              _buildShareItem(Icons.message, 'Share to WhatsApp'),
              _buildShareItem(Icons.camera_alt, 'Share to Instagram'),
              _buildShareItem(Icons.facebook, 'Share to Facebook'),
              _buildShareItem(Icons.alternate_email, 'Share to Twitter'),
              _buildShareItem(Icons.more_horiz, 'More apps…'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () => Navigator.pop(context),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withAlpha(51), borderRadius: BorderRadius.circular(4), border: Border.all(color: color, width: 0.5)),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
