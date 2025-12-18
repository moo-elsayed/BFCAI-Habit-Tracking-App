import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../presentation/widgets/custom_bottom_sheet.dart';
import 'bottom_sheet_selection_item_entity.dart';

class SettingsTileEntity {
  const SettingsTileEntity({
    required this.title,
    required this.icon,
    this.isDestructive = false,
    this.trailing,
    this.onTap,
  });

  final String title;
  final bool isDestructive;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
}

SettingsTileEntity getThemeTile({
  required BuildContext context,
  required String currentThemeName,
}) => SettingsTileEntity(
  onTap: () {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) => CustomBottomSheet(
        title: "theme".tr(),
        items: getThemeItems(
          context: context,
          currentTheme: getCurrentTheme(context),
        ),
      ),
    );
  },
  title: "theme".tr(),
  icon: CupertinoIcons.moon_fill,
  trailing: Row(
    children: [
      Text(currentThemeName, style: AppTextStyles.font14Grey(context)),
      Gap(8.w),
      Icon(Icons.arrow_forward_ios, size: 16.r, color: Colors.grey),
    ],
  ),
);

SettingsTileEntity getLanguageTile(BuildContext context) => SettingsTileEntity(
  onTap: () {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) => CustomBottomSheet(
        title: "language".tr(),
        items: getLanguageItems(context),
      ),
    );
  },
  title: "language".tr(),
  icon: CupertinoIcons.globe,
  trailing: Row(
    children: [
      Text(
        !isArabic(context) ? "English" : "العربية",
        style: AppTextStyles.font14Grey(context),
      ),
      Gap(8.w),
      Icon(Icons.arrow_forward_ios, size: 16.r, color: Colors.grey),
    ],
  ),
);
