// lib/features/cash_ending/data/models/currency_model.dart

import '../../domain/entities/currency.dart';
import 'denomination_model.dart';

/// Data Transfer Object for Currency
/// Handles JSON serialization/deserialization
class CurrencyModel {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final List<DenominationModel> denominations;

  const CurrencyModel({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    this.denominations = const [],
  });

  /// Create from JSON (from database)
  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      currencyId: json['currency_id']?.toString() ?? '',
      currencyCode: json['currency_code']?.toString() ?? '',
      currencyName: json['currency_name']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      denominations: (json['denominations'] as List<dynamic>?)
              ?.map((d) => DenominationModel.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convert to JSON (to database)
  Map<String, dynamic> toJson() {
    return {
      'currency_id': currencyId,
      'currency_code': currencyCode,
      'currency_name': currencyName,
      'symbol': symbol,
      'denominations': denominations.map((d) => d.toJson()).toList(),
    };
  }

  /// Convert to Domain Entity
  Currency toEntity() {
    return Currency(
      currencyId: currencyId,
      currencyCode: currencyCode,
      currencyName: currencyName,
      symbol: symbol,
      denominations: denominations.map((d) => d.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory CurrencyModel.fromEntity(Currency entity) {
    return CurrencyModel(
      currencyId: entity.currencyId,
      currencyCode: entity.currencyCode,
      currencyName: entity.currencyName,
      symbol: entity.symbol,
      denominations: entity.denominations
          .map((d) => DenominationModel.fromEntity(d))
          .toList(),
    );
  }
}
