import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/features/settings/domain/entities/settings_tile_entity.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({super.key, required this.settingsTileEntity});

  final SettingsTileEntity settingsTileEntity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: settingsTileEntity.onTap,
      child: Container(
        padding: .symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.habitCardColor(context),
          borderRadius: .circular(24.r),
        ),
        child: Row(
          children: [
            Container(
              padding: .all(10.r),
              decoration: BoxDecoration(
                color: settingsTileEntity.isDestructive
                    ? Colors.red.withValues(alpha: 0.1)
                    : AppColors.primary(context).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                settingsTileEntity.icon,
                color: settingsTileEntity.isDestructive
                    ? Colors.red
                    : AppColors.primary(context),
                size: 24.r,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: Text(
                settingsTileEntity.title,
                style: AppTextStyles.font16PrimarySemiBold(context).copyWith(
                  color: settingsTileEntity.isDestructive
                      ? Colors.red
                      : AppColors.textPrimary(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (settingsTileEntity.trailing != null)
              settingsTileEntity.trailing!,
          ],
        ),
      ),
    );
  }
}
