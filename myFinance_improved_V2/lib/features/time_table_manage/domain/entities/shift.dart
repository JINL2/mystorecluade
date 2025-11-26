/// Shift Entity
///
/// Represents a work shift with scheduling details and capacity information.
class Shift {
  final String shiftId;
  final String storeId;
  final String? storeName;
  final String shiftDate;
  final DateTime planStartTime;
  final DateTime planEndTime;
  final int targetCount;
  final int currentCount;
  final List<String> tags;
  final String? shiftName;

  const Shift({
    required this.shiftId,
    required this.storeId,
    this.storeName,
    required this.shiftDate,
    required this.planStartTime,
    required this.planEndTime,
    required this.targetCount,
    required this.currentCount,
    this.tags = const [],
    this.shiftName,
  });

  /// Check if shift is fully staffed
  bool get isFullyStaffed => currentCount >= targetCount;

  /// Check if shift is under-staffed
  bool get isUnderStaffed => currentCount < targetCount;

  /// Get remaining slots available
  int get remainingSlots => targetCount - currentCount;

  /// Check if shift has no approved employees
  bool get hasNoApproved => currentCount == 0;

  /// Get shift duration in hours
  double get durationInHours {
    final duration = planEndTime.difference(planStartTime);
    return duration.inMinutes / 60.0;
  }

  /// Copy with method for immutability
  Shift copyWith({
    String? shiftId,
    String? storeId,
    String? storeName,
    String? shiftDate,
    DateTime? planStartTime,
    DateTime? planEndTime,
    int? targetCount,
    int? currentCount,
    List<String>? tags,
    String? shiftName,
  }) {
    return Shift(
      shiftId: shiftId ?? this.shiftId,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      shiftDate: shiftDate ?? this.shiftDate,
      planStartTime: planStartTime ?? this.planStartTime,
      planEndTime: planEndTime ?? this.planEndTime,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      tags: tags ?? this.tags,
      shiftName: shiftName ?? this.shiftName,
    );
  }

  @override
  String toString() => 'Shift(id: $shiftId, date: $shiftDate, $currentCount/$targetCount)';
}
