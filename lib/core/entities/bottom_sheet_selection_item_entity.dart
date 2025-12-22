import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracking_app/core/entities/habit_entity.dart';
import 'package:habit_tracking_app/core/theming/app_colors.dart';
import 'package:habit_tracking_app/generated/assets.dart';
import 'package:restart_app/restart_app.dart';
import '../helpers/extensions.dart';
import '../helpers/functions.dart';
import '../theming/managers/theme_cubit/theme_cubit.dart';
import '../widgets/custom_confirmation_dialog.dart';

class BottomSheetSelectionItemEntity {
  const BottomSheetSelectionItemEntity({
    this.icon,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  final Widget? icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
}

List<BottomSheetSelectionItemEntity> getThemeItems({
  required BuildContext context,
  required ThemeMode currentTheme,
}) => [
  BottomSheetSelectionItemEntity(
    title: "system".tr(),
    isSelected: currentTheme == .system,
    onTap: () {
      _setTheme(context: context, currentTheme: .system);
    },
  ),
  BottomSheetSelectionItemEntity(
    title: "light".tr(),
    isSelected: currentTheme == .light,
    onTap: () {
      _setTheme(context: context, currentTheme: .light);
    },
  ),
  BottomSheetSelectionItemEntity(
    title: "dark".tr(),
    isSelected: currentTheme == .dark,
    onTap: () {
      _setTheme(context: context, currentTheme: .dark);
    },
  ),
];

List<BottomSheetSelectionItemEntity> getLanguageItems(BuildContext context) => [
  BottomSheetSelectionItemEntity(
    title: "العربية",
    isSelected: isArabic(context),
    onTap: () async {
      _showDialog(context: context, langCode: "ar");
    },
  ),
  BottomSheetSelectionItemEntity(
    title: "English",
    isSelected: !isArabic(context),
    onTap: () async {
      _showDialog(context: context, langCode: "en");
    },
  ),
];

List<BottomSheetSelectionItemEntity> getActionItems({
  required BuildContext context,
  required HabitEntity habitEntity,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) => [
  BottomSheetSelectionItemEntity(
    title: "edit".tr(),
    onTap: () {
      context.pop();
      onEdit();
    },
    icon: Image.asset(
      Assets.iconsEditIcon,
      height: 24.sp,
      color: Theme.of(context).colorScheme.inverseSurface,
    ),
  ),
  BottomSheetSelectionItemEntity(
    title: "delete".tr(),
    onTap: () {
      context.pop();
      onDelete();
    },
    icon: SvgPicture.asset(
      Assets.iconsTrash,
      colorFilter: ColorFilter.mode(AppColors.error(context), .srcIn),
    ),
  ),
];

// -------------------------------------

void _setTheme({
  required BuildContext context,
  required ThemeMode currentTheme,
}) {
  context.read<ThemeCubit>().changeTheme(currentTheme);
  context.pop();
}

void _showDialog({required BuildContext context, required String langCode}) {
  context.pop();
  showCupertinoDialog(
    context: context,
    builder: (context) => CustomConfirmationDialog(
      title: "confirm_language_change".tr(),
      subtitle: "app_will_restart".tr(),
      textConfirmButton: "ok".tr(),
      textCancelButton: "cancel".tr(),
      onConfirm: () async {
        context.pop();
        await context.setLocale(Locale(langCode));
        Restart.restartApp();
      },
    ),
  );
}
