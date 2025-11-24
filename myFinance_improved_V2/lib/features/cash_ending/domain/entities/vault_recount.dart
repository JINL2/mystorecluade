// lib/features/cash_ending/domain/entities/vault_recount.dart

import 'denomination.dart';

/// Domain entity representing a vault recount operation
///
/// Unlike VaultTransaction which represents Flow (debit/credit),
/// VaultRecount represents Stock (actual quantity on hand).
///
/// The system will:
/// 1. Calculate previous stock from flow: SUM(debit) - SUM(credit)
/// 2. Compare with actual stock from recount
/// 3. Generate adjustment transactions (flow) for the difference
class VaultRecount {
  final String companyId;
  final String? storeId;
  final String locationId;
  final String currencyId;
  final String userId;
  final DateTime recordDate;
  final DateTime createdAt;
  final List<Denomination> denominations; // Actual quantities counted

  VaultRecount({
    required this.companyId,
    this.storeId,
    required this.locationId,
    required this.currencyId,
    required this.userId,
    required this.recordDate,
    required this.createdAt,
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

  /// Check if recount has data
  bool get hasData {
    return denominations.any((denom) => denom.quantity > 0);
  }

  /// Get only denominations with quantity > 0
  ///
  /// Business Rule: Only count denominations that exist
  /// This optimizes RPC processing
  List<Denomination> get activeDenominations {
    return denominations.where((denom) => denom.quantity > 0).toList();
  }

  /// Create a copy with updated fields
  VaultRecount copyWith({
    String? companyId,
    String? storeId,
    String? locationId,
    String? currencyId,
    String? userId,
    DateTime? recordDate,
    DateTime? createdAt,
    List<Denomination>? denominations,
  }) {
    return VaultRecount(
      companyId: companyId ?? this.companyId,
      storeId: storeId ?? this.storeId,
      locationId: locationId ?? this.locationId,
      currencyId: currencyId ?? this.currencyId,
      userId: userId ?? this.userId,
      recordDate: recordDate ?? this.recordDate,
      createdAt: createdAt ?? this.createdAt,
      denominations: denominations ?? this.denominations,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VaultRecount &&
        other.companyId == companyId &&
        other.locationId == locationId &&
        other.currencyId == currencyId &&
        other.recordDate == recordDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      companyId,
      locationId,
      currencyId,
      recordDate,
    );
  }
}
