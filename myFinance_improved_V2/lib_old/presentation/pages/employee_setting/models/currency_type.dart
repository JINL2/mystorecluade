class CurrencyType {
  final String? currencyId; // UUID primary key from Supabase
  final String currencyCode; // Currency code like VND, USD
  final String currencyName;
  final String symbol;
  final int decimalPlaces;
  final bool isActive;

  CurrencyType({
    this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    this.decimalPlaces = 2,
    this.isActive = true,
  });

  factory CurrencyType.fromJson(Map<String, dynamic> json) {
    return CurrencyType(
      currencyId: json['currency_id'] as String?, // UUID primary key
      currencyCode: json['currency_code'] as String,
      currencyName: json['currency_name'] as String,
      symbol: json['symbol'] as String,
      decimalPlaces: json['decimal_places'] as int? ?? 2,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency_id': currencyId,
      'currency_code': currencyCode,
      'currency_name': currencyName,
      'symbol': symbol,
      'decimal_places': decimalPlaces,
      'is_active': isActive,
    };
  }
}