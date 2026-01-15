
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key, required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          _buildMovieDetails(),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
        tooltip: 'Back',
      ),
      backgroundColor: Colors.black,
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          'https://image.tmdb.org/t/p/w500/r9oTE25So8FLMOL6v3v4c2rqzQO.jpg',
          fit: BoxFit.cover,
          semanticLabel: 'My Fault movie poster',
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.movie, color: Colors.grey)),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.cast, color: Colors.white),
          onPressed: () {
            // TODO: Implement casting
          },
          tooltip: 'Cast',
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://picsum.photos/seed/user/200'),
          ),
        ),
      ],
    );
  }

  SliverPadding _buildMovieDetails() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Text(
            'My Fault',
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.lightBlue.shade200, size: 18),
              const SizedBox(width: 6),
              Text(
                'Prime',
                style: TextStyle(
                  color: Colors.lightBlue.shade200,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _PrimaryButton(
            icon: Icons.play_arrow,
            label: 'Play movie',
            onPressed: () {
              // TODO: Implement video player
            },
          ),
          const SizedBox(height: 12),
          const _SecondaryButton(icon: Icons.download, label: 'Download'),
          const SizedBox(height: 28),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ActionIcon(key: Key('watchlist_button'), icon: Icons.add, label: 'Watchlist'),
              _ActionIcon(key: Key('like_button'), icon: Icons.thumb_up_outlined, label: 'Like'),
              _ActionIcon(key: Key('not_for_me_button'), icon: Icons.thumb_down_outlined, label: 'Not for me'),
              _ActionIcon(key: Key('share_button'), icon: Icons.share_outlined, label: 'Share'),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            "Noah must leave her town, boyfriend and friends to move into her mom's new husband's mansion. There, she meets the mysterious and alluring Nick.",
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.white,
            ),
          ),
        ]),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.icon, required this.label, this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black, size: 24),
      label: Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white, size: 24),
      label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2F2F2F),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
