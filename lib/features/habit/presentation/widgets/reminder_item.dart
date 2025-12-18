import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/app_colors.dart';

class ReminderItem extends StatelessWidget {
  const ReminderItem({
    super.key,
    required this.reminderValue,
    required this.onTap,
  });

  final DateTime reminderValue;
  final VoidCallback onTap;



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary(context).withValues(alpha: 0.1),
        borderRadius: .circular(20.r),
        border: .all(color: AppColors.primary(context)),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(
            CupertinoIcons.alarm,
            size: 16.r,
            color: AppColors.primary(context),
          ),
          Gap(6.w),
          Text(
            reminderValue.formattedTime(context),
            style: TextStyle(
              color: AppColors.primary(context),
              fontWeight: .w600,
              fontSize: 14.sp,
            ),
          ),
          Gap(8.w),
          GestureDetector(
            onTap: onTap,
            child: Icon(Icons.close, size: 18.sp, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
