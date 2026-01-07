// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyMetricsModel _$MonthlyMetricsModelFromJson(Map<String, dynamic> json) =>
    MonthlyMetricsModel(
      revenue: json['revenue'] as num,
      margin: json['margin'] as num,
      marginRate: json['margin_rate'] as num,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$MonthlyMetricsModelToJson(
        MonthlyMetricsModel instance) =>
    <String, dynamic>{
      'revenue': instance.revenue,
      'margin': instance.margin,
      'margin_rate': instance.marginRate,
      'quantity': instance.quantity,
    };

GrowthMetricsModel _$GrowthMetricsModelFromJson(Map<String, dynamic> json) =>
    GrowthMetricsModel(
      revenuePct: json['revenue_pct'] as num,
      marginPct: json['margin_pct'] as num,
      quantityPct: json['quantity_pct'] as num,
    );

Map<String, dynamic> _$GrowthMetricsModelToJson(GrowthMetricsModel instance) =>
    <String, dynamic>{
      'revenue_pct': instance.revenuePct,
      'margin_pct': instance.marginPct,
      'quantity_pct': instance.quantityPct,
    };

SalesDashboardModel _$SalesDashboardModelFromJson(Map<String, dynamic> json) =>
    SalesDashboardModel(
      thisMonth: MonthlyMetricsModel.fromJson(
          json['this_month'] as Map<String, dynamic>),
      lastMonth: MonthlyMetricsModel.fromJson(
          json['last_month'] as Map<String, dynamic>),
      growth:
          GrowthMetricsModel.fromJson(json['growth'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SalesDashboardModelToJson(
        SalesDashboardModel instance) =>
    <String, dynamic>{
      'this_month': instance.thisMonth,
      'last_month': instance.lastMonth,
      'growth': instance.growth,
    };
