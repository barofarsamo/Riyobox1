
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:riyobox/models/movie.dart';
import 'package:riyobox/services/api_service.dart';
import 'package:riyobox/presentation/widgets/movie_card.dart';
import 'package:riyobox/presentation/widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  int _currentCarouselIndex = 0;

  final List<String> _filters = [
    "Dhammaan",
    "Filimada",
    "Musalsalada",
    "Anime",
    "Caruurta",
    "Subscriptions"
  ];
  String _selectedFilter = "Dhammaan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text('RIYOBOX', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.cast),
                  onPressed: () {},
                  tooltip: 'Google Cast',
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                  tooltip: 'Settings',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Semantics(
                    label: 'User Profile',
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage('https://picsum.photos/seed/avatar/100/100'),
                    ),
                  ),
                ),
              ],
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: SizedBox(
                  height: 50.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          label: Text(_filters[index]),
                          selected: _selectedFilter == _filters[index],
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedFilter = _filters[index];
                            });
                          },
                          backgroundColor: const Color(0xFF2C2B30),
                          selectedColor: Colors.deepPurple,
                          labelStyle: TextStyle(
                            color: _selectedFilter == _filters[index] ? Colors.white : Colors.grey[400],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCarouselSlider(),
              const SizedBox(height: 20),
              _buildMovieCategory("Filimada Riyobox", _apiService.getTrendingMovies()),
              _buildMovieCategory("Asalka Riyobox", _apiService.getTopRatedMovies()),
              _buildMovieCategory("Daawashada Sii Wad", _apiService.getNowPlayingMovies()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return FutureBuilder<List<Movie>>(
      future: _apiService.getTrendingMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerLoading.rectangular(height: 250);
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 250,
            child: Center(child: Text('Lama soo rari karin filimada la soo bandhigay.')),
          );
        }

        final movies = snapshot.data!;

        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 250.0,
                autoPlay: true,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentCarouselIndex = index;
                  });
                },
              ),
              items: movies.map((movie) {
                return Builder(
                  builder: (BuildContext context) {
                    return Semantics(
                      label: 'Featured movie: ${movie.title}',
                      container: true,
                      child: Stack(
                        children: [
                          ExcludeSemantics(
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              fit: BoxFit.cover,
                              height: 250.0,
                              width: double.infinity,
                              loadingBuilder: (context, child, progress) {
                                return progress == null ? child : const ShimmerLoading.rectangular(height: 250);
                              },
                              errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
                            ),
                          ),
                          Container(
                            height: 250.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black.withAlpha(204), Colors.transparent],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: ExcludeSemantics(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: movies.asMap().entries.map((entry) {
                return Semantics(
                  label: 'Movie indicator ${entry.key + 1}',
                  selected: _currentCarouselIndex == entry.key,
                  button: true,
                  child: GestureDetector(
                    onTap: () => setState(() => _currentCarouselIndex = entry.key),
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withAlpha(_currentCarouselIndex == entry.key ? 230 : 102),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMovieCategory(String title, Future<List<Movie>> future) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<Movie>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildMovieShimmerList();
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Cilad ayaa ka dhacday soo rarida filimada.'));
              }
              final movies = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return SizedBox(
                    width: 140,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MovieCard(movie: movie, height: 160),
                          const SizedBox(height: 8),
                          Text(
                            movie.title,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            movie.releaseDate.split('-')[0],
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieShimmerList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return const SizedBox(
          width: 140,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading.rectangular(height: 160),
                SizedBox(height: 8),
                ShimmerLoading.rectangular(height: 14, width: 100),
                SizedBox(height: 4),
                ShimmerLoading.rectangular(height: 12, width: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
