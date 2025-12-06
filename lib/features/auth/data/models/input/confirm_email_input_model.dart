import 'package:habit_tracking_app/features/auth/domain/entities/input/confirm_email_input_entity.dart';

class ConfirmEmailInputModel {
  ConfirmEmailInputModel({required this.email, required this.code});

  final String email;
  final String code;

  factory ConfirmEmailInputModel.fromEntity(ConfirmEmailInputEntity entity) =>
      ConfirmEmailInputModel(email: entity.email, code: entity.code);

  Map<String, dynamic> toJson() => {'email': email, 'code': code};
}
