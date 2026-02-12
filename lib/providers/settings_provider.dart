import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  String _language = 'English';
  bool _notificationsEnabled = true;
  String _playbackQuality = 'Auto';

  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  String get playbackQuality => _playbackQuality;

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setPlaybackQuality(String quality) {
    _playbackQuality = quality;
    notifyListeners();
  }
}
