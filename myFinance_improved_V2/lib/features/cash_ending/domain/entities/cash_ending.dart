// lib/features/cash_ending/domain/entities/cash_ending.dart

import 'currency.dart';

/// Domain entity representing a cash ending record
/// This is the aggregate root for the cash ending feature
class CashEnding {
  final String? cashEndingId; // null for new records
  final String companyId;
  final String userId;
  final String locationId;
  final String? storeId;
  final DateTime recordDate;
  final DateTime createdAt;
  final List<Currency> currencies;

  CashEnding({
    this.cashEndingId,
    required this.companyId,
    required this.userId,
    required this.locationId,
    this.storeId,
    required this.recordDate,
    required this.createdAt,
    required this.currencies,
  }) {
    // Simple validation
    if (companyId.isEmpty) {
      throw ArgumentError('Company ID cannot be empty');
    }
    if (userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }
    if (locationId.isEmpty) {
      throw ArgumentError('Location ID cannot be empty');
    }
  }

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

  /// Create a copy with updated fields
  CashEnding copyWith({
    String? cashEndingId,
    String? companyId,
    String? userId,
    String? locationId,
    String? storeId,
    DateTime? recordDate,
    DateTime? createdAt,
    List<Currency>? currencies,
  }) {
    return CashEnding(
      cashEndingId: cashEndingId ?? this.cashEndingId,
      companyId: companyId ?? this.companyId,
      userId: userId ?? this.userId,
      locationId: locationId ?? this.locationId,
      storeId: storeId ?? this.storeId,
      recordDate: recordDate ?? this.recordDate,
      createdAt: createdAt ?? this.createdAt,
      currencies: currencies ?? this.currencies,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CashEnding &&
        other.cashEndingId == cashEndingId &&
        other.companyId == companyId &&
        other.userId == userId &&
        other.locationId == locationId &&
        other.storeId == storeId &&
        other.recordDate == recordDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      cashEndingId,
      companyId,
      userId,
      locationId,
      storeId,
      recordDate,
    );
  }
}
