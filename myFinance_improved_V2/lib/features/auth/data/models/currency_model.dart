// lib/features/auth/data/models/currency_model.dart

import '../../domain/value_objects/currency.dart';

/// Currency Model
///
/// 📦 Reference data model for currencies
class CurrencyModel {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;

  const CurrencyModel({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
  });

  /// Create from Supabase JSON
  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      currencyId: json['currency_id'] as String,
      currencyCode: json['currency_code'] as String,
      currencyName: json['currency_name'] as String,
      symbol: json['symbol'] as String,
    );
  }

  /// Convert to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'currency_id': currencyId,
      'currency_code': currencyCode,
      'currency_name': currencyName,
      'symbol': symbol,
    };
  }

  /// Convert to Domain Value Object
  Currency toValueObject() {
    return Currency(
      currencyId: currencyId,
      currencyCode: currencyCode,
      currencyName: currencyName,
      symbol: symbol,
    );
  }
}
