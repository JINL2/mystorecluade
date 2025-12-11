import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';

/// Helper class for payment method page utilities
class PaymentHelpers {
  PaymentHelpers._();

  /// Format number with comma separators
  static String formatNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Get icon widget for cash location type
  static Widget getCashLocationIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type.toLowerCase()) {
      case 'bank':
        iconData = Icons.account_balance;
        iconColor = TossColors.primary;
        break;
      case 'cash':
      default:
        iconData = Icons.payments;
        iconColor = TossColors.success;
        break;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: TossSpacing.iconSM,
    );
  }

  /// Convert amount to selected currency using exchange rate
  static double convertToSelectedCurrency(
    double baseAmount,
    String targetCurrencyCode,
    Map<String, dynamic>? exchangeRateData,
  ) {
    if (exchangeRateData == null) return baseAmount;

    final exchangeRates =
        exchangeRateData['exchange_rates'] as List<Map<String, dynamic>>? ?? [];

    // Find the exchange rate for target currency
    double rate = 1.0;
    for (final rateData in exchangeRates) {
      if (rateData['currency_code'] == targetCurrencyCode) {
        rate = (rateData['rate'] as num?)?.toDouble() ?? 1.0;
        break;
      }
    }

    // Convert from base to target currency
    return baseAmount / rate;
  }
}
