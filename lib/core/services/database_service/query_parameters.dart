import 'package:equatable/equatable.dart';

import '../../../features/habit/domain/entities/get_habit_history_input_entity.dart';

class QueryParameters extends Equatable {
  const QueryParameters({
    required this.startDate,
    required this.habitId,
    required this.endDate,
  });

  final int habitId;
  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [habitId, startDate, endDate];

  factory QueryParameters.fromGetHabitHistoryInputEntity(
    GetHabitHistoryInputEntity entity,
  ) => QueryParameters(
    habitId: entity.habitId,
    startDate: entity.startDate,
    endDate: entity.endDate,
  );

  Map<String, dynamic> toJson() => {
    "HabitId": habitId,
    "StartDate": startDate.toIso8601String().split('T').first,
    "EndDate": endDate.toIso8601String().split('T').first,
  };
}
