import 'package:habit_tracking_app/features/auth/domain/entities/input/confirm_email_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';
import '../../../features/auth/domain/entities/input/login_input_entity.dart';
import '../../../features/auth/domain/entities/response/login_response_entity.dart';

abstract class AuthService {
  Future<String> register(RegisterInputEntity input);

  Future<LoginResponseEntity> login(LoginInputEntity input);

  Future<String> confirmEmail(ConfirmEmailInputEntity input);

  Future<String> logout(String token);
}
