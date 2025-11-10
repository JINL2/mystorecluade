class DateFormatUtils {
  static String getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  static String getWeekdayFull(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  static String getWeekdayShort(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }
}

/// Extension methods on DateTime for formatting
extension DateTimeFormatting on DateTime {
  /// Format date as 'YYYY-MM-DD' for API requests and database keys
  /// Example: 2024-11-15
  String toDateKey() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  /// Format date as 'YYYY-MM' for month-based keys
  /// Example: 2024-11
  String toMonthKey() {
    return '$year-${month.toString().padLeft(2, '0')}';
  }

  /// Format time as 'HH:MM' from DateTime
  /// Example: 14:30
  String toTimeKey() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Format date for display: 'Month DD, YYYY'
  /// Example: November 15, 2024
  String toDisplayDate() {
    return '${DateFormatUtils.getMonthName(month)} $day, $year';
  }

  /// Get the full weekday name
  /// Example: Monday
  String get weekdayFull => DateFormatUtils.getWeekdayFull(weekday);

  /// Get the short weekday name
  /// Example: Mon
  String get weekdayShort => DateFormatUtils.getWeekdayShort(weekday);
}
