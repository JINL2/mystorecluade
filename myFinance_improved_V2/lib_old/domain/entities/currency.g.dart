// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CurrencyImpl _$$CurrencyImplFromJson(Map<String, dynamic> json) =>
    _$CurrencyImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      symbol: json['symbol'] as String,
      flagEmoji: json['flagEmoji'] as String,
      companyCurrencyId: json['companyCurrencyId'] as String?,
      denominations: (json['denominations'] as List<dynamic>?)
              ?.map((e) => Denomination.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CurrencyImplToJson(_$CurrencyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'fullName': instance.fullName,
      'symbol': instance.symbol,
      'flagEmoji': instance.flagEmoji,
      'companyCurrencyId': instance.companyCurrencyId,
      'denominations': instance.denominations,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$CurrencyTypeImpl _$$CurrencyTypeImplFromJson(Map<String, dynamic> json) =>
    _$CurrencyTypeImpl(
      currencyId: json['currencyId'] as String,
      currencyCode: json['currencyCode'] as String,
      currencyName: json['currencyName'] as String,
      symbol: json['symbol'] as String,
      flagEmoji: json['flagEmoji'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CurrencyTypeImplToJson(_$CurrencyTypeImpl instance) =>
    <String, dynamic>{
      'currencyId': instance.currencyId,
      'currencyCode': instance.currencyCode,
      'currencyName': instance.currencyName,
      'symbol': instance.symbol,
      'flagEmoji': instance.flagEmoji,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$CompanyCurrencyImpl _$$CompanyCurrencyImplFromJson(
        Map<String, dynamic> json) =>
    _$CompanyCurrencyImpl(
      companyCurrencyId: json['companyCurrencyId'] as String,
      companyId: json['companyId'] as String,
      currencyId: json['currencyId'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      currencyCode: json['currencyCode'] as String?,
      currencyName: json['currencyName'] as String?,
      symbol: json['symbol'] as String?,
      flagEmoji: json['flagEmoji'] as String?,
    );

Map<String, dynamic> _$$CompanyCurrencyImplToJson(
        _$CompanyCurrencyImpl instance) =>
    <String, dynamic>{
      'companyCurrencyId': instance.companyCurrencyId,
      'companyId': instance.companyId,
      'currencyId': instance.currencyId,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'currencyCode': instance.currencyCode,
      'currencyName': instance.currencyName,
      'symbol': instance.symbol,
      'flagEmoji': instance.flagEmoji,
    };
