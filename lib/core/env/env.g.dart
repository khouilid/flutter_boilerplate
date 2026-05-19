// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: .env.dev
final class _DevEnv {
  static const List<int> _enviedkeybaseUrl = <int>[];

  static const List<int> _envieddatabaseUrl = <int>[];

  static final String baseUrl = String.fromCharCodes(List<int>.generate(
    _envieddatabaseUrl.length,
    (int i) => i,
    growable: false,
  ).map((int i) => _envieddatabaseUrl[i] ^ _enviedkeybaseUrl[i]));
}

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: .env.prod
final class _ProdEnv {
  static const List<int> _enviedkeybaseUrl = <int>[];

  static const List<int> _envieddatabaseUrl = <int>[];

  static final String baseUrl = String.fromCharCodes(List<int>.generate(
    _envieddatabaseUrl.length,
    (int i) => i,
    growable: false,
  ).map((int i) => _envieddatabaseUrl[i] ^ _enviedkeybaseUrl[i]));
}
