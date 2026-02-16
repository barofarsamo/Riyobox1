import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:riyobox/core/constants.dart';

class SportsWebSocketService {
  WebSocketChannel? _channel;
  final Function(dynamic) onMessage;

  SportsWebSocketService({required this.onMessage});

  void connect() {
    final wsUrl = Constants.apiBaseUrl.replaceFirst('https', 'wss').replaceFirst('http', 'ws') + '/sports/live';
    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _channel!.stream.listen((message) {
        final data = json.decode(message);
        onMessage(data);
      }, onError: (error) {
        print('WebSocket Error: $error');
        _reconnect();
      }, onDone: () {
        _reconnect();
      });
    } catch (e) {
      _reconnect();
    }
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      connect();
    });
  }

  void dispose() {
    _channel?.sink.close();
  }
}
