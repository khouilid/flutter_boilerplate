import 'dart:async';
import '../../domain/entities/message.dart';
import '../../domain/repositories/message_repository.dart';
import '../services/chat_api_service.dart';
import '../DTO/message_dto.dart';

class MessageRepositoryImpl implements MessageRepository {
  final ChatApiService _apiService;
  final List<Message> _messages = [];
  final _messagesController = StreamController<List<Message>>.broadcast();

  MessageRepositoryImpl(this._apiService) {
    _loadInitialMessages();
  }

  Future<void> _loadInitialMessages() async {
    try {
      // final messages = await _apiService.getMessages();
      // _messages.addAll(messages.map((dto) => dto.toDomain()));
      _messagesController.add(_messages);
    } catch (e) {
      // Handle error appropriately
      _messagesController.addError(e);
    }
  }

  @override
  Future<List<Message>> getMessages() async {
    return _messages;
  }

  @override
  Future<void> sendMessage(Message message) async {
    try {
      final dto = MessageDTO.fromDomain(message);
      _messages.add(message);
      _messagesController.add(_messages);
      final response = await _apiService
          .sendMessage(LlmRequestDTO(message: dto, model: 'gemma3:1b'));
      _messages.add(response.getMessage().toDomain());
      _messagesController.add(_messages);
    } catch (e) {
      // Handle error appropriately
      _messagesController.addError(e);
    }
  }

  @override
  Future<void> updateMessageStatus(
      String messageId, MessageStatus status) async {
    // try {
    //   final response = await _apiService.updateMessageStatus(
    //     messageId,
    //     {'status': status.toString().split('.').last},
    //   );
    //   final index = _messages.indexWhere((m) => m.id == messageId);
    //   if (index != -1) {
    //     _messages[index] = response.toDomain();
    //     _messagesController.add(_messages);
    //   }
    // } catch (e) {
    //   // Handle error appropriately
    //   _messagesController.addError(e);
    // }
  }

  @override
  Stream<List<Message>> watchMessages() {
    return _messagesController.stream;
  }

  void dispose() {
    _messagesController.close();
  }
}
