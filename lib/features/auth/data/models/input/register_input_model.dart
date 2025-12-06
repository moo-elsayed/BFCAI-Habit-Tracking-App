import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';

class RegisterInputModel {
  RegisterInputModel({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String fullName;
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  factory RegisterInputModel.fromEntity(RegisterInputEntity entity) =>
      RegisterInputModel(
        fullName: entity.fullName,
        username: entity.username,
        email: entity.email,
        password: entity.password,
        confirmPassword: entity.confirmPassword,
      );

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'userName': username,
    'email': email,
    'password': password,
    'confirmPassword': confirmPassword,
  };
}
