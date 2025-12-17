import 'package:habit_tracking_app/core/entities/tracking/tracking_record_entity.dart';
import '../../helpers/enums.dart';

class HabitTrackingEntity {
  const HabitTrackingEntity({
    this.habitId = 1,
    this.name = '',
    this.type = .task,
    this.targetValue = 1,
    this.icon = '',
    this.color = '',
    this.isActive = true,
    this.trackingRecordEntity,
  });

  final int habitId;
  final String name;
  final HabitType type;
  final int targetValue;
  final String icon;
  final String color;
  final bool isActive;
  final TrackingRecordEntity? trackingRecordEntity;
}
