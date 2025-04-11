import 'package:boilerplate_app/features/chat/application/chat_application.dart';
import 'package:boilerplate_app/features/chat/application/chat_state.dart';
import 'package:boilerplate_app/features/chat/infrastructure/repositories/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatApplicationProvider =
    StateNotifierProvider<ChatApplicationNotifier, ChatState>((ref) {
  final repository = ref.watch(messageRepositoryProvider.notifier);
  return ChatApplicationNotifier(repository);
});
