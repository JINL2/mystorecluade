/// Stats Format Helpers
///
/// Utility functions for formatting stats display values.
class StatsFormatHelpers {
  StatsFormatHelpers._();

  /// Format change value with + or - prefix
  static String formatChange(int change) {
    if (change == 0) return '0';
    return change > 0 ? '+$change' : '$change';
  }

  /// Format overtime hours
  static String formatOvertimeHours(double hours) {
    if (hours == 0) return '0h';
    return '${hours.toStringAsFixed(1)}h';
  }

  /// Format overtime change
  static String formatOvertimeChange(double change) {
    if (change == 0) return '0h';
    final prefix = change > 0 ? '+' : '';
    return '$prefix${change.toStringAsFixed(1)}h';
  }

  /// Get current month key in "yyyy-MM" format for data lookup
  static String getCurrentMonthKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }
}
