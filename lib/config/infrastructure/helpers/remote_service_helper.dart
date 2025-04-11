import 'dart:io';

import 'package:boilerplate_app/config/domain/remote_response.dart';
import 'package:boilerplate_app/config/infrastructure/exceptions/dio_exception.dart' as exp;
import 'package:boilerplate_app/config/infrastructure/extensions/dio_extensions.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

mixin RemoteServiceHelper {


  // Consider moving this transaction to a more specific location since it's named for a specific batch process
  final transaction = Sentry.startTransaction('processOrderBatch()', 'task');

  // Good pattern for simple API calls that don't need RemoteResponse wrapper
  Future<T> remoteResponseHandler<T>(
    Future<Response<dynamic>> function, [
    T Function(dynamic response)? mapFunction,
  ]) async =>  await _handleResponse<T, T>(function, mapFunction) as T;

  // Well structured method for handling API responses with proper error handling
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
        // Consider consolidating duplicate Sentry calls
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

  // This method could be simplified and split into smaller functions
  Future<Object?> _handleResponse<T, R>(
    Future<Response<dynamic>> function,
    R Function(dynamic response)? mapFunction, {
    bool throwError = true,
  }) async {
    try {
      final response = await function;

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        if (throwError) {
          return mapFunction != null ? mapFunction(response.data) : unit;
        } else {
          return mapFunction != null 
            ? RemoteResponse.withData(mapFunction(response.data))
            : const RemoteResponse.withData(unit);
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
          // Remove duplicate Sentry calls
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
