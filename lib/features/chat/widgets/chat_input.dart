import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
import 'package:mini_shop_app/features/chat/controllers/chat_provider.dart';

class ChatInput extends ConsumerStatefulWidget {
  final String chatId;
  const ChatInput({super.key, required this.chatId});

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  final _controller = TextEditingController();
  bool _isSending = false;

  Future<void> _send() async {
    final text = _controller.text;
    if (text.isEmpty) return;

    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) return;

    setState(() => _isSending = true);

    try {
      // Assuming you wrapped the sendMessage method from earlier in a provider
      ref
          .read(chatServiceProvider)
          .sendMessage(chatId: widget.chatId, senderId: user.uid, text: text);
      _controller.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send message')));
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type a message..',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: _isSending
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : IconButton(
                      onPressed: _send,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
