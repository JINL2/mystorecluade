// lib/features/cash_ending/domain/entities/bank_balance.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import 'currency.dart';

part 'bank_balance.freezed.dart';

/// Domain entity representing a bank balance record (Multi-Currency)
///
/// Supports multiple currencies for a single bank location
/// Uses Currency entity (but bank doesn't use denominations, only total_amount)
@freezed
class BankBalance with _$BankBalance {
  const factory BankBalance({
    String? balanceId, // null for new records
    required String companyId,
    String? storeId,
    required String locationId,
    required String userId,
    required DateTime recordDate,
    required DateTime createdAt,
    required List<Currency> currencies, // Each currency with totalAmount (no denominations used)
  }) = _BankBalance;

  const BankBalance._();

  /// Check if this is for headquarter location
  bool get isHeadquarter => storeId == null || storeId == 'headquarter';

  /// Calculate total amount across all currencies
  double get totalAmount {
    return currencies.fold(
      0.0,
      (sum, currency) => sum + currency.totalAmount,
    );
  }

  /// Check if balance has data
  bool get hasData {
    return currencies.any((currency) => currency.totalAmount > 0);
  }
}
