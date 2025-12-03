import 'package:google_fonts/google_fonts.dart';
import 'package:habit_tracking_app/core/theming/app_colors.dart';
import 'package:habit_tracking_app/core/theming/font_weight_helper.dart';
import 'package:flutter/material.dart';

abstract class AppTextStyles {
  static TextStyle font16WhiteHeeboRegular = GoogleFonts.heebo(
    fontSize: 16,
    color: AppColors.color21243D,
    fontWeight: FontWeightHelper.regular,
  );

  static TextStyle font20WhiteHeeboMedium = GoogleFonts.heebo(
    fontSize: 20,
    color: AppColors.white,
    fontWeight: FontWeightHelper.medium,
  );

  static TextStyle font32color21243DHeeboBold = GoogleFonts.heebo(
    fontSize: 32,
    color: AppColors.color21243D,
    fontWeight: FontWeightHelper.bold,
  );
}
