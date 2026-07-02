abstract class AppRepository {
  Future<void> initialize();
  bool get isInitialized;
}
