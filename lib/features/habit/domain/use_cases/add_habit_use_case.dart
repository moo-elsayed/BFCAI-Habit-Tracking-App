import 'package:habit_tracking_app/core/helpers/functions.dart';
import 'package:habit_tracking_app/features/habit/domain/repo/habit_repo.dart';
import '../../../../core/entities/habit_entity.dart';
import '../../../../core/helpers/network_response.dart';
import '../../../../core/services/local_notification_service/local_notification_service.dart';

class AddHabitUseCase {
  AddHabitUseCase(this._habitRepo);

  final HabitRepo _habitRepo;

  Future<NetworkResponse<String>> call(HabitEntity input) async {
    var networkResponse = await _habitRepo.addHabit(input);
    switch (networkResponse) {
      case NetworkSuccess<String>():
        try {
          await LocalNotificationService.scheduleHabit(input);
          return NetworkSuccess(networkResponse.data);
        } catch (e) {
          return handleError(e, "AddHabitUseCase");
        }
      case NetworkFailure<String>():
        return NetworkFailure(networkResponse.exception);
    }
  }
}
