import 'package:habit_tracking_app/features/auth/domain/entities/input/login_input_entity.dart';

class LoginInputModel {
  LoginInputModel({required this.email, required this.password});

  final String email;
  final String password;

  factory LoginInputModel.fromEntity(LoginInputEntity entity) =>
      LoginInputModel(email: entity.email, password: entity.password);

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
