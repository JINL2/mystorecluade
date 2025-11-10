// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreImpl _$$StoreImplFromJson(Map<String, dynamic> json) => _$StoreImpl(
      id: json['store_id'] as String,
      name: json['store_name'] as String,
      companyId: json['company_id'] as String,
      storeCode: json['store_code'] as String?,
      phone: json['store_phone'] as String?,
      address: json['store_address'] as String?,
      timezone: json['timezone'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      huddleTimeMinutes: (json['huddle_time'] as num?)?.toInt(),
      paymentTimeDays: (json['payment_time'] as num?)?.toInt(),
      allowedDistanceMeters: (json['allowed_distance'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isDeleted: json['is_deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$StoreImplToJson(_$StoreImpl instance) =>
    <String, dynamic>{
      'store_id': instance.id,
      'store_name': instance.name,
      'company_id': instance.companyId,
      'store_code': instance.storeCode,
      'store_phone': instance.phone,
      'store_address': instance.address,
      'timezone': instance.timezone,
      'description': instance.description,
      'is_active': instance.isActive,
      'huddle_time': instance.huddleTimeMinutes,
      'payment_time': instance.paymentTimeDays,
      'allowed_distance': instance.allowedDistanceMeters,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'is_deleted': instance.isDeleted,
    };
