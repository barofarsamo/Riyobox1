import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riyobox/models/movie.dart';

class ApiService {
  static const String _apiKey = 'YOUR_API_KEY'; // TODO: Replace with your TMDB API key
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  bool get _isMock => _apiKey == 'YOUR_API_KEY';

  Future<List<Movie>> getTrendingMovies() async {
    if (_isMock) return _getMockMovies();
    return _fetchMovies('/trending/movie/day');
  }

  Future<List<Movie>> getTopRatedMovies() async {
    if (_isMock) return _getMockMovies();
    return _fetchMovies('/movie/top_rated');
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    if (_isMock) return _getMockMovies();
    return _fetchMovies('/movie/now_playing');
  }

  Future<Movie> getMovieDetails(String movieId) async {
    if (_isMock) {
      final movies = await _getMockMovies();
      return movies.firstWhere((m) => m.id.toString() == movieId,
          orElse: () => movies[0]);
    }
    final response =
        await http.get(Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Movie>> _fetchMovies(String url) async {
    final response =
        await http.get(Uri.parse('$_baseUrl$url?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> _getMockMovies() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Movie(
        id: 1,
        title: 'Inception',
        overview:
            'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
        posterPath: '/edv5CZvfkjSfm9kfCghQ9KyTM9J.jpg',
        backdropPath: '/8ZTVqvKDcmSjS0Bv0vUvMG7uH9d.jpg',
        releaseDate: '2010-07-15',
        voteAverage: 8.3,
      ),
      Movie(
        id: 2,
        title: 'The Dark Knight',
        overview:
            'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
        posterPath: '/qJ2tW6WMUDp9QmSbmz94S0OOTvW.jpg',
        backdropPath: '/nMKdUUtnkbviS79pQvMKuH2pS0E.jpg',
        releaseDate: '2008-07-16',
        voteAverage: 8.5,
      ),
      Movie(
        id: 3,
        title: 'Interstellar',
        overview:
            'The adventures of a group of explorers who make use of a newly discovered wormhole to surpass the limitations on human space travel and conquer the vast distances involved in an interstellar voyage.',
        posterPath: '/gEU2QniE6EwfVDxCzs25vQO2Cq9.jpg',
        backdropPath: '/rAi91vS9VQ9o6X6mYm96UDZp6em.jpg',
        releaseDate: '2014-11-05',
        voteAverage: 8.4,
      ),
      Movie(
        id: 4,
        title: 'The Matrix',
        overview:
            'Set in the 22nd century, The Matrix tells the story of a computer hacker who joins a group of underground insurgents fighting the vast and powerful computers who now rule the earth.',
        posterPath: '/f89U3Y9SJuCYFJj7G0qywaO9Lbn.jpg',
        backdropPath: '/nc6Yn63FIBnB88W6OQeFp0r7iXN.jpg',
        releaseDate: '1999-03-30',
        voteAverage: 8.2,
      ),
    ];
  }
}
