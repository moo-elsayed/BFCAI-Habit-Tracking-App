import '../../domain/entities/habit_entity.dart';
import 'habit_schedule_model.dart';

class HabitModel {
  HabitModel({
    this.id,
    required this.name,
    required this.type,
    required this.targetValue,
    required this.icon,
    required this.color,
    required this.startDate,
    required this.isActive,
    required this.habitSchedules,
  });

  final int? id;
  final String name;
  final int type;
  final int targetValue;
  final String icon;
  final String color;
  final String startDate;
  final bool isActive;
  final List<HabitScheduleModel> habitSchedules;

  factory HabitModel.fromEntity(HabitEntity entity) => HabitModel(
    name: entity.name,
    type: entity.type.value,
    targetValue: entity.targetValue,
    icon: entity.icon,
    color: entity.color,
    startDate: entity.startDate.toIso8601String(),
    isActive: entity.isActive,
    habitSchedules: entity.habitSchedules
        .map((e) => HabitScheduleModel.fromEntity(e))
        .toList(),
  );

  factory HabitModel.fromJson(Map<String, dynamic> json) => HabitModel(
    name: json["name"],
    type: json["type"] is int
        ? json["type"]
        : (json["type"] == "UnCountableHabit" ? 1 : 2),
    targetValue: json["targetValue"],
    icon: json["icon"],
    color: json["color"],
    startDate: json["startDate"],
    isActive: json["isActive"],
    habitSchedules: (json["habitSchedules"] as List)
        .map((e) => HabitScheduleModel.fromJson(e))
        .toList(),
  );

  HabitEntity toEntity() => HabitEntity(
    id: id,
    name: name,
    type: HabitType.values.firstWhere((e) => e.value == type),
    targetValue: targetValue,
    icon: icon,
    color: color,
    startDate: DateTime.parse(startDate),
    isActive: isActive,
    habitSchedules: habitSchedules.map((e) => e.toEntity()).toList(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "type": type,
    "targetValue": targetValue,
    "icon": icon,
    "color": color,
    "startDate": startDate,
    "isActive": isActive,
    "habitSchedules": habitSchedules.map((e) => e.toJson()).toList(),
  };
}
