import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/currency.dart';
import 'denomination_dto.dart';

part 'currency_dto.freezed.dart';
part 'currency_dto.g.dart';

/// Currency DTO
///
/// Maps to RPC: get_company_currencies_with_exchange_rates
/// Handles JSON serialization/deserialization with Freezed
@freezed
class CurrencyDto with _$CurrencyDto {
  const CurrencyDto._();

  const factory CurrencyDto({
    @JsonKey(name: 'currency_id') required String currencyId,
    @JsonKey(name: 'company_currency_id') String? companyCurrencyId,
    @JsonKey(name: 'currency_code') required String currencyCode,
    @JsonKey(name: 'currency_name') required String currencyName,
    @JsonKey(name: 'symbol') required String symbol,
    @JsonKey(name: 'flag_emoji') String? flagEmoji,

    // Grand Total calculation fields
    @JsonKey(name: 'is_base_currency') @Default(false) bool isBaseCurrency,
    @JsonKey(name: 'exchange_rate_to_base') @Default(1.0) double exchangeRateToBase,

    // RPC returns JSONB array - custom deserializer
    @JsonKey(
      name: 'denominations',
      fromJson: _denominationsFromJson,
      toJson: _denominationsToJson,
    )
    @Default([]) List<DenominationDto> denominations,
  }) = _CurrencyDto;

  factory CurrencyDto.fromJson(Map<String, dynamic> json) =>
      _$CurrencyDtoFromJson(json);

  /// Factory method for RPC responses (injects currency_id into denominations)
  factory CurrencyDto.fromRpcJson(Map<String, dynamic> json) {
    // First parse using generated method
    final dto = _$CurrencyDtoFromJson(json);

    // Inject currency_id into each denomination (since RPC JSONB doesn't include it)
    final currencyId = json['currency_id'] as String;
    final denominationsWithCurrencyId = dto.denominations
        .map((denom) => denom.copyWith(currencyId: currencyId))
        .toList();

    return dto.copyWith(denominations: denominationsWithCurrencyId);
  }

  /// Convert to Domain Entity
  Currency toEntity() {
    return Currency(
      currencyId: currencyId,
      companyCurrencyId: companyCurrencyId,
      currencyCode: currencyCode,
      currencyName: currencyName,
      symbol: symbol,
      flagEmoji: flagEmoji,
      isBaseCurrency: isBaseCurrency,
      exchangeRateToBase: exchangeRateToBase,
      denominations: denominations.map((dto) => dto.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory CurrencyDto.fromEntity(Currency entity) {
    return CurrencyDto(
      currencyId: entity.currencyId,
      companyCurrencyId: entity.companyCurrencyId,
      currencyCode: entity.currencyCode,
      currencyName: entity.currencyName,
      symbol: entity.symbol,
      flagEmoji: entity.flagEmoji,
      isBaseCurrency: entity.isBaseCurrency,
      exchangeRateToBase: entity.exchangeRateToBase,
      denominations: entity.denominations
          .map((e) => DenominationDto.fromEntity(e))
          .toList(),
    );
  }
}

// Helper functions for JSONB denominations parsing
List<DenominationDto> _denominationsFromJson(dynamic json) {
  if (json == null) return [];

  if (json is List) {
    return json
        .map((item) => DenominationDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  return [];
}

dynamic _denominationsToJson(List<DenominationDto> denominations) {
  return denominations.map((dto) => dto.toJson()).toList();
}
