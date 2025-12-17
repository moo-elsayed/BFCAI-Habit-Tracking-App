class ApiConstants {
  static const String baseUrl = "https://habitedge.runasp.net/Api/";

  static const String version = "v1";

  // Auth
  static const String authRoute = "$version/Authentication";

  // Endpoints
  static const String register = "$authRoute/Register";
  static const String login = "$authRoute/SignIn";
  static const String confirmEmail = "$authRoute/Confirm-Email";
  static const String refreshToken = "$authRoute/refresh-token";
  static const String revokeToken = "$authRoute/revoke-token";

  // Habit
  static const String habitRoute = "$version/Habit";

  // Habit Tracking
  static const String habitTrackingRoute = "$version/Tracking";

  // Endpoints
  static const String createHabit = "$habitRoute/Create";
  static const String getHabits = "$habitRoute/List";
  static const String editHabit = "$habitRoute/Edit";
  static const String deleteHabit = "$habitRoute/Delete";
  static const String getHabit = "$habitRoute/GetById";

}
