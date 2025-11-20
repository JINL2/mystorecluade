import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/currency.dart';
import 'denomination_dto.dart';

part 'currency_dto.freezed.dart';
part 'currency_dto.g.dart';

/// Currency DTO
///
/// Maps to DB table: currency_types
/// Handles JSON serialization/deserialization with Freezed
@freezed
class CurrencyDto with _$CurrencyDto {
  const CurrencyDto._();

  const factory CurrencyDto({
    @JsonKey(name: 'currency_id') required String currencyId,
    @JsonKey(name: 'currency_code') required String currencyCode,
    @JsonKey(name: 'currency_name') required String currencyName,
    @JsonKey(name: 'symbol') required String symbol,
    @JsonKey(name: 'flag_emoji') String? flagEmoji,
    @Default([]) List<DenominationDto> denominations,
  }) = _CurrencyDto;

  factory CurrencyDto.fromJson(Map<String, dynamic> json) =>
      _$CurrencyDtoFromJson(json);

  /// Convert to Domain Entity
  Currency toEntity() {
    return Currency(
      currencyId: currencyId,
      currencyCode: currencyCode,
      currencyName: currencyName,
      symbol: symbol,
      denominations: denominations.map((dto) => dto.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory CurrencyDto.fromEntity(Currency entity) {
    return CurrencyDto(
      currencyId: entity.currencyId,
      currencyCode: entity.currencyCode,
      currencyName: entity.currencyName,
      symbol: entity.symbol,
      denominations: entity.denominations
          .map((e) => DenominationDto.fromEntity(e))
          .toList(),
    );
  }
}
