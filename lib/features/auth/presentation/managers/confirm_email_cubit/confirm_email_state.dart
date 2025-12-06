part of 'confirm_email_cubit.dart';

@immutable
sealed class ConfirmEmailState {}

final class ConfirmEmailInitial extends ConfirmEmailState {}

final class ConfirmEmailLoading extends ConfirmEmailState {}

final class ConfirmEmailSuccess extends ConfirmEmailState {}

final class ConfirmEmailFailure extends ConfirmEmailState {
  ConfirmEmailFailure(this.errorMessage);

  final String errorMessage;
}
