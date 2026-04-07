// import 'dart:developer';
// import 'package:social_book/app/data/models/chat/chat_mesage_model.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';


// /// SQLite database service for local message storage
// class ChatLocalDbService {
//   static Database? _database;
//   static const String _tableName = 'chat_messages';

//   /// Get database instance (singleton pattern)
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   /// Initialize database
//   Future<Database> _initDatabase() async {
//     try {
//       final dbPath = await getDatabasesPath();
//       final path = join(dbPath, 'social_book_chat.db');

//       log('📂 Opening database at: $path');

//       return await openDatabase(
//         path,
//         version: 1,
//         onCreate: _onCreate,
//         onUpgrade: _onUpgrade,
//       );
//     } catch (e) {
//       log('❌ Error initializing database: $e');
//       rethrow;
//     }
//   }

//   /// Create tables on first run
//   Future<void> _onCreate(Database db, int version) async {
//     try {
//       log('🏗️ Creating chat_messages table...');
      
//       await db.execute('''
//         CREATE TABLE $_tableName (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           messageId INTEGER,
//           sessionId INTEGER,
//           senderProfileId INTEGER NOT NULL,
//           receiverProfileId INTEGER NOT NULL,
//           messageType TEXT NOT NULL DEFAULT 'Text',
//           messageContent TEXT NOT NULL,
//           mediaUrl TEXT,
//           createdAt INTEGER NOT NULL,
//           isMine INTEGER NOT NULL DEFAULT 0,
//           type TEXT,
//           source TEXT,
//           isRead INTEGER DEFAULT 0,
//           isDelivered INTEGER DEFAULT 0
//         )
//       ''');

//       // Create indexes for faster queries
//       await db.execute('''
//         CREATE INDEX idx_sender_receiver 
//         ON $_tableName (senderProfileId, receiverProfileId)
//       ''');

//       await db.execute('''
//         CREATE INDEX idx_created_at 
//         ON $_tableName (createdAt DESC)
//       ''');

//       log('✅ Database tables created successfully');
//     } catch (e) {
//       log('❌ Error creating tables: $e');
//       rethrow;
//     }
//   }

//   /// Handle database upgrades
//   Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
//     log('🔄 Upgrading database from v$oldVersion to v$newVersion');
//     // Add migration logic here if needed
//   }

//   /// Insert a new message into database
//   Future<int> insertMessage(ChatMessageModel message) async {
//     try {
//       final db = await database;
//       final id = await db.insert(
//         _tableName,
//         message.toDb(),
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//       log('✅ Message inserted with ID: $id');
//       return id;
//     } catch (e) {
//       log('❌ Error inserting message: $e');
//       rethrow;
//     }
//   }

//   /// Get all messages for a specific conversation
//   /// Returns messages sorted by newest first (for reverse ListView)
//   Future<List<ChatMessageModel>> getMessagesByUser({
//     required int myProfileId,
//     required int otherProfileId,
//     int limit = 100,
//   }) async {
//     try {
//       final db = await database;
      
//       // Get messages where I'm sender OR receiver with the other user
//       final List<Map<String, dynamic>> maps = await db.query(
//         _tableName,
//         where: '''
//           (senderProfileId = ? AND receiverProfileId = ?) 
//           OR 
//           (senderProfileId = ? AND receiverProfileId = ?)
//         ''',
//         whereArgs: [myProfileId, otherProfileId, otherProfileId, myProfileId],
//         orderBy: 'createdAt DESC',
//         limit: limit,
//       );

//       log('📦 Fetched ${maps.length} messages from database');

//       return maps.map((map) => ChatMessageModel.fromDb(map)).toList();
//     } catch (e) {
//       log('❌ Error fetching messages: $e');
//       return [];
//     }
//   }

//   /// Delete all messages for a specific conversation
//   Future<int> deleteConversation({
//     required int myProfileId,
//     required int otherProfileId,
//   }) async {
//     try {
//       final db = await database;
      
//       final count = await db.delete(
//         _tableName,
//         where: '''
//           (senderProfileId = ? AND receiverProfileId = ?) 
//           OR 
//           (senderProfileId = ? AND receiverProfileId = ?)
//         ''',
//         whereArgs: [myProfileId, otherProfileId, otherProfileId, myProfileId],
//       );

//       log('🗑️ Deleted $count messages from conversation');
//       return count;
//     } catch (e) {
//       log('❌ Error deleting conversation: $e');
//       return 0;
//     }
//   }

//   /// Mark message as read
//   Future<void> markAsRead(int messageId) async {
//     try {
//       final db = await database;
//       await db.update(
//         _tableName,
//         {'isRead': 1},
//         where: 'id = ?',
//         whereArgs: [messageId],
//       );
//       log('✅ Message $messageId marked as read');
//     } catch (e) {
//       log('❌ Error marking message as read: $e');
//     }
//   }

//   /// Get unread message count for a user
//   Future<int> getUnreadCount({
//     required int myProfileId,
//     required int otherProfileId,
//   }) async {
//     try {
//       final db = await database;
      
//       final result = await db.rawQuery('''
//         SELECT COUNT(*) as count FROM $_tableName 
//         WHERE receiverProfileId = ? 
//         AND senderProfileId = ? 
//         AND isRead = 0
//       ''', [myProfileId, otherProfileId]);

//       return Sqflite.firstIntValue(result) ?? 0;
//     } catch (e) {
//       log('❌ Error getting unread count: $e');
//       return 0;
//     }
//   }

//   /// Check if message already exists (prevent duplicates)
//   Future<bool> messageExists({
//     required int senderProfileId,
//     required int receiverProfileId,
//     required String messageContent,
//     required int timestamp,
//   }) async {
//     try {
//       final db = await database;
      
//       final result = await db.query(
//         _tableName,
//         where: '''
//           senderProfileId = ? 
//           AND receiverProfileId = ? 
//           AND messageContent = ? 
//           AND createdAt = ?
//         ''',
//         whereArgs: [senderProfileId, receiverProfileId, messageContent, timestamp],
//         limit: 1,
//       );

//       return result.isNotEmpty;
//     } catch (e) {
//       log('❌ Error checking message existence: $e');
//       return false;
//     }
//   }

//   /// Close database connection
//   Future<void> close() async {
//     try {
//       final db = await database;
//       await db.close();
//       _database = null;
//       log('🔒 Database closed');
//     } catch (e) {
//       log('❌ Error closing database: $e');
//     }
//   }

//   /// Clear all chat data (for debugging/testing)
//   Future<void> clearAllMessages() async {
//     try {
//       final db = await database;
//       await db.delete(_tableName);
//       log('🗑️ All messages cleared from database');
//     } catch (e) {
//       log('❌ Error clearing messages: $e');
//     }
//   }
// }