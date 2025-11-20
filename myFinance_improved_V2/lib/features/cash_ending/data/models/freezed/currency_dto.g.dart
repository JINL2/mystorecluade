// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CurrencyDtoImpl _$$CurrencyDtoImplFromJson(Map<String, dynamic> json) =>
    _$CurrencyDtoImpl(
      currencyId: json['currency_id'] as String,
      currencyCode: json['currency_code'] as String,
      currencyName: json['currency_name'] as String,
      symbol: json['symbol'] as String,
      flagEmoji: json['flag_emoji'] as String?,
      denominations: (json['denominations'] as List<dynamic>?)
              ?.map((e) => DenominationDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CurrencyDtoImplToJson(_$CurrencyDtoImpl instance) =>
    <String, dynamic>{
      'currency_id': instance.currencyId,
      'currency_code': instance.currencyCode,
      'currency_name': instance.currencyName,
      'symbol': instance.symbol,
      'flag_emoji': instance.flagEmoji,
      'denominations': instance.denominations,
    };
