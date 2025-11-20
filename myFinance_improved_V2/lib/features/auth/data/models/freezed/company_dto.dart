// lib/features/auth/data/models/freezed/company_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_dto.freezed.dart';
part 'company_dto.g.dart';

/// Company Data Transfer Object
///
/// Maps directly to Supabase companies table schema.
/// Uses Freezed for immutability and json_serializable for JSON mapping.
///
/// DB Columns (snake_case) → Dart Fields (camelCase):
/// - company_id → companyId
/// - company_name → companyName
/// - company_code → companyCode
/// - company_type_id → companyTypeId
/// - owner_id → ownerId
/// - base_currency_id → baseCurrencyId
/// - timezone → timezone
/// - created_at → createdAt
/// - updated_at → updatedAt
/// - is_deleted → isDeleted
@freezed
class CompanyDto with _$CompanyDto {
  const factory CompanyDto({
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'company_code') String? companyCode,
    @JsonKey(name: 'company_type_id') required String companyTypeId,
    @JsonKey(name: 'owner_id') required String ownerId,
    @JsonKey(name: 'base_currency_id') required String baseCurrencyId,
    String? timezone,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
    @JsonKey(name: 'other_type_detail') String? otherTypeDetail,
  }) = _CompanyDto;

  factory CompanyDto.fromJson(Map<String, dynamic> json) =>
      _$CompanyDtoFromJson(json);
}
