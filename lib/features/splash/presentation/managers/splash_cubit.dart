import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/local_storage/app_preferences_service.dart';
import '../../../../core/services/local_storage/auth_storage_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._appPreferencesService, this._authStorageService)
    : super(SplashInitial());

  final AppPreferencesService _appPreferencesService;
  final AuthStorageService _authStorageService;

  Future<void> checkAppStatus() async {
    if (_firstTime) {
      emit(SplashSuccess(.navigateToOnboarding));
      return;
    }

    String? myAccessToken = await _token;

    if (myAccessToken != null && myAccessToken.isNotEmpty && _isLoggedIn) {
      emit(SplashSuccess(.navigateToAppSection));
    } else {
      emit(SplashSuccess(.navigateToLogin));
    }
  }

  Future<String?> get _token async =>
      await _authStorageService.getAccessToken();

  bool get _firstTime => _appPreferencesService.getFirstTime();

  bool get _isLoggedIn => _appPreferencesService.getLoggedIn();
}
