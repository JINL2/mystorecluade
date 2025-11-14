import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/store.dart';

part 'store_dto.freezed.dart';
part 'store_dto.g.dart';

/// Store DTO
///
/// Maps to DB table: stores
/// Handles JSON serialization/deserialization with Freezed
@freezed
class StoreDto with _$StoreDto {
  const StoreDto._();

  const factory StoreDto({
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'store_name') required String storeName,
    @JsonKey(name: 'store_code') String? storeCode,
  }) = _StoreDto;

  factory StoreDto.fromJson(Map<String, dynamic> json) =>
      _$StoreDtoFromJson(json);

  /// Convert to Domain Entity
  Store toEntity() {
    return Store(
      storeId: storeId,
      storeName: storeName,
      storeCode: storeCode,
    );
  }

  /// Create from Domain Entity
  factory StoreDto.fromEntity(Store entity) {
    return StoreDto(
      storeId: entity.storeId,
      storeName: entity.storeName,
      storeCode: entity.storeCode,
    );
  }
}
