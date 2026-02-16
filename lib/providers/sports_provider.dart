import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riyobox/services/sports_service.dart';
import 'package:riyobox/services/sports_ws_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SportsProvider extends ChangeNotifier {
  final SportsService _sportsService = SportsService();
  late SportsWebSocketService _wsService;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  List<dynamic> _liveMatches = [];
  List<dynamic> _todayMatches = [];
  List<dynamic> _adminStreams = [];
  bool _isLoading = false;
  Timer? _refreshTimer;

  final Map<int, String> _lastKnownScores = {};

  List<dynamic> get liveMatches => _liveMatches;
  List<dynamic> get todayMatches => _todayMatches;
  bool get isLoading => _isLoading;

  SportsProvider() {
    _initNotifications();
    fetchTodayMatches();
    startLiveRefresh();
    _initWebSocket();
    fetchAdminStreams();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  void _initWebSocket() {
    _wsService = SportsWebSocketService(onMessage: (data) {
      if (data['type'] == 'live_update') {
        _handleLiveUpdate(data['match']);
      }
    });
    _wsService.connect();
  }

  void _handleLiveUpdate(dynamic match) {
    final index = _liveMatches.indexWhere((m) => m['fixture']['id'] == match['fixture']['id']);
    if (index != -1) {
      _checkGoalAlerts([match]);
      _liveMatches[index] = match;
      notifyListeners();
    } else {
      _liveMatches.add(match);
      notifyListeners();
    }
  }

  Future<void> fetchTodayMatches() async {
    _isLoading = true;
    notifyListeners();
    try {
      final now = DateTime.now();
      final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final response = await _sportsService.getMatchesByDate(dateStr);
      _todayMatches = response['response'] ?? [];
    } catch (e) {} finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLiveMatches() async {
    try {
      final response = await _sportsService.getLiveMatches();
      final currentLive = response['response'] ?? [];
      _checkGoalAlerts(currentLive);
      _liveMatches = currentLive;
      notifyListeners();
    } catch (e) {}
  }

  Future<void> fetchAdminStreams() async {
    _adminStreams = await _sportsService.getLiveStreams();
    notifyListeners();
  }

  String? getStreamForMatch(int fixtureId) {
    final stream = _adminStreams.firstWhere((s) => s['fixtureId'] == fixtureId, orElse: () => null);
    return stream?['streamUrl'];
  }

  void _checkGoalAlerts(List<dynamic> matches) {
    for (var match in matches) {
      final id = match['fixture']['id'];
      final homeGoals = match['goals']['home'];
      final awayGoals = match['goals']['away'];
      final currentScore = "$homeGoals-$awayGoals";

      if (_lastKnownScores.containsKey(id) && _lastKnownScores[id] != currentScore) {
        _showNotification(
          "GOAL ALERT! ⚽",
          "${match['teams']['home']['name']} $homeGoals - $awayGoals ${match['teams']['away']['name']}"
        );
      }
      _lastKnownScores[id] = currentScore;
    }
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'goal_alerts', 'Goal Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, details);
  }

  void startLiveRefresh() {
    _refreshTimer?.cancel();
    fetchLiveMatches();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchLiveMatches();
      fetchAdminStreams();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _wsService.dispose();
    super.dispose();
  }
}
