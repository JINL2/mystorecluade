// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreModelImpl _$$StoreModelImplFromJson(Map<String, dynamic> json) =>
    _$StoreModelImpl(
      id: json['store_id'] as String,
      name: json['store_name'] as String,
      code: json['store_code'] as String,
      companyId: json['company_id'] as String,
      address: json['store_address'] as String?,
      phone: json['store_phone'] as String?,
      huddleTime: (json['huddle_time'] as num?)?.toInt(),
      paymentTime: (json['payment_time'] as num?)?.toInt(),
      allowedDistance: (json['allowed_distance'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$StoreModelImplToJson(_$StoreModelImpl instance) =>
    <String, dynamic>{
      'store_id': instance.id,
      'store_name': instance.name,
      'store_code': instance.code,
      'company_id': instance.companyId,
      'store_address': instance.address,
      'store_phone': instance.phone,
      'huddle_time': instance.huddleTime,
      'payment_time': instance.paymentTime,
      'allowed_distance': instance.allowedDistance,
    };
