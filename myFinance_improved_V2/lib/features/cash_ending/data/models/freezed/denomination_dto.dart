import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/denomination.dart';

part 'denomination_dto.freezed.dart';
part 'denomination_dto.g.dart';

/// Denomination DTO
///
/// Maps to DB table: currency_denominations
/// Handles JSON serialization/deserialization with Freezed
@freezed
class DenominationDto with _$DenominationDto {
  const DenominationDto._();

  const factory DenominationDto({
    @JsonKey(name: 'denomination_id') required String denominationId,
    @JsonKey(name: 'currency_id') String? currencyId, // Optional: not in RPC JSONB
    @JsonKey(name: 'value') required double value,
    @JsonKey(name: 'quantity') @Default(0) int quantity,
    @JsonKey(name: 'type') String? type,
  }) = _DenominationDto;

  factory DenominationDto.fromJson(Map<String, dynamic> json) =>
      _$DenominationDtoFromJson(json);

  /// Convert to Domain Entity
  Denomination toEntity() {
    return Denomination(
      denominationId: denominationId,
      currencyId: currencyId ?? '', // Fallback for RPC JSONB (injected by CurrencyDto)
      value: value,
      quantity: quantity,
    );
  }

  /// Create from Domain Entity
  factory DenominationDto.fromEntity(Denomination entity) {
    return DenominationDto(
      denominationId: entity.denominationId,
      currencyId: entity.currencyId,
      value: entity.value,
      quantity: entity.quantity,
    );
  }
}
