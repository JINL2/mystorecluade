/// Invoice period filter enum
enum InvoicePeriod {
  today,
  thisWeek,
  thisMonth,
  lastMonth,
  allTime;

  String get displayName {
    switch (this) {
      case InvoicePeriod.today:
        return 'Today';
      case InvoicePeriod.thisWeek:
        return 'This week';
      case InvoicePeriod.thisMonth:
        return 'This month';
      case InvoicePeriod.lastMonth:
        return 'Last month';
      case InvoicePeriod.allTime:
        return 'All time';
    }
  }

  DateRange getDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final startOfToday = DateTime(now.year, now.month, now.day, 0, 0, 0);

    switch (this) {
      case InvoicePeriod.today:
        return DateRange(startDate: startOfToday, endDate: today);
      case InvoicePeriod.thisWeek:
        final weekStart = startOfToday.subtract(Duration(days: startOfToday.weekday - 1));
        return DateRange(startDate: weekStart, endDate: today);
      case InvoicePeriod.thisMonth:
        final monthStart = DateTime(now.year, now.month, 1, 0, 0, 0);
        final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return DateRange(startDate: monthStart, endDate: monthEnd);
      case InvoicePeriod.lastMonth:
        final lastMonthStart = DateTime(now.year, now.month - 1, 1, 0, 0, 0);
        final lastMonthEnd = DateTime(now.year, now.month, 0, 23, 59, 59);
        return DateRange(startDate: lastMonthStart, endDate: lastMonthEnd);
      case InvoicePeriod.allTime:
        return DateRange(startDate: null, endDate: null);
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
