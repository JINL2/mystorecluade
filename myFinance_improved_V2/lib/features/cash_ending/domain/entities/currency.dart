// lib/features/cash_ending/domain/entities/currency.dart

import 'denomination.dart';

/// Domain entity representing a currency
class Currency {
  final String currencyId;
  final String currencyCode; // e.g., 'KRW', 'USD', 'JPY'
  final String currencyName; // e.g., 'Korean Won'
  final String symbol; // e.g., '₩', '$', '¥'
  final List<Denomination> denominations;

  Currency({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    this.denominations = const [],
  }) {
    // Simple validation
    if (currencyCode.isEmpty) {
      throw ArgumentError('Currency code cannot be empty');
    }
  }

  /// Calculate total amount for all denominations in this currency
  double get totalAmount {
    return denominations.fold(
      0.0,
      (sum, denom) => sum + denom.totalAmount,
    );
  }

  /// Check if this currency has any denomination quantities entered
  bool get hasData {
    return denominations.any((denom) => denom.hasQuantity);
  }

  /// Get only denominations that have quantity > 0
  List<Denomination> get activeDenominations {
    return denominations.where((denom) => denom.hasQuantity).toList();
  }

  /// Create a copy with updated fields
  Currency copyWith({
    String? currencyId,
    String? currencyCode,
    String? currencyName,
    String? symbol,
    List<Denomination>? denominations,
  }) {
    return Currency(
      currencyId: currencyId ?? this.currencyId,
      currencyCode: currencyCode ?? this.currencyCode,
      currencyName: currencyName ?? this.currencyName,
      symbol: symbol ?? this.symbol,
      denominations: denominations ?? this.denominations,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Currency &&
        other.currencyId == currencyId &&
        other.currencyCode == currencyCode &&
        other.currencyName == currencyName &&
        other.symbol == symbol;
  }

  @override
  int get hashCode {
    return Object.hash(
      currencyId,
      currencyCode,
      currencyName,
      symbol,
    );
  }
}
