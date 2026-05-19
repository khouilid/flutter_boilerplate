import 'dart:io';

import 'package:boilerplate_app/core/domain/remote_response.dart';
import 'package:boilerplate_app/core/infrastructure/exceptions/dio_exception.dart' as exp;
import 'package:boilerplate_app/core/infrastructure/extensions/dio_extensions.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'package:sentry_flutter/sentry_flutter.dart';

/// Centralized HTTP response handler for all remote service calls.
///
/// This class provides a standardized way to handle API responses across the app,
/// including:
/// - Success response validation and data mapping
/// - Error response parsing and user-friendly message extraction
/// - Network error classification (no internet vs server error)
/// - Automatic Sentry error reporting for server-side failures
///
/// ## Usage
/// Extend this class in your remote service and use [handleRemoteResponse] to wrap
/// Dio calls:
/// ```dart
/// class AuthRemoteService extends RemoteServiceHelper {
///   Future<UserDto> getUser() => handleRemoteResponse(
///     _dio.get('/user'),
///     (response) => UserDto.fromJson(response),
///   );
/// }
/// ```
mixin RemoteServiceHelper {
  final transaction = Sentry.startTransaction('processOrderBatch()', 'task');

  /// Handles a remote API response and returns the mapped result.
  ///
  /// [function] The Dio HTTP request future to execute
  /// [mapFunction] Optional function to transform the response data into a domain object
  ///
  /// Returns the mapped data on success, or throws a [exp.DioException] on failure.
  ///
  /// ## Error Handling
  /// - Empty responses throw with "Empty response received"
  /// - HTTP 4xx/5xx responses are parsed for error messages and reported to Sentry
  /// - Network errors are classified using [DioErrorX.isNoConnectionError]
  /// - [SocketException] with "reset" message returns a user-friendly "Connection lost" message
  Future<T> handleRemoteResponse<T>(
    Future<Response<dynamic>> function, [
    T Function(dynamic response)? mapFunction,
  ]) async => await _handleResponse<T, T>(function, mapFunction) as T;

  Future<Object?> _handleResponse<T, R>(
    Future<Response<dynamic>> function,
    R Function(dynamic response)? mapFunction, {
    bool throwError = true,
  }) async {
    try {
      final response = await function;
      if (response.data == null) {
        throw exp.DioException(
          code: response.statusCode,
          message: 'Empty response received',
        );
      }

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        if (throwError) {
          if (mapFunction != null) {
            try {
              final mappedData = await compute(mapFunction, response.data);
              return mappedData;
            } catch (e, s) {
              Logger().e('Response mapping failed', error: e, stackTrace: s);
              await _captureSentryEvent(response, errorMessage: e.toString());
              throw exp.DioException(
                code: 500,
                message: 'Response mapping failed: $e',
              );
            }
          } else {
            return unit;
          }
        } else {
          if (mapFunction != null) {
            return RemoteResponse.withData(mapFunction(response.data));
          } else {
            return const RemoteResponse.withData(unit);
          }
        }
      } else {
        await _handleErrorResponse(response);
        // This part will not be reached as _handleErrorResponse always throws
        return null;
      }
    } catch (e, s) {
      Logger().d('Remote service error', error: e, stackTrace: s);
      return _handleException(e, throwError, s);
    }
  }

  /// Parses an HTTP error response and throws a [exp.DioException] with a user-friendly message.
  ///
  /// Error messages are extracted in priority order:
  /// 1. `message` field from JSON response body
  /// 2. Raw response body as string
  /// 3. HTTP status message
  /// 4. Generic fallback based on status code range
  ///
  /// Reports errors to Sentry for status codes >= 400.
  Future<void> _handleErrorResponse(Response response) async {
    final statusCode = response.statusCode!;
    if (statusCode >= 400) {
      await _captureSentryEvent(response);
    }

    var errorMessage =
        response.statusMessage ??
        (statusCode >= 500 ? 'Server error occurred' : 'Client error occurred');

    if (response.data is Map && (response.data as Map)['message'] != null) {
      errorMessage = (response.data as Map)['message'] as String;
    } else if (response.data != null && response.data.toString().isNotEmpty) {
      errorMessage = response.data.toString();
    }

    throw exp.DioException(code: statusCode, message: errorMessage);
  }

  /// Filters sensitive headers from HTTP requests/responses before Sentry reporting.
  ///
  /// Removes authorization tokens, cookies, and set-cookie headers to prevent
  /// leaking credentials in error reports.
  Map<String, String> _filterHeaders(Map<String, dynamic> headers) {
    final sensitiveKeys = ['authorization', 'cookie', 'set-cookie'];
    final filteredHeaders = <String, String>{};
    headers.forEach((key, value) {
      if (!sensitiveKeys.contains(key.toLowerCase())) {
        filteredHeaders[key] = value.toString();
      }
    });
    return filteredHeaders;
  }

  /// Captures an HTTP error event in Sentry for monitoring and debugging.
  ///
  /// Includes request details (URL, method, filtered headers) and response data
  /// with appropriate severity level (error for 5xx, warning for others).
  Future<void> _captureSentryEvent(
    Response response, {
    String? errorMessage,
    StackTrace? stackTrace,
  }) async {
    final statusCode = response.statusCode;
    final requestOptions = response.requestOptions;
    final url = requestOptions.uri.toString();

    await Sentry.captureEvent(
      SentryEvent(
        message: SentryMessage(
          errorMessage ?? 'HTTP Error [$statusCode]: ${response.statusMessage}',
        ),
        level: statusCode != null && statusCode >= 500
            ? SentryLevel.error
            : SentryLevel.warning,
        tags: {
          'http.status_code': statusCode.toString(),
          'http.url': url,
          'http.method': requestOptions.method,
        },
        fingerprint: [
          'http',
          url,
          requestOptions.method,
          statusCode.toString(),
        ],
        request: SentryRequest(
          url: url,
          method: requestOptions.method,
          headers: _filterHeaders(requestOptions.headers),
          data: requestOptions.data,
        ),
        contexts: Contexts(
          response: SentryResponse(
            statusCode: statusCode,
            headers: _filterHeaders(response.headers.map),
            data: response.data,
          ),
        ),
      ),
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  /// Classifies and handles different types of exceptions from HTTP requests.
  ///
  /// Handles three categories of errors:
  /// 1. [DioException] with no connection - returns "No Internet Connection"
  /// 2. [SocketException] - detects connection reset and returns appropriate message
  /// 3. Other exceptions - reported to Sentry and re-thrapped as generic error
  ///
  /// When [throwError] is `false`, returns [RemoteResponse.noConnection] instead
  /// of throwing for connectivity issues.
  Future<Object?> _handleException(
    dynamic e,
    bool throwError, [
    StackTrace? stackTrace,
  ]) async {
    if (e is DioException) {
      final response = e.response;

      if (e.isNoConnectionError) {
        await Sentry.captureException(e, stackTrace: stackTrace);
        if (throwError) {
          throw exp.DioException(code: 400, message: 'No Internet Connection');
        } else {
          return const RemoteResponse.noConnection();
        }
      } else if (response != null) {
        await _handleErrorResponse(response);
      }
    } else if (e is SocketException) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      final isConnectionReset = e.message.contains('reset');
      if (throwError) {
        throw exp.DioException(
          code: 503,
          message: isConnectionReset
              ? 'Connection lost. Please try again.'
              : 'Network connection failed',
        );
      } else {
        return const RemoteResponse.noConnection();
      }
    } else {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace ?? StackTrace.current,
      );
    }
    // After handling, always throw a generic exception to ensure upstream gets it.
    throw exp.DioException(
      code: 500,
      message: 'An unexpected error occurred: $e',
    );
  }
}
