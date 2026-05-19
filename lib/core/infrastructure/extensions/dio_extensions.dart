import 'dart:io';

import 'package:dio/dio.dart';

/// Extension on [DioException] providing helper methods for error classification.
///
/// This extension simplifies error handling by providing semantic checks
/// for common network failure scenarios.
extension DioErrorX on DioException {
  /// Determines if this exception represents a network connectivity failure.
  ///
  /// Returns `true` for errors that indicate the device cannot reach the server,
  /// including:
  /// - [SocketException] with messages containing "reset", "refused", or "failed"
  /// - [DioExceptionType.connectionError] - General connection failures
  /// - [DioExceptionType.connectionTimeout] - Connection establishment timeout
  /// - [DioExceptionType.unknown] - Unknown network errors
  /// - [DioExceptionType.receiveTimeout] - Response receive timeout
  /// - [DioExceptionType.sendTimeout] - Request send timeout
  ///
  /// This is useful for distinguishing between "no internet" scenarios
  /// (where you might show a connectivity warning) versus server-side errors
  /// (where you might show a different message).
  ///
  /// ## Example
  /// ```dart
  /// try {
  ///   await dio.get('/api/data');
  /// } on DioException catch (e) {
  ///   if (e.isNoConnectionError) {
  ///     showError('Please check your internet connection');
  ///   } else {
  ///     showError('Server error occurred');
  ///   }
  /// }
  /// ```
  bool get isNoConnectionError {
    if (error is SocketException) {
      final socketError = error as SocketException;
      if (socketError.message.contains('reset') ||
          socketError.message.contains('refused') ||
          socketError.message.contains('failed')) {
        return true;
      }
    }

    return type == DioExceptionType.connectionError ||
        type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.unknown ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout;
  }
}
