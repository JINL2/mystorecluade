// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CashLocationImpl _$$CashLocationImplFromJson(Map<String, dynamic> json) =>
    _$CashLocationImpl(
      locationId: json['locationId'] as String,
      locationName: json['locationName'] as String,
      locationType: json['locationType'] as String,
      totalJournalCashAmount:
          (json['totalJournalCashAmount'] as num).toDouble(),
      totalRealCashAmount: (json['totalRealCashAmount'] as num).toDouble(),
      cashDifference: (json['cashDifference'] as num).toDouble(),
      companyId: json['companyId'] as String,
      storeId: json['storeId'] as String?,
      currencySymbol: json['currencySymbol'] as String,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$CashLocationImplToJson(_$CashLocationImpl instance) =>
    <String, dynamic>{
      'locationId': instance.locationId,
      'locationName': instance.locationName,
      'locationType': instance.locationType,
      'totalJournalCashAmount': instance.totalJournalCashAmount,
      'totalRealCashAmount': instance.totalRealCashAmount,
      'cashDifference': instance.cashDifference,
      'companyId': instance.companyId,
      'storeId': instance.storeId,
      'currencySymbol': instance.currencySymbol,
      'isDeleted': instance.isDeleted,
    };
