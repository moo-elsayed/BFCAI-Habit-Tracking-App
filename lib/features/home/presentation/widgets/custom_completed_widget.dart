import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';

class CustomCompletedWidget extends StatelessWidget {
  const CustomCompletedWidget({super.key, this.isCompleted = true});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        shape: .circle,
        border: .all(
          color: isCompleted
              ? AppColors.success(context)
              : AppColors.textSecondary(context),
          width: 2,
        ),
      ),
      child: isCompleted
          ? Icon(Icons.check, color: AppColors.success(context), size: 18.sp)
          : null,
    );
  }
}
