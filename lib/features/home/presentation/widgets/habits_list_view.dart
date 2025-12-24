import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'habit_item.dart';

class HabitsListView extends StatelessWidget {
  const HabitsListView({
    super.key,
    this.habits,
    this.isLoading = false,
    required this.selectedDateNotifier,
  });

  final List<HabitTrackingEntity>? habits;
  final ValueNotifier<DateTime> selectedDateNotifier;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: habits?.length ?? 3,
      padding: .symmetric(horizontal: 16.w),
      separatorBuilder: (context, index) => Gap(12.h),
      itemBuilder: (context, index) {
        return Skeletonizer(
          enabled: isLoading,
          child: HabitItem(
            selectedDateNotifier: selectedDateNotifier,
            habitTrackingEntity: habits?[index] ?? const HabitTrackingEntity(),
          ),
        );
      },
    );
  }
}
