import 'dart:async';
import 'package:boilerplate_app/config/infrastructure/helpers/repository_helper.dart';

import 'package:boilerplate_app/features/chat/domain/message.dart';

import 'package:boilerplate_app/features/chat/infrastructure/services/chat_api_service.dart';
import 'package:boilerplate_app/features/chat/infrastructure/DTO/message_dto.dart';

class MessageRepository with RepositoryHelper {
  final ChatApiService _apiService;

  MessageRepository(this._apiService);


  Future<List<Message>> getMessages() async {
    return [];
  }

  FutureEitherFailureOr<Message> sendMessage(Message message) async {
    final dto = MessageDTO.fromDomain(message);

    return handleData(
        _apiService.sendMessage(
            LlmRequestDTO(message: dto, model: 'gemma3:1b')), (data) async {
      return data.getMessage().toDomain();
    });
  }

  Future<void> updateMessageStatus(
      String messageId, MessageStatus status) async {}
}
