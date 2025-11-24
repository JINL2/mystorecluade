// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CurrencyDtoImpl _$$CurrencyDtoImplFromJson(Map<String, dynamic> json) =>
    _$CurrencyDtoImpl(
      currencyId: json['currency_id'] as String,
      companyCurrencyId: json['company_currency_id'] as String?,
      currencyCode: json['currency_code'] as String,
      currencyName: json['currency_name'] as String,
      symbol: json['symbol'] as String,
      flagEmoji: json['flag_emoji'] as String?,
      isBaseCurrency: json['is_base_currency'] as bool? ?? false,
      exchangeRateToBase:
          (json['exchange_rate_to_base'] as num?)?.toDouble() ?? 1.0,
      denominations: json['denominations'] == null
          ? const []
          : _denominationsFromJson(json['denominations']),
    );

Map<String, dynamic> _$$CurrencyDtoImplToJson(_$CurrencyDtoImpl instance) =>
    <String, dynamic>{
      'currency_id': instance.currencyId,
      'company_currency_id': instance.companyCurrencyId,
      'currency_code': instance.currencyCode,
      'currency_name': instance.currencyName,
      'symbol': instance.symbol,
      'flag_emoji': instance.flagEmoji,
      'is_base_currency': instance.isBaseCurrency,
      'exchange_rate_to_base': instance.exchangeRateToBase,
      'denominations': _denominationsToJson(instance.denominations),
    };
