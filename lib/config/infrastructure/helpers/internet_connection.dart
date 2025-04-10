import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

class InternetConnectionService {
  final Connectivity _connectivity;
  InternetConnectionService(this._connectivity);

  Future<bool> isInternetConnected() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Future<T> when<T>({
    required Future<T> Function() onData,
    required Future<T> Function() onError,
  }) async {
    final result = await _connectivity.checkConnectivity();
    if (!result.contains(ConnectivityResult.none)) {
      try {
        return await onData();
      } catch (e) {
        Logger().e(e);
        return onError();
      }
    } else {
      Logger().e('No Internet Connection');

      return onError();
    }
  }
}
