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
}
