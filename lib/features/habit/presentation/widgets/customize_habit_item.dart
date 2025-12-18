import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class CustomizeHabitItem extends StatelessWidget {
  const CustomizeHabitItem({
    super.key,
    required this.title,
    this.onTap,
    required this.child,
  });

  final String title;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: .symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.habitCardColor(context),
          borderRadius: .circular(24.r),
        ),
        child: Row(
          spacing: 16.w,
          children: [
            Container(
              width: 35.w,
              height: 35.h,
              decoration: BoxDecoration(
                color: AppColors.textSecondary(context).withValues(alpha: 0.2),
                borderRadius: .circular(6.r),
              ),
              child: child,
            ),
            Text(
              title,
              style: AppTextStyles.font16PrimarySemiBold(
                context,
              ).copyWith(color: AppColors.textPrimary(context)),
            ),
          ],
        ),
      ),
    );
  }
}
