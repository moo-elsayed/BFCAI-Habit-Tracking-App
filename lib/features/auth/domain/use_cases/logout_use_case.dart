import 'package:habit_tracking_app/features/auth/domain/repo/auth_repo.dart';
import 'package:habit_tracking_app/features/auth/domain/use_cases/clear_user_session_use_case.dart';
import '../../../../core/helpers/network_response.dart';

class LogoutUseCase {
  LogoutUseCase(this._authRepo, this._clearUserSessionUseCase);

  final AuthRepo _authRepo;
  final ClearUserSessionUseCase _clearUserSessionUseCase;

  Future<NetworkResponse<String>> call() async {
    var networkResponse = await _authRepo.logout();
    switch (networkResponse) {
      case NetworkSuccess<String>():
        try {
          await _clearUserSessionUseCase.call();
          return NetworkSuccess(networkResponse.data);
        } catch (e) {
          return NetworkFailure(Exception("error_occurred_please_try_again"));
        }
      case NetworkFailure<String>():
        return NetworkFailure(networkResponse.exception);
    }
  }
}
