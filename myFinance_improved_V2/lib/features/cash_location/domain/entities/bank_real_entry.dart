// Domain Entity - Bank Real Entry Business Object

import '../../../../core/utils/datetime_utils.dart';

class BankRealEntry {
  final String createdAt;
  final String recordDate;
  final String locationId;
  final String locationName;
  final double totalAmount;
  final List<CurrencySummary> currencySummary;

  const BankRealEntry({
    required this.createdAt,
    required this.recordDate,
    required this.locationId,
    required this.locationName,
    required this.totalAmount,
    required this.currencySummary,
  });

  // Business logic methods
  String getFormattedTime() {
    try {
      // Parse timestamp as UTC (DB stores without timezone info but it's UTC)
      // Example: "2025-10-27 17:54:41.715" should be treated as UTC
      final utcDateTime = DateTime.parse('${createdAt}Z'); // Add Z to force UTC parsing
      final localDateTime = utcDateTime.toLocal();
      return DateTimeUtils.formatTimeOnly(localDateTime);
    } catch (e) {
      // Fallback: try parsing with toLocal if Z format fails
      try {
        final localDateTime = DateTimeUtils.toLocal(createdAt);
        return DateTimeUtils.formatTimeOnly(localDateTime);
      } catch (e2) {
        return '';
      }
    }
  }

  String getCurrencySymbol() {
    if (currencySummary.isNotEmpty) {
      return currencySummary.first.symbol;
    }
    return '';
  }

  // Convenience getters for backward compatibility
  String get symbol => getCurrencySymbol();

  String get currencyCode {
    if (currencySummary.isNotEmpty) {
      return currencySummary.first.currencyCode;
    }
    return '';
  }

  String getTransactionType() {
    if (totalAmount == 0) {
      return 'Error';
    } else if (totalAmount < 0) {
      return 'Withdrawal';
    } else {
      return 'Deposit';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankRealEntry &&
          runtimeType == other.runtimeType &&
          createdAt == other.createdAt &&
          locationId == other.locationId;

  @override
  int get hashCode => createdAt.hashCode ^ locationId.hashCode;
}

// Re-use CurrencySummary and Denomination from cash_real_entry.dart
// Or create separate file for shared value objects
class CurrencySummary {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final double totalValue;
  final List<Denomination> denominations;

  const CurrencySummary({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.totalValue,
    required this.denominations,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencySummary &&
          runtimeType == other.runtimeType &&
          currencyId == other.currencyId;

  @override
  int get hashCode => currencyId.hashCode;
}

class Denomination {
  final String denominationId;
  final String denominationType;
  final double denominationValue;
  final int quantity;
  final double subtotal;

  const Denomination({
    required this.denominationId,
    required this.denominationType,
    required this.denominationValue,
    required this.quantity,
    required this.subtotal,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Denomination &&
          runtimeType == other.runtimeType &&
          denominationId == other.denominationId;

  @override
  int get hashCode => denominationId.hashCode;
}
