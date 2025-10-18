/// Currency value object
///
/// Represents a monetary currency (e.g., USD, EUR, KRW).
/// This is a read-only reference data that comes from the database.
class Currency {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;

  const Currency({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      currencyId: json['currency_id'] as String,
      currencyCode: json['currency_code'] as String,
      currencyName: json['currency_name'] as String,
      symbol: json['symbol'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency_id': currencyId,
      'currency_code': currencyCode,
      'currency_name': currencyName,
      'symbol': symbol,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Currency && other.currencyId == currencyId;
  }

  @override
  int get hashCode => currencyId.hashCode;

  @override
  String toString() => 'Currency(code: $currencyCode, symbol: $symbol)';
}
