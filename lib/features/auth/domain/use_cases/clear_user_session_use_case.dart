import 'package:habit_tracking_app/core/services/notification_service/notification_service.dart';

import '../../../../core/helpers/app_logger.dart';
import '../../../../core/services/local_storage/app_preferences_service.dart';
import '../../../../core/services/local_storage/auth_storage_service.dart';

class ClearUserSessionUseCase {
  ClearUserSessionUseCase(
    this._appPreferencesService,
    this._authStorageService,
    this._notificationService,
  );

  final AppPreferencesService _appPreferencesService;
  final AuthStorageService _authStorageService;
  final NotificationService _notificationService;

  Future<void> call() async {
    try {
      await Future.wait([
        _appPreferencesService.setLoggedIn(false),
        _appPreferencesService.deleteUseName(),
        _appPreferencesService.deleteEmailAddress(),
        _authStorageService.clearTokens(),
        _appPreferencesService.deleteHabitsScheduled(),
        _notificationService.cancelAll(),
      ]);
    } catch (e) {
      AppLogger.error("error in clear user session", error: e.toString());
      throw Exception('Failed to clear user session');
    }
  }
}
