part of 'habit_cubit.dart';

@immutable
sealed class HabitState {}

final class HabitInitial extends HabitState {}

final class HabitLoading extends HabitState {}

final class HabitSuccess extends HabitState {}

final class HabitFailure extends HabitState {
  final String message;

  HabitFailure(this.message);
}
