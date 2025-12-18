import '../../core/entities/habit_schedule_entity.dart';
import '../../core/helpers/functions.dart';

class HabitScheduleModel {
  HabitScheduleModel({required this.dayOfWeek, required this.notificationTime});

  final int dayOfWeek;
  final String notificationTime;

  factory HabitScheduleModel.fromEntity(HabitScheduleEntity entity) =>
      HabitScheduleModel(
        dayOfWeek: entity.dayOfWeek,
        notificationTime: entity.notificationTime,
      );

  factory HabitScheduleModel.fromJson(Map<String, dynamic> json) {
    return HabitScheduleModel(
      dayOfWeek: json["dayOfWeek"] is int
          ? json["dayOfWeek"]
          : parseDayStringToInt(json["dayOfWeek"]),
      notificationTime: json["notificationTime"],
    );
  }

  HabitScheduleEntity toEntity() => HabitScheduleEntity(
    dayOfWeek: dayOfWeek,
    notificationTime: notificationTime,
  );

  Map<String, dynamic> toJson() => {
    "dayOfWeek": dayOfWeek,
    "notificationTime": notificationTime.length > 8
        ? notificationTime.substring(0, 8)
        : notificationTime,
  };
}
