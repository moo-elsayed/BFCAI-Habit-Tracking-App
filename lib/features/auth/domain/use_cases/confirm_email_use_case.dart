import 'package:habit_tracking_app/features/auth/domain/repo/auth_repo.dart';
import '../../../../core/helpers/network_response.dart';
import '../entities/input/confirm_email_input_entity.dart';

class ConfirmEmailUseCase {
  ConfirmEmailUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<NetworkResponse<String>> call(ConfirmEmailInputEntity input) async =>
      await _authRepo.confirmEmail(input);
}
