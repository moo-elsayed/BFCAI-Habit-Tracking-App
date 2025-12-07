import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/features/settings/domain/entities/settings_tile_entity.dart';
import 'package:habit_tracking_app/features/settings/presentation/widgets/settings_tile.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/theming/managers/theme_cubit/theme_cubit.dart';
import '../../../../core/widgets/custom_cupertino_switch.dart';
import '../../../../core/widgets/custom_divider.dart';
import 'change_language_bottom_sheet.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(8.r),
      decoration: BoxDecoration(
        color: AppColors.habitCardColor(context),
        borderRadius: .circular(16.r),
      ),
      child: Column(
        children: [
          SettingsTile(
            settingsTileEntity: SettingsTileEntity(
              title: "dark_mode".tr(),
              icon: CupertinoIcons.moon_fill,
              trailing: CustomCupertinoSwitch(
                isChecked: _isChecked(context),
                onChanged: (value) {
                  context.read<ThemeCubit>().changeTheme(value);
                },
              ),
            ),
          ),
          CustomDivider(),
          SettingsTile(
            settingsTileEntity: SettingsTileEntity(
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
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext sheetContext) =>
                      const ChangeLanguageBottomSheet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isChecked(BuildContext context) {
    var myState = context.watch<ThemeCubit>().state;
    return myState is ThemeChanged
        ? (myState).themeMode == ThemeMode.dark
        : false;
  }
}
