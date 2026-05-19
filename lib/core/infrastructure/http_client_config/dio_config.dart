import 'package:boilerplate_app/core/env/env.dart';
import 'package:boilerplate_app/core/infrastructure/http_client_config/dio_interceptor.dart';
import 'package:boilerplate_app/core/infrastructure/http_client_config/retry_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioConfig {
  static late Dio httpClient;
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static Dio createDio(Logger logger, String token) {
    httpClient = Dio()
      ..interceptors.addAll([
        DioInterceptor(token),
        LoggingInterceptor(baseUrl: Environment.baseUrl),
        RetryInterceptor(dio: httpClient)
      ]);

    return httpClient;
  }
}
