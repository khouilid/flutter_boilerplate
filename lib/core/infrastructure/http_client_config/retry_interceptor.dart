import 'dart:io';

import 'package:dio/dio.dart';

/// A Dio interceptor that automatically retries failed HTTP requests on transient network errors.
///
/// This interceptor handles common network failures such as connection resets, timeouts,
/// and temporary connectivity issues by retrying the request with exponential backoff.
///
/// ## When Retries Occur
/// Retries are triggered for the following error types:
/// - [DioExceptionType.connectionError] - General connection errors
/// - [DioExceptionType.connectionTimeout] - Connection establishment timeout
/// - [DioExceptionType.receiveTimeout] - Response receive timeout
/// - [DioExceptionType.sendTimeout] - Request send timeout
/// - [SocketException] with "reset" in the message (connection reset by peer)
///
/// ## When Retries Are Skipped
/// Retries are NOT attempted for:
/// - [DioExceptionType.badResponse] - Server returned an HTTP error response (4xx/5xx)
/// - [DioExceptionType.cancel] - Request was cancelled
/// - [DioExceptionType.badCertificate] - SSL/TLS certificate validation failed
///
/// ## Retry Strategy
/// Uses exponential backoff with configurable delays. Default delays are:
/// - First retry: 1 second
/// - Second retry: 2 seconds
/// - Subsequent retries: 4 seconds (uses last value if retries exceed delay list length)
///
/// ## Example
/// ```dart
/// final dio = Dio();
/// dio.interceptors.add(RetryInterceptor(
///   retries: 3,
///   dio: dio,
///   retryDelays: const [
///     Duration(seconds: 1),
///     Duration(seconds: 2),
///     Duration(seconds: 4),
///   ],
/// ));
/// ```
class RetryInterceptor extends Interceptor {
  /// Creates a retry interceptor with the specified configuration.
  ///
  /// [retries] Maximum number of retry attempts (default: 2)
  /// [retryDelays] Delays between retry attempts using exponential backoff
  /// [dio] The Dio instance used to re-execute failed requests
  RetryInterceptor({
    this.retries = 2,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ],
    required this.dio,
  });

  /// Maximum number of retry attempts for failed requests.
  final int retries;

  /// Delays between each retry attempt.
  ///
  /// Uses exponential backoff pattern. If the number of retries exceeds
  /// the length of this list, the last delay value is reused.
  final List<Duration> retryDelays;

  /// The Dio instance used to re-execute failed requests.
  final Dio dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      super.onError(err, handler);
      return;
    }

    var retryCount = 0;
    var currentError = err;

    while (retryCount < retries) {
      final delay = retryCount < retryDelays.length
          ? retryDelays[retryCount]
          : retryDelays.last;

      await Future<void>.delayed(delay);

      try {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } on DioException catch (e) {
        currentError = e;
        retryCount++;
        if (!_shouldRetry(e)) {
          break;
        }
      }
    }

    super.onError(currentError, handler);
  }

  /// Determines whether a failed request should be retried.
  ///
  /// Returns `true` for transient network errors that may succeed on retry,
  /// and `false` for permanent failures that will not benefit from retrying.
  bool _shouldRetry(DioException error) {
    if (error.type == DioExceptionType.badResponse) {
      return false;
    }
    if (error.type == DioExceptionType.cancel) {
      return false;
    }
    if (error.type == DioExceptionType.badCertificate) {
      return false;
    }

    if (error.error is SocketException) {
      final socketError = error.error! as SocketException;
      if (socketError.message.contains('reset')) {
        return true;
      }
    }

    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout;
  }
}
