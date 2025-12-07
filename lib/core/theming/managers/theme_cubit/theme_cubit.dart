import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracking_app/core/services/local_storage/app_preferences_service.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._appPreferencesService) : super(ThemeInitial());
  final AppPreferencesService _appPreferencesService;

  void getCurrentTheme() {
    final bool isDark = _appPreferencesService.getDarkMode();
    emit(ThemeChanged(isDark ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> changeTheme(bool isDark) async {
    await _appPreferencesService.setDarkMode(isDark);
    emit(ThemeChanged(isDark ? ThemeMode.dark : ThemeMode.light));
  }
}
