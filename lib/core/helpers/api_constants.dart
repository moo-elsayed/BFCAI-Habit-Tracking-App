class ApiConstants {
  static const String baseUrl = "https://habitedge.runasp.net/Api/";

  static const String _version = "v1";

  /// Auth
  static const String _authRoute = "$_version/Authentication";

  // Endpoints
  static const String register = "$_authRoute/Register";
  static const String login = "$_authRoute/SignIn";
  static const String confirmEmail = "$_authRoute/Confirm-Email";
  static const String refreshToken = "$_authRoute/refresh-token";
  static const String revokeToken = "$_authRoute/revoke-token";

  /// Habit
  static const String _habitRoute = "$_version/Habit";

  // Endpoints
  static const String createHabit = "$_habitRoute/Create";
  static const String getHabits = "$_habitRoute/List";
  static const String editHabit = "$_habitRoute/Edit";
  static const String deleteHabit = "$_habitRoute/Delete";
  static const String getHabit = "$_habitRoute/GetById";

  /// Habit Tracking
  static const String _habitTrackingRoute = "$_version/Tracking";

  // Endpoints
  static const String getTrackedHabits = "$_habitTrackingRoute/List";
  static const String createHabitTracking = "$_habitTrackingRoute/Create";
  static const String editHabitTracking = "$_habitTrackingRoute/Edit";
}
