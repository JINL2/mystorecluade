// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CurrencyImpl _$$CurrencyImplFromJson(Map<String, dynamic> json) =>
    _$CurrencyImpl(
      currencyId: json['currency_id'] as String,
      currencyCode: json['currency_code'] as String,
      currencyName: json['currency_name'] as String,
      symbol: json['symbol'] as String,
      denominations: (json['denominations'] as List<dynamic>?)
              ?.map((e) => Denomination.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CurrencyImplToJson(_$CurrencyImpl instance) =>
    <String, dynamic>{
      'currency_id': instance.currencyId,
      'currency_code': instance.currencyCode,
      'currency_name': instance.currencyName,
      'symbol': instance.symbol,
      'denominations': instance.denominations,
    };
