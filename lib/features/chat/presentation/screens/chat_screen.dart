import 'package:boilerplate_app/features/chat/presentation/widget/bubble_message.dart';
import 'package:boilerplate_app/features/chat/presentation/widget/chat_input.dart';
import 'package:boilerplate_app/features/chat/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    setState(() => _isSending = true);
    final sendMessageUseCase = ref.read(chatUseCaseProvider);
    await sendMessageUseCase.send(_messageController.text);
    _messageController.clear();

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arcade Ai'),
        backgroundColor: Colors.transparent,
        elevation: 1,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(message: messages[index]);
                },
              ),
              loading: () => const Center(child: Text('No conversation yet!')),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
          ChatInput(
            controller: _messageController,
            onSend: _sendMessage,
            isLoading: _isSending,
          ),
        ],
      ),
    );
  }
}
