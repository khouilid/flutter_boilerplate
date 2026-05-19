import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectionService {
  InternetConnectionService(this._connectivity);
  final Connectivity _connectivity;

  Future<bool> isInternetConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.other);
  }

  Future<T> when<T>({
    required Future<T> Function() onData,
    required Future<T> Function() onError,
  }) async {
    if (await isInternetConnected()) {
      try {
        return await onData();
      } catch (e) {
        return onError();
      }
    } else {
      return onError();
    }
  }
}
