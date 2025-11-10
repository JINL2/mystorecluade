// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'denomination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DenominationImpl _$$DenominationImplFromJson(Map<String, dynamic> json) =>
    _$DenominationImpl(
      denominationId: json['denomination_id'] as String,
      currencyId: json['currency_id'] as String,
      value: (json['value'] as num).toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DenominationImplToJson(_$DenominationImpl instance) =>
    <String, dynamic>{
      'denomination_id': instance.denominationId,
      'currency_id': instance.currencyId,
      'value': instance.value,
      'quantity': instance.quantity,
    };
