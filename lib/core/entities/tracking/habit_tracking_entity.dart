import 'package:habit_tracking_app/core/entities/tracking/tracking_record_entity.dart';
import '../../helpers/enums.dart';

class HabitTrackingEntity {
  const HabitTrackingEntity({
    this.habitId = 1,
    this.name = 'habit',
    this.type = .task,
    this.targetValue = 1,
    this.icon = '',
    this.color = '0xFFFFFFFF',
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

  HabitTrackingEntity copyWith({
    int? habitId,
    String? name,
    HabitType? type,
    int? targetValue,
    String? icon,
    String? color,
    bool? isActive,
    TrackingRecordEntity? trackingRecordEntity,
  }) => HabitTrackingEntity(
    habitId: habitId ?? this.habitId,
    name: name ?? this.name,
    type: type ?? this.type,
    targetValue: targetValue ?? this.targetValue,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    isActive: isActive ?? this.isActive,
    trackingRecordEntity: trackingRecordEntity ?? this.trackingRecordEntity,
  );
}
