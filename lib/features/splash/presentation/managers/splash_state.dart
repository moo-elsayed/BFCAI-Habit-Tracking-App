part of 'splash_cubit.dart';

enum SplashProcess {
  navigateToOnboarding,
  navigateToLogin,
  navigateToAppSection,
}

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashSuccess extends SplashState {
  SplashSuccess(this.process);

  final SplashProcess process;
}
