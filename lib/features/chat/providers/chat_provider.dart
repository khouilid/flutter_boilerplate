import 'package:boilerplate_app/config/providers/network_provider.dart';
import 'package:boilerplate_app/features/chat/application/chat_application.dart';
import 'package:boilerplate_app/features/chat/application/chat_state.dart';
import 'package:boilerplate_app/features/chat/infrastructure/repositories/message_repository.dart';
import 'package:boilerplate_app/features/chat/infrastructure/services/chat_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatApiServiceProvider = Provider<ChatApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ChatApiService(dio);
});

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  final apiService = ref.watch(chatApiServiceProvider);
  final repository = MessageRepository(apiService);
  return repository;
});

// final messagesProvider = StreamProvider((ref) {
//   final repository = ref.watch(messageRepositoryProvider);
//   return repository.watchMessages();
// });

final chatApplicationProvider =
    StateNotifierProvider<ChatApplicationNotifier, ChatState>((ref) {
  final repository = ref.watch(messageRepositoryProvider);
  return ChatApplicationNotifier(repository);
});
