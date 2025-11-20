// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyTypeModelImpl _$$CompanyTypeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CompanyTypeModelImpl(
      id: json['company_type_id'] as String,
      typeName: json['type_name'] as String,
    );

Map<String, dynamic> _$$CompanyTypeModelImplToJson(
        _$CompanyTypeModelImpl instance) =>
    <String, dynamic>{
      'company_type_id': instance.id,
      'type_name': instance.typeName,
    };
