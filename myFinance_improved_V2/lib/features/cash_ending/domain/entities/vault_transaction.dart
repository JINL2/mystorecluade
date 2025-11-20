// lib/features/cash_ending/domain/entities/vault_transaction.dart

import 'denomination.dart';

/// Domain entity representing a vault transaction
///
/// This represents a single vault deposit (credit) or withdrawal (debit)
/// following the same pattern as CashEnding entity
class VaultTransaction {
  final String? transactionId; // null for new records
  final String companyId;
  final String? storeId;
  final String locationId;
  final String currencyId;
  final String userId;
  final DateTime recordDate;
  final DateTime createdAt;
  final bool isCredit; // true for deposit (credit), false for withdrawal (debit)
  final List<Denomination> denominations; // Denominations with quantities

  VaultTransaction({
    this.transactionId,
    required this.companyId,
    this.storeId,
    required this.locationId,
    required this.currencyId,
    required this.userId,
    required this.recordDate,
    required this.createdAt,
    required this.isCredit,
    required this.denominations,
  }) {
    // Simple validation
    if (companyId.isEmpty) {
      throw ArgumentError('Company ID cannot be empty');
    }
    if (locationId.isEmpty) {
      throw ArgumentError('Location ID cannot be empty');
    }
    if (currencyId.isEmpty) {
      throw ArgumentError('Currency ID cannot be empty');
    }
    if (userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }
  }

  /// Check if this is for headquarter location
  bool get isHeadquarter => storeId == null || storeId == 'headquarter';

  /// Calculate total amount from denominations
  double get totalAmount {
    return denominations.fold(
      0.0,
      (sum, denom) => sum + (denom.value * denom.quantity),
    );
  }

  /// Check if transaction has data
  bool get hasData {
    return denominations.any((denom) => denom.quantity > 0);
  }

  /// Transaction type as string
  String get transactionType => isCredit ? 'credit' : 'debit';

  /// Create a copy with updated fields
  VaultTransaction copyWith({
    String? transactionId,
    String? companyId,
    String? storeId,
    String? locationId,
    String? currencyId,
    String? userId,
    DateTime? recordDate,
    DateTime? createdAt,
    bool? isCredit,
    List<Denomination>? denominations,
  }) {
    return VaultTransaction(
      transactionId: transactionId ?? this.transactionId,
      companyId: companyId ?? this.companyId,
      storeId: storeId ?? this.storeId,
      locationId: locationId ?? this.locationId,
      currencyId: currencyId ?? this.currencyId,
      userId: userId ?? this.userId,
      recordDate: recordDate ?? this.recordDate,
      createdAt: createdAt ?? this.createdAt,
      isCredit: isCredit ?? this.isCredit,
      denominations: denominations ?? this.denominations,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VaultTransaction &&
        other.transactionId == transactionId &&
        other.companyId == companyId &&
        other.locationId == locationId &&
        other.currencyId == currencyId &&
        other.recordDate == recordDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      transactionId,
      companyId,
      locationId,
      currencyId,
      recordDate,
    );
  }
}
