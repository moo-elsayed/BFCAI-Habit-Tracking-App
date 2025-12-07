import 'package:flutter/material.dart';
import 'app_palette.dart';

class AppColors {
  AppColors._();

  static Color background(BuildContext context) =>
      _isDark(context) ? AppPalette.blackRussian : AppPalette.offWhite;

  static Color surface(BuildContext context) =>
      _isDark(context) ? AppPalette.navyDark : AppPalette.white;

  static Color modalBackground(BuildContext context) =>
      _isDark(context) ? AppPalette.navyCard : AppPalette.white;

  // 💡 دي الحاجة الجديدة المهمة للـ Habit Card
  static Color habitCardColor(BuildContext context) =>
      _isDark(context) ? AppPalette.navyCard : AppPalette.white;

  static Color textPrimary(BuildContext context) =>
      _isDark(context) ? AppPalette.white : AppPalette.blackRussian;

  static Color textSecondary(BuildContext context) =>
      _isDark(context) ? AppPalette.greyLight : AppPalette.greyDark;

  static Color primary(BuildContext context) => AppPalette.blueMain;

  static Color success(BuildContext context) => AppPalette.greenSuccess;

  static Color error(BuildContext context) => AppPalette.redError;

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}
