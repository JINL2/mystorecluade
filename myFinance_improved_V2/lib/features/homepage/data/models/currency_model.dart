import 'package:myfinance_improved/features/homepage/domain/entities/currency.dart';

/// Data Transfer Object for Currency
/// Handles JSON serialization/deserialization from Supabase
class CurrencyModel extends Currency {
  const CurrencyModel({
    required super.id,
    required super.code,
    required super.name,
    required super.symbol,
  });

  /// Create from JSON (from Supabase response)
  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['currency_id'] as String,
      code: json['currency_code'] as String,
      name: json['currency_name'] as String,
      symbol: json['symbol'] as String,
    );
  }

  /// Convert to JSON (for Supabase request)
  Map<String, dynamic> toJson() {
    return {
      'currency_id': id,
      'currency_code': code,
      'currency_name': name,
      'symbol': symbol,
    };
  }

  /// Convert to domain entity
  Currency toEntity() {
    return Currency(
      id: id,
      code: code,
      name: name,
      symbol: symbol,
    );
  }
}
