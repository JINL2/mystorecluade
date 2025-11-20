/// Shift Metadata Entity
///
/// Represents shift configuration from store_shifts table.
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

  /// Create from JSON (from RPC: get_shift_metadata)
  factory ShiftMetadata.fromJson(Map<String, dynamic> json) {
    return ShiftMetadata(
      shiftId: json['shift_id'] as String,
      storeId: json['store_id'] as String,
      shiftName: json['shift_name'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      isActive: json['is_active'] as bool? ?? true,
      numberShift: json['number_shift'] as int?,
      isCanOvertime: json['is_can_overtime'] as bool? ?? false,
      shiftBonus: (json['shift_bonus'] as num?)?.toDouble(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'shift_id': shiftId,
      'store_id': storeId,
      'shift_name': shiftName,
      'start_time': startTime,
      'end_time': endTime,
      'is_active': isActive,
      'number_shift': numberShift,
      'is_can_overtime': isCanOvertime,
      'shift_bonus': shiftBonus,
    };
  }

  @override
  String toString() => 'ShiftMetadata(id: $shiftId, name: $shiftName, $startTime-$endTime)';
}
