import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
import 'package:habit_tracking_app/core/theming/app_colors.dart';
import 'package:habit_tracking_app/core/theming/app_text_styles.dart';
import 'package:habit_tracking_app/features/home/presentation/managers/home_cubit/home_cubit.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';

class HabitItem extends StatelessWidget {
  const HabitItem({
    super.key,
    required this.habitTrackingEntity,
    required this.onIncrement,
  });

  final HabitTrackingEntity habitTrackingEntity;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final isCompleted =
        habitTrackingEntity.trackingRecordEntity?.progressPercentage == 100;
    return GestureDetector(
      onTap: () {
        var habitEntity = context.read<HomeCubit>().getEquivalentHabit(
          habitTrackingEntity,
        );
        context.pushNamed(Routes.habitEditorView, arguments: habitEntity);
      },
      child: Container(
        padding: .symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.habitCardColor(context),
          borderRadius: .circular(24.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: _getColor(),
                borderRadius: .circular(16),
              ),
              child: habitTrackingEntity.icon.isEmpty
                  ? null
                  : Icon(_getIcon(), size: 28.sp),
            ),
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    habitTrackingEntity.name,
                    style: AppTextStyles.font18SemiBold(context),
                  ),
                  Gap(4.h),
                  if (habitTrackingEntity.type == .count)
                    Text(
                      "${habitTrackingEntity.trackingRecordEntity?.currentValue}/${habitTrackingEntity.targetValue} ${"times".tr()}",
                      style: AppTextStyles.font14Grey(context),
                    )
                  else
                    Text(
                      isCompleted ? "completed".tr() : "tap_to_complete".tr(),
                      style: AppTextStyles.font14CustomColor(
                        isCompleted
                            ? AppColors.success(context)
                            : AppColors.textSecondary(context),
                      ),
                    ),
                ],
              ),
            ),
            if (habitTrackingEntity.type == .count)
              _buildCountableAction(context)
            else
              _buildBooleanAction(isCompleted: isCompleted, context: context),
          ],
        ),
      ),
    );
  }

  Color _getColor() => Color(int.parse(habitTrackingEntity.color));

  IconData _getIcon() => IconData(
    int.parse(habitTrackingEntity.icon),
    fontFamily: 'MaterialIcons',
  );

  Widget _buildCountableAction(BuildContext context) {
    return GestureDetector(
      onTap: onIncrement,
      child: Icon(
        Icons.add,
        color: AppColors.textPrimary(context),
        size: 30.sp,
      ),
    );
  }

  Widget _buildBooleanAction({
    required bool isCompleted,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onIncrement,
      child: Container(
        width: 30.w,
        height: 30.h,
        decoration: BoxDecoration(
          borderRadius: .circular(12.r),
          border: .all(
            color: isCompleted
                ? AppColors.success(context)
                : AppColors.textSecondary(context),
            width: 2,
          ),
        ),
        child: isCompleted
            ? Icon(Icons.check, color: AppColors.success(context), size: 28.sp)
            : null,
      ),
    );
  }
}
