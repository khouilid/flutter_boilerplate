import 'package:boilerplate_app/core/helpers/enums.dart';
import 'package:boilerplate_app/features/chat/domain/entities/message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_dto.g.dart';

@JsonSerializable()
class MessageDTO {
  @JsonKey(name: 'role')
  final String role;
  @JsonKey(name: 'content')
  final String content;

  MessageDTO({
    required this.role,
    required this.content,
  });

  factory MessageDTO.fromJson(Map<String, dynamic> json) =>
      _$MessageDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDTOToJson(this);

  factory MessageDTO.fromDomain(Message message) {
    return MessageDTO(
      role: message.origin == MessageOrigin.user ? 'user' : 'assistant',
      content: message.text,
    );
  }

  Message toDomain() {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      origin: role == 'assistant' ? MessageOrigin.llm : MessageOrigin.user,
      text: content,
      timestamp: DateTime.now(),
    );
  }
}

@JsonSerializable()
class LlmRequestDTO {
  @JsonKey(name: 'model')
  final String model;

  @JsonKey(name: 'message')
  final MessageDTO message;

  LlmRequestDTO({
    required this.model,
    required this.message,
  });

  factory LlmRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$LlmRequestDTOFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      "model": "gemma3:1b",
      "messages": [
        // ...oldMessages.map(
        //   (message) => {"role": message.role, "content": message.content},
        // ),
        {
          "role": "user", //"user" is a prompt provided by the user.
          "content": message.content //user prompt should be written here
        }
      ],
      "stream": false
    };
  }

  MessageDTO getMessage() {
    return message;
  }
}
