import 'dart:convert';
import 'dart:ui';

import 'package:web_socket_channel/web_socket_channel.dart';

class UserChatService {
  late final WebSocketChannel _channel;

  /// 🔌 Connect socket
  Future<void> connect() async {
    final wsUrl = Uri.parse(
      'wss://socialbookwebsocket.veteransoftwares.com/ws/sessions/1',
    );
    _channel = WebSocketChannel.connect(wsUrl);
    await _channel.ready;
  }

  /// 📤 Send request payload
  void getSessions({
    required String sessionType,
    int pageNumber = 1,
    int pageSize = 20,
  }) {
    final payload = {
      "action": "getSessions",
      "sessionType": sessionType,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };

    _channel.sink.add(jsonEncode(payload));
  }

  /// 📥 Listen to socket stream
  void listen({
    required Function(dynamic data) onData,
    Function(dynamic error)? onError,
    VoidCallback? onDone,
  }) {
    _channel.stream.listen(
      (message) {
        final decoded = json.decode(message);
        onData(decoded);
      },
      onError: onError,
      onDone: onDone,
    );
  }

  /// ❌ Close socket
  void disconnect() {
    _channel.sink.close();
  }
}
