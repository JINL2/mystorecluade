/// Store Shift Entity
///
/// Represents a shift configuration for a store.
/// This is a pure business entity with no dependencies on external frameworks.
class StoreShift {
  final String shiftId;
  final String shiftName;
  final String startTime;  // Time-only (HH:mm format, no timezone)
  final String endTime;    // Time-only (HH:mm format, no timezone)
  final int shiftBonus;
  final bool isActive;
  final int numberShift;       // Required number of employees for this shift
  final bool isCanOvertime;    // Whether overtime is allowed for this shift
  final int employeeCount;     // Actual number of employees assigned to this shift
  final DateTime createdAt;  // Timestamp (stored as UTC in DB, converted to local)
  final DateTime updatedAt;  // Timestamp (stored as UTC in DB, converted to local)

  const StoreShift({
    required this.shiftId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.shiftBonus,
    required this.isActive,
    this.numberShift = 1,
    this.isCanOvertime = false,
    this.employeeCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy with optional field updates
  StoreShift copyWith({
    String? shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? shiftBonus,
    bool? isActive,
    int? numberShift,
    bool? isCanOvertime,
    int? employeeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreShift(
      shiftId: shiftId ?? this.shiftId,
      shiftName: shiftName ?? this.shiftName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      shiftBonus: shiftBonus ?? this.shiftBonus,
      isActive: isActive ?? this.isActive,
      numberShift: numberShift ?? this.numberShift,
      isCanOvertime: isCanOvertime ?? this.isCanOvertime,
      employeeCount: employeeCount ?? this.employeeCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StoreShift &&
        other.shiftId == shiftId &&
        other.shiftName == shiftName &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.shiftBonus == shiftBonus &&
        other.isActive == isActive &&
        other.numberShift == numberShift &&
        other.isCanOvertime == isCanOvertime &&
        other.employeeCount == employeeCount &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return shiftId.hashCode ^
        shiftName.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        shiftBonus.hashCode ^
        isActive.hashCode ^
        numberShift.hashCode ^
        isCanOvertime.hashCode ^
        employeeCount.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'StoreShift(shiftId: $shiftId, shiftName: $shiftName, startTime: $startTime, endTime: $endTime, shiftBonus: $shiftBonus, isActive: $isActive, numberShift: $numberShift, isCanOvertime: $isCanOvertime, employeeCount: $employeeCount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
