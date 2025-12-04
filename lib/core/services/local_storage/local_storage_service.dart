abstract class LocalStorageService {
  Future<void> init();

  Future<void> setFirstTime(bool isFirstTime);

  bool getFirstTime();
}
