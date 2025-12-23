import 'package:habit_tracking_app/core/entities/habit_entity.dart';
import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';

class HabitDetailsArgs {
  HabitDetailsArgs({
    required this.habitEntity,
    required this.habitTrackingEntity,
    required this.selectedDate,
  });

  final HabitEntity habitEntity;
  final HabitTrackingEntity habitTrackingEntity;
  final DateTime selectedDate;
}
