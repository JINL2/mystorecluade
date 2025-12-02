/// Shift Metadata Item Entity
///
/// Represents a single shift configuration in the store's metadata.
class ShiftMetadataItem {
  final String shiftId;
  final String shiftName;
  final String startTime; // HH:mm format or ISO string
  final String endTime; // HH:mm format or ISO string
  final int targetCount; // Required number of employees
  final bool isActive;
  final bool isCanOvertime;

  const ShiftMetadataItem({
    required this.shiftId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.targetCount,
    required this.isActive,
    this.isCanOvertime = false,
  });

  /// Check if this shift requires employees
  bool get requiresStaff => targetCount > 0;

  /// Check if shift is available for scheduling
  bool get isAvailableForScheduling => isActive && requiresStaff;

  /// Copy with method for immutability
  ShiftMetadataItem copyWith({
    String? shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? targetCount,
    bool? isActive,
    bool? isCanOvertime,
  }) {
    return ShiftMetadataItem(
      shiftId: shiftId ?? this.shiftId,
      shiftName: shiftName ?? this.shiftName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      targetCount: targetCount ?? this.targetCount,
      isActive: isActive ?? this.isActive,
      isCanOvertime: isCanOvertime ?? this.isCanOvertime,
    );
  }

  @override
  String toString() =>
      'ShiftMetadataItem(id: $shiftId, name: $shiftName, active: $isActive)';
}
