import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final internetConnectivityProvider = Provider<Connectivity>(
  (ref) => Connectivity(),
);


final connectivityProvider = StreamProvider<bool>((ref) {
  final connectivity = ref.watch(internetConnectivityProvider);

  return connectivity.onConnectivityChanged.map((results) {
    return !results.contains(ConnectivityResult.none);
  });
});
