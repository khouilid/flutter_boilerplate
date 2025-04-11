import 'package:boilerplate_app/core/helpers/enums.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String text;
  final DateTime timestamp;
  final MessageOrigin origin;
  final MessageStatus status;

  const Message({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.origin,
    this.status = MessageStatus.sent,
  });

  @override
  List<Object?> get props => [id, text, timestamp, origin, status];
}

enum MessageStatus {
  sent,
  delivered,
  read,
}
