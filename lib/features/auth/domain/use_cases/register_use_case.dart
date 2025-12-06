import 'package:habit_tracking_app/features/auth/domain/repo/auth_repo.dart';
import '../../../../core/helpers/network_response.dart';
import '../entities/input/register_input_entity.dart';

class RegisterUseCase {
  RegisterUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<NetworkResponse<String>> call(RegisterInputEntity input) async =>
     await _authRepo.register(input);
}
