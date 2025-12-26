import 'package:habit_tracking_app/features/auth/domain/repo/auth_repo.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/save_user_session_use_case.dart';
import '../../../../core/helpers/network_response.dart';
import '../entities/input/login_input_entity.dart';
import '../entities/response/login_response_entity.dart';

class LoginUseCase {
  LoginUseCase(this._authRepo, this._saveUserSession);

  final AuthRepo _authRepo;
  final SaveUserSessionUseCase _saveUserSession;

  Future<NetworkResponse<LoginResponseEntity>> call(
    LoginInputEntity input,
  ) async {
    var networkResponse = await _authRepo.login(input);
    switch (networkResponse) {
      case NetworkSuccess<LoginResponseEntity>():
        try {
          await _saveUserSession.call(networkResponse.data!);
          return NetworkSuccess(networkResponse.data);
        } catch (e) {
          return NetworkFailure<LoginResponseEntity>(e as Exception);
        }
      case NetworkFailure<LoginResponseEntity>():
        return NetworkFailure<LoginResponseEntity>(networkResponse.exception);
    }
  }
}
