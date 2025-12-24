import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class HorizontalCalendarStripItem extends StatelessWidget {
  const HorizontalCalendarStripItem({
    super.key,
    required this.isTheSameDay,
    required this.langCode,
    required this.date,
    required this.colors,
  });

  final bool isTheSameDay;
  final String langCode;
  final DateTime date;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      decoration: BoxDecoration(
        color: isTheSameDay ? AppColors.surface(context) : Colors.transparent,
        borderRadius: .circular(16.r),
        border: isTheSameDay ? null : .all(color: Colors.transparent),
      ),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Text(
            DateFormat('E', langCode).format(date),
            style: isTheSameDay
                ? AppTextStyles.font14SemiBoldCustomColor(
                    AppColors.primary(context),
                  )
                : AppTextStyles.font14CustomColor(
                    AppColors.textSecondary(context),
                  ),
          ),
          Gap(6.h),
          Text(
            DateFormat('d', langCode).format(date),
            style: AppTextStyles.font18SemiBold(context),
          ),
          Gap(4.h),
          if (colors.isNotEmpty)
            Row(
              mainAxisAlignment: .center,
              children: List.generate(
                colors.length,
                (dotIndex) => Container(
                  margin: .symmetric(horizontal: 1.5.w),
                  width: 5.w,
                  height: 5.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: colors[dotIndex], width: 1.w),
                    color: colors[dotIndex],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )
          else
            Gap(5.w),
        ],
      ),
    );
  }
}
