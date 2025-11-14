// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CurrencyModelImpl _$$CurrencyModelImplFromJson(Map<String, dynamic> json) =>
    _$CurrencyModelImpl(
      id: json['currency_id'] as String,
      code: json['currency_code'] as String,
      name: json['currency_name'] as String,
      symbol: json['symbol'] as String,
    );

Map<String, dynamic> _$$CurrencyModelImplToJson(_$CurrencyModelImpl instance) =>
    <String, dynamic>{
      'currency_id': instance.id,
      'currency_code': instance.code,
      'currency_name': instance.name,
      'symbol': instance.symbol,
    };
