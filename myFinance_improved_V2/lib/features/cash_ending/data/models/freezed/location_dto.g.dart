// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationDtoImpl _$$LocationDtoImplFromJson(Map<String, dynamic> json) =>
    _$LocationDtoImpl(
      locationId: json['cash_location_id'] as String,
      locationName: json['location_name'] as String,
      locationType: json['location_type'] as String,
      storeId: json['store_id'] as String?,
      currencyId: json['currency_id'] as String?,
      accountId: json['bank_account'] as String?,
      bankName: json['bank_name'] as String?,
      currencyCode: json['currency_code'] as String?,
      icon: json['icon'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$LocationDtoImplToJson(_$LocationDtoImpl instance) =>
    <String, dynamic>{
      'cash_location_id': instance.locationId,
      'location_name': instance.locationName,
      'location_type': instance.locationType,
      'store_id': instance.storeId,
      'currency_id': instance.currencyId,
      'bank_account': instance.accountId,
      'bank_name': instance.bankName,
      'currency_code': instance.currencyCode,
      'icon': instance.icon,
      'note': instance.note,
    };
