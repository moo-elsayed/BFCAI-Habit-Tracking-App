import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracking_app/core/theming/app_colors.dart';
import 'package:habit_tracking_app/core/entities/bottom_sheet_selection_item_entity.dart';
import '../../../../core/theming/app_text_styles.dart';

class BottomSheetSelectionItem extends StatelessWidget {
  const BottomSheetSelectionItem({super.key, required this.entity});

  final BottomSheetSelectionItemEntity entity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: entity.onTap,
      child: Container(
        width: double.infinity,
        padding: .symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.habitCardColor(context),
          borderRadius: .circular(24.r),
          border: entity.isSelected
              ? .all(color: AppColors.primary(context), width: 1.5)
              : .all(color: Colors.transparent),
        ),
        child: entity.icon != null
            ? Row(
                spacing: 16.w,
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary(context).withValues(alpha: 0.2),
                      borderRadius: .circular(16.r),
                    ),
                    child: Center(child: entity.icon),
                  ),
                  Text(
                    entity.title,
                    style: AppTextStyles.font14Regular(
                      context,
                    ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            : Text(
                entity.title,
                style: AppTextStyles.font14Regular(
                  context,
                ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}
