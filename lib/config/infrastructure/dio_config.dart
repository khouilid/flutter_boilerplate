import 'package:boilerplate_app/config/env/environment.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioConfig {

  static const Duration connectTimeout = Duration(seconds: 100);
  static const Duration receiveTimeout = Duration(seconds: 100);

  static Dio createDio(Logger logger) {
    final dio = Dio(BaseOptions(
      baseUrl: Environment.baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    dio.interceptors.addAll([
      _createLoggingInterceptor(logger),
      _createAuthInterceptor(),
      _createErrorInterceptor(),
    ]);

    return dio;
  }

  static InterceptorsWrapper _createLoggingInterceptor(Logger logger) {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.i('Request: ${options.method} ${options.path}');
        logger.d('Request data: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.i('Response: ${response.statusCode}');
        logger.d('Response data: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        logger.e('Error: ${error.message}');
        logger.e('Error response: ${error.response?.data}');
        return handler.next(error);
      },
    );
  }

  static InterceptorsWrapper _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token if available
        // final token = await getToken();
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        return handler.next(options);
      },
    );
  }

  static InterceptorsWrapper _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Handle unauthorized error
          // await refreshToken();
          // return handler.resolve(await _retry(error.requestOptions));
        }
        return handler.next(error);
      },
    );
  }

  // static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
  //   final options = Options(
  //     method: requestOptions.method,
  //     headers: requestOptions.headers,
  //   );
  //   return dio.request<dynamic>(
  //     requestOptions.path,
  //     data: requestOptions.data,
  //     queryParameters: requestOptions.queryParameters,
  //     options: options,
  //   );
  // }
}
