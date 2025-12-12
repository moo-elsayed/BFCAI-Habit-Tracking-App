import '../../domain/entities/habit_schedule_entity.dart';

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
          : _parseDayStringToInt(json["dayOfWeek"]),
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

  static int _parseDayStringToInt(String day) {
    switch (day.toLowerCase()) {
      case 'saturday':
        return 0;
      case 'sunday':
        return 1;
      case 'monday':
        return 2;
      case 'tuesday':
        return 3;
      case 'wednesday':
        return 4;
      case 'thursday':
        return 5;
      case 'friday':
        return 6;
      default:
        return 0;
    }
  }
}
