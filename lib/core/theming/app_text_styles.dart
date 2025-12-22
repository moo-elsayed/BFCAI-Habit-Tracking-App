import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ----------------------------------------
  // Headings & Titles
  // ----------------------------------------

  // للعناوين الكبيرة جداً (زي Onboarding Title)
  static TextStyle font24Bold(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 24.sp,
        color: AppColors.textPrimary(context),
        fontWeight: FontWeight.w700,
      );

  static TextStyle font24Medium(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 24.sp,
        color: AppColors.textPrimary(context),
        fontWeight: FontWeight.w500,
      );

  // for app bar
  static TextStyle font22Bold(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 22.sp,
        color: AppColors.textPrimary(context),
        fontWeight: FontWeight.w700,
      );

  // ... باقي الكود بتاعك زي ما هو ...

  // ----------------------------------------
  // Big Stats
  // ----------------------------------------
  static TextStyle font32Bold(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 32.sp,
        color: AppColors.primary(context),
        fontWeight: FontWeight.bold,
      );

  // لعناوين الأقسام أو اسم العادة (Habit Name)
  static TextStyle font18SemiBold(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 18.sp,
        color: AppColors.textPrimary(context),
        fontWeight: FontWeight.w600,
      );

  // ----------------------------------------
  // Body Text & Inputs
  // ----------------------------------------

  // للكتابة جوه الـ TextFields (Input)
  static TextStyle font14Regular(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 14.sp,
        color: AppColors.textPrimary(context),
        fontWeight: FontWeight.w400,
      );

  // للوصف الطويل (زي Onboarding Description) - لونه رمادي
  static TextStyle font14Grey(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 14.sp,
        color: AppColors.textSecondary(context),
        fontWeight: FontWeight.w400,
      );

  // ----------------------------------------
  // Buttons & Actions
  // ----------------------------------------

  // 💡 للزرار الأساسي (تكون بيضاء دايماً لأن الزرار ملون)
  static TextStyle font16WhiteSemiBold(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 16.sp,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      );

  // 💡 للزرار الفرعي (Text Button) اللي لونه بياخد لون البراند
  static TextStyle font16PrimarySemiBold(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 16.sp,
        color: AppColors.primary(context),
        fontWeight: FontWeight.w600,
      );

  // ----------------------------------------
  // Small Text & Captions
  // ----------------------------------------

  // للـ Labels اللي فوق الـ Input أو التواريخ الصغيرة
  static TextStyle font13Medium(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 13.sp,
        color: AppColors.textPrimary(context), // أو textSecondary حسب الحاجة
        fontWeight: FontWeight.w500,
      );

  static TextStyle font12Grey(BuildContext context) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 12.sp,
        color: AppColors.textSecondary(context),
        fontWeight: FontWeight.w500,
      );

  // ----------------------------------------
  // Custom One-offs
  // ----------------------------------------
  static TextStyle font14CustomColor(Color color) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 14.sp,
        color: color,
        fontWeight: FontWeight.w400,
      );

  static TextStyle font14SemiBoldCustomColor(Color color) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: 14.sp,
        color: color,
        fontWeight: FontWeight.w600,
      );
}
