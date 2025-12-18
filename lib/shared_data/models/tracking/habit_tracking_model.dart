import 'package:habit_tracking_app/core/entities/tracking/habit_tracking_entity.dart';
import 'package:habit_tracking_app/shared_data/models/tracking/tracking_record_model.dart';
import '../../../core/helpers/enums.dart';

class HabitTrackingModel {
  HabitTrackingModel({
    required this.habitId,
    required this.name,
    required this.type,
    required this.targetValue,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.trackingRecordModel,
  });

  final int habitId;
  final String name;
  final HabitType type;
  final int targetValue;
  final String icon;
  final String color;
  final bool isActive;
  final TrackingRecordModel trackingRecordModel;

  factory HabitTrackingModel.fromJson(Map<String, dynamic> json) =>
      HabitTrackingModel(
        habitId: json["habitId"],
        name: json["habitName"],
        type: json["habitType"] == 1 ? .task : .count,
        targetValue: json["habitTargetValue"],
        icon: json["habitIcon"],
        color: json["habitColor"],
        isActive: json["isActive"],
        trackingRecordModel: TrackingRecordModel.fromJson(
          json["trackingRecord"],
        ),
      );

  HabitTrackingEntity toEntity() => HabitTrackingEntity(
    habitId: habitId,
    name: name,
    type: type,
    targetValue: targetValue,
    icon: icon,
    color: color,
    isActive: isActive,
    trackingRecordEntity: trackingRecordModel.toEntity(),
  );
}
