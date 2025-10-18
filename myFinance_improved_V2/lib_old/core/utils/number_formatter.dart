import 'package:intl/intl.dart';

/// Number formatting utility for consistent currency and number display
class NumberFormatter {
  /// Formats a number with thousands separators (commas)
  /// Example: 9000000 → "9,000,000"
  static String formatWithCommas(num value) {
    final formatter = NumberFormat('#,###');
    return formatter.format(value);
  }
  
  /// Formats currency with symbol and commas
  /// Example: formatCurrency(9000000, "₫") → "₫9,000,000"
  static String formatCurrency(num value, String symbol) {
    return '$symbol${formatWithCommas(value)}';
  }
  
  /// Formats decimal currency with commas (preserves decimal places)
  /// Example: formatCurrencyDecimal(9000000.50, "₫") → "₫9,000,000.50"
  static String formatCurrencyDecimal(num value, String symbol, {int decimalPlaces = 2}) {
    final formatter = NumberFormat('#,###.${'0' * decimalPlaces}');
    return '$symbol${formatter.format(value)}';
  }
  
  /// Formats integer currency (no decimal places)
  /// Example: formatCurrencyInt(9000000, "₫") → "₫9,000,000"
  static String formatCurrencyInt(num value, String symbol) {
    return formatCurrency(value.round(), symbol);
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
    } else {
      return value.toStringAsFixed(0);
    }
  }
}