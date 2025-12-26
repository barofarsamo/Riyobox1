import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riyobox/models/movie.dart';

class ApiService {
  static const String _apiKey = 'YOUR_API_KEY'; // TODO: Replace with your TMDB API key
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getTrendingMovies() async {
    return _fetchMovies('/trending/movie/day');
  }

  Future<List<Movie>> getTopRatedMovies() async {
    return _fetchMovies('/movie/top_rated');
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    return _fetchMovies('/movie/now_playing');
  }

  Future<Movie> getMovieDetails(String movieId) async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Movie>> _fetchMovies(String url) async {
    final response = await http.get(Uri.parse('$_baseUrl$url?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
