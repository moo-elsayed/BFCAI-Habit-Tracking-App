import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:habit_tracking_app/core/entities/habit_entity.dart';
import 'package:habit_tracking_app/core/helpers/extensions.dart';
import 'package:habit_tracking_app/core/routing/routes.dart';

class HabitItem extends StatelessWidget {
  const HabitItem({
    super.key,
    required this.habitEntity,
    required this.onIncrement,
  });

  final HabitEntity habitEntity;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    // final isCompleted = habitEntity.currentValue >= habitEntity.targetValue;
    final isCompleted = false;

    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.habitEditorView, arguments: habitEntity);
      },
      child: Container(
        margin: .symmetric(vertical: 8.h, horizontal: 16.w),
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
                    habitEntity.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(4.h),
                  if (habitEntity.type == .count)
                    Text(
                      "1/${habitEntity.targetValue} times",
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

            if (habitEntity.type == .count)
              _buildCountableAction()
            else
              _buildBooleanAction(isCompleted),
          ],
        ),
      ),
    );
  }

  Color _getColor() => Color(int.parse(habitEntity.color));

  IconData _getIcon() =>
      IconData(int.parse(habitEntity.icon), fontFamily: 'MaterialIcons');

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
