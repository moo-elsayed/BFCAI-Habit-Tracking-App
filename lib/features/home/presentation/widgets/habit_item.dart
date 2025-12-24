import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/entities/tracking/create_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/edit_habit_tracking_input_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/theming/app_colors.dart';
import 'package:habit_tracking_app/core/theming/app_text_styles.dart';
import 'package:habit_tracking_app/features/home/presentation/managers/home_cubit/home_cubit.dart';
import 'package:habit_tracking_app/features/home/presentation/widgets/custom_completed_widget.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../habit/presentation/view_utils/args/habit_details_args.dart';

class HabitItem extends StatelessWidget {
  const HabitItem({
    super.key,
    required this.habitTrackingEntity,
    required this.selectedDateNotifier,
  });

  final HabitTrackingEntity habitTrackingEntity;
  final ValueNotifier<DateTime> selectedDateNotifier;

  @override
  Widget build(BuildContext context) {
    final isCompleted =
        habitTrackingEntity.trackingRecordEntity.progressPercentage >= 100;
    var currentValue = habitTrackingEntity.trackingRecordEntity.currentValue;
    var targetValue = habitTrackingEntity.targetValue;
    return GestureDetector(
      onTap: () async {
        var habitEntity = context.read<HomeCubit>().getEquivalentHabit(
          habitTrackingEntity,
        );

        bool? myBool = await context.pushNamed(
          Routes.habitDetailsView,
          arguments: HabitDetailsArgs(
            habitEntity: habitEntity,
            habitTrackingEntity: habitTrackingEntity,
            selectedDate: selectedDateNotifier.value,
          ),
        );
        if (myBool != null && myBool) {
          context.read<HomeCubit>().getAllHabits();
          context.read<HomeCubit>().getHabitsByDate(selectedDateNotifier.value);
        }
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
                color: getColor(habitTrackingEntity.color),
                shape: BoxShape.circle,
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
                      "$currentValue/$targetValue ${"times".tr()}",
                      style: AppTextStyles.font14CustomColor(
                        isCompleted
                            ? AppColors.success(context)
                            : AppColors.textSecondary(context),
                      ),
                    )
                  else
                    Text(
                      "task".tr(),
                      style: AppTextStyles.font14CustomColor(
                        isCompleted
                            ? AppColors.success(context)
                            : AppColors.textSecondary(context),
                      ),
                    ),
                ],
              ),
            ),
            if (selectedDateNotifier.value.isBefore(DateTime.now()))
              if (habitTrackingEntity.type == .count)
                _buildCountableAction(
                  habitTrackingEntity: habitTrackingEntity,
                  isCompleted: isCompleted,
                  context: context,
                )
              else
                _buildBooleanAction(isCompleted: isCompleted, context: context),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() => IconData(
    int.parse(habitTrackingEntity.icon),
    fontFamily: 'MaterialIcons',
  );

  Widget _buildCountableAction({
    required BuildContext context,
    required bool isCompleted,
    required HabitTrackingEntity habitTrackingEntity,
  }) {
    return GestureDetector(
      onTap: () {
        var trackingRecordEntity = habitTrackingEntity.trackingRecordEntity;
        if (trackingRecordEntity.trackingId == null) {
          context.read<HomeCubit>().createHabitTracking(
            CreateHabitTrackingInputEntity(
              habitId: habitTrackingEntity.habitId,
              currentValue: 1,
              date: selectedDateNotifier.value,
            ),
          );
        } else {
          context.read<HomeCubit>().editHabitTracking(
            EditHabitTrackingInputEntity(
              trackingId: trackingRecordEntity.trackingId ?? 0,
              currentValue: trackingRecordEntity.currentValue + 1,
            ),
          );
        }
      },
      child: isCompleted
          ? const CustomCompletedWidget()
          : Icon(Icons.add, color: AppColors.textPrimary(context), size: 24.sp),
    );
  }

  Widget _buildBooleanAction({
    required bool isCompleted,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        var trackingRecordEntity = habitTrackingEntity.trackingRecordEntity;
        log(trackingRecordEntity.trackingId.toString());
        if (trackingRecordEntity.trackingId == null) {
          context.read<HomeCubit>().createHabitTracking(
            CreateHabitTrackingInputEntity(
              habitId: habitTrackingEntity.habitId,
              currentValue: 1,
              date: selectedDateNotifier.value,
            ),
          );
        } else {
          context.read<HomeCubit>().editHabitTracking(
            EditHabitTrackingInputEntity(
              trackingId: trackingRecordEntity.trackingId ?? 0,
              currentValue: trackingRecordEntity.currentValue == 1 ? 0 : 1,
            ),
          );
        }
      },
      child: CustomCompletedWidget(isCompleted: isCompleted),
    );
  }
}
