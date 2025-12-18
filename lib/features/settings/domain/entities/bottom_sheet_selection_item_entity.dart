import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_app/restart_app.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/theming/managers/theme_cubit/theme_cubit.dart';
import '../../../../core/widgets/custom_confirmation_dialog.dart';

class BottomSheetSelectionItemEntity {
  const BottomSheetSelectionItemEntity({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

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
