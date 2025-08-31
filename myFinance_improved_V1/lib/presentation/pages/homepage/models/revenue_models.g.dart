// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RevenueDataImpl _$$RevenueDataImplFromJson(Map<String, dynamic> json) =>
    _$RevenueDataImpl(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currencySymbol: json['currencySymbol'] as String? ?? 'USD',
      period: json['period'] as String? ?? 'Today',
      comparisonAmount: (json['comparisonAmount'] as num?)?.toDouble() ?? 0.0,
      comparisonPeriod: json['comparisonPeriod'] as String? ?? '',
    );

Map<String, dynamic> _$$RevenueDataImplToJson(_$RevenueDataImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currencySymbol': instance.currencySymbol,
      'period': instance.period,
      'comparisonAmount': instance.comparisonAmount,
      'comparisonPeriod': instance.comparisonPeriod,
    };

_$RevenueResponseImpl _$$RevenueResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RevenueResponseImpl(
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      currency_symbol: json['currency_symbol'] as String? ?? 'USD',
      period: json['period'] as String? ?? 'Today',
      comparison_revenue:
          (json['comparison_revenue'] as num?)?.toDouble() ?? 0.0,
      comparison_period: json['comparison_period'] as String? ?? '',
    );

Map<String, dynamic> _$$RevenueResponseImplToJson(
        _$RevenueResponseImpl instance) =>
    <String, dynamic>{
      'revenue': instance.revenue,
      'currency_symbol': instance.currency_symbol,
      'period': instance.period,
      'comparison_revenue': instance.comparison_revenue,
      'comparison_period': instance.comparison_period,
    };
