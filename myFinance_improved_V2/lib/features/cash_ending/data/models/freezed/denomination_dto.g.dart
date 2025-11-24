// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'denomination_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DenominationDtoImpl _$$DenominationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$DenominationDtoImpl(
      denominationId: json['denomination_id'] as String,
      currencyId: json['currency_id'] as String?,
      value: (json['value'] as num).toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$$DenominationDtoImplToJson(
        _$DenominationDtoImpl instance) =>
    <String, dynamic>{
      'denomination_id': instance.denominationId,
      'currency_id': instance.currencyId,
      'value': instance.value,
      'quantity': instance.quantity,
      'type': instance.type,
    };
