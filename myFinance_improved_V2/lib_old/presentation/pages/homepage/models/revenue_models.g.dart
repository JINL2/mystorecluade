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
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      isLoading: json['isLoading'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$RevenueDataImplToJson(_$RevenueDataImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currencySymbol': instance.currencySymbol,
      'period': instance.period,
      'comparisonAmount': instance.comparisonAmount,
      'comparisonPeriod': instance.comparisonPeriod,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'isLoading': instance.isLoading,
      'errorMessage': instance.errorMessage,
    };

_$RevenueResponseImpl _$$RevenueResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RevenueResponseImpl(
      amount: (json['amount'] as num).toDouble(),
      currencySymbol: json['currency_symbol'] as String,
      period: json['period'] as String,
      comparisonAmount: (json['comparison_amount'] as num?)?.toDouble(),
      comparisonPeriod: json['comparison_period'] as String?,
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
      storeId: json['store_id'] as String?,
      companyId: json['company_id'] as String?,
    );

Map<String, dynamic> _$$RevenueResponseImplToJson(
        _$RevenueResponseImpl instance) =>
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

_$RevenueCategoryBreakdownImpl _$$RevenueCategoryBreakdownImplFromJson(
        Map<String, dynamic> json) =>
    _$RevenueCategoryBreakdownImpl(
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      iconName: json['iconName'] as String? ?? '',
      colorHex: json['colorHex'] as String? ?? '#000000',
    );

Map<String, dynamic> _$$RevenueCategoryBreakdownImplToJson(
        _$RevenueCategoryBreakdownImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'amount': instance.amount,
      'percentage': instance.percentage,
      'iconName': instance.iconName,
      'colorHex': instance.colorHex,
    };

_$DailyRevenueSummaryImpl _$$DailyRevenueSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyRevenueSummaryImpl(
      date: DateTime.parse(json['date'] as String),
      grossRevenue: (json['grossRevenue'] as num).toDouble(),
      netRevenue: (json['netRevenue'] as num).toDouble(),
      expenses: (json['expenses'] as num).toDouble(),
      transactionCount: (json['transactionCount'] as num).toInt(),
      currencySymbol: json['currencySymbol'] as String,
      categoryBreakdown: (json['categoryBreakdown'] as List<dynamic>?)
              ?.map((e) =>
                  RevenueCategoryBreakdown.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DailyRevenueSummaryImplToJson(
        _$DailyRevenueSummaryImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'grossRevenue': instance.grossRevenue,
      'netRevenue': instance.netRevenue,
      'expenses': instance.expenses,
      'transactionCount': instance.transactionCount,
      'currencySymbol': instance.currencySymbol,
      'categoryBreakdown': instance.categoryBreakdown,
    };
