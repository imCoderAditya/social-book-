// import 'dart:convert';
// import 'dart:developer';
// import 'dart:ui';

// import 'package:web_socket_channel/web_socket_channel.dart';

// class ChatSocketService {
//   late WebSocketChannel _channel;
//   bool _isConnected = false;

//   /// 🔌 Connect chat socket
//   Future<void> connect({required int profileId}) async {
//     final wsUrl = Uri.parse(
//       'wss://socialbookwebsocket.veteransoftwares.com/ws/chat/$profileId',
//     );

//     _channel = WebSocketChannel.connect(wsUrl);
//     await _channel.ready;
//     _isConnected = true;

//     log('✅ Chat socket connected');
//   }

//   /// 📥 Listen messages
//   void listen({
//     required Function(dynamic data) onData,
//     Function(dynamic error)? onError,
//     VoidCallback? onDone,
//   }) {
//     _channel.stream.listen(
//       (message) {
//         log("📩 Chat WS Raw => $message");
//         final decoded = json.decode(message);
//         onData(decoded);
//       },
//       onError: onError,
//       onDone: onDone,
//     );
//   }

//   /// 📤 Send chat message
//   void sendMessage({
//     required int senderProfileId,
//     required int receiverProfileId,
//     required String messageContent,
//     String messageType = "Text",
//   }) {
//     if (!_isConnected) {
//       throw Exception("Chat socket not connected");
//     }

//     final payload = {
//       "action": "sendMessage",
//       "senderProfileId": senderProfileId,
//       "receiverProfileId": receiverProfileId,
//       "messageType": messageType,
//       "messageContent": messageContent,
//     };

//     log("📤 Chat WS Payload => ${jsonEncode(payload)}");
//     _channel.sink.add(jsonEncode(payload));
//   }

//   /// ❌ Disconnect
//   void disconnect() {
//     _isConnected = false;
//     _channel.sink.close();
//     log("🔌 Chat socket disconnected");
//   }
// }

// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:web_socket_channel/web_socket_channel.dart';

// /// WebSocket service for real-time chat messaging
// class ChatSocketService {
//   WebSocketChannel? _channel;
//   StreamController<Map<String, dynamic>>? _messageController;
//   String? _currentUrl;
//   bool _isConnected = false;

//   bool get isConnected => _isConnected;

//   /// Connect to WebSocket server
//   Future<void> connect({required int profileId}) async {
//     try {
//       // Disconnect existing connection if any
//       if (_isConnected) {
//         await disconnect();
//       }

//       _currentUrl = 'wss://socialbookwebsocket.veteransoftwares.com/ws/chat/$profileId';
      
//       log('🔌 Connecting to WebSocket: $_currentUrl');
      
//       _channel = WebSocketChannel.connect(Uri.parse(_currentUrl!));
//       _messageController = StreamController<Map<String, dynamic>>.broadcast();
//       _isConnected = true;

//       // Listen to WebSocket stream
//       _channel!.stream.listen(
//         (data) {
//           try {
//             final decoded = json.decode(data);
//             log('📩 Received WebSocket message: $decoded');
//             _messageController?.add(decoded);
//           } catch (e) {
//             log('❌ Error parsing WebSocket message: $e');
//           }
//         },
//         onError: (error) {
//           log('❌ WebSocket error: $error');
//           _isConnected = false;
//           _messageController?.addError(error);
//         },
//         onDone: () {
//           log('🔌 WebSocket connection closed');
//           _isConnected = false;
//           _messageController?.close();
//         },
//       );

//       log('✅ WebSocket connected successfully');
//     } catch (e) {
//       log('❌ Failed to connect WebSocket: $e');
//       _isConnected = false;
//       rethrow;
//     }
//   }

//   /// Listen to incoming messages
//   void listen({
//     required Function(Map<String, dynamic>) onData,
//     Function(dynamic)? onError,
//     Function()? onDone,
//   }) {
//     if (_messageController == null) {
//       log('⚠️ WebSocket not connected. Call connect() first.');
//       return;
//     }

//     _messageController!.stream.listen(
//       onData,
//       onError: onError,
//       onDone: onDone,
//     );
//   }

//   /// Send message through WebSocket
//   void sendMessage({
//     required int senderProfileId,
//     required int receiverProfileId,
//     required String messageContent,
//     String messageType = 'Text',
//   }) {
//     if (!_isConnected || _channel == null) {
//       log('⚠️ Cannot send message: WebSocket not connected');
//       return;
//     }

//     final payload = {
//       'action': 'sendMessage',
//       'senderProfileId': senderProfileId,
//       'receiverProfileId': receiverProfileId,
//       'messageType': messageType,
//       'messageContent': messageContent,
//     };

//     try {
//       final jsonPayload = json.encode(payload);
//       log('📤 Sending message: $jsonPayload');
//       _channel!.sink.add(jsonPayload);
//     } catch (e) {
//       log('❌ Error sending message: $e');
//     }
//   }

//   /// Disconnect WebSocket
//   Future<void> disconnect() async {
//     try {
//       log('🔌 Disconnecting WebSocket...');
//       await _channel?.sink.close();
//       await _messageController?.close();
//       _channel = null;
//       _messageController = null;
//       _isConnected = false;
//       log('✅ WebSocket disconnected');
//     } catch (e) {
//       log('❌ Error disconnecting WebSocket: $e');
//     }
//   }

//   /// Reconnect WebSocket
//   Future<void> reconnect(int profileId) async {
//     log('🔄 Reconnecting WebSocket...');
//     await disconnect();
//     await Future.delayed(const Duration(seconds: 2));
//     await connect(profileId: profileId);
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';

/// WebSocket service for real-time chat messaging
class ChatSocketService {
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _messageController;
  String? _currentUrl;
  bool _isConnected = false;
  Timer? _heartbeatTimer;
  int? _currentProfileId;

  bool get isConnected => _isConnected;

  /// Connect to WebSocket server
  Future<void> connect({required int profileId}) async {
    try {
      // Disconnect existing connection if any
      if (_isConnected) {
        await disconnect();
      }

      _currentProfileId = profileId;
      _currentUrl = 'wss://socialbookwebsocket.veteransoftwares.com/ws/chat/$profileId';
      
      log('🔌 Connecting to WebSocket: $_currentUrl');
      
      _channel = WebSocketChannel.connect(Uri.parse(_currentUrl!));
      _messageController = StreamController<Map<String, dynamic>>.broadcast();
      _isConnected = true;

      // Listen to WebSocket stream
      _channel!.stream.listen(
        (data) {
          try {
            final decoded = json.decode(data);
            log('📩 Received WebSocket message: $decoded');
            _messageController?.add(decoded);
          } catch (e) {
            log('❌ Error parsing WebSocket message: $e');
            // Try to handle as string
            if (data is String) {
              log('📩 Received string message: $data');
            }
          }
        },
        onError: (error) {
          log('❌ WebSocket error: $error');
          _isConnected = false;
          _messageController?.addError(error);
          _stopHeartbeat();
        },
        onDone: () {
          log('🔌 WebSocket connection closed');
          _isConnected = false;
          _messageController?.close();
          _stopHeartbeat();
        },
      );

      // Start heartbeat to keep connection alive
      _startHeartbeat();

      log('✅ WebSocket connected successfully');
    } catch (e) {
      log('❌ Failed to connect WebSocket: $e');
      _isConnected = false;
      rethrow;
    }
  }

  /// Listen to incoming messages
  void listen({
    required Function(Map<String, dynamic>) onData,
    Function(dynamic)? onError,
    Function()? onDone,
  }) {
    if (_messageController == null) {
      log('⚠️ WebSocket not connected. Call connect() first.');
      return;
    }

    _messageController!.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
    );
  }

  /// Send message through WebSocket
  void sendMessage({
    required int senderProfileId,
    required int receiverProfileId,
    required String messageContent,
    String messageType = 'Text',
  }) {
    if (!_isConnected || _channel == null) {
      log('⚠️ Cannot send message: WebSocket not connected');
      return;
    }

    final payload = {
      'action': 'sendMessage',
      'senderProfileId': senderProfileId,
      'receiverProfileId': receiverProfileId,
      'messageType': messageType,
      'messageContent': messageContent,
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      final jsonPayload = json.encode(payload);
      log('📤 Sending message: $jsonPayload');
      _channel!.sink.add(jsonPayload);
    } catch (e) {
      log('❌ Error sending message: $e');
    }
  }

  /// Send typing indicator
  void sendTypingIndicator({
    required int senderProfileId,
    required int receiverProfileId,
    required bool isTyping,
  }) {
    if (!_isConnected || _channel == null) return;

    final payload = {
      'action': 'typing',
      'senderProfileId': senderProfileId,
      'receiverProfileId': receiverProfileId,
      'isTyping': isTyping,
    };

    try {
      _channel!.sink.add(json.encode(payload));
    } catch (e) {
      log('❌ Error sending typing indicator: $e');
    }
  }

  /// Mark message as read
  void markAsRead({
    required int messageId,
    required int profileId,
  }) {
    if (!_isConnected || _channel == null) return;

    final payload = {
      'action': 'markRead',
      'messageId': messageId,
      'profileId': profileId,
    };

    try {
      _channel!.sink.add(json.encode(payload));
    } catch (e) {
      log('❌ Error marking message as read: $e');
    }
  }

  /// Start heartbeat to keep connection alive
  void _startHeartbeat() {
    _stopHeartbeat();
    
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected && _channel != null) {
        try {
          final payload = {
            'action': 'ping',
            'timestamp': DateTime.now().toIso8601String(),
          };
          _channel!.sink.add(json.encode(payload));
          log('💓 Heartbeat sent');
        } catch (e) {
          log('❌ Error sending heartbeat: $e');
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  /// Stop heartbeat timer
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Disconnect WebSocket
  Future<void> disconnect() async {
    try {
      log('🔌 Disconnecting WebSocket...');
      
      _stopHeartbeat();
      
      await _channel?.sink.close();
      await _messageController?.close();
      
      _channel = null;
      _messageController = null;
      _isConnected = false;
      _currentProfileId = null;
      
      log('✅ WebSocket disconnected');
    } catch (e) {
      log('❌ Error disconnecting WebSocket: $e');
    }
  }

  /// Reconnect WebSocket
  Future<void> reconnect() async {
    if (_currentProfileId == null) {
      log('❌ Cannot reconnect: No profile ID stored');
      return;
    }

    log('🔄 Reconnecting WebSocket...');
    await disconnect();
    await Future.delayed(const Duration(seconds: 2));
    await connect(profileId: _currentProfileId!);
  }

  /// Check connection status
  bool checkConnection() {
    return _isConnected && _channel != null;
  }
}