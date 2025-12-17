import 'dart:developer';

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
    await Future.delayed(const Duration(seconds: 2));

    if (_firstTime) {
      emit(SplashNavigateToOnboarding());
      return;
    }

    var list = await Future.wait([_token, _refreshToken]);

    var myToken = list[0];
    var myRefreshToken = list[1];

    log(myToken.toString());
    log(myRefreshToken.toString());

    if (myToken != null && myToken.isNotEmpty && _isLoggedIn) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToLogin());
    }
  }

  Future<String?> get _token async =>
      await _authStorageService.getAccessToken();

  Future<String?> get _refreshToken async =>
      await _authStorageService.getRefreshToken();

  bool get _firstTime => _appPreferencesService.getFirstTime();

  bool get _isLoggedIn => _appPreferencesService.getLoggedIn();
}
