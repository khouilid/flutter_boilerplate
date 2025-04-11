import 'dart:async';
import 'package:boilerplate_app/config/infrastructure/helpers/repository_helper.dart';
import 'package:boilerplate_app/features/chat/domain/message.dart';
import 'package:boilerplate_app/features/chat/infrastructure/services/chat_api_service.dart';
import 'package:boilerplate_app/features/chat/infrastructure/DTO/message_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

@Riverpod()
class MessageRepository extends _$MessageRepository with RepositoryHelper {
  late ChatApiService _apiService;

  @override
  Future<void> build() async {
    _apiService = ref.read(chatApiServiceProvider.notifier);
  }

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

  Future<void> updateMessageStatus(String messageId, MessageStatus status) async {}
}
