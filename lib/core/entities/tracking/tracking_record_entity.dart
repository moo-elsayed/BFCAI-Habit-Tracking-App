class TrackingRecordEntity {
  const TrackingRecordEntity({
    this.trackingId,
    this.status = '',
    this.currentValue = 0,
    this.progressPercentage = 0,
    this.updatedAt,
  });

  final int? trackingId;
  final String status;
  final int currentValue;
  final num progressPercentage;
  final String? updatedAt;

  TrackingRecordEntity copyWith({
    int? trackingId,
    String? status,
    int? currentValue,
    num? progressPercentage,
    String? updatedAt,
  }) => TrackingRecordEntity(
    trackingId: trackingId ?? this.trackingId,
    status: status ?? this.status,
    currentValue: currentValue ?? this.currentValue,
    progressPercentage: progressPercentage ?? this.progressPercentage,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
