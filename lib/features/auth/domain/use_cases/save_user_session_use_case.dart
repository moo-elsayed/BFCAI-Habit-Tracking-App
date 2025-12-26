import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';
import 'package:habit_tracking_app/core/services/local_storage/auth_storage_service.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/response/login_response_entity.dart';
import '../../../../core/helpers/app_logger.dart';

class SaveUserSessionUseCase {
  SaveUserSessionUseCase(this._appPreferencesService, this._authStorageService);

  final AppPreferencesService _appPreferencesService;
  final AuthStorageService _authStorageService;

  Future<void> call(LoginResponseEntity loginResponseEntity) async {
    try {
      await Future.wait([
        _appPreferencesService.setLoggedIn(true),
        _appPreferencesService.setUsername(loginResponseEntity.username),
        _appPreferencesService.setEmailAddress(loginResponseEntity.email),
        _authStorageService.saveTokens(
          accessToken: loginResponseEntity.token,
          refreshToken: loginResponseEntity.refreshToken,
        ),
      ]);
    } catch (e) {
      AppLogger.error("error in save user session", error: e.toString());
      throw Exception("failed_to_save_user_session");
    }
  }
}
