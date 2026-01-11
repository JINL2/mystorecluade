// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_optimization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReorderProductModel _$ReorderProductModelFromJson(Map<String, dynamic> json) =>
    ReorderProductModel(
      productId: json['product_id'] as String?,
      productName: json['product_name'] as String,
      categoryName: json['category_name'] as String?,
      currentStock: json['current_stock'] as num,
      reorderPoint: json['reorder_point'] as num,
      orderQty: json['order_qty'] as num?,
      suggestedOrderQty: json['suggested_order_qty'] as num?,
      avgDailyDemand: json['avg_daily_demand'] as num,
      daysLeft: json['days_left'] as num?,
      daysOfInventory: json['days_of_inventory'] as num?,
      priority: json['priority'] as String?,
    );

Map<String, dynamic> _$ReorderProductModelToJson(
        ReorderProductModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'product_name': instance.productName,
      'category_name': instance.categoryName,
      'current_stock': instance.currentStock,
      'reorder_point': instance.reorderPoint,
      'order_qty': instance.orderQty,
      'suggested_order_qty': instance.suggestedOrderQty,
      'avg_daily_demand': instance.avgDailyDemand,
      'days_left': instance.daysLeft,
      'days_of_inventory': instance.daysOfInventory,
      'priority': instance.priority,
    };

OptimizationMetricsModel _$OptimizationMetricsModelFromJson(
        Map<String, dynamic> json) =>
    OptimizationMetricsModel(
      stockoutRate: json['stockout_rate'] as num,
      overstockRate: json['overstock_rate'] as num,
      avgTurnover: json['avg_turnover'] as num,
      reorderNeeded: (json['reorder_needed'] as num).toInt(),
    );

Map<String, dynamic> _$OptimizationMetricsModelToJson(
        OptimizationMetricsModel instance) =>
    <String, dynamic>{
      'stockout_rate': instance.stockoutRate,
      'overstock_rate': instance.overstockRate,
      'avg_turnover': instance.avgTurnover,
      'reorder_needed': instance.reorderNeeded,
    };

InventoryOptimizationModel _$InventoryOptimizationModelFromJson(
        Map<String, dynamic> json) =>
    InventoryOptimizationModel(
      overallScore: (json['overall_score'] as num).toInt(),
      metrics: OptimizationMetricsModel.fromJson(
          json['metrics'] as Map<String, dynamic>),
      urgentOrders: (json['urgent_orders'] as List<dynamic>)
          .map((e) => ReorderProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InventoryOptimizationModelToJson(
        InventoryOptimizationModel instance) =>
    <String, dynamic>{
      'overall_score': instance.overallScore,
      'metrics': instance.metrics,
      'urgent_orders': instance.urgentOrders,
    };
