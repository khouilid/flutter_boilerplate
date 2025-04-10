import 'dart:io';

import 'package:boilerplate_app/config/domain/remote_response.dart';
import 'package:boilerplate_app/config/infrastructure/exceptions/dio_exception.dart'
    as exp;
import 'package:boilerplate_app/config/infrastructure/extensions/dio_extensions.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:logger/logger.dart';

import 'package:sentry_flutter/sentry_flutter.dart';

class RemoteServiceHelper {
  final transaction = Sentry.startTransaction('processOrderBatch()', 'task');

  Future<T> withoutRemoteResponse<T>(
    Future<Response<dynamic>> function, [
    T Function(dynamic response)? mapFunction,
  ]) async =>
      await _handleResponse<T, T>(function, mapFunction) as T;

  Future<RemoteResponse<T>> withRemoteResponse<T>(
    Future<Response<dynamic>> function,
    T Function(dynamic response) mapFunction,
  ) async {
    try {
      final response = await function;
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return RemoteResponse.withData(mapFunction(response.data));
      } else {
        throw exp.DioException(
          code: response.statusCode,
          message: response.statusMessage,
        );
      }
    } on DioException catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
      );

      Logger().d(s);

      if (e.isNoConnectionError) {
        Sentry.captureException(
          e,
          stackTrace: s,
        );

        return const RemoteResponse.noConnection();
      } else if (e.response != null) {
        throw exp.DioException(
          code: e.response?.statusCode,
          message: e.response?.statusMessage,
        );
      } else {
        rethrow;
      }
    }
  }

  Future<Object?> _handleResponse<T, R>(
    Future<Response<dynamic>> function,
    R Function(dynamic response)? mapFunction, {
    bool throwError = true,
  }) async {
    try {
      final response = await function;

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        if (throwError) {
          if (mapFunction != null) {
            return mapFunction(response.data);
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
        if (response.statusCode == 500) {
          Sentry.captureException(
            "Throw DioException 500",
            stackTrace: StackTrace.current,
          );
          Logger().i(response.data);
          throw exp.DioException(
            code: response.statusCode,
            message: response.data.toString(),
          );
        } else {
          Sentry.captureException(
            "Throw DioException",
            stackTrace: StackTrace.current,
          );
          Sentry.captureException(
            "Throw DioException",
            stackTrace: StackTrace.current,
          );
          Logger().i(response.data);

          throw exp.DioException(
            code: response.statusCode,
            message: response.statusMessage,
          );
        }
      }
    } catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
      );
      Logger().d(e);
      Logger().d(s);

      if (e is DioException) {
        Logger().w(e.response?.data);
        if (e.isNoConnectionError) {
          if (throwError) {
            throw exp.DioException(
              code: 400,
              message: 'No Internet Connection',
            );
          } else {
            return const RemoteResponse.noConnection();
          }
        } else if (e.response != null) {
          throw exp.DioException(
            code: e.response?.statusCode,
            message: e.response?.data["message"] as String,
          );
        } else {
          rethrow;
        }
      } else if (e is SocketException) {
        throw exp.DioException(
          code: e.hashCode,
          message: "SocketException",
        );
      }
    }
    return null;
  }
}
