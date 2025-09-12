// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'denomination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DenominationImpl _$$DenominationImplFromJson(Map<String, dynamic> json) =>
    _$DenominationImpl(
      id: json['id'] as String,
      companyId: json['companyId'] as String,
      currencyId: json['currencyId'] as String,
      value: (json['value'] as num).toDouble(),
      type: $enumDecode(_$DenominationTypeEnumMap, json['type']),
      displayName: json['displayName'] as String,
      emoji: json['emoji'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$DenominationImplToJson(_$DenominationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyId': instance.companyId,
      'currencyId': instance.currencyId,
      'value': instance.value,
      'type': _$DenominationTypeEnumMap[instance.type]!,
      'displayName': instance.displayName,
      'emoji': instance.emoji,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$DenominationTypeEnumMap = {
  DenominationType.coin: 'coin',
  DenominationType.bill: 'bill',
};

_$DenominationInputImpl _$$DenominationInputImplFromJson(
        Map<String, dynamic> json) =>
    _$DenominationInputImpl(
      companyId: json['companyId'] as String,
      currencyId: json['currencyId'] as String,
      value: (json['value'] as num).toDouble(),
      type: $enumDecode(_$DenominationTypeEnumMap, json['type']),
      displayName: json['displayName'] as String?,
      emoji: json['emoji'] as String?,
    );

Map<String, dynamic> _$$DenominationInputImplToJson(
        _$DenominationInputImpl instance) =>
    <String, dynamic>{
      'companyId': instance.companyId,
      'currencyId': instance.currencyId,
      'value': instance.value,
      'type': _$DenominationTypeEnumMap[instance.type]!,
      'displayName': instance.displayName,
      'emoji': instance.emoji,
    };
