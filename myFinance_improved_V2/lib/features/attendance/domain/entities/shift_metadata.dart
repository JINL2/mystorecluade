/// Shift Metadata Entity
///
/// Represents shift configuration from store_shifts table.
/// Pure domain entity - JSON serialization handled by Data layer (ShiftMetadataModel).
class ShiftMetadata {
  final String shiftId;
  final String storeId;
  final String shiftName;
  final String startTime;
  final String endTime;
  final bool isActive;
  final int? numberShift;
  final bool isCanOvertime;
  final double? shiftBonus;

  const ShiftMetadata({
    required this.shiftId,
    required this.storeId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.isActive,
    this.numberShift,
    required this.isCanOvertime,
    this.shiftBonus,
  });

  /// Get formatted time range (e.g., "09:00 - 17:00")
  String get timeRange => '$startTime - $endTime';

  @override
  String toString() => 'ShiftMetadata(id: $shiftId, name: $shiftName, $startTime-$endTime)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftMetadata &&
          runtimeType == other.runtimeType &&
          shiftId == other.shiftId;

  @override
  int get hashCode => shiftId.hashCode;
}
