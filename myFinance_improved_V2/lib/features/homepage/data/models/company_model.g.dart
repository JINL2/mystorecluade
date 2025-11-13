// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyModelImpl _$$CompanyModelImplFromJson(Map<String, dynamic> json) =>
    _$CompanyModelImpl(
      id: json['company_id'] as String,
      name: json['company_name'] as String,
      code: json['company_code'] as String,
      companyTypeId: json['company_type_id'] as String,
      baseCurrencyId: json['base_currency_id'] as String,
    );

Map<String, dynamic> _$$CompanyModelImplToJson(_$CompanyModelImpl instance) =>
    <String, dynamic>{
      'company_id': instance.id,
      'company_name': instance.name,
      'company_code': instance.code,
      'company_type_id': instance.companyTypeId,
      'base_currency_id': instance.baseCurrencyId,
    };
