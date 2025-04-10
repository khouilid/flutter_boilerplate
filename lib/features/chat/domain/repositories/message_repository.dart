import '../entities/message.dart';

abstract class MessageRepository {
  Future<List<Message>> getMessages();
  Future<void> sendMessage(Message message);
  Future<void> updateMessageStatus(String messageId, MessageStatus status);
  Stream<List<Message>> watchMessages();
}
