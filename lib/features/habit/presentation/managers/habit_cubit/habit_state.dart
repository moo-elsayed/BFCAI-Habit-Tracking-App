part of 'habit_cubit.dart';

enum HabitProcess { add, edit, delete, none }

@immutable
sealed class HabitState {}

final class HabitInitial extends HabitState {}

final class HabitLoading extends HabitState {
  HabitLoading(this.process);

  final HabitProcess process;
}

final class HabitSuccess extends HabitState {
  HabitSuccess(this.process);

  final HabitProcess process;
}

final class HabitFailure extends HabitState {
  HabitFailure(this.message, this.process);

  final String message;
  final HabitProcess process;
}
