class HabitHistoryEntity {
  HabitHistoryEntity({
    required this.date,
    this.status = '',
    this.currentValue = 1,
    this.targetValue = 1,
  });

  final DateTime date;
  final String status;
  final int currentValue;
  final int targetValue;

  bool get isCompleted => currentValue >= targetValue;
}
