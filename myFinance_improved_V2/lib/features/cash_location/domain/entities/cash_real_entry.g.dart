// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_real_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CashRealEntryImpl _$$CashRealEntryImplFromJson(Map<String, dynamic> json) =>
    _$CashRealEntryImpl(
      createdAt: json['createdAt'] as String,
      recordDate: json['recordDate'] as String,
      locationId: json['locationId'] as String,
      locationName: json['locationName'] as String,
      locationType: json['locationType'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currencySummary: (json['currencySummary'] as List<dynamic>)
          .map((e) => CurrencySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CashRealEntryImplToJson(_$CashRealEntryImpl instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'recordDate': instance.recordDate,
      'locationId': instance.locationId,
      'locationName': instance.locationName,
      'locationType': instance.locationType,
      'totalAmount': instance.totalAmount,
      'currencySummary': instance.currencySummary,
    };
