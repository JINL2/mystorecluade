// Domain Entity - Vault Real Entry Business Object

import 'package:freezed_annotation/freezed_annotation.dart';

import 'bank_real_entry.dart';

part 'vault_real_entry.freezed.dart';
part 'vault_real_entry.g.dart';

@freezed
class VaultRealEntry with _$VaultRealEntry {
  const VaultRealEntry._();

  const factory VaultRealEntry({
    required String createdAt,
    required String recordDate,
    required String locationId,
    required String locationName,
    required double totalAmount,
    required List<CurrencySummary> currencySummary,
  }) = _VaultRealEntry;

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
      return 'Vault';
    }
  }

  factory VaultRealEntry.fromJson(Map<String, dynamic> json) =>
      _$VaultRealEntryFromJson(json);
}
