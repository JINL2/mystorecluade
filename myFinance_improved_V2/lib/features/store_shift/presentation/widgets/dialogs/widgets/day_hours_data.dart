/// Internal data class for managing day hours state
///
/// Used by BusinessHoursDialog to track individual day settings
class DayHoursData {
  final int dayOfWeek;
  final String dayName;
  final bool isOpen;
  final String openTime;
  final String closeTime;
  final bool closesNextDay; // True if close_time is on the next day (overnight)

  DayHoursData({
    required this.dayOfWeek,
    required this.dayName,
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
    this.closesNextDay = false,
  });

  DayHoursData copyWith({
    int? dayOfWeek,
    String? dayName,
    bool? isOpen,
    String? openTime,
    String? closeTime,
    bool? closesNextDay,
  }) {
    return DayHoursData(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      dayName: dayName ?? this.dayName,
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      closesNextDay: closesNextDay ?? this.closesNextDay,
    );
  }

  /// Check if this is an overnight schedule (close time is on the next day)
  /// Auto-detect if close time is earlier than open time
  bool get isOvernight {
    if (closesNextDay) return true;
    // Auto-detect: if close time is before open time, it's overnight
    final openParts = openTime.split(':');
    final closeParts = closeTime.split(':');
    final openMinutes = int.parse(openParts[0]) * 60 + int.parse(openParts[1]);
    final closeMinutes =
        int.parse(closeParts[0]) * 60 + int.parse(closeParts[1]);
    return closeMinutes < openMinutes;
  }
}
