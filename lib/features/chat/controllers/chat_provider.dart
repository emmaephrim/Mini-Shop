import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/features/chat/models/message.dart';

// We use family to pass the specific chatId we want to listen to
final chatMessagesStreamProvider = StreamProvider.family<List<Message>, String>(
  (ref, chatId) {
    final dbRef = FirebaseDatabase.instance.ref('messages/$chatId');

    // .onValue is live WebSocket stream listening to this specific folder
    return dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      final List<Message> messages = [];
      data.forEach(((key, value) {
        messages.add(Message.fromMap(key, value));
      }));

      // Sort so the newest messages appear at the bottom of the chat screen
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    });
  },
);

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

class ChatService {
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final db = FirebaseDatabase.instance;
    final timestamp = DateTime.now().toIso8601String();

    // push the actual message
    await db.ref('messages/$chatId').push().set({
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    });

    // update the "Inbox" metadata so the chat moves to the top of the list
    await db.ref('chats/$chatId').update({
      'lastMessage': text,
      'lastMessageTime': timestamp,
    });
  }

  String generateChatId(String uid1, String uid2) {
    // put but IDs in a list
    final uids = [uid1, uid2];
    uids.sort();
    return '${uids[0]}_$uids[1]';
  }

  Future<String> initializeChat(String currentUserId, String sellerId) async {
    final chatId = generateChatId(currentUserId, sellerId);
    final dbRef = FirebaseDatabase.instance.ref('chats/$chatId');
    // .update instead of .set()
    //If the chat already exists, this safely re-asserts the participation
    //WITHOUT erasing their 'lastMessage' history
    await dbRef.update({
      'participants': {currentUserId: true, sellerId: true},

      // We do not overwrite lastMessage or timestamp here
    });

    return chatId;
  }
}
