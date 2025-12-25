import 'package:habit_tracking_app/core/services/notification_service/notification_service.dart';
import 'package:habit_tracking_app/features/habit/domain/repo/habit_repo.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/helpers/network_response.dart';

class DeleteHabitUseCase {
  DeleteHabitUseCase(this._habitRepo, this._notificationService);

  final HabitRepo _habitRepo;
  final NotificationService _notificationService;

  Future<NetworkResponse<String>> call(int id) async {
    var networkResponse = await _habitRepo.deleteHabit(id);
    switch (networkResponse) {
      case NetworkSuccess<String>():
        try {
          await _notificationService.cancelHabitNotifications(id);
          return NetworkSuccess(networkResponse.data);
        } catch (e) {
          return handleError(e, "DeleteHabitUseCase");
        }
      case NetworkFailure<String>():
        return NetworkFailure(networkResponse.exception);
    }
  }
}
