// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreDtoImpl _$$StoreDtoImplFromJson(Map<String, dynamic> json) =>
    _$StoreDtoImpl(
      storeId: json['store_id'] as String,
      storeName: json['store_name'] as String,
      storeCode: json['store_code'] as String?,
    );

Map<String, dynamic> _$$StoreDtoImplToJson(_$StoreDtoImpl instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'store_code': instance.storeCode,
    };
