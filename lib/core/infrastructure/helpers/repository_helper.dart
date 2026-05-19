import 'package:boilerplate_app/core/domain/failure.dart';
import 'package:boilerplate_app/core/domain/fresh.dart';
import 'package:boilerplate_app/core/infrastructure/exceptions/dio_exception.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

typedef FutureEitherFailureOr<T> = Future<Either<Failure, T>>;

typedef FutureEitherFailureOrFresh<T> = Future<Either<Failure, Fresh<T>>>;

typedef AsyncPlatformSpecificListOrApply<T> = Future<List<T>>;

mixin RepositoryHelper {
  FutureEitherFailureOr<R> handleData<R, T>(
    Future<T> future,
    Future<R> Function(T data) mapData,
  ) async {
    try {
      final value = await future;
      return right(await mapData(value));
    } on DioException catch (e) {
      return left(Failure.server(e.code, e.message.toString()));
    } on PlatformException catch (e) {
      return left(Failure.storage(e.message));
    } catch (e) {
      return left(Failure.unknown(e.toString()));
    }
  }
}
