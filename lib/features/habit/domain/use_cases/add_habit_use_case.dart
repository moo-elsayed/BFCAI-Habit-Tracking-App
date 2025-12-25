import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/core/services/notification_service/notification_service.dart';
import 'package:habit_tracking_app/features/habit/domain/repo/habit_repo.dart';
import '../../../../core/entities/habit_entity.dart';
import '../../../../core/helpers/network_response.dart';

class AddHabitUseCase {
  AddHabitUseCase(this._habitRepo, this._notificationService);

  final HabitRepo _habitRepo;
  final NotificationService _notificationService;

  Future<NetworkResponse<String>> call(HabitEntity input) async {
    var networkResponse = await _habitRepo.addHabit(input);
    switch (networkResponse) {
      case NetworkSuccess<String>():
        try {
          await _notificationService.scheduleHabit(input);
          return NetworkSuccess(networkResponse.data);
        } catch (e) {
          return handleError(e, "AddHabitUseCase");
        }
      case NetworkFailure<String>():
        return NetworkFailure(networkResponse.exception);
    }
  }
}
