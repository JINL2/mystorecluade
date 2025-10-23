import '../../domain/entities/currency_type.dart';

/// Data Model: Currency Type Model
///
/// DTO (Data Transfer Object) for CurrencyType with JSON serialization.
/// This model knows how to convert between JSON and Domain Entity.
class CurrencyTypeModel extends CurrencyType {
  const CurrencyTypeModel({
    super.currencyId,
    required super.currencyCode,
    required super.currencyName,
    required super.symbol,
    super.decimalPlaces = 2,
    super.isActive = true,
  });

  /// Create model from domain entity
  factory CurrencyTypeModel.fromEntity(CurrencyType entity) {
    return CurrencyTypeModel(
      currencyId: entity.currencyId,
      currencyCode: entity.currencyCode,
      currencyName: entity.currencyName,
      symbol: entity.symbol,
      decimalPlaces: entity.decimalPlaces,
      isActive: entity.isActive,
    );
  }

  /// Create model from JSON (Supabase response)
  factory CurrencyTypeModel.fromJson(Map<String, dynamic> json) {
    return CurrencyTypeModel(
      currencyId: json['currency_id'] as String?,
      currencyCode: json['currency_code'] as String,
      currencyName: json['currency_name'] as String,
      symbol: json['symbol'] as String,
      decimalPlaces: json['decimal_places'] as int? ?? 2,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  /// Convert model to JSON (for Supabase requests)
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

  /// Convert model to domain entity
  CurrencyType toEntity() {
    return CurrencyType(
      currencyId: currencyId,
      currencyCode: currencyCode,
      currencyName: currencyName,
      symbol: symbol,
      decimalPlaces: decimalPlaces,
      isActive: isActive,
    );
  }
}
