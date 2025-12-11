import 'package:flutter/material.dart';
import 'app_palette.dart';

class AppTheme {
  // ☀️ Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      // ... (الإعدادات القديمة)
      useMaterial3: true,
      brightness: Brightness.light,

      // ✅ دي اللي بتغير لون الخلفية في التطبيق كله
      scaffoldBackgroundColor: AppPalette.offWhite,

      // نضبط الألوان الأساسية عشان الأزرار والـ Toggles
      colorScheme: const ColorScheme.light(
        primary: AppPalette.blueMain,
        surface: AppPalette.white, // لون الكروت والـ Dialogs
      ),

      // ممكن كمان تضبط الـ AppBar هنا بالمرة
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: .dark,
      ),
      // 1. تظبيط الـ BottomSheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppPalette.white,
        modalBackgroundColor: AppPalette.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // 2. تظبيط الـ Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppPalette.white,
        surfaceTintColor: Colors.transparent, // عشان Material 3 مايغيرش اللون
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  // 🌙 Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      // ... (الإعدادات القديمة)
      useMaterial3: true,
      brightness: Brightness.dark,

      // ✅ لون الخلفية الغامق
      scaffoldBackgroundColor: AppPalette.blackRussian,

      colorScheme: const ColorScheme.dark(
        primary: AppPalette.blueMain,
        surface: AppPalette.navyDark, // لون الكروت في الدارك
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: .light,
      ),
      // 1. تظبيط الـ BottomSheet (استخدمنا navyCard)
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppPalette.navyCard,
        modalBackgroundColor: AppPalette.navyCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      dialogTheme: const DialogThemeData(
        backgroundColor: AppPalette.navyCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
