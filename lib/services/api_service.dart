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
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Movie(
        id: 1,
        title: 'Inception',
        overview: 'A thief who steals corporate secrets through the use of dream-sharing technology...',
        posterPath: '/edv5CZvfkjSfm9kfCghQ9KyTM9J.jpg',
        backdropPath: '/8ZTVqvKDcmSjS0Bv0vUvMG7uH9d.jpg',
        releaseDate: '2010-07-15',
        voteAverage: 8.3,
      ),
      Movie(
        id: 2,
        title: 'The Dark Knight',
        overview: 'When the menace known as the Joker wreaks havoc...',
        posterPath: '/qJ2tW6WMUDp9QmSbmz94S0OOTvW.jpg',
        backdropPath: '/nMKdUUtnkbviS79pQvMKuH2pS0E.jpg',
        releaseDate: '2008-07-16',
        voteAverage: 8.5,
      ),
      Movie(
        id: 3,
        title: 'Interstellar',
        overview: 'The adventures of a group of explorers...',
        posterPath: '/gEU2QniE6EwfVDxCzs25vQO2Cq9.jpg',
        backdropPath: '/rAi91vS9VQ9o6X6mYm96UDZp6em.jpg',
        releaseDate: '2014-11-05',
        voteAverage: 8.4,
      ),
      Movie(
        id: 4,
        title: 'The Matrix',
        overview: 'Set in the 22nd century...',
        posterPath: '/f89U3Y9SJuCYFJj7G0qywaO9Lbn.jpg',
        backdropPath: '/nc6Yn63FIBnB88W6OQeFp0r7iXN.jpg',
        releaseDate: '1999-03-30',
        voteAverage: 8.2,
      ),
      Movie(
        id: 5,
        title: 'Pulp Fiction',
        overview: 'The lives of two mob hitmen, a boxer, a gangster and his wife...',
        posterPath: '/d5iIl9h9FvS6o9HqSfe66C2oQvW.jpg',
        backdropPath: '/suaAg0uYInNiS309699696o8Qf8.jpg',
        releaseDate: '1994-09-10',
        voteAverage: 8.9,
      ),
       Movie(
        id: 6,
        title: 'The Boys',
        overview: 'A group of vigilantes set out to take down corrupt superheroes...',
        posterPath: '/7YvYvS337oNooT5YIrj6i6H8E2C.jpg',
        backdropPath: '/n69v9K3p7lH2C89X7P6X0B3Y8S.jpg',
        releaseDate: '2019-07-26',
        voteAverage: 8.7,
      ),
      Movie(
        id: 7,
        title: 'Dune: Part Two',
        overview: 'Paul Atreides unites with Chani and the Fremen while on a warpath of revenge...',
        posterPath: '/8uS9uS9uS9uS9uS9uS9uS9uS9uS.jpg',
        backdropPath: '/9uS9uS9uS9uS9uS9uS9uS9uS9uS.jpg',
        releaseDate: '2024-02-27',
        voteAverage: 8.3,
      ),
    ];
  }
}
