import 'package:intl/intl.dart';

/// Number formatting utility for consistent currency and number display
///
/// Uses cached NumberFormat instances for better performance.
/// Avoids creating new formatter instances on every call.
class NumberFormatter {
  // Cached formatters for better performance
  static final NumberFormat _intFormatter = NumberFormat('#,###');
  static final NumberFormat _decimalFormatter = NumberFormat('#,##0.00', 'en_US');

  /// Formats a number with thousands separators (commas)
  /// Example: 9000000 → "9,000,000"
  static String formatWithCommas(num value) {
    return _intFormatter.format(value);
  }

  /// Formats currency with symbol and commas
  /// Example: formatCurrency(9000000, "₫") → "₫9,000,000"
  static String formatCurrency(num value, String symbol) {
    return '$symbol${_intFormatter.format(value)}';
  }

  /// Formats decimal currency with commas (preserves decimal places)
  /// Example: formatCurrencyDecimal(9000000.50, "₫") → "₫9,000,000.50"
  ///
  /// Note: Uses cached formatter for default 2 decimal places.
  /// Custom decimal places will create new formatter instance.
  static String formatCurrencyDecimal(num value, String symbol, {int decimalPlaces = 2}) {
    if (decimalPlaces == 2) {
      return '$symbol${_decimalFormatter.format(value)}';
    }
    // Fallback for non-standard decimal places
    final formatter = NumberFormat('#,###.${'0' * decimalPlaces}');
    return '$symbol${formatter.format(value)}';
  }

  /// Formats integer currency (no decimal places)
  /// Example: formatCurrencyInt(9000000, "₫") → "₫9,000,000"
  static String formatCurrencyInt(num value, String symbol) {
    return '$symbol${_intFormatter.format(value.round())}';
  }

  /// Formats number in compact form (K, M, B)
  /// Example: formatCompact(1500) → "1.5K"
  /// Example: formatCompact(1500000) → "1.5M"
  /// Example: formatCompact(1500000000) → "1.5B"
  static String formatCompact(num value) {
    if (value.abs() >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  /// Direct access to cached decimal formatter for external use
  static NumberFormat get decimalFormatter => _decimalFormatter;
}