import 'package:boilerplate_app/core/env/env.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Dio interceptor that handles authentication and request configuration.
///
/// This interceptor is applied to all outgoing HTTP requests and:
/// - Sets the `Content-Type` header to `application/json; charset=UTF-8`
/// - Adds the `Authorization` header with Bearer token if available
/// - Configures the base URL from environment settings
/// - Sets request timeouts for connection, receive, and send operations
///
/// ## Timeout Values
/// - Connect timeout: 15 seconds (time to establish TCP connection)
/// - Receive timeout: 30 seconds (time to receive response after request sent)
/// - Send timeout: 30 seconds (time to send request body)
class DioInterceptor extends Interceptor {
  /// Creates an interceptor with the given authenticator for token retrieval.
  DioInterceptor(this._token);
  final String? _token;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    Logger().i(Environment.baseUrl);
    final modifiedOptions = options
      ..headers.addAll({
        'Content-Type': 'application/json; charset=UTF-8',
        if (_token != null) 'Authorization': 'Bearer $_token',
      })
      ..baseUrl = Environment.baseUrl
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 30)
      ..sendTimeout = const Duration(seconds: 30);

    handler.next(modifiedOptions);
  }
}

class LoggingInterceptor extends InterceptorsWrapper {
  LoggingInterceptor({required this.baseUrl});
  int maxCharactersPerLine = 200;
  String baseUrl;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String bodyString;
    if (options.data is FormData) {
      final formData = options.data as FormData;
      bodyString = 'FormData:\n';

      // Print fields
      for (final field in formData.fields) {
        bodyString += '  ${field.key}: ${field.value}\n';
      }

      // Print files
      for (final file in formData.files) {
        bodyString +=
            '  ${file.key}: ${file.value.filename} (${file.value.length} bytes)\n';
      }
    } else {
      bodyString = options.data?.toString() ?? 'null';
    }

    Logger().d(
      'HTTP On Request ${options.method}\n'
      'Path ${options.path}\n'
      'Body: $bodyString\n'
      'Headers: ${options.headers}\n'
      'Query Parameters: ${options.queryParameters}',
    );

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    Logger().i(
      'HTTP On Response ${response.requestOptions.method}\nStatusCode ${response.statusCode}\nPath ${response.requestOptions.path}',
    );

    final responseAsString = response.data.toString();

    if (responseAsString.length > maxCharactersPerLine) {
      final iterations =
          (responseAsString.length / maxCharactersPerLine).floor();
      for (var i = 0; i <= iterations; i++) {
        var endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
      }
    }
    Logger().i('HTTPS Response:${response.data}');

    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    Logger().e(
      'ERROR[${err.response != null ? err.response?.statusCode : err}] => PATH: ${err.requestOptions.path}',
    );
    Logger().e('MESSAGE: ${err.response?.data ?? ' '}');

    return super.onError(err, handler);
  }
}
