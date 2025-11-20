// lib/features/auth/data/models/freezed/store_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_dto.freezed.dart';
part 'store_dto.g.dart';

/// Store Data Transfer Object
///
/// Maps directly to Supabase stores table schema.
/// Uses Freezed for immutability and json_serializable for JSON mapping.
///
/// DB Columns (snake_case) → Dart Fields (camelCase):
/// - store_id → storeId
/// - store_name → storeName
/// - store_code → storeCode
/// - store_address → storeAddress
/// - store_phone → storePhone
/// - company_id → companyId
/// - huddle_time → huddleTime
/// - payment_time → paymentTime
/// - allowed_distance → allowedDistance
/// - created_at → createdAt
/// - updated_at → updatedAt
/// - is_deleted → isDeleted
@freezed
class StoreDto with _$StoreDto {
  const factory StoreDto({
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'store_name') required String storeName,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'store_code') String? storeCode,
    @JsonKey(name: 'store_address') String? storeAddress,
    @JsonKey(name: 'store_phone') String? storePhone,
    @JsonKey(name: 'huddle_time') int? huddleTime,
    @JsonKey(name: 'payment_time') int? paymentTime,
    @JsonKey(name: 'allowed_distance') int? allowedDistance,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
  }) = _StoreDto;

  factory StoreDto.fromJson(Map<String, dynamic> json) =>
      _$StoreDtoFromJson(json);
}
