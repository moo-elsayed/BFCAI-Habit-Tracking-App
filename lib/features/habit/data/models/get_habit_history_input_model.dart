class GetHabitHistoryInputModel {
  GetHabitHistoryInputModel({
    required this.habitId,
    required this.startDate,
    required this.endDate,
  });

  final int habitId;
  final DateTime startDate;
  final DateTime endDate;
}
