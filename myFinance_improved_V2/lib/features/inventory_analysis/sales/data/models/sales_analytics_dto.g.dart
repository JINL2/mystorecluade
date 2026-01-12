// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_analytics_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsDataPointDto _$AnalyticsDataPointDtoFromJson(
        Map<String, dynamic> json) =>
    AnalyticsDataPointDto(
      period: json['period'] as String,
      dimensionId: json['dimension_id'] as String?,
      dimensionName: json['dimension_name'] as String?,
      totalQuantity: json['total_quantity'] as num?,
      totalRevenue: json['total_revenue'] as num?,
      totalMargin: json['total_margin'] as num?,
      marginRate: json['margin_rate'] as num?,
      invoiceCount: json['invoice_count'] as num?,
      revenueGrowth: json['revenue_growth'] as num?,
      quantityGrowth: json['quantity_growth'] as num?,
      marginGrowth: json['margin_growth'] as num?,
    );

Map<String, dynamic> _$AnalyticsDataPointDtoToJson(
        AnalyticsDataPointDto instance) =>
    <String, dynamic>{
      'period': instance.period,
      'dimension_id': instance.dimensionId,
      'dimension_name': instance.dimensionName,
      'total_quantity': instance.totalQuantity,
      'total_revenue': instance.totalRevenue,
      'total_margin': instance.totalMargin,
      'margin_rate': instance.marginRate,
      'invoice_count': instance.invoiceCount,
      'revenue_growth': instance.revenueGrowth,
      'quantity_growth': instance.quantityGrowth,
      'margin_growth': instance.marginGrowth,
    };

AnalyticsSummaryDto _$AnalyticsSummaryDtoFromJson(Map<String, dynamic> json) =>
    AnalyticsSummaryDto(
      totalRevenue: json['total_revenue'] as num?,
      totalQuantity: json['total_quantity'] as num?,
      totalMargin: json['total_margin'] as num?,
      avgMarginRate: json['avg_margin_rate'] as num?,
      recordCount: json['record_count'] as num?,
    );

Map<String, dynamic> _$AnalyticsSummaryDtoToJson(
        AnalyticsSummaryDto instance) =>
    <String, dynamic>{
      'total_revenue': instance.totalRevenue,
      'total_quantity': instance.totalQuantity,
      'total_margin': instance.totalMargin,
      'avg_margin_rate': instance.avgMarginRate,
      'record_count': instance.recordCount,
    };

SalesAnalyticsResponseDto _$SalesAnalyticsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    SalesAnalyticsResponseDto(
      success: json['success'] as bool?,
      summary: json['summary'] as Map<String, dynamic>?,
      data: json['data'] as List<dynamic>?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$SalesAnalyticsResponseDtoToJson(
        SalesAnalyticsResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'summary': instance.summary,
      'data': instance.data,
      'error': instance.error,
    };

DrillDownItemDto _$DrillDownItemDtoFromJson(Map<String, dynamic> json) =>
    DrillDownItemDto(
      id: json['item_id'] as String?,
      name: json['item_name'] as String?,
      totalQuantity: json['total_quantity'] as num?,
      totalRevenue: json['total_revenue'] as num?,
      totalMargin: json['total_margin'] as num?,
      marginRate: json['margin_rate'] as num?,
      productCount: json['product_count'] as num?,
      brandCount: json['brand_count'] as num?,
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      brandId: json['brand_id'] as String?,
      brandName: json['brand_name'] as String?,
    );

Map<String, dynamic> _$DrillDownItemDtoToJson(DrillDownItemDto instance) =>
    <String, dynamic>{
      'item_id': instance.id,
      'item_name': instance.name,
      'total_quantity': instance.totalQuantity,
      'total_revenue': instance.totalRevenue,
      'total_margin': instance.totalMargin,
      'margin_rate': instance.marginRate,
      'product_count': instance.productCount,
      'brand_count': instance.brandCount,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'brand_id': instance.brandId,
      'brand_name': instance.brandName,
    };

DrillDownResponseDto _$DrillDownResponseDtoFromJson(
        Map<String, dynamic> json) =>
    DrillDownResponseDto(
      success: json['success'] as bool?,
      level: json['level'] as String?,
      parentId: json['parent_id'] as String?,
      data: json['data'] as List<dynamic>?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$DrillDownResponseDtoToJson(
        DrillDownResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'level': instance.level,
      'parent_id': instance.parentId,
      'data': instance.data,
      'error': instance.error,
    };
