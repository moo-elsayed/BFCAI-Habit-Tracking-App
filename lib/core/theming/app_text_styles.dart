import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle font24Bold(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 24.sp,
        color: AppColors.textPrimary(context),
        fontWeight: .w700,
      );

  static TextStyle font14Regular(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 14.sp,
        color: AppColors.textPrimary(context),
        fontWeight: .w400,
      );

  static TextStyle font12Grey(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 12.sp,
        color: AppColors.textSecondary(context),
        fontWeight: .w500,
      );

  static TextStyle font14CustomColor(Color color) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 14.sp,
        color: color,
        fontWeight: .w400,
      );
}
