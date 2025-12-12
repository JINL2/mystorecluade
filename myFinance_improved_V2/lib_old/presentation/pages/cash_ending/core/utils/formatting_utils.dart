import 'package:intl/intl.dart';

/// Formatting utility functions for Cash Ending page
/// FROM PRODUCTION LINES 4707-4725
class FormattingUtils {
  
  /// Format currency amount with symbol
  /// FROM PRODUCTION LINES 4707-4711
  static String formatCurrency(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    return '$symbol${formatter.format(amount.abs().round())}';
  }
  
  /// Format transaction amount with +/- prefix
  /// FROM PRODUCTION LINES 4713-4719
  static String formatTransactionAmount(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    final isIncome = amount > 0;
    final prefix = isIncome ? '+$symbol' : '-$symbol';
    return '$prefix${formatter.format(amount.abs().round())}';
  }
  
  /// Format balance amount
  /// FROM PRODUCTION LINES 4721-4725
  static String formatBalance(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    return '$symbol${formatter.format(amount.round())}';
  }
}