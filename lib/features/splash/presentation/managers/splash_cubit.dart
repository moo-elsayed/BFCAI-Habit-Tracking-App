import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/services/auth_service/token_service.dart';
import '../../../../core/services/local_storage/app_preferences_service.dart';
import '../../../../core/services/local_storage/auth_storage_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(
    this._appPreferencesService,
    this._authStorageService,
    this._tokenService,
  ) : super(SplashInitial());

  final AppPreferencesService _appPreferencesService;
  final AuthStorageService _authStorageService;
  final TokenService _tokenService;

  Future<void> checkAppStatus() async {
    if (_firstTime) {
      emit(SplashSuccess(.navigateToOnboarding));
      return;
    }

    if (!_isLoggedIn) {
      emit(SplashSuccess(.navigateToLogin));
      return;
    }

    final isValid = await _ensureValidToken();

    if (isValid) {
      emit(SplashSuccess(.navigateToAppSection));
    } else {
      emit(SplashSuccess(.navigateToLogin));
    }
  }

  Future<bool> _ensureValidToken() async {
    var list = await Future.wait([
      _authStorageService.getAccessToken(),
      _authStorageService.getRefreshToken(),
      _authStorageService.getAccessTokenExpiry(),
      _authStorageService.getRefreshTokenExpiry(),
    ]);
    final accessToken = list[0] as String?;
    final refreshToken = list[1] as String?;
    final accessExpiry = list[2] as DateTime?;
    final refreshExpiry = list[3] as DateTime?;

    if (accessToken == null ||
        refreshToken == null ||
        accessExpiry == null ||
        refreshExpiry == null) {
      return false;
    }

    final now = DateTime.now();

    if (refreshExpiry.isBefore(now)) {
      await _authStorageService.clearTokens();
      return false;
    }

    if (accessExpiry.difference(now).inSeconds < 60) {
      try {
        await _tokenService.refreshTokenSilently();
        return true;
      } catch (_) {
        return false;
      }
    }

    return true;
  }

  bool get _firstTime => _appPreferencesService.getFirstTime();

  bool get _isLoggedIn => _appPreferencesService.getLoggedIn();
}
