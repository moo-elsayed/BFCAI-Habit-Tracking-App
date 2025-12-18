import 'package:habit_tracking_app/core/entities/tracking/tracking_record_entity.dart';

class TrackingRecordModel {
  const TrackingRecordModel({
    required this.trackingId,
    required this.status,
    required this.currentValue,
    required this.progressPercentage,
    required this.updatedAt,
  });

  final int trackingId;
  final String status;
  final int currentValue;
  final num progressPercentage;
  final String updatedAt;

  factory TrackingRecordModel.fromJson(Map<String, dynamic> json) =>
      TrackingRecordModel(
        trackingId: json["id"],
        status: json["status"],
        currentValue: json["currentValue"],
        progressPercentage: json["progressPercentage"],
        updatedAt: json["updatedAt"],
      );

  TrackingRecordEntity toEntity() => TrackingRecordEntity(
    trackingId: trackingId,
    status: status,
    currentValue: currentValue,
    progressPercentage: progressPercentage,
    updatedAt: updatedAt,
  );
}
