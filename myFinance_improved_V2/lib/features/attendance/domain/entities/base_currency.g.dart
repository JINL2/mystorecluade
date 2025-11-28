// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BaseCurrencyImpl _$$BaseCurrencyImplFromJson(Map<String, dynamic> json) =>
    _$BaseCurrencyImpl(
      currencyId: json['currency_id'] as String,
      currencyCode: json['currency_code'] as String,
      currencyName: json['currency_name'] as String,
      symbol: json['symbol'] as String,
      flagEmoji: json['flag_emoji'] as String?,
    );

Map<String, dynamic> _$$BaseCurrencyImplToJson(_$BaseCurrencyImpl instance) =>
    <String, dynamic>{
      'currency_id': instance.currencyId,
      'currency_code': instance.currencyCode,
      'currency_name': instance.currencyName,
      'symbol': instance.symbol,
      'flag_emoji': instance.flagEmoji,
    };
