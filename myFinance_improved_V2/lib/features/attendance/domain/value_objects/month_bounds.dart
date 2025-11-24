/// Value Object representing the first and last day of a month
/// Encapsulates month boundary calculations
class MonthBounds {
  final DateTime firstDay;
  final DateTime lastDay;

  MonthBounds._({
    required this.firstDay,
    required this.lastDay,
  });

  /// Create MonthBounds for a specific month
  /// Input: any DateTime in the target month
  /// Output: MonthBounds with first and last day of that month
  factory MonthBounds.fromDate(DateTime date) {
    // First day: year-month-01 at 00:00:00
    final firstDay = DateTime(date.year, date.month, 1);

    // Last day: next month's first day minus 1 day
    final lastDay = DateTime(date.year, date.month + 1, 0);

    return MonthBounds._(
      firstDay: firstDay,
      lastDay: lastDay,
    );
  }

  /// Get month key in yyyy-MM format for caching/comparison
  String get monthKey {
    return '${firstDay.year}-${firstDay.month.toString().padLeft(2, '0')}';
  }

  /// Get last day formatted as yyyy-MM-dd for RPC calls
  /// RPC functions require the LAST day of the month as p_request_date
  ///
  /// ⚠️ IMPORTANT: Converts to UTC before formatting
  /// Example: Local 2025-01-31 23:30 (Vietnam +7) → UTC 2025-02-01 16:30
  /// Result: "2025-02-01" (next day in UTC)
  String get lastDayFormatted {
    // Use last moment of the day (23:59:59) to check if date changes in UTC
    final lastMomentLocal = DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59);
    final lastMomentUtc = lastMomentLocal.toUtc();

    return '${lastMomentUtc.year}-${lastMomentUtc.month.toString().padLeft(2, '0')}-${lastMomentUtc.day.toString().padLeft(2, '0')}';
  }

  /// Get first day formatted as yyyy-MM-dd
  ///
  /// ⚠️ IMPORTANT: Converts to UTC before formatting
  /// Example: Local 2025-01-01 00:00:00 (Vietnam +7) → UTC 2024-12-31 17:00:00
  /// Result: "2024-12-31" (previous day in UTC)
  String get firstDayFormatted {
    // Use first moment of the day (00:00:00) to check if date changes in UTC
    final firstMomentLocal = DateTime(firstDay.year, firstDay.month, firstDay.day, 0, 0, 0);
    final firstMomentUtc = firstMomentLocal.toUtc();

    return '${firstMomentUtc.year}-${firstMomentUtc.month.toString().padLeft(2, '0')}-${firstMomentUtc.day.toString().padLeft(2, '0')}';
  }

  /// Get last moment of month as UTC timestamp for RPC calls (TIMESTAMPTZ)
  /// Returns: "yyyy-MM-dd HH:mm:ss" in UTC (without 'T' or 'Z')
  ///
  /// Example: Local 2025-01-31 23:59:59 (Vietnam +7) → "2025-02-01 16:59:59" (UTC)
  String get lastMomentUtcFormatted {
    final lastMomentLocal = DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59);
    final lastMomentUtc = lastMomentLocal.toUtc();

    return '${lastMomentUtc.year}-${lastMomentUtc.month.toString().padLeft(2, '0')}-${lastMomentUtc.day.toString().padLeft(2, '0')} '
           '${lastMomentUtc.hour.toString().padLeft(2, '0')}:${lastMomentUtc.minute.toString().padLeft(2, '0')}:${lastMomentUtc.second.toString().padLeft(2, '0')}';
  }

  /// Check if a date string belongs to this month
  /// Input: date string in yyyy-MM-dd format
  bool containsDate(String dateString) {
    return dateString.startsWith(monthKey);
  }

  @override
  String toString() {
    return 'MonthBounds($firstDayFormatted to $lastDayFormatted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonthBounds &&
        other.firstDay == firstDay &&
        other.lastDay == lastDay;
  }

  @override
  int get hashCode => firstDay.hashCode ^ lastDay.hashCode;
}
