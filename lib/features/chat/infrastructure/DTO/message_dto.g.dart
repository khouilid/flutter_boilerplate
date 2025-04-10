// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDTO _$MessageDTOFromJson(Map<String, dynamic> json) => MessageDTO(
      role: json['role'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$MessageDTOToJson(MessageDTO instance) =>
    <String, dynamic>{
      'role': instance.role,
      'content': instance.content,
    };

LlmRequestDTO _$LlmRequestDTOFromJson(Map<String, dynamic> json) =>
    LlmRequestDTO(
      model: json['model'] as String,
      message: MessageDTO.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LlmRequestDTOToJson(LlmRequestDTO instance) =>
    <String, dynamic>{
      'model': instance.model,
      'message': instance.message,
    };
