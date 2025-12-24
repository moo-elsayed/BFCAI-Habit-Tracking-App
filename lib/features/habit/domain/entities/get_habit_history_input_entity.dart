class GetHabitHistoryInputEntity {
  GetHabitHistoryInputEntity({
    this.habitId = 1,
    required this.startDate,
    required this.endDate,
  });

  final int habitId;
  final DateTime startDate;
  final DateTime endDate;
}
