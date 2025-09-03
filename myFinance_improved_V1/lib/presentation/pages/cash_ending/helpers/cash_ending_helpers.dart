import 'package:intl/intl.dart';

/// Helper class for cash ending calculations and utilities
class CashEndingHelpers {
  /// Format number with thousands separator
  static String formatNumber(dynamic value) {
    if (value == null) return '0';
    final number = value is String ? double.tryParse(value) ?? 0 : value.toDouble();
    return NumberFormat('#,##0').format(number);
  }

  /// Format currency with symbol
  static String formatCurrency(double amount, String symbol) {
    return '$symbol ${formatNumber(amount)}';
  }

  /// Calculate total from denomination quantities
  static double calculateDenominationTotal(
    String quantity,
    double denominationValue,
  ) {
    final qty = int.tryParse(quantity) ?? 0;
    return qty * denominationValue;
  }

  /// Calculate grand total from all denominations
  static double calculateGrandTotal(
    Map<String, Map<String, dynamic>> denominationData,
  ) {
    double total = 0;
    denominationData.forEach((currencyId, data) {
      final denominations = data['denominations'] as List<Map<String, dynamic>>? ?? [];
      final controllers = data['controllers'] as Map<String, dynamic>? ?? {};
      
      for (final denom in denominations) {
        final controller = controllers[denom['id']];
        if (controller != null) {
          final value = double.tryParse(denom['value']?.toString() ?? '0') ?? 0;
          total += calculateDenominationTotal(controller.text, value);
        }
      }
    });
    return total;
  }

  /// Parse amount from formatted string
  static double parseFormattedAmount(String formattedAmount) {
    // Remove all non-numeric characters except decimal point
    final cleanedAmount = formattedAmount.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleanedAmount) ?? 0;
  }

  /// Format date for display
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }

  /// Format relative time
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return formatDate(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Validate if amount is valid
  static bool isValidAmount(String amount) {
    if (amount.isEmpty) return false;
    final parsed = double.tryParse(amount.replaceAll(',', ''));
    return parsed != null && parsed > 0;
  }

  /// Get currency symbol from currency data
  static String getCurrencySymbol(
    List<Map<String, dynamic>> currencyTypes,
    String? currencyId,
  ) {
    if (currencyId == null) return '\$';
    
    final currency = currencyTypes.firstWhere(
      (c) => c['id'] == currencyId,
      orElse: () => {'symbol': '\$'},
    );
    
    return currency['symbol'] ?? '\$';
  }

  /// Get currency code from currency data
  static String getCurrencyCode(
    List<Map<String, dynamic>> currencyTypes,
    String? currencyId,
  ) {
    if (currencyId == null) return 'USD';
    
    final currency = currencyTypes.firstWhere(
      (c) => c['id'] == currencyId,
      orElse: () => {'currency_code': 'USD'},
    );
    
    return currency['currency_code'] ?? 'USD';
  }

  /// Check if user has permission for vault/bank operations
  static bool hasVaultBankPermission(Map<String, dynamic> userData) {
    final companyData = userData['company_users'] as List<dynamic>?;
    if (companyData == null || companyData.isEmpty) return false;
    
    final firstCompanyUser = companyData.first as Map<String, dynamic>;
    final role = firstCompanyUser['user_role'] as String?;
    
    return role == 'owner' || role == 'manager';
  }

  /// Validate selection completeness
  static bool isSelectionComplete({
    required String? storeId,
    required String? locationId,
    required String? currencyId,
  }) {
    return storeId != null && locationId != null && currencyId != null;
  }

  /// Clear denomination controllers
  static void clearDenominationControllers(
    Map<String, Map<String, dynamic>> controllers,
  ) {
    controllers.forEach((_, data) {
      final ctrlMap = data['controllers'] as Map<String, dynamic>?;
      ctrlMap?.forEach((_, controller) {
        if (controller != null) {
          controller.clear();
        }
      });
    });
  }

  /// Calculate transaction type color
  static String getTransactionTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'debit':
        return 'error';
      case 'credit':
        return 'success';
      default:
        return 'primary';
    }
  }
}
