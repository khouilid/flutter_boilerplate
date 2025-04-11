import 'package:boilerplate_app/config/providers/network_provider.dart';
import 'package:boilerplate_app/config/infrastructure/helpers/remote_service_helper.dart';
import 'package:boilerplate_app/features/chat/infrastructure/DTO/message_dto.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_api_service.g.dart';

@Riverpod()
class ChatApiService extends _$ChatApiService with RemoteServiceHelper {
  late Dio _dio;

  @override
  Future<void> build() async {
    _dio = ref.watch(dioProvider);
  }

  Future<List<MessageDTO>> getMessages() async {
    return [];
  }

  Future<LlmRequestDTO> sendMessage(LlmRequestDTO message) async {
    return remoteResponseHandler(
      _dio.post(
        '/chat',
        data: message.toJson(),
      ),
      (data) => LlmRequestDTO.fromJson(data),
    );
  }
}
