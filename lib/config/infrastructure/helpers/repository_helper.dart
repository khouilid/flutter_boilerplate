import 'package:boilerplate_app/config/domain/failure.dart';
import 'package:boilerplate_app/config/domain/fresh.dart';
import 'package:boilerplate_app/config/infrastructure/exceptions/dio_exception.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:sentry_flutter/sentry_flutter.dart';

typedef FutureEitherFailureOr<T> = Future<Either<Failure, T>>;

typedef FutureEitherFailureOrFresh<T> = Future<Either<Failure, Fresh<T>>>;

typedef AsyncPlatformSpecificListOrApply<T> = Future<List<T>>;

mixin RepositoryHelper {
  final transaction = Sentry.startTransaction('processOrderBatch()', 'task');

  FutureEitherFailureOr<R> handleData<R, T>(
    Future<T> future,
    Future<R> Function(T data) mapData,
  ) async {
    try {
      final value = await future;
      return right(await mapData(value));
    } on DioException catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
      );

      return left(Failure.server(e.code, e.message.toString()));
    } on PlatformException catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
      );

      return left(
        Failure.storage(e.message),
      );
    } catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
      );

      return left(Failure.unknown(e.toString()));
    }
  }

  Future<List<T>> emptyArrayHandler<T>(
    AsyncPlatformSpecificListOrApply<T> wrappedFunction,
  ) async {
    if (kIsWeb) {
      return <T>[];
    } else {
      return await wrappedFunction;
    }
  }
}
