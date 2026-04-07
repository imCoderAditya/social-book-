import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/models/chat/chat_mesage_model.dart';
import 'package:social_book/app/data/models/onlineUser/online_user_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatController extends GetxController {
  // User and session data
  Rxn<OnlineUser> onlineUser = Rxn<OnlineUser>();
  var sessionId = 0.obs;

  int currentUserProfileId = 1;

  // WebSocket
  WebSocketChannel? _channel;
  RxBool isConnected = false.obs;
  RxBool isConnecting = false.obs;

  // Messages
  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  RxBool isLoading = false.obs;

  // UI Controllers
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    initialized1();
  }

  void initialized1() async {
    isLoading.value = true; // TODO LOADER END
    onlineUser.value = Get.arguments["userChatData"];
    sessionId.value = onlineUser.value?.sessionId ?? 0;
    log("sessionId.value ${sessionId.value}");
    if (sessionId.value > 0) {
      await connectWebSocket();
      await loadChatHistory(); // Optional: Load previous messages
    }
  }

  //   void initialized1() async {
  //   isLoading.value = true;

  //   onlineUser.value = Get.arguments["userChatData"];
  //   sessionId.value = onlineUser.value?.sessionId ?? 0;

  //   // 👇 loader sirf initial setup ke liye
  //   await Future.delayed(const Duration(milliseconds: 300));

  //   if (sessionId.value > 0) {
  //     connectWebSocket(); // ❗ await mat karo
  //   }

  // }

  /// Connect to WebSocket
  Future<void> connectWebSocket() async {
    if (isConnected.value || isConnecting.value) return;

    try {
      isConnecting.value = true;

      final wsUrl =
          'wss://socialbookwebsocket.veteransoftwares.com/ws/chat/${sessionId.value}';

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Listen to messages
      _channel?.stream.listen(
        (data) {
          _handleIncomingMessage(data);
        },
        onError: (error) {
          debugPrint('WebSocket Error: $error');
          isConnected.value = false;
          isConnecting.value = false;

          // Attempt reconnection after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            if (!isConnected.value) {
              connectWebSocket();
            }
          });
        },
        onDone: () {
          log('WebSocket connection closed');
          isConnected.value = false;
          isConnecting.value = false;

          // Attempt reconnection
          Future.delayed(const Duration(seconds: 3), () {
            if (!isConnected.value && sessionId.value > 0) {
              connectWebSocket();
            }
          });
        },
      );

      isConnected.value = true;
      isConnecting.value = false;

      log('WebSocket connected successfully');
    } catch (e) {
      log('Failed to connect WebSocket: $e');
      isConnecting.value = false;

      // Retry connection
      Future.delayed(const Duration(seconds: 3), () {
        connectWebSocket();
      });
    }
  }

  /// Handle incoming WebSocket messages
  void _handleIncomingMessage(dynamic data) {
    try {
      final jsonData = json.decode(data);

      if (jsonData['type'] == 'chat_message') {
        final message = ChatMessage.fromJson(jsonData);

        // Add message to list (avoid duplicates)
        if (!messages.any((m) => m.messageID == message.messageID)) {
          messages.insert(0, message); // Insert at beginning for reverse list

          // Scroll to bottom
          Future.delayed(const Duration(milliseconds: 100), () {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      }
    } catch (e) {
      log('Error parsing message: $e');
    } finally {
      isLoading.value = false; // TODO LOADER END
    }
  }

  /// Send text message
  void sendTextMessage(String content) {
    if (content.trim().isEmpty || !isConnected.value) {
      Get.snackbar(
        'Error',
        'Cannot send message. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final receiverProfileId = onlineUser.value?.otherProfileId ?? 127;
    LoggerUtils.debug("Friend userId $receiverProfileId");
    final message = {
      "action": "sendMessage",
      "senderProfileId": currentUserProfileId,
      "receiverProfileId": receiverProfileId,
      "messageType": "Text",
      "messageContent": content,
    };

    try {
      _channel?.sink.add(json.encode(message));
      messageController.clear();
      update(); // Update UI for send button icon
    } catch (e) {
      debugPrint('Error sending message: $e');
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Load chat history (Optional - implement based on your API)
  Future<void> loadChatHistory() async {
    try {
      // isLoading.value = true;

      // TODO: Implement API call to load previous messages
      // Example:
      // final response = await ApiService.getChatHistory(sessionId.value);
      // messages.value = response.map((json) => ChatMessage.fromJson(json)).toList();

      // isLoading.value = false;
    } catch (e) {
      print('Error loading chat history: $e');
      // isLoading.value = false;
    }
  }

  /// Refresh chat
  void refreshChat() {
    messages.clear();
    loadChatHistory();
  }

  /// Clear chat
  void clearChat() {
    messages.clear();
    Get.snackbar(
      'Chat Cleared',
      'All messages have been removed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Disconnect WebSocket
  void disconnectWebSocket() {
    _channel?.sink.close();
    isConnected.value = false;
    isConnecting.value = false;
  }

  @override
  void onClose() {
    disconnectWebSocket();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
