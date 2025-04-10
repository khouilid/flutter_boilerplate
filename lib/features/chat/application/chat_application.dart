import 'package:boilerplate_app/core/helpers/enums.dart';
import 'package:boilerplate_app/features/chat/domain/entities/message.dart';
import 'package:boilerplate_app/features/chat/domain/repositories/message_repository.dart';

class ChatApplication {
  final MessageRepository _repository;

  ChatApplication(this._repository);

  Future<void> send(String text) async {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
      origin: MessageOrigin.user,
    );

    await _repository.sendMessage(message);
  }
}
