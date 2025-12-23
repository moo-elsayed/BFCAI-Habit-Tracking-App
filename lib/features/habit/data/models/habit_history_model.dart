import '../../domain/entities/habit_history_entity.dart';

class HabitHistoryModel {
  HabitHistoryModel({
    required this.date,
    required this.status,
    required this.currentValue,
    required this.targetValue,
  });

  final DateTime date;
  final String status;
  final int currentValue;
  final int targetValue;

  factory HabitHistoryModel.fromJson(Map<String, dynamic> json) {
    return HabitHistoryModel(
      date: DateTime.parse(json['date']),
      status: json['status'] ?? 'Unknown',
      currentValue: json['currentValue'] ?? 0,
      targetValue: json['targetValue'] ?? 1,
    );
  }

  HabitHistoryEntity toEntity() => HabitHistoryEntity(
    date: date,
    status: status,
    currentValue: currentValue,
    targetValue: targetValue,
  );
}
