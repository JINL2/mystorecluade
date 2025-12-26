// Domain Entity - Cash Real Entry Business Object
// Note: JSON serialization is handled by data/models layer

import 'package:freezed_annotation/freezed_annotation.dart';

import 'bank_real_entry.dart';

part 'cash_real_entry.freezed.dart';

@freezed
class CashRealEntry with _$CashRealEntry {
  const CashRealEntry._();

  const factory CashRealEntry({
    required String createdAt,
    required String recordDate,
    required String locationId,
    required String locationName,
    required String locationType,
    required double totalAmount,
    required List<CurrencySummary> currencySummary,
  }) = _CashRealEntry;

  // Business logic: Get currency symbol (no formatting)
  String getCurrencySymbol() {
    if (currencySummary.isNotEmpty) {
      return currencySummary.first.symbol;
    }
    return '';
  }

  String getTransactionType() {
    if (totalAmount == 0) {
      return 'Error';
    } else if (totalAmount < 0) {
      return 'Shortage';
    } else {
      return 'Cash';
    }
  }
}
