// lib/features/cash_ending/domain/entities/vault_transaction.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import 'currency.dart';

part 'vault_transaction.freezed.dart';

/// Domain entity representing a vault transaction (Multi-Currency)
///
/// Supports IN (debit), OUT (credit), and RECOUNT transactions
/// with multiple currencies in a single transaction
@freezed
class VaultTransaction with _$VaultTransaction {
  const factory VaultTransaction({
    String? transactionId, // null for new records
    required String companyId,
    String? storeId,
    required String locationId,
    required String userId,
    required DateTime recordDate,
    required DateTime createdAt,
    required bool isCredit, // true for OUT (credit), false for IN (debit)
    required List<Currency> currencies, // Multi-currency support
  }) = _VaultTransaction;

  const VaultTransaction._();

  /// Check if this is for headquarter location
  bool get isHeadquarter => storeId == null || storeId == 'headquarter';

  /// Calculate total amount across all currencies (in base currency after conversion)
  double get totalAmount {
    return currencies.fold(
      0.0,
      (sum, currency) => sum + currency.totalAmount,
    );
  }

  /// Check if transaction has data
  bool get hasData {
    return currencies.any((currency) => currency.hasData);
  }

  /// Transaction type as string
  String get transactionType => isCredit ? 'out' : 'in';
}
