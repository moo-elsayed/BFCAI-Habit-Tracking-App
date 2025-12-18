import '../../../core/entities/tracking/edit_habit_tracking_input_entity.dart';

class EditHabitTrackingInputModel {
  EditHabitTrackingInputModel({
    required this.trackingId,
    required this.currentValue,
  });

  final int trackingId;
  final int currentValue;

  factory EditHabitTrackingInputModel.fromEntity(
    EditHabitTrackingInputEntity entity,
  ) => EditHabitTrackingInputModel(
    trackingId: entity.trackingId,
    currentValue: entity.currentValue,
  );

  Map<String, dynamic> toJson() => {
    "id": trackingId,
    "currentValue": currentValue,
  };
}
