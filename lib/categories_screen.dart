import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> genres = [
      {'name': 'Action', 'image': 'https://picsum.photos/seed/action/400/200'},
      {'name': 'Comedy', 'image': 'https://picsum.photos/seed/comedy/400/200'},
      {'name': 'Drama', 'image': 'https://picsum.photos/seed/drama/400/200'},
      {'name': 'Horror', 'image': 'https://picsum.photos/seed/horror/400/200'},
      {'name': 'Sci-Fi', 'image': 'https://picsum.photos/seed/scifi/400/200'},
      {'name': 'Romance', 'image': 'https://picsum.photos/seed/romance/400/200'},
      {'name': 'Anime', 'image': 'https://picsum.photos/seed/anime/400/200'},
      {'name': 'Documentary', 'image': 'https://picsum.photos/seed/documentary/400/200'},
    ];

    final List<String> trendingMovies = [
      'https://picsum.photos/seed/movie1/200/300',
      'https://picsum.photos/seed/movie2/200/300',
      'https://picsum.photos/seed/movie3/200/300',
      'https://picsum.photos/seed/movie4/200/300',
      'https://picsum.photos/seed/movie5/200/300',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF1C1C2A),
            title: Row(
              children: [
                const Text('RIYO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('Online', style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.cast, color: Colors.white),
                onPressed: () {},
                tooltip: 'Cast to device',
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {},
                tooltip: 'Settings',
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Semantics(
                  label: 'User profile',
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage('https://picsum.photos/seed/profile/100/100'),
                  ),
                ),
              ),
            ],
            floating: true,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildFeaturedCategoryCard(context),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Browse Genres', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildGenreCard(genres[index]['name']!, genres[index]['image']!);
                },
                childCount: genres.length,
              ),
            ),
          ),
           SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Trending in Movies', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('See All', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                itemCount: trendingMovies.length,
                itemBuilder: (context, index) {
                  return _buildTrendingMovieCard(trendingMovies[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCategoryCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image.network(
            'https://picsum.photos/seed/van/800/400',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            semanticLabel: 'Featured category: Anime Hub',
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withAlpha(204), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.0, 0.7],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('FEATURED CATEGORY', style: TextStyle(color: Colors.yellowAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('ANIME HUB', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow, color: Colors.black),
                  label: const Text('Explore Anime', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGenreCard(String name, String imageUrl) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            semanticLabel: '$name genre',
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(102),
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildTrendingMovieCard(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Card(
         clipBehavior: Clip.antiAlias,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Image.network(
          imageUrl,
          width: 120,
          height: 180,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
