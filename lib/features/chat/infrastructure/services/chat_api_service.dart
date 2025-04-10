import 'package:boilerplate_app/features/chat/infrastructure/DTO/message_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../DTO/message_dto.dart';

part 'chat_api_service.g.dart';

@RestApi()
abstract class ChatApiService {
  factory ChatApiService(Dio dio, {String baseUrl}) = _ChatApiService;

  @GET('/chat')
  Future<List<MessageDTO>> getMessages();

  @POST('/chat')
  Future<LlmRequestDTO> sendMessage(@Body() LlmRequestDTO message);

  @PUT('/messages/{id}/status')
  Future<MessageDTO> updateMessageStatus(
    @Path('id') String messageId,
    @Body() Map<String, String> status,
  );
}

// class ChatApiService {
//   final Dio dio;

//   ChatApiService({required this.dio});

//   Future<List<MessageDTO>> getMessages() async {
//     return [];
//   }

//   Future<LlmRequestDTO> sendMessage(LlmRequestDTO message) async {
//     return LlmRequestDTO(message: MessageDTO(content: '', role: ''), model: '');
//   }

//   // Future<MessageDTO> updateMessageStatus(
//   //   @Path('id') String messageId,
//   //   @Body() Map<String, String> status,
//   // );
// }
