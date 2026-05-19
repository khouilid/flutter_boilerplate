abstract class RouteStorage {
  Future<String?> read();
  Future<void> save(String route);
  Future<void> clear();
}
