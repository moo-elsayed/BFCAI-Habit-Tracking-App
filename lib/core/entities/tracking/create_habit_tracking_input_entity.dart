class CreateHabitTrackingInputEntity {
  const CreateHabitTrackingInputEntity({
    this.habitId = 0,
    this.date,
    this.currentValue = 0,
  });

  final int habitId;
  final DateTime? date;
  final int currentValue;
}
