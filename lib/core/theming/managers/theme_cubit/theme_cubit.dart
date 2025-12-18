import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';

import '../../../helpers/functions.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._appPreferencesService) : super(ThemeInitial());
  final AppPreferencesService _appPreferencesService;

  void getCurrentTheme() {
    final String? savedTheme = _appPreferencesService.getThemeMode();
    emit(ThemeChanged(getThemeMode(savedTheme)));
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    await _appPreferencesService.setThemeMode(themeMode.name);
    emit(ThemeChanged(themeMode));
  }
}
