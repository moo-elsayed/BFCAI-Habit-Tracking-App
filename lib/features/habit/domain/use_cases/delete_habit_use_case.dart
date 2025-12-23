import 'package:habit_tracking_app/features/habit/domain/repo/habit_repo.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/helpers/network_response.dart';
import '../../../../core/services/local_notification_service/local_notification_service.dart';

class DeleteHabitUseCase {
  DeleteHabitUseCase(this._habitRepo);

  final HabitRepo _habitRepo;

  Future<NetworkResponse<String>> call(int id) async {
    var networkResponse = await _habitRepo.deleteHabit(id);
    switch (networkResponse) {
      case NetworkSuccess<String>():
        try {
          await LocalNotificationService.cancelHabitNotifications(id);
          return NetworkSuccess(networkResponse.data);
        } catch (e) {
          return handleError(e, "DeleteHabitUseCase");
        }
      case NetworkFailure<String>():
        return NetworkFailure(networkResponse.exception);
    }
  }
}
