/// Shift Time Range Value Object
///
/// Represents a time range for a shift with validation.
class ShiftTimeRange {
  final DateTime startTime;
  final DateTime endTime;

  const ShiftTimeRange({
    required this.startTime,
    required this.endTime,
  });

  /// Get duration of the shift
  Duration get duration => endTime.difference(startTime);

  /// Get duration in hours
  double get durationInHours => duration.inMinutes / 60.0;

  /// Get duration in minutes
  int get durationInMinutes => duration.inMinutes;

  /// Check if time range is valid (end after start)
  bool get isValid => endTime.isAfter(startTime);

  /// Check if this time range overlaps with another
  bool isOverlapping(ShiftTimeRange other) {
    return startTime.isBefore(other.endTime) && endTime.isAfter(other.startTime);
  }

  /// Format time range as string (HH:mm - HH:mm)
  String toDisplayString() {
    final startHour = startTime.hour.toString().padLeft(2, '0');
    final startMinute = startTime.minute.toString().padLeft(2, '0');
    final endHour = endTime.hour.toString().padLeft(2, '0');
    final endMinute = endTime.minute.toString().padLeft(2, '0');
    return '$startHour:$startMinute - $endHour:$endMinute';
  }

  @override
  String toString() => toDisplayString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShiftTimeRange &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode;
}
