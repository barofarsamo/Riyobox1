import 'package:flutter/foundation.dart';
import 'package:flutter_cast_video/flutter_cast_video.dart';

class CastService extends ChangeNotifier {
  ChromeCastController? _controller;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void setController(ChromeCastController controller) {
    _controller = controller;
    _controller?.addSessionListener();
    notifyListeners();
  }

  Future<void> loadMedia(String url) async {
    if (_controller != null) {
      await _controller!.loadMedia(url);
    }
  }

  Future<void> stopCasting() async {
    if (_controller != null) {
      // The plugin might not have a direct 'stop' but we can disconnect or load empty
      // Actually, we can just stop the session via the native UI or try to find a stop method.
    }
  }

  void updateConnectionStatus(bool connected) {
    _isConnected = connected;
    notifyListeners();
  }
}
