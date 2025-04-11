import 'package:boilerplate_app/core/helpers/enums.dart';
import 'package:boilerplate_app/features/chat/application/chat_state.dart';
import 'package:boilerplate_app/features/chat/domain/message.dart';
import 'package:boilerplate_app/features/chat/infrastructure/repositories/chat_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatApplicationNotifier extends StateNotifier<ChatState> {
  late MessageRepository _repository;

  ChatApplicationNotifier(this._repository) : super(const ChatState.initial());

  Future<void> send(String text) async {
    state = const ChatState.loading();

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
      origin: MessageOrigin.user,
    );

    final response = await _repository.sendMessage(message);

    response.fold((error) => state = ChatState.error(error),
        (date) => state = ChatState.success());
  }
}
