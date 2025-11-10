// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyImpl _$$CompanyImplFromJson(Map<String, dynamic> json) =>
    _$CompanyImpl(
      id: json['company_id'] as String,
      name: json['company_name'] as String,
      businessNumber: json['company_business_number'] as String?,
      email: json['company_email'] as String?,
      phone: json['company_phone'] as String?,
      address: json['company_address'] as String?,
      companyTypeId: json['company_type_id'] as String,
      currencyId: json['base_currency_id'] as String,
      companyCode: json['company_code'] as String?,
      ownerId: json['owner_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      timezone: json['timezone'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$CompanyImplToJson(_$CompanyImpl instance) =>
    <String, dynamic>{
      'company_id': instance.id,
      'company_name': instance.name,
      'company_business_number': instance.businessNumber,
      'company_email': instance.email,
      'company_phone': instance.phone,
      'company_address': instance.address,
      'company_type_id': instance.companyTypeId,
      'base_currency_id': instance.currencyId,
      'company_code': instance.companyCode,
      'owner_id': instance.ownerId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'timezone': instance.timezone,
      'is_deleted': instance.isDeleted,
    };
