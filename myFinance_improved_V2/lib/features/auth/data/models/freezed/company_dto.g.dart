// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyDtoImpl _$$CompanyDtoImplFromJson(Map<String, dynamic> json) =>
    _$CompanyDtoImpl(
      companyId: json['company_id'] as String,
      companyName: json['company_name'] as String,
      companyCode: json['company_code'] as String?,
      companyTypeId: json['company_type_id'] as String,
      ownerId: json['owner_id'] as String,
      baseCurrencyId: json['base_currency_id'] as String,
      timezone: json['timezone'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
      otherTypeDetail: json['other_type_detail'] as String?,
    );

Map<String, dynamic> _$$CompanyDtoImplToJson(_$CompanyDtoImpl instance) =>
    <String, dynamic>{
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'company_code': instance.companyCode,
      'company_type_id': instance.companyTypeId,
      'owner_id': instance.ownerId,
      'base_currency_id': instance.baseCurrencyId,
      'timezone': instance.timezone,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'is_deleted': instance.isDeleted,
      'other_type_detail': instance.otherTypeDetail,
    };
