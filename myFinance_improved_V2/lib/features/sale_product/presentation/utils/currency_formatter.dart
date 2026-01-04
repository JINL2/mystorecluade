import 'package:intl/intl.dart';

/// Currency formatter utility - reusable NumberFormat instance
///
/// Prevents creating new NumberFormat objects on every widget build
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Shared instance for currency formatting (integer only)
  /// Format: #,##0 (e.g., 1,000)
  static final NumberFormat currency = NumberFormat('#,##0', 'en_US');

  /// Shared instance for currency formatting with decimals
  /// Format: #,##0.00 (e.g., 1,000.50)
  static final NumberFormat currencyWithDecimals =
      NumberFormat('#,##0.00', 'en_US');

  /// Smart price formatting - shows decimals only when needed
  /// - If value has decimal part: shows up to 2 decimal places (e.g., 1,000.50)
  /// - If value is whole number: shows no decimals (e.g., 1,000)
  static String formatPrice(double value) {
    if (value == value.roundToDouble()) {
      // Whole number - no decimals
      return currency.format(value.toInt());
    } else {
      // Has decimal part - show up to 2 decimal places
      return currencyWithDecimals.format(value);
    }
  }
}
