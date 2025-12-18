import 'package:habit_tracking_app/core/entities/tracking/create_habit_tracking_input_entity.dart';

class CreateHabitTrackingInputModel {
  CreateHabitTrackingInputModel({
    required this.id,
    required this.date,
    required this.currentValue,
  });

  final int id;
  final DateTime date;
  final int currentValue;

  factory CreateHabitTrackingInputModel.fromEntity(
    CreateHabitTrackingInputEntity entity,
  ) => CreateHabitTrackingInputModel(
    id: entity.habitId,
    date: entity.date ?? DateTime.now(),
    currentValue: entity.currentValue,
  );

  Map<String, dynamic> toJson() => {
    "habitId": id,
    "date": date.toString().substring(0, 10),
    "currentValue": currentValue,
  };
}
