// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_real_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VaultRealEntryImpl _$$VaultRealEntryImplFromJson(Map<String, dynamic> json) =>
    _$VaultRealEntryImpl(
      createdAt: json['createdAt'] as String,
      recordDate: json['recordDate'] as String,
      locationId: json['locationId'] as String,
      locationName: json['locationName'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currencySummary: (json['currencySummary'] as List<dynamic>)
          .map((e) => CurrencySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$VaultRealEntryImplToJson(
        _$VaultRealEntryImpl instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'recordDate': instance.recordDate,
      'locationId': instance.locationId,
      'locationName': instance.locationName,
      'totalAmount': instance.totalAmount,
      'currencySummary': instance.currencySummary,
    };
