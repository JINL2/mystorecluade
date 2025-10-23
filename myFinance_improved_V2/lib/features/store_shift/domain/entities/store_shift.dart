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
  final DateTime createdAt;  // Timestamp (stored as UTC in DB, converted to local)
  final DateTime updatedAt;  // Timestamp (stored as UTC in DB, converted to local)

  const StoreShift({
    required this.shiftId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.shiftBonus,
    required this.isActive,
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
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'StoreShift(shiftId: $shiftId, shiftName: $shiftName, startTime: $startTime, endTime: $endTime, shiftBonus: $shiftBonus, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
