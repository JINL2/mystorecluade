/// Domain Entity: Currency Type
///
/// Pure business object representing a currency type in the system.
class CurrencyType {
  final String? currencyId; // UUID primary key from Supabase
  final String currencyCode; // Currency code like VND, USD
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
  String toString() {
    return 'CurrencyType{currencyCode: $currencyCode, currencyName: $currencyName, symbol: $symbol}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyType &&
          runtimeType == other.runtimeType &&
          currencyCode == other.currencyCode;

  @override
  int get hashCode => currencyCode.hashCode;
}
