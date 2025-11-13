// Domain Entity - Cash Real Entry Business Object

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/datetime_utils.dart';
import 'bank_real_entry.dart';

part 'cash_real_entry.freezed.dart';
part 'cash_real_entry.g.dart';

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

  String getTransactionType() {
    if (totalAmount == 0) {
      return 'Error';
    } else if (totalAmount < 0) {
      return 'Shortage';
    } else {
      return 'Cash';
    }
  }

  factory CashRealEntry.fromJson(Map<String, dynamic> json) =>
      _$CashRealEntryFromJson(json);
}
