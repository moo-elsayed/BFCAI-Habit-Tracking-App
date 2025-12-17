import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
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
        padding: .all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: .circular(24.r),
        ),
        child: Row(
          children: [
            Container(
              padding: const .all(12),
              decoration: BoxDecoration(
                color: _getColor(),
                borderRadius: .circular(16),
              ),
              child: Icon(_getIcon(), color: _getColor(), size: 28),
            ),
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    habitTrackingEntity.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(4.h),
                  if (habitTrackingEntity.type == .count)
                    Text(
                      "${habitTrackingEntity.trackingRecordEntity?.currentValue}/${habitTrackingEntity.targetValue} times",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  else
                    Text(
                      isCompleted ? "Completed" : "Tap to complete",
                      style: TextStyle(
                        color: isCompleted ? Colors.green : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            if (habitTrackingEntity.type == .count)
              _buildCountableAction()
            else
              _buildBooleanAction(isCompleted),
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

  Widget _buildCountableAction() {
    return GestureDetector(
      onTap: onIncrement,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: .circular(12.r),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildBooleanAction(bool isCompleted) {
    return GestureDetector(
      onTap: onIncrement,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: isCompleted ? const Color(0xFF4AF6C8) : Colors.transparent,
          borderRadius: .circular(12.r),
          border: isCompleted ? null : .all(color: Colors.grey, width: 2),
        ),
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.black, size: 28)
            : null,
      ),
    );
  }
}
