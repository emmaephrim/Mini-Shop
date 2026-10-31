import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
import 'package:mini_shop_app/features/chat/controllers/chat_provider.dart';
import 'package:mini_shop_app/features/chat/widgets/chat_input.dart';
import 'package:mini_shop_app/features/chat/widgets/message_bubble.dart';

class ChatScreen extends ConsumerWidget {
  final String chatId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.receiverName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authServiceProvider).currentUser;
    final messageAsync = ref.watch(chatMessagesStreamProvider(chatId));

    return Scaffold(
      appBar: AppBar(title: Text(receiverName)),
      body: Column(
        children: [
          Expanded(
            child: messageAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text('No messages yes say hi!'));
                }

                final reversedMessages = messages.reversed.toList();

                return ListView.builder(
                  itemCount: reversedMessages.length,
                  itemBuilder: (ctx, index) {
                    final message = reversedMessages[index];
                    final isMe = message.senderId == currentUser?.uid;

                    return MessageBubble(message: message, isMe: isMe);
                  },
                );
              },
              error: ((error, stackTrace) =>
                  Center(child: Text('Error: $error'))),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
          // Input Area
          ChatInput(chatId: chatId),
        ],
      ),
    );
  }
}
