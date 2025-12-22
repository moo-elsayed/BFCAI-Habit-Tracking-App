part of 'home_cubit.dart';

enum HomeProcess {
  getHomeHabits,
  getAll,
  getHabitsByDate,
  create,
  edit,
  none,
}

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {
  HomeLoading(this.process);

  final HomeProcess process;
}

final class HomeSuccess extends HomeState {
  HomeSuccess({required this.process, this.habits});

  final HomeProcess process;
  final List<HabitTrackingEntity>? habits;
}

final class HomeFailure extends HomeState {
  HomeFailure(this.message, this.process);

  final String message;
  final HomeProcess process;
}
