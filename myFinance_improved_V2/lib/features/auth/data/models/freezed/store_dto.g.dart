// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreDtoImpl _$$StoreDtoImplFromJson(Map<String, dynamic> json) =>
    _$StoreDtoImpl(
      storeId: json['store_id'] as String,
      storeName: json['store_name'] as String,
      companyId: json['company_id'] as String,
      storeCode: json['store_code'] as String?,
      storeAddress: json['store_address'] as String?,
      storePhone: json['store_phone'] as String?,
      huddleTime: (json['huddle_time'] as num?)?.toInt(),
      paymentTime: (json['payment_time'] as num?)?.toInt(),
      allowedDistance: (json['allowed_distance'] as num?)?.toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$StoreDtoImplToJson(_$StoreDtoImpl instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'company_id': instance.companyId,
      'store_code': instance.storeCode,
      'store_address': instance.storeAddress,
      'store_phone': instance.storePhone,
      'huddle_time': instance.huddleTime,
      'payment_time': instance.paymentTime,
      'allowed_distance': instance.allowedDistance,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'is_deleted': instance.isDeleted,
    };
