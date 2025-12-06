import 'package:habit_tracking_app/core/helpers/network_response.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/confirm_email_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/login_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/response/login_response_entity.dart';

abstract class AuthRepo {
  Future<NetworkResponse<String>> register(RegisterInputEntity input);

  Future<NetworkResponse<LoginResponseEntity>> login(LoginInputEntity input);

  Future<NetworkResponse<String>> confirmEmail(ConfirmEmailInputEntity input);

  Future<NetworkResponse<String>> logout();
}
