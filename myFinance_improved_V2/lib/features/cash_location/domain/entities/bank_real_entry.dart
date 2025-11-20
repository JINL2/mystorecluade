// Domain Entity - Bank Real Entry Business Object

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/datetime_utils.dart';

part 'bank_real_entry.freezed.dart';
part 'bank_real_entry.g.dart';

@freezed
class BankRealEntry with _$BankRealEntry {
  const BankRealEntry._();

  const factory BankRealEntry({
    required String createdAt,
    required String recordDate,
    required String locationId,
    required String locationName,
    required double totalAmount,
    required List<CurrencySummary> currencySummary,
  }) = _BankRealEntry;

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

  factory BankRealEntry.fromJson(Map<String, dynamic> json) =>
      _$BankRealEntryFromJson(json);
}

@freezed
class CurrencySummary with _$CurrencySummary {
  const factory CurrencySummary({
    required String currencyId,
    required String currencyCode,
    required String currencyName,
    required String symbol,
    required double totalValue,
    required List<Denomination> denominations,
  }) = _CurrencySummary;

  factory CurrencySummary.fromJson(Map<String, dynamic> json) =>
      _$CurrencySummaryFromJson(json);
}

@freezed
class Denomination with _$Denomination {
  const factory Denomination({
    required String denominationId,
    required String denominationType,
    required double denominationValue,
    required int quantity,
    required double subtotal,
  }) = _Denomination;

  factory Denomination.fromJson(Map<String, dynamic> json) =>
      _$DenominationFromJson(json);
}
