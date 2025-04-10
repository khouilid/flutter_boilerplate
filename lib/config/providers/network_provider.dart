import 'package:boilerplate_app/config/infrastructure/dio_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final loggerProvider = Provider<Logger>((ref) {
  return Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );
});

final dioProvider = Provider<Dio>((ref) {
  final logger = ref.watch(loggerProvider);
  return DioConfig.createDio(logger);
});
