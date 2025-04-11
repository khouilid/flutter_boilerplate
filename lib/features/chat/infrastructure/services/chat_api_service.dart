import 'package:boilerplate_app/config/providers/network_provider.dart';
import 'package:boilerplate_app/features/chat/infrastructure/DTO/message_dto.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_api_service.g.dart';

@Riverpod()
class ChatApiService extends _$ChatApiService {
  late Dio dio;

  @override
  Future<void> build() async {
    dio = ref.watch(dioProvider);
  }

  Future<List<MessageDTO>> getMessages() async {
    return [];
  }

  Future<LlmRequestDTO> sendMessage(LlmRequestDTO message) async {
    return LlmRequestDTO(message: MessageDTO(content: '', role: ''), model: '');
  }
}
