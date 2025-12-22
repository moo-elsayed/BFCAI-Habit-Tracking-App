import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/theming/app_colors.dart';
import 'package:habit_tracking_app/features/home/presentation/managers/home_cubit/home_cubit.dart';
import '../../../../core/entities/tracking/create_habit_tracking_input_entity.dart';
import '../../../../core/entities/tracking/edit_habit_tracking_input_entity.dart';
import '../../../../core/entities/tracking/habit_tracking_entity.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/theming/app_text_styles.dart';

class HabitDetailsProgressCard extends StatelessWidget {
  const HabitDetailsProgressCard({
    super.key,
    required this.habit,
    required this.onValueUpdated,
  });

  final HabitTrackingEntity habit;
  final ValueChanged<HabitTrackingEntity> onValueUpdated;

  void _updateValue(int newValue, BuildContext context) {
    if (newValue < 0) return;

    final updatedRecord = habit.trackingRecordEntity.copyWith(
      currentValue: newValue,
      progressPercentage: (newValue / habit.targetValue) * 100,
    );

    final updatedHabit = habit.copyWith(trackingRecordEntity: updatedRecord);
    onValueUpdated(updatedHabit);

    if (habit.trackingRecordEntity.trackingId != null) {
      context.read<HomeCubit>().editHabitTracking(
        EditHabitTrackingInputEntity(
          trackingId: habit.trackingRecordEntity.trackingId!,
          currentValue: newValue,
        ),
      );
    } else {
      context.read<HomeCubit>().createHabitTracking(
        CreateHabitTrackingInputEntity(
          habitId: habit.habitId,
          currentValue: newValue,
          date: DateTime.parse(
            habit.trackingRecordEntity.updatedAt ??
                DateTime.now().toIso8601String(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted =
        habit.trackingRecordEntity.currentValue >= habit.targetValue;
    int current = habit.trackingRecordEntity.currentValue;
    int target = habit.targetValue;
    return Container(
      padding: .all(24.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: .circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isCompleted ? "completed".tr() : "in_progress".tr(),
            style: isCompleted
                ? AppTextStyles.font16PrimarySemiBold(
                    context,
                  ).copyWith(color: Colors.green)
                : AppTextStyles.font14Grey(context).copyWith(fontSize: 16.sp),
          ),
          Gap(20.h),
          if (habit.type == .task)
            _buildTaskControl(
              isCompleted: isCompleted,
              habit: habit,
              context: context,
            )
          else
            _buildCountableControl(current, target, context),
          Gap(20.h),
          ClipRRect(
            borderRadius: .circular(10.r),
            child: LinearProgressIndicator(
              value: (current / target).clamp(0.0, 1.0),
              minHeight: 8.h,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(getColor(habit.color)),
            ),
          ),
          Gap(10.h),
          Text(
            "${((current / target) * 100).toInt()}%",
            style: AppTextStyles.font14Grey(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskControl({
    required bool isCompleted,
    required HabitTrackingEntity habit,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () => _updateValue(isCompleted ? 0 : 1, context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 60.h,
        width: 60.h,
        decoration: BoxDecoration(
          color: isCompleted ? getColor(habit.color) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: getColor(habit.color), width: 2),
        ),
        child: isCompleted
            ? Icon(Icons.check, color: Colors.white, size: 40.sp)
            : null,
      ),
    );
  }

  Widget _buildCountableControl(int current, int target, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCircleBtn(
          context: context,
          icon: Icons.remove,
          onTap: () => _updateValue(current - 1, context),
        ),
        Text("$current", style: AppTextStyles.font32Bold(context)),
        _buildCircleBtn(
          context: context,
          icon: Icons.add,
          onTap: () => _updateValue(current + 1, context),
        ),
      ],
    );
  }

  Widget _buildCircleBtn({
    required IconData icon,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          color: AppColors.habitCardColor(context),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.inverseSurface),
      ),
    );
  }
}
