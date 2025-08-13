import 'package:intl/intl.dart';

class SalaryFormatter {
  static String formatAmount(double amount, String currencySymbol, {int? decimalPlaces}) {
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimalPlaces ?? 2,
    );
    
    return '${formatter.format(amount)}$currencySymbol';
  }
  
  static String formatAmountWithCommas(double amount) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }
  
  static String getSalaryTypeDisplay(String type) {
    switch (type.toLowerCase()) {
      case 'monthly':
        return 'Monthly';
      case 'hourly':
        return 'Hourly';
      default:
        return type;
    }
  }
  
  static String formatSalaryPeriod(double amount, String type, String symbol) {
    final formattedAmount = formatAmountWithCommas(amount);
    final period = type.toLowerCase() == 'hourly' ? '/hr' : '/mo';
    return '$formattedAmount$symbol$period';
  }
}