// lib/features/cash_ending/domain/entities/bank_balance.dart

/// Domain entity representing a bank balance record
///
/// This represents a single bank account balance entry
/// following the same pattern as CashEnding entity
class BankBalance {
  final String? balanceId; // null for new records
  final String companyId;
  final String? storeId;
  final String locationId;
  final String currencyId;
  final int totalAmount;
  final String userId;
  final DateTime recordDate;
  final DateTime createdAt;

  BankBalance({
    this.balanceId,
    required this.companyId,
    this.storeId,
    required this.locationId,
    required this.currencyId,
    required this.totalAmount,
    required this.userId,
    required this.recordDate,
    required this.createdAt,
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

  /// Check if amount is valid (non-negative)
  bool get isValidAmount => totalAmount >= 0;

  /// Create a copy with updated fields
  BankBalance copyWith({
    String? balanceId,
    String? companyId,
    String? storeId,
    String? locationId,
    String? currencyId,
    int? totalAmount,
    String? userId,
    DateTime? recordDate,
    DateTime? createdAt,
  }) {
    return BankBalance(
      balanceId: balanceId ?? this.balanceId,
      companyId: companyId ?? this.companyId,
      storeId: storeId ?? this.storeId,
      locationId: locationId ?? this.locationId,
      currencyId: currencyId ?? this.currencyId,
      totalAmount: totalAmount ?? this.totalAmount,
      userId: userId ?? this.userId,
      recordDate: recordDate ?? this.recordDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BankBalance &&
        other.balanceId == balanceId &&
        other.companyId == companyId &&
        other.locationId == locationId &&
        other.currencyId == currencyId &&
        other.recordDate == recordDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      balanceId,
      companyId,
      locationId,
      currencyId,
      recordDate,
    );
  }
}
