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
      final movie = movies.firstWhere((m) => m.id.toString() == movieId,
          orElse: () => movies[0]);

      // If it's The Boys, add seasons
      if (movie.id == 6) {
        return Movie(
          id: movie.id,
          title: movie.title,
          overview: movie.overview,
          posterPath: movie.posterPath,
          backdropPath: movie.backdropPath,
          releaseDate: movie.releaseDate,
          voteAverage: movie.voteAverage,
          runtime: 60,
          genres: ['Action', 'Sci-Fi', 'Comedy'],
          cast: ['Karl Urban', 'Jack Quaid', 'Antony Starr'],
          director: 'Eric Kripke',
          contentRating: 'R',
          isTvShow: true,
          seasons: [
            Season(
              number: 1,
              title: 'Season 1 (2019)',
              episodes: [
                Episode(number: 1, title: 'The Name of the Game', duration: '60min'),
                Episode(number: 2, title: 'Cherry', duration: '56min'),
                Episode(number: 3, title: 'Get Some', duration: '58min'),
                Episode(number: 4, title: 'The Female of the Species', duration: '55min'),
              ],
            ),
            Season(
              number: 2,
              title: 'Season 2 (2020)',
              episodes: [
                Episode(number: 1, title: 'The Big Ride', duration: '62min'),
              ],
            ),
          ],
        );
      }

      return Movie(
        id: movie.id,
        title: movie.title,
        overview: movie.overview,
        posterPath: movie.posterPath,
        backdropPath: movie.backdropPath,
        releaseDate: movie.releaseDate,
        voteAverage: movie.voteAverage,
        runtime: 148,
        genres: ['Action', 'Sci-Fi', 'Adventure'],
        cast: ['Actor 1', 'Actor 2', 'Actor 3'],
        director: 'John Director',
        contentRating: 'PG-13',
      );
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
        runtime: 148,
        genres: ['Action', 'Sci-Fi'],
        fileSize: '450.2 MB',
        isDownloaded: true,
      ),
      Movie(
        id: 2,
        title: 'The Dark Knight',
        overview: 'When the menace known as the Joker wreaks havoc...',
        posterPath: '/qJ2tW6WMUDp9QmSbmz94S0OOTvW.jpg',
        backdropPath: '/nMKdUUtnkbviS79pQvMKuH2pS0E.jpg',
        releaseDate: '2008-07-16',
        voteAverage: 8.5,
        runtime: 152,
        genres: ['Action', 'Crime', 'Drama'],
      ),
      Movie(
        id: 3,
        title: 'Interstellar',
        overview: 'The adventures of a group of explorers...',
        posterPath: '/gEU2QniE6EwfVDxCzs25vQO2Cq9.jpg',
        backdropPath: '/rAi91vS9VQ9o6X6mYm96UDZp6em.jpg',
        releaseDate: '2014-11-05',
        voteAverage: 8.4,
        runtime: 169,
        genres: ['Adventure', 'Drama', 'Sci-Fi'],
      ),
      Movie(
        id: 4,
        title: 'The Matrix',
        overview: 'Set in the 22nd century...',
        posterPath: '/f89U3Y9SJuCYFJj7G0qywaO9Lbn.jpg',
        backdropPath: '/nc6Yn63FIBnB88W6OQeFp0r7iXN.jpg',
        releaseDate: '1999-03-30',
        voteAverage: 8.2,
        runtime: 136,
        genres: ['Action', 'Sci-Fi'],
      ),
      Movie(
        id: 5,
        title: 'Pulp Fiction',
        overview: 'The lives of two mob hitmen, a boxer, a gangster and his wife...',
        posterPath: '/d5iIl9h9FvS6o9HqSfe66C2oQvW.jpg',
        backdropPath: '/suaAg0uYInNiS309699696o8Qf8.jpg',
        releaseDate: '1994-09-10',
        voteAverage: 8.9,
        runtime: 154,
        genres: ['Crime', 'Drama'],
      ),
       Movie(
        id: 6,
        title: 'The Boys',
        overview: 'A group of vigilantes set out to take down corrupt superheroes...',
        posterPath: '/7YvYvS337oNooT5YIrj6i6H8E2C.jpg',
        backdropPath: '/n69v9K3p7lH2C89X7P6X0B3Y8S.jpg',
        releaseDate: '2019-07-26',
        voteAverage: 8.7,
        isTvShow: true,
      ),
      Movie(
        id: 7,
        title: 'Dune: Part Two',
        overview: 'Paul Atreides unites with Chani and the Fremen while on a warpath of revenge...',
        posterPath: '/8uS9uS9uS9uS9uS9uS9uS9uS9uS.jpg',
        backdropPath: '/9uS9uS9uS9uS9uS9uS9uS9uS9uS.jpg',
        releaseDate: '2024-02-27',
        voteAverage: 8.3,
        runtime: 166,
        genres: ['Action', 'Adventure', 'Sci-Fi'],
      ),
      Movie(
        id: 8,
        title: 'Fallout',
        overview: 'In a future, post-apocalyptic Los Angeles...',
        posterPath: '/x9p316R936N79S309699696o8Qf8.jpg',
        backdropPath: '/y9p316R936N79S309699696o8Qf8.jpg',
        releaseDate: '2024-04-10',
        voteAverage: 8.4,
        isTvShow: true,
        isDownloading: true,
        downloadProgress: 0.85,
        fileSize: '280.7 MB',
        downloadedEpisodesCount: 1,
      ),
      Movie(
        id: 9,
        title: 'Road House',
        overview: 'Ex-UFC fighter Dalton takes a job as a bouncer...',
        posterPath: '/z9p316R936N79S309699696o8Qf8.jpg',
        backdropPath: '/w9p316R936N79S309699696o8Qf8.jpg',
        releaseDate: '2024-03-21',
        voteAverage: 7.0,
        runtime: 123,
        fileSize: '520.1 MB',
        isDownloaded: true,
      ),
    ];
  }

  Future<List<Movie>> getSimilarMovies(String movieId) async {
    final all = await _getMockMovies();
    return all.where((m) => m.id.toString() != movieId).take(4).toList();
  }

  Future<List<Movie>> getMoviesByDirector(String director) async {
    final all = await _getMockMovies();
    return all.take(2).toList();
  }
}
