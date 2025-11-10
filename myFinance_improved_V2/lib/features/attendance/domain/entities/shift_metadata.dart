/// Shift Metadata Entity
///
/// Represents shift template information for a store.
class ShiftMetadata {
  final String shiftId;
  final String shiftName;
  final String startTime;
  final String endTime;
  final String? description;
  final bool isActive;

  const ShiftMetadata({
    required this.shiftId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    this.description,
    this.isActive = true,
  });

  /// Calculate shift duration in hours
  double get durationHours {
    try {
      final start = _parseTime(startTime);
      final end = _parseTime(endTime);

      var duration = end.difference(start);
      if (duration.isNegative) {
        // Handle overnight shifts
        duration = duration + const Duration(hours: 24);
      }

      return duration.inMinutes / 60.0;
    } catch (e) {
      return 0.0;
    }
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  @override
  String toString() => 'ShiftMetadata($shiftName: $startTime - $endTime)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftMetadata &&
          runtimeType == other.runtimeType &&
          shiftId == other.shiftId;

  @override
  int get hashCode => shiftId.hashCode;
}
