// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bcg_matrix_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BcgCategoryModel _$BcgCategoryModelFromJson(Map<String, dynamic> json) =>
    BcgCategoryModel(
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      totalRevenue: json['total_revenue'] as num,
      marginRatePct: json['margin_rate_pct'] as num,
      totalQuantity: (json['total_quantity'] as num).toInt(),
      salesVolumePercentile: json['sales_volume_percentile'] as num,
      marginPercentile: json['margin_percentile'] as num,
      quadrant: json['strategy_quadrant'] as String,
    );

Map<String, dynamic> _$BcgCategoryModelToJson(BcgCategoryModel instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'total_revenue': instance.totalRevenue,
      'margin_rate_pct': instance.marginRatePct,
      'total_quantity': instance.totalQuantity,
      'sales_volume_percentile': instance.salesVolumePercentile,
      'margin_percentile': instance.marginPercentile,
      'strategy_quadrant': instance.quadrant,
    };
