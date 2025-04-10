import 'dart:io';

import 'package:dio/dio.dart';

extension DioErrorX on DioException {
  bool get isNoConnectionError {
    return (type == DioExceptionType.connectionError ||
            type == DioExceptionType.connectionTimeout ||
            type == DioExceptionType.unknown ||
            type == DioExceptionType.receiveTimeout ||
            type == DioExceptionType.sendTimeout) &&
        error is SocketException;
  }
}
