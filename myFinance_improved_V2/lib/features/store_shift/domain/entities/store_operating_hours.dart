/// Store Operating Hours Entity
///
/// Represents operating hours for a specific day of the week.
/// This is a pure business entity with no dependencies on external frameworks.
class StoreOperatingHours {
  final String dayOfWeek;
  final String openTime;
  final String closeTime;
  final bool isClosed;

  const StoreOperatingHours({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
  });

  /// Create a copy with optional field updates
  StoreOperatingHours copyWith({
    String? dayOfWeek,
    String? openTime,
    String? closeTime,
    bool? isClosed,
  }) {
    return StoreOperatingHours(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StoreOperatingHours &&
        other.dayOfWeek == dayOfWeek &&
        other.openTime == openTime &&
        other.closeTime == closeTime &&
        other.isClosed == isClosed;
  }

  @override
  int get hashCode {
    return dayOfWeek.hashCode ^
        openTime.hashCode ^
        closeTime.hashCode ^
        isClosed.hashCode;
  }

  @override
  String toString() {
    return 'StoreOperatingHours(dayOfWeek: $dayOfWeek, openTime: $openTime, closeTime: $closeTime, isClosed: $isClosed)';
  }
}
