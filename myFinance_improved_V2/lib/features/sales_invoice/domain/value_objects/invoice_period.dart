/// Invoice period filter enum
/// Note: displayName is in presentation/extensions/invoice_period_extension.dart
enum InvoicePeriod {
  today,
  thisWeek,
  thisMonth,
  lastMonth,
  allTime;

  /// Get date range for this period (business logic)
  DateRange getDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final startOfToday = DateTime(now.year, now.month, now.day, 0, 0, 0);

    switch (this) {
      case InvoicePeriod.today:
        return DateRange(startDate: startOfToday, endDate: today);
      case InvoicePeriod.thisWeek:
        // Monday = 1, Sunday = 7
        // weekStart: Go back to Monday of this week
        final weekStart = startOfToday.subtract(Duration(days: startOfToday.weekday - 1));
        // weekEnd: Go forward to Sunday of this week
        final weekEnd = weekStart.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        return DateRange(startDate: weekStart, endDate: weekEnd);
      case InvoicePeriod.thisMonth:
        final monthStart = DateTime(now.year, now.month, 1, 0, 0, 0);
        final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return DateRange(startDate: monthStart, endDate: monthEnd);
      case InvoicePeriod.lastMonth:
        final lastMonthStart = DateTime(now.year, now.month - 1, 1, 0, 0, 0);
        final lastMonthEnd = DateTime(now.year, now.month, 0, 23, 59, 59);
        return DateRange(startDate: lastMonthStart, endDate: lastMonthEnd);
      case InvoicePeriod.allTime:
        return const DateRange(startDate: null, endDate: null);
    }
  }
}

/// Date range value object
class DateRange {
  final DateTime? startDate;
  final DateTime? endDate;

  const DateRange({
    this.startDate,
    this.endDate,
  });
}
