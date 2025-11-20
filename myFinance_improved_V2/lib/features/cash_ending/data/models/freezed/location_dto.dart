import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/location.dart';

part 'location_dto.freezed.dart';
part 'location_dto.g.dart';

/// Location DTO
///
/// Maps to DB table: cash_locations
/// Handles JSON serialization/deserialization with Freezed
@freezed
class LocationDto with _$LocationDto {
  const LocationDto._();

  const factory LocationDto({
    @JsonKey(name: 'cash_location_id') required String locationId,
    @JsonKey(name: 'location_name') required String locationName,
    @JsonKey(name: 'location_type') required String locationType,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'currency_id') String? currencyId,
    @JsonKey(name: 'bank_account') String? accountId,
    @JsonKey(name: 'bank_name') String? bankName,
    @JsonKey(name: 'currency_code') String? currencyCode,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'note') String? note,
  }) = _LocationDto;

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);

  /// Convert to Domain Entity
  Location toEntity() {
    return Location(
      locationId: locationId,
      locationName: locationName,
      locationType: locationType,
      storeId: storeId,
      currencyId: currencyId,
      accountId: accountId,
    );
  }

  /// Create from Domain Entity
  factory LocationDto.fromEntity(Location entity) {
    return LocationDto(
      locationId: entity.locationId,
      locationName: entity.locationName,
      locationType: entity.locationType,
      storeId: entity.storeId,
      currencyId: entity.currencyId,
      accountId: entity.accountId,
    );
  }
}
