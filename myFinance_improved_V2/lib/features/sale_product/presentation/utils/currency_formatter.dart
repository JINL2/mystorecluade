import 'package:intl/intl.dart';

/// Currency formatter utility - reusable NumberFormat instance
///
/// Prevents creating new NumberFormat objects on every widget build
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Shared instance for currency formatting
  /// Format: #,##0 (e.g., 1,000)
  static final NumberFormat currency = NumberFormat('#,##0', 'en_US');
}
