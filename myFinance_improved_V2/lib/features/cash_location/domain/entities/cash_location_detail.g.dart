// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_location_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CashLocationDetailImpl _$$CashLocationDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$CashLocationDetailImpl(
      locationId: json['locationId'] as String,
      locationName: json['locationName'] as String,
      locationType: json['locationType'] as String,
      note: json['note'] as String?,
      description: json['description'] as String?,
      bankName: json['bankName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      isMainLocation: json['isMainLocation'] as bool,
      companyId: json['companyId'] as String,
      storeId: json['storeId'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$CashLocationDetailImplToJson(
        _$CashLocationDetailImpl instance) =>
    <String, dynamic>{
      'locationId': instance.locationId,
      'locationName': instance.locationName,
      'locationType': instance.locationType,
      'note': instance.note,
      'description': instance.description,
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
      'isMainLocation': instance.isMainLocation,
      'companyId': instance.companyId,
      'storeId': instance.storeId,
      'isDeleted': instance.isDeleted,
    };
