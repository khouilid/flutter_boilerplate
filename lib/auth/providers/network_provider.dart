import 'package:boilerplate_app/core/infrastructure/http_client_config/dio_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final logger = Provider<Logger>((ref) {
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
  // impl read user auth with secure storage ...... and replace USER_TOKEN with the real one
  return DioConfig.createDio(ref.watch(logger), 'USER_TOKEN');
});
