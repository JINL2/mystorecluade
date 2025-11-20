/// Extension methods for Transaction entities.
///
/// Provides utility methods for transaction date formatting and grouping.
library;

extension TransactionDateExtension on DateTime {
  /// Converts DateTime to a standardized date key for grouping
  /// Format: YYYY-MM-DD (e.g., "2025-01-13")
  ///
  /// This is used to group transactions by date consistently across the app
  String toDateKey() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}
