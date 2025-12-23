part of 'habit_cubit.dart';

enum HabitProcess { add, edit, delete, getHabitHistory, none }

@immutable
sealed class HabitState {}

final class HabitInitial extends HabitState {}

final class HabitLoading extends HabitState {
  HabitLoading(this.process);

  final HabitProcess process;
}

final class HabitSuccess extends HabitState {
  HabitSuccess(this.process, {this.history});

  final HabitProcess process;
  final List<HabitHistoryEntity>? history;
}

final class HabitFailure extends HabitState {
  HabitFailure(this.message, this.process);

  final String message;
  final HabitProcess process;
}
