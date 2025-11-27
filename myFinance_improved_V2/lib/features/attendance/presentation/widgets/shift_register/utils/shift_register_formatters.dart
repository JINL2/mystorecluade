/// Utility functions for formatting dates and times in the shift register feature.
class ShiftRegisterFormatters {
  /// Returns the full weekday name for the given weekday number (1-7).
  ///
  /// Example:
  /// ```dart
  /// getWeekdayFull(1); // Returns 'Monday'
  /// getWeekdayFull(7); // Returns 'Sunday'
  /// ```
  static String getWeekdayFull(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[weekday - 1];
  }

  /// Returns the full month name for the given month number (1-12).
  ///
  /// Example:
  /// ```dart
  /// getMonthName(1);  // Returns 'January'
  /// getMonthName(12); // Returns 'December'
  /// ```
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
      'December',
    ];
    return months[month - 1];
  }

  /// Formats a date as YYYY-MM-DD string.
  ///
  /// Example:
  /// ```dart
  /// formatDateString(DateTime(2024, 11, 26)); // Returns '2024-11-26'
  /// ```
  static String formatDateString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Formats a date as a display string.
  ///
  /// Example:
  /// ```dart
  /// formatDisplayDate(DateTime(2024, 11, 26)); // Returns '26 November 2024'
  /// ```
  static String formatDisplayDate(DateTime date) {
    return '${date.day} ${getMonthName(date.month)} ${date.year}';
  }

  /// Returns the short weekday abbreviation for calendar headers.
  ///
  /// Example:
  /// ```dart
  /// getWeekdayShort(1); // Returns 'M'
  /// getWeekdayShort(7); // Returns 'S'
  /// ```
  static String getWeekdayShort(int weekday) {
    const weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return weekDays[weekday - 1];
  }
}
