// lib/features/cash_ending/domain/entities/cash_ending.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import 'currency.dart';

part 'cash_ending.freezed.dart';

/// Domain entity representing a cash ending record
/// This is the aggregate root for the cash ending feature
@freezed
class CashEnding with _$CashEnding {
  const factory CashEnding({
    String? cashEndingId, // null for new records
    required String companyId,
    required String userId,
    required String locationId,
    String? storeId,
    required DateTime recordDate,
    required DateTime createdAt,
    required List<Currency> currencies,
  }) = _CashEnding;

  const CashEnding._();

  /// Calculate grand total across all currencies
  double get grandTotal {
    return currencies.fold(
      0.0,
      (sum, currency) => sum + currency.totalAmount,
    );
  }

  /// Get only currencies that have data (denominations with quantities)
  List<Currency> get activeCurrencies {
    return currencies.where((currency) => currency.hasData).toList();
  }

  /// Check if this cash ending has any data
  bool get hasData {
    return currencies.any((currency) => currency.hasData);
  }

  /// Check if this is for headquarter location
  bool get isHeadquarter => storeId == null || storeId == 'headquarter';
}
