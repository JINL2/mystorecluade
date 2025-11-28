import '../../domain/entities/base_currency.dart';

/// Base Currency Model - Data layer model for get_base_currency RPC
///
/// Handles JSON parsing from the RPC response structure:
/// ```json
/// {
///   "base_currency": {
///     "currency_id": "...",
///     "currency_code": "VND",
///     "currency_name": "Vietnamese Dong",
///     "symbol": "₫",
///     "flag_emoji": "🇻🇳"
///   },
///   "company_currencies": [...]
/// }
/// ```
class BaseCurrencyModel {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final String? flagEmoji;

  BaseCurrencyModel({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    this.flagEmoji,
  });

  /// Parse from RPC response (extracts base_currency from full response)
  factory BaseCurrencyModel.fromRpcResponse(Map<String, dynamic> json) {
    final baseCurrency = json['base_currency'] as Map<String, dynamic>? ?? {};
    return BaseCurrencyModel.fromJson(baseCurrency);
  }

  /// Parse from base_currency JSON object
  factory BaseCurrencyModel.fromJson(Map<String, dynamic> json) {
    return BaseCurrencyModel(
      currencyId: json['currency_id']?.toString() ?? '',
      currencyCode: json['currency_code']?.toString() ?? '',
      currencyName: json['currency_name']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      flagEmoji: json['flag_emoji']?.toString(),
    );
  }

  /// Convert to domain entity
  BaseCurrency toEntity() {
    return BaseCurrency(
      currencyId: currencyId,
      currencyCode: currencyCode,
      currencyName: currencyName,
      symbol: symbol,
      flagEmoji: flagEmoji,
    );
  }
}
