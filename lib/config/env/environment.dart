import 'package:flutter/foundation.dart';
import 'package:envied/envied.dart';

part 'environment.g.dart';

@Envied(path: '.env.dev')
abstract class DevEnv {
  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  static final String baseUrl = _DevEnv.baseUrl;
}

@Envied(path: '.env.prod')
abstract class ProdEnv {
  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  static final String baseUrl = _ProdEnv.baseUrl;
}

class Environment {
  //* for android
  // static const String baseUrl = 'http://10.0.2.2:11434/api';
  //* for ios
  // static const String baseUrl = 'http://127.0.0.1:11434/api';
  //* for macos

  static String get baseUrl => kReleaseMode ? DevEnv.baseUrl : ProdEnv.baseUrl;
}
