import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riyobox/core/constants.dart';
import 'package:riyobox/services/sports_cache_helper.dart';

class SportsService {
  static const String _baseUrl = '${Constants.apiBaseUrl}/sports';
  final SportsCacheHelper _cache = SportsCacheHelper();

  Future<Map<String, dynamic>> getLiveMatches() async {
    try {
      final cached = await _cache.getFromCache('live_matches', 30);
      if (cached != null) return json.decode(cached);
    } catch (e) {}

    final response = await http.get(Uri.parse('$_baseUrl/fixtures?live=all'));
    if (response.statusCode == 200) {
      try {
        await _cache.saveToCache('live_matches', response.body);
      } catch (e) {}
      return json.decode(response.body);
    }
    throw Exception('Failed to load live matches');
  }

  Future<Map<String, dynamic>> getMatchesByDate(String date) async {
    try {
      final cached = await _cache.getFromCache('matches_$date', 60);
      if (cached != null) return json.decode(cached);
    } catch (e) {}

    final response = await http.get(Uri.parse('$_baseUrl/fixtures?date=$date'));
    if (response.statusCode == 200) {
      try {
        await _cache.saveToCache('matches_$date', response.body);
      } catch (e) {}
      return json.decode(response.body);
    }
    throw Exception('Failed to load matches for $date');
  }

  Future<Map<String, dynamic>> getMatchDetails(int fixtureId) async {
    final response = await http.get(Uri.parse('$_baseUrl/fixtures?id=$fixtureId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load match details');
  }

  Future<Map<String, dynamic>> getMatchStatistics(int fixtureId) async {
    final response = await http.get(Uri.parse('$_baseUrl/fixtures/statistics?fixture=$fixtureId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load match statistics');
  }

  Future<Map<String, dynamic>> getMatchLineups(int fixtureId) async {
    final response = await http.get(Uri.parse('$_baseUrl/fixtures/lineups?fixture=$fixtureId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load lineups');
  }

  Future<Map<String, dynamic>> getMatchEvents(int fixtureId) async {
    final response = await http.get(Uri.parse('$_baseUrl/fixtures/events?fixture=$fixtureId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load events');
  }

  Future<Map<String, dynamic>> getStandings(int leagueId, int season) async {
    final cacheKey = 'standings_${leagueId}_$season';
    try {
      final cached = await _cache.getFromCache(cacheKey, 300);
      if (cached != null) return json.decode(cached);
    } catch (e) {}

    final response = await http.get(Uri.parse('$_baseUrl/standings?league=$leagueId&season=$season'));
    if (response.statusCode == 200) {
      try {
        await _cache.saveToCache(cacheKey, response.body);
      } catch (e) {}
      return json.decode(response.body);
    }
    throw Exception('Failed to load standings');
  }

  Future<Map<String, dynamic>> getTeamInfo(int teamId) async {
    final response = await http.get(Uri.parse('$_baseUrl/teams?id=$teamId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load team info');
  }

  Future<Map<String, dynamic>> getPlayerInfo(int playerId, int season) async {
    final response = await http.get(Uri.parse('$_baseUrl/players?id=$playerId&season=$season'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load player info');
  }

  Future<Map<String, dynamic>> search(String type, String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/$type?search=$query'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Search failed');
  }

  Future<List<dynamic>> getLiveStreams() async {
    final response = await http.get(Uri.parse('${Constants.apiBaseUrl}/livestreams'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return [];
  }
}
