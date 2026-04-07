// // // To parse this JSON data, do
// // //
// // //     final chatMessageModel = chatMessageModelFromJson(jsonString);

// // import 'dart:convert';

// // ChatMessageModel chatMessageModelFromJson(String str) => ChatMessageModel.fromJson(json.decode(str));

// // String chatMessageModelToJson(ChatMessageModel data) => json.encode(data.toJson());

// // class ChatMessageModel {
// //     final String? type;
// //     final int? messageId;
// //     final int? sessionId;
// //     final int? senderProfileId;
// //     final int? receiverProfileId;
// //     final String? messageType;
// //     final String? messageContent;
// //     final dynamic mediaUrl;
// //     final bool? isEncrypted;
// //     final bool? isRead;
// //     final dynamic readAt;
// //     final bool? isDelivered;
// //     final dynamic deliveredAt;
// //     final bool? isDeleted;
// //     final dynamic deletedBy;
// //     final DateTime? createdAt;
// //     final String? source;

// //     ChatMessageModel({
// //         this.type,
// //         this.messageId,
// //         this.sessionId,
// //         this.senderProfileId,
// //         this.receiverProfileId,
// //         this.messageType,
// //         this.messageContent,
// //         this.mediaUrl,
// //         this.isEncrypted,
// //         this.isRead,
// //         this.readAt,
// //         this.isDelivered,
// //         this.deliveredAt,
// //         this.isDeleted,
// //         this.deletedBy,
// //         this.createdAt,
// //         this.source,
// //     });

// //     ChatMessageModel copyWith({
// //         String? type,
// //         int? messageId,
// //         int? sessionId,
// //         int? senderProfileId,
// //         int? receiverProfileId,
// //         String? messageType,
// //         String? messageContent,
// //         dynamic mediaUrl,
// //         bool? isEncrypted,
// //         bool? isRead,
// //         dynamic readAt,
// //         bool? isDelivered,
// //         dynamic deliveredAt,
// //         bool? isDeleted,
// //         dynamic deletedBy,
// //         DateTime? createdAt,
// //         String? source,
// //     }) => 
// //         ChatMessageModel(
// //             type: type ?? this.type,
// //             messageId: messageId ?? this.messageId,
// //             sessionId: sessionId ?? this.sessionId,
// //             senderProfileId: senderProfileId ?? this.senderProfileId,
// //             receiverProfileId: receiverProfileId ?? this.receiverProfileId,
// //             messageType: messageType ?? this.messageType,
// //             messageContent: messageContent ?? this.messageContent,
// //             mediaUrl: mediaUrl ?? this.mediaUrl,
// //             isEncrypted: isEncrypted ?? this.isEncrypted,
// //             isRead: isRead ?? this.isRead,
// //             readAt: readAt ?? this.readAt,
// //             isDelivered: isDelivered ?? this.isDelivered,
// //             deliveredAt: deliveredAt ?? this.deliveredAt,
// //             isDeleted: isDeleted ?? this.isDeleted,
// //             deletedBy: deletedBy ?? this.deletedBy,
// //             createdAt: createdAt ?? this.createdAt,
// //             source: source ?? this.source,
// //         );

// //     factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
// //         type: json["type"],
// //         messageId: json["messageID"],
// //         sessionId: json["sessionID"],
// //         senderProfileId: json["senderProfileID"],
// //         receiverProfileId: json["receiverProfileID"],
// //         messageType: json["messageType"],
// //         messageContent: json["messageContent"],
// //         mediaUrl: json["mediaURL"],
// //         isEncrypted: json["isEncrypted"],
// //         isRead: json["isRead"],
// //         readAt: json["readAt"],
// //         isDelivered: json["isDelivered"],
// //         deliveredAt: json["deliveredAt"],
// //         isDeleted: json["isDeleted"],
// //         deletedBy: json["deletedBy"],
// //         createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
// //         source: json["source"],
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "type": type,
// //         "messageID": messageId,
// //         "sessionID": sessionId,
// //         "senderProfileID": senderProfileId,
// //         "receiverProfileID": receiverProfileId,
// //         "messageType": messageType,
// //         "messageContent": messageContent,
// //         "mediaURL": mediaUrl,
// //         "isEncrypted": isEncrypted,
// //         "isRead": isRead,
// //         "readAt": readAt,
// //         "isDelivered": isDelivered,
// //         "deliveredAt": deliveredAt,
// //         "isDeleted": isDeleted,
// //         "deletedBy": deletedBy,
// //         "createdAt": createdAt?.toIso8601String(),
// //         "source": source,
// //     };
// // }

// // import 'dart:convert';

// // /// Message model for chat with SQLite support
// // class ChatMessageModel {
// //   final int? id; // SQLite auto-increment ID
// //   final String? type; // WebSocket message type
// //   final int? messageId; // Server-side message ID
// //   final int? sessionId;
// //   final int senderProfileId;
// //   final int receiverProfileId;
// //   final String messageType; // "Text", "Image", etc.
// //   final String messageContent;
// //   final String? mediaUrl;
// //   final bool? isEncrypted;
// //   final bool? isRead;
// //   final String? readAt;
// //   final bool? isDelivered;
// //   final String? deliveredAt;
// //   final bool? isDeleted;
// //   final String? deletedBy;
// //   final DateTime createdAt;
// //   final String? source;
// //   final bool isMine; // Local flag to identify own messages

// //   ChatMessageModel({
// //     this.id,
// //     this.type,
// //     this.messageId,
// //     this.sessionId,
// //     required this.senderProfileId,
// //     required this.receiverProfileId,
// //     required this.messageType,
// //     required this.messageContent,
// //     this.mediaUrl,
// //     this.isEncrypted,
// //     this.isRead,
// //     this.readAt,
// //     this.isDelivered,
// //     this.deliveredAt,
// //     this.isDeleted,
// //     this.deletedBy,
// //     required this.createdAt,
// //     this.source,
// //     required this.isMine,
// //   });

// //   /// Create from WebSocket JSON response
// //   factory ChatMessageModel.fromJson(Map<String, dynamic> json, int myProfileId) {
// //     return ChatMessageModel(
// //       id: json['id'],
// //       type: json['type'],
// //       messageId: json['messageID'],
// //       sessionId: json['sessionID'],
// //       senderProfileId: json['senderProfileID'] ?? json['senderProfileId'] ?? 0,
// //       receiverProfileId: json['receiverProfileID'] ?? json['receiverProfileId'] ?? 0,
// //       messageType: json['messageType'] ?? 'Text',
// //       messageContent: json['messageContent'] ?? '',
// //       mediaUrl: json['mediaURL'],
// //       isEncrypted: json['isEncrypted'],
// //       isRead: json['isRead'],
// //       readAt: json['readAt'],
// //       isDelivered: json['isDelivered'],
// //       deliveredAt: json['deliveredAt'],
// //       isDeleted: json['isDeleted'],
// //       deletedBy: json['deletedBy'],
// //       createdAt: json['createdAt'] != null
// //           ? DateTime.parse(json['createdAt'])
// //           : DateTime.now(),
// //       source: json['source'],
// //       isMine: (json['senderProfileID'] ?? json['senderProfileId']) == myProfileId,
// //     );
// //   }

// //   /// Create from SQLite database row
// //   factory ChatMessageModel.fromDb(Map<String, dynamic> db) {
// //     return ChatMessageModel(
// //       id: db['id'],
// //       senderProfileId: db['senderProfileId'],
// //       receiverProfileId: db['receiverProfileId'],
// //       messageType: db['messageType'] ?? 'Text',
// //       messageContent: db['messageContent'] ?? '',
// //       mediaUrl: db['mediaUrl'],
// //       createdAt: DateTime.fromMillisecondsSinceEpoch(db['createdAt']),
// //       isMine: db['isMine'] == 1,
// //       messageId: db['messageId'],
// //       sessionId: db['sessionId'],
// //       type: db['type'],
// //       source: db['source'],
// //     );
// //   }

// //   /// Convert to SQLite map
// //   Map<String, dynamic> toDb() {
// //     return {
// //       'messageId': messageId,
// //       'sessionId': sessionId,
// //       'senderProfileId': senderProfileId,
// //       'receiverProfileId': receiverProfileId,
// //       'messageType': messageType,
// //       'messageContent': messageContent,
// //       'mediaUrl': mediaUrl,
// //       'createdAt': createdAt.millisecondsSinceEpoch,
// //       'isMine': isMine ? 1 : 0,
// //       'type': type,
// //       'source': source,
// //     };
// //   }

// //   /// Convert to JSON for WebSocket
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'type': type,
// //       'messageID': messageId,
// //       'sessionID': sessionId,
// //       'senderProfileID': senderProfileId,
// //       'receiverProfileID': receiverProfileId,
// //       'messageType': messageType,
// //       'messageContent': messageContent,
// //       'mediaURL': mediaUrl,
// //       'isEncrypted': isEncrypted,
// //       'isRead': isRead,
// //       'readAt': readAt,
// //       'isDelivered': isDelivered,
// //       'deliveredAt': deliveredAt,
// //       'isDeleted': isDeleted,
// //       'deletedBy': deletedBy,
// //       'createdAt': createdAt.toIso8601String(),
// //       'source': source,
// //     };
// //   }

// //   ChatMessageModel copyWith({
// //     int? id,
// //     String? type,
// //     int? messageId,
// //     int? sessionId,
// //     int? senderProfileId,
// //     int? receiverProfileId,
// //     String? messageType,
// //     String? messageContent,
// //     String? mediaUrl,
// //     bool? isEncrypted,
// //     bool? isRead,
// //     String? readAt,
// //     bool? isDelivered,
// //     String? deliveredAt,
// //     bool? isDeleted,
// //     String? deletedBy,
// //     DateTime? createdAt,
// //     String? source,
// //     bool? isMine,
// //   }) {
// //     return ChatMessageModel(
// //       id: id ?? this.id,
// //       type: type ?? this.type,
// //       messageId: messageId ?? this.messageId,
// //       sessionId: sessionId ?? this.sessionId,
// //       senderProfileId: senderProfileId ?? this.senderProfileId,
// //       receiverProfileId: receiverProfileId ?? this.receiverProfileId,
// //       messageType: messageType ?? this.messageType,
// //       messageContent: messageContent ?? this.messageContent,
// //       mediaUrl: mediaUrl ?? this.mediaUrl,
// //       isEncrypted: isEncrypted ?? this.isEncrypted,
// //       isRead: isRead ?? this.isRead,
// //       readAt: readAt ?? this.readAt,
// //       isDelivered: isDelivered ?? this.isDelivered,
// //       deliveredAt: deliveredAt ?? this.deliveredAt,
// //       isDeleted: isDeleted ?? this.isDeleted,
// //       deletedBy: deletedBy ?? this.deletedBy,
// //       createdAt: createdAt ?? this.createdAt,
// //       source: source ?? this.source,
// //       isMine: isMine ?? this.isMine,
// //     );
// //   }
// // }

// import 'dart:convert';

// /// Message delivery status
// enum MessageStatus {
//   pending,   // Not sent yet (offline or waiting)
//   sent,      // Server received it
//   delivered, // Recipient's device got it
//   read,      // Recipient opened and saw it
//   failed;    // Send failed

//   static MessageStatus fromString(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return MessageStatus.pending;
//       case 'sent':
//         return MessageStatus.sent;
//       case 'delivered':
//         return MessageStatus.delivered;
//       case 'read':
//         return MessageStatus.read;
//       case 'failed':
//         return MessageStatus.failed;
//       default:
//         return MessageStatus.pending;
//     }
//   }

//   String toDbString() => toString().split('.').last;
// }

// /// Message model for chat with SQLite support and offline capabilities
// class ChatMessageModel {
//   final int? id; // SQLite auto-increment ID
//   final String? tempId; // Temporary UUID for offline messages
//   final String? type; // WebSocket message type
//   final int? messageId; // Server-side message ID (null until synced)
//   final int? sessionId;
//   final int senderProfileId;
//   final int receiverProfileId;
//   final String messageType; // "Text", "Image", etc.
//   final String messageContent;
//   final String? mediaUrl;
//   final bool? isEncrypted;
//   final bool? isRead;
//   final String? readAt;
//   final bool? isDelivered;
//   final String? deliveredAt;
//   final bool? isDeleted;
//   final String? deletedBy;
//   final DateTime createdAt;
//   final String? source;
//   final bool isMine; // Local flag to identify own messages
//   final MessageStatus status; // Message delivery status
//   final bool isSynced; // Has this been confirmed by server?
//   final int retryCount; // For failed messages

//   ChatMessageModel({
//     this.id,
//     this.tempId,
//     this.type,
//     this.messageId,
//     this.sessionId,
//     required this.senderProfileId,
//     required this.receiverProfileId,
//     required this.messageType,
//     required this.messageContent,
//     this.mediaUrl,
//     this.isEncrypted,
//     this.isRead,
//     this.readAt,
//     this.isDelivered,
//     this.deliveredAt,
//     this.isDeleted,
//     this.deletedBy,
//     required this.createdAt,
//     this.source,
//     required this.isMine,
//     this.status = MessageStatus.pending,
//     this.isSynced = false,
//     this.retryCount = 0,
//   });

//   /// Create from WebSocket JSON response
//   factory ChatMessageModel.fromJson(Map<String, dynamic> json, int myProfileId) {
//     // Handle different field name variations from backend
//     final senderId = json['senderProfileID'] ?? 
//                      json['senderProfileId'] ?? 
//                      json['sender_profile_id'] ?? 
//                      0;
    
//     final receiverId = json['receiverProfileID'] ?? 
//                        json['receiverProfileId'] ?? 
//                        json['receiver_profile_id'] ?? 
//                        0;
    
//     final isMine = senderId == myProfileId;

//     // Debug logging
//     print('🔍 Parsing message - Sender: $senderId, Receiver: $receiverId, MyId: $myProfileId, IsMine: $isMine');

//     return ChatMessageModel(
//       id: json['id'],
//       tempId: json['tempId'] ?? json['temp_id'],
//       type: json['type'],
//       messageId: json['messageID'] ?? json['messageId'] ?? json['message_id'],
//       sessionId: json['sessionID'] ?? json['sessionId'] ?? json['session_id'],
//       senderProfileId: senderId,
//       receiverProfileId: receiverId,
//       messageType: json['messageType'] ?? json['message_type'] ?? 'Text',
//       messageContent: json['messageContent'] ?? json['message_content'] ?? '',
//       mediaUrl: json['mediaURL'] ?? json['mediaUrl'] ?? json['media_url'],
//       isEncrypted: json['isEncrypted'] ?? json['is_encrypted'],
//       isRead: json['isRead'] ?? json['is_read'],
//       readAt: json['readAt'] ?? json['read_at'],
//       isDelivered: json['isDelivered'] ?? json['is_delivered'],
//       deliveredAt: json['deliveredAt'] ?? json['delivered_at'],
//       isDeleted: json['isDeleted'] ?? json['is_deleted'],
//       deletedBy: json['deletedBy'] ?? json['deleted_by'],
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt'])
//           : (json['created_at'] != null 
//               ? DateTime.parse(json['created_at'])
//               : DateTime.now()),
//       source: json['source'],
//       isMine: isMine,
//       status: _determineStatusFromJson(json, isMine),
//       isSynced: json['messageID'] != null || 
//                 json['messageId'] != null || 
//                 json['message_id'] != null,
//     );
//   }

//   /// Determine status from JSON data
//   static MessageStatus _determineStatusFromJson(Map<String, dynamic> json, bool isMine) {
//     if (json['status'] != null) {
//       return MessageStatus.fromString(json['status']);
//     }

//     if (!isMine) {
//       // Received messages start as delivered
//       return MessageStatus.delivered;
//     }

//     // For my messages
//     if (json['isRead'] == true) return MessageStatus.read;
//     if (json['isDelivered'] == true) return MessageStatus.delivered;
//     if (json['messageID'] != null || json['messageId'] != null) {
//       return MessageStatus.sent;
//     }
//     return MessageStatus.pending;
//   }

//   /// Create from SQLite database row
//   factory ChatMessageModel.fromDb(Map<String, dynamic> db) {
//     return ChatMessageModel(
//       id: db['id'],
//       tempId: db['tempId'],
//       senderProfileId: db['senderProfileId'],
//       receiverProfileId: db['receiverProfileId'],
//       messageType: db['messageType'] ?? 'Text',
//       messageContent: db['messageContent'] ?? '',
//       mediaUrl: db['mediaUrl'],
//       createdAt: DateTime.fromMillisecondsSinceEpoch(db['createdAt']),
//       isMine: db['isMine'] == 1,
//       messageId: db['messageId'],
//       sessionId: db['sessionId'],
//       type: db['type'],
//       source: db['source'],
//       status: MessageStatus.fromString(db['status'] ?? 'pending'),
//       isSynced: db['isSynced'] == 1,
//       retryCount: db['retryCount'] ?? 0,
//       isRead: db['isRead'] == 1,
//       isDelivered: db['isDelivered'] == 1,
//       readAt: db['readAt'],
//       deliveredAt: db['deliveredAt'],
//     );
//   }

//   /// Convert to SQLite map
//   Map<String, dynamic> toDb() {
//     return {
//       'tempId': tempId,
//       'messageId': messageId,
//       'sessionId': sessionId,
//       'senderProfileId': senderProfileId,
//       'receiverProfileId': receiverProfileId,
//       'messageType': messageType,
//       'messageContent': messageContent,
//       'mediaUrl': mediaUrl,
//       'createdAt': createdAt.millisecondsSinceEpoch,
//       'isMine': isMine ? 1 : 0,
//       'type': type,
//       'source': source,
//       'status': status.toDbString(),
//       'isSynced': isSynced ? 1 : 0,
//       'retryCount': retryCount,
//       'isRead': isRead == true ? 1 : 0,
//       'isDelivered': isDelivered == true ? 1 : 0,
//       'readAt': readAt,
//       'deliveredAt': deliveredAt,
//     };
//   }

//   /// Convert to JSON for WebSocket
//   Map<String, dynamic> toJson() {
//     return {
//       'tempId': tempId,
//       'type': type,
//       'messageID': messageId,
//       'sessionID': sessionId,
//       'senderProfileID': senderProfileId,
//       'receiverProfileID': receiverProfileId,
//       'messageType': messageType,
//       'messageContent': messageContent,
//       'mediaURL': mediaUrl,
//       'isEncrypted': isEncrypted,
//       'isRead': isRead,
//       'readAt': readAt,
//       'isDelivered': isDelivered,
//       'deliveredAt': deliveredAt,
//       'isDeleted': isDeleted,
//       'deletedBy': deletedBy,
//       'createdAt': createdAt.toIso8601String(),
//       'source': source,
//       'status': status.toDbString(),
//     };
//   }

//   ChatMessageModel copyWith({
//     int? id,
//     String? tempId,
//     String? type,
//     int? messageId,
//     int? sessionId,
//     int? senderProfileId,
//     int? receiverProfileId,
//     String? messageType,
//     String? messageContent,
//     String? mediaUrl,
//     bool? isEncrypted,
//     bool? isRead,
//     String? readAt,
//     bool? isDelivered,
//     String? deliveredAt,
//     bool? isDeleted,
//     String? deletedBy,
//     DateTime? createdAt,
//     String? source,
//     bool? isMine,
//     MessageStatus? status,
//     bool? isSynced,
//     int? retryCount,
//   }) {
//     return ChatMessageModel(
//       id: id ?? this.id,
//       tempId: tempId ?? this.tempId,
//       type: type ?? this.type,
//       messageId: messageId ?? this.messageId,
//       sessionId: sessionId ?? this.sessionId,
//       senderProfileId: senderProfileId ?? this.senderProfileId,
//       receiverProfileId: receiverProfileId ?? this.receiverProfileId,
//       messageType: messageType ?? this.messageType,
//       messageContent: messageContent ?? this.messageContent,
//       mediaUrl: mediaUrl ?? this.mediaUrl,
//       isEncrypted: isEncrypted ?? this.isEncrypted,
//       isRead: isRead ?? this.isRead,
//       readAt: readAt ?? this.readAt,
//       isDelivered: isDelivered ?? this.isDelivered,
//       deliveredAt: deliveredAt ?? this.deliveredAt,
//       isDeleted: isDeleted ?? this.isDeleted,
//       deletedBy: deletedBy ?? this.deletedBy,
//       createdAt: createdAt ?? this.createdAt,
//       source: source ?? this.source,
//       isMine: isMine ?? this.isMine,
//       status: status ?? this.status,
//       isSynced: isSynced ?? this.isSynced,
//       retryCount: retryCount ?? this.retryCount,
//     );
//   }

//   /// Get unique identifier (prefer messageId, fallback to tempId)
//   String get uniqueId => messageId?.toString() ?? tempId ?? id?.toString() ?? '';
// }

import 'package:get/get.dart';
import 'package:social_book/app/modules/chat/controllers/chat_controller.dart';

class ChatMessage {
  final int messageID;
  final int sessionID;
  final int senderProfileID;
  final int receiverProfileID;
  final String messageType;
  final String messageContent;
  final String? mediaURL;
  final bool isEncrypted;
  final bool isRead;
  final String? readAt;
  final bool isDelivered;
  final String? deliveredAt;
  final bool isDeleted;
  final String? deletedBy;
  final DateTime createdAt;
  final String source;

  ChatMessage({
    required this.messageID,
    required this.sessionID,
    required this.senderProfileID,
    required this.receiverProfileID,
    required this.messageType,
    required this.messageContent,
    this.mediaURL,
    required this.isEncrypted,
    required this.isRead,
    this.readAt,
    required this.isDelivered,
    this.deliveredAt,
    required this.isDeleted,
    this.deletedBy,
    required this.createdAt,
    required this.source,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageID: json['messageID'] ?? 0,
      sessionID: json['sessionID'] ?? 0,
      senderProfileID: json['senderProfileID'] ?? 0,
      receiverProfileID: json['receiverProfileID'] ?? 0,
      messageType: json['messageType'] ?? 'Text',
      messageContent: json['messageContent'] ?? '',
      mediaURL: json['mediaURL'],
      isEncrypted: json['isEncrypted'] ?? false,
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'],
      isDelivered: json['isDelivered'] ?? false,
      deliveredAt: json['deliveredAt'],
      isDeleted: json['isDeleted'] ?? false,
      deletedBy: json['deletedBy'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      source: json['source'] ?? 'websocket',
    );
  }

   

  bool get isMine => senderProfileID == Get.find<ChatController>().currentUserProfileId;
}