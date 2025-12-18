// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_recount_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VaultRecountDtoImpl _$$VaultRecountDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$VaultRecountDtoImpl(
      companyId: json['company_id'] as String,
      storeId: json['store_id'] as String?,
      locationId: json['location_id'] as String,
      currencyId: json['currency_id'] as String,
      userId: json['created_by'] as String,
      recordDate: DateTime.parse(json['record_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      denominations: (json['denominations'] as List<dynamic>?)
              ?.map((e) => DenominationDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$VaultRecountDtoImplToJson(
        _$VaultRecountDtoImpl instance) =>
    <String, dynamic>{
      'company_id': instance.companyId,
      'store_id': instance.storeId,
      'location_id': instance.locationId,
      'currency_id': instance.currencyId,
      'created_by': instance.userId,
      'record_date': instance.recordDate.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'denominations': instance.denominations,
    };
