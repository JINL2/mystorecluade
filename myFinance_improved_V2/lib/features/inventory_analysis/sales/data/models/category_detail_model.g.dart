// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopBrandModel _$TopBrandModelFromJson(Map<String, dynamic> json) =>
    TopBrandModel(
      brandId: json['brand_id'] as String,
      brandName: json['brand_name'] as String,
      revenue: json['revenue'] as num,
      marginRatePct: json['avg_margin_rate'] as num,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$TopBrandModelToJson(TopBrandModel instance) =>
    <String, dynamic>{
      'brand_id': instance.brandId,
      'brand_name': instance.brandName,
      'revenue': instance.revenue,
      'avg_margin_rate': instance.marginRatePct,
      'quantity': instance.quantity,
    };

ProblemProductModel _$ProblemProductModelFromJson(Map<String, dynamic> json) =>
    ProblemProductModel(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      currentStock: (json['current_stock'] as num).toInt(),
      reorderPoint: json['reorder_point'] as num,
      marginChange: json['margin_change'] as num?,
      issueType: json['issue_type'] as String,
    );

Map<String, dynamic> _$ProblemProductModelToJson(
        ProblemProductModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'product_name': instance.productName,
      'current_stock': instance.currentStock,
      'reorder_point': instance.reorderPoint,
      'margin_change': instance.marginChange,
      'issue_type': instance.issueType,
    };

CategoryDetailModel _$CategoryDetailModelFromJson(Map<String, dynamic> json) =>
    CategoryDetailModel(
      summary: CategorySummaryModel.fromJson(
          json['summary'] as Map<String, dynamic>),
      topBrands: (json['top_brands'] as List<dynamic>)
          .map((e) => TopBrandModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      problemProducts: (json['problem_products'] as List<dynamic>)
          .map((e) => ProblemProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryDetailModelToJson(
        CategoryDetailModel instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'top_brands': instance.topBrands,
      'problem_products': instance.problemProducts,
    };

CategorySummaryModel _$CategorySummaryModelFromJson(
        Map<String, dynamic> json) =>
    CategorySummaryModel(
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      totalRevenue: json['total_revenue'] as num,
      totalMargin: json['total_margin'] as num,
      marginRatePct: json['margin_rate_pct'] as num,
      totalQuantity: (json['total_quantity'] as num).toInt(),
      growthPct: json['growth_pct'] as num?,
    );

Map<String, dynamic> _$CategorySummaryModelToJson(
        CategorySummaryModel instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'total_revenue': instance.totalRevenue,
      'total_margin': instance.totalMargin,
      'margin_rate_pct': instance.marginRatePct,
      'total_quantity': instance.totalQuantity,
      'growth_pct': instance.growthPct,
    };
