// lib/features/cash_location/domain/entities/currency_type.dart

/// Domain entity for currency types
class CurrencyType {
  final String? currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final int decimalPlaces;
  final bool isActive;

  const CurrencyType({
    this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    this.decimalPlaces = 2,
    this.isActive = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyType &&
          runtimeType == other.runtimeType &&
          currencyId == other.currencyId;

  @override
  int get hashCode => currencyId.hashCode;
}
