// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RevenueModelImpl _$$RevenueModelImplFromJson(Map<String, dynamic> json) =>
    _$RevenueModelImpl(
      amount: (json['amount'] as num).toDouble(),
      currencySymbol: json['currency_symbol'] as String,
      period: json['period'] as String,
      comparisonAmount: (json['comparison_amount'] as num?)?.toDouble() ?? 0.0,
      comparisonPeriod: json['comparison_period'] as String?,
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
      storeId: json['store_id'] as String?,
      companyId: json['company_id'] as String?,
    );

Map<String, dynamic> _$$RevenueModelImplToJson(_$RevenueModelImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency_symbol': instance.currencySymbol,
      'period': instance.period,
      'comparison_amount': instance.comparisonAmount,
      'comparison_period': instance.comparisonPeriod,
      'last_updated': instance.lastUpdated?.toIso8601String(),
      'store_id': instance.storeId,
      'company_id': instance.companyId,
    };
