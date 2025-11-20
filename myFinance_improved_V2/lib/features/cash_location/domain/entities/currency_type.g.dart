// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CurrencyTypeImpl _$$CurrencyTypeImplFromJson(Map<String, dynamic> json) =>
    _$CurrencyTypeImpl(
      currencyId: json['currencyId'] as String?,
      currencyCode: json['currencyCode'] as String,
      currencyName: json['currencyName'] as String,
      symbol: json['symbol'] as String,
      decimalPlaces: (json['decimalPlaces'] as num?)?.toInt() ?? 2,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$CurrencyTypeImplToJson(_$CurrencyTypeImpl instance) =>
    <String, dynamic>{
      'currencyId': instance.currencyId,
      'currencyCode': instance.currencyCode,
      'currencyName': instance.currencyName,
      'symbol': instance.symbol,
      'decimalPlaces': instance.decimalPlaces,
      'isActive': instance.isActive,
    };
