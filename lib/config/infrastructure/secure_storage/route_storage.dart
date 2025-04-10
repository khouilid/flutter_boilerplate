import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_route_storage.dart';

class SecureRoutetorage implements RouteStorage {
  final FlutterSecureStorage _storage;

  SecureRoutetorage(this._storage);

  static const _key = 'khouilid_dev_this';

  String? _cachedRoute;

  @override
  Future<String?> read() async {
    
    if (_cachedRoute != null) {
      return _cachedRoute;
    }
    final storedValue = await _storage.read(key: _key);


    if (storedValue == null) {
      return null;
    }

    return _cachedRoute = storedValue;
  }

  @override
  Future<void> save(String token) {
    _cachedRoute = token;

    return _storage.write(
      key: _key,
      value: token,
    );
  }

  @override
  Future<void> clear() {
    _cachedRoute = null;
    return _storage.delete(key: _key);
  }
}
