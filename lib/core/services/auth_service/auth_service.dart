import 'package:habit_tracking_app/features/auth/domain/entities/input/confirm_email_input_entity.dart';
import 'package:habit_tracking_app/features/auth/domain/entities/input/register_input_entity.dart';
import 'package:habit_tracking_app/shared_data/models/api_response/api_response.dart';
import '../../../features/auth/domain/entities/input/login_input_entity.dart';
import '../../../features/auth/domain/entities/response/login_response_entity.dart';

abstract class AuthService {
  Future<ApiResponse<String>> register(RegisterInputEntity input);

  Future<ApiResponse<LoginResponseEntity>> login(LoginInputEntity input);

  Future<ApiResponse<String>> confirmEmail(ConfirmEmailInputEntity input);

  Future<ApiResponse<String>> logout();
}
