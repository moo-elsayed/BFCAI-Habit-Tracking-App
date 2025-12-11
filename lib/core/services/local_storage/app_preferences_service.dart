abstract class AppPreferencesService {
  Future<void> init();

  Future<void> setFirstTime(bool isFirstTime);

  bool getFirstTime();

  Future<void> setLoggedIn(bool isLoggedIn);

  bool getLoggedIn();

  Future<void> setUsername(String username);

  String getUsername();

  Future<void> deleteUseName();

  Future<void> setEmailAddress(String emailAddress);

  String getEmailAddress();

  Future<void> deleteEmailAddress();

  Future<void> setDarkMode(bool isDark);

  bool? getDarkMode();
}
