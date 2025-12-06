import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/input/confirm_email_input_entity.dart';
import '../../../domain/entities/input/login_input_entity.dart';
import '../../../domain/entities/input/register_input_entity.dart';
import '../../../domain/entities/response/login_response_entity.dart';

abstract class AuthRemoteDataSource {
  Future<NetworkResponse<String>> register(RegisterInputEntity input);

  Future<NetworkResponse<LoginResponseEntity>> login(LoginInputEntity input);

  Future<NetworkResponse<String>> confirmEmail(ConfirmEmailInputEntity input);

  Future<NetworkResponse<String>> logout();
}
