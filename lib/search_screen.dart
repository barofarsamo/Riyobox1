import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riyobox/models/movie.dart';
import 'package:riyobox/services/api_service.dart';
import 'package:riyobox/presentation/widgets/movie_card.dart';
import 'package:riyobox/presentation/widgets/shimmer_loading.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      // In a real app, we'd call a search API.
      // Our mock ApiService doesn't have a search method yet, so I'll add one or use getTrendingMovies and filter.
      final movies = await _apiService.getTrendingMovies();
      final filteredMovies = movies.where((movie) =>
        movie.title.toLowerCase().contains(query.toLowerCase())).toList();

      setState(() {
        _searchResults = filteredMovies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2A),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            Expanded(
              child: _isLoading
                ? _buildLoadingGrid()
                : (_hasSearched ? _buildSearchResults() : _buildInitialContent()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search movies, TV shows...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.yellow),
                filled: true,
                fillColor: const Color(0xFF2A2A3A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white54),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: GestureDetector(
                onTap: () {
                  _searchController.clear();
                  _onSearchChanged('');
                  FocusScope.of(context).unfocus();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.yellow, fontSize: 16.0),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInitialContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        const Text(
          'Trending Searches',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        _buildTrendingSearch('Inception'),
        _buildTrendingSearch('Interstellar'),
        _buildTrendingSearch('The Dark Knight'),
        _buildTrendingSearch('Pulp Fiction'),
        const SizedBox(height: 24.0),
        const Text(
          'Browse by Category',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 2.5,
          children: [
            _buildCategoryChip('Action', Colors.redAccent),
            _buildCategoryChip('Comedy', Colors.orangeAccent),
            _buildCategoryChip('Drama', Colors.blueAccent),
            _buildCategoryChip('Horror', Colors.purpleAccent),
            _buildCategoryChip('Sci-Fi', Colors.greenAccent),
            _buildCategoryChip('Romance', Colors.pinkAccent),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[700]),
            const SizedBox(height: 16),
            const Text(
              'No results found',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try searching for something else',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: _searchResults[index]);
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ShimmerLoading.rectangular(height: 150),
    );
  }

  Widget _buildTrendingSearch(String title) {
    return ListTile(
      leading: const Icon(Icons.trending_up, color: Colors.yellow),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16.0),
      onTap: () {
        _searchController.text = title;
        _onSearchChanged(title);
      },
    );
  }

  Widget _buildCategoryChip(String label, Color color) {
    return GestureDetector(
      onTap: () {
        _searchController.text = label;
        _onSearchChanged(label);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(
            colors: [color.withAlpha(153), const Color(0xFF2A2A3A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
