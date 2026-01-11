import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/inventory_optimization.dart';

part 'inventory_optimization_model.g.dart';

/// Reorder product Model
/// RPC: get_inventory_reorder_list response item
/// Note: RPC uses different field names:
///   - order_qty OR suggested_order_qty
///   - days_left OR days_of_inventory
@JsonSerializable(fieldRename: FieldRename.snake)
class ReorderProductModel {
  @JsonKey(name: 'product_id')
  final String? productId;
  @JsonKey(name: 'product_name')
  final String productName;
  @JsonKey(name: 'category_name')
  final String? categoryName;
  @JsonKey(name: 'current_stock')
  final num currentStock;
  @JsonKey(name: 'reorder_point')
  final num reorderPoint;
  @JsonKey(name: 'order_qty')
  final num? orderQty;
  @JsonKey(name: 'suggested_order_qty')
  final num? suggestedOrderQty;
  @JsonKey(name: 'avg_daily_demand')
  final num avgDailyDemand;
  @JsonKey(name: 'days_left')
  final num? daysLeft;
  @JsonKey(name: 'days_of_inventory')
  final num? daysOfInventory;
  final String? priority;

  ReorderProductModel({
    this.productId,
    required this.productName,
    this.categoryName,
    required this.currentStock,
    required this.reorderPoint,
    this.orderQty,
    this.suggestedOrderQty,
    required this.avgDailyDemand,
    this.daysLeft,
    this.daysOfInventory,
    this.priority,
  });

  /// Get actual order quantity (from either field)
  num get actualOrderQty => orderQty ?? suggestedOrderQty ?? 0;

  /// Get actual days left (from either field)
  num get actualDaysLeft => daysLeft ?? daysOfInventory ?? 0;

  factory ReorderProductModel.fromJson(Map<String, dynamic> json) =>
      _$ReorderProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReorderProductModelToJson(this);

  ReorderProduct toEntity() => ReorderProduct(
        productId: productId ?? '',
        productName: productName,
        categoryName: categoryName,
        currentStock: currentStock,
        reorderPoint: reorderPoint,
        orderQty: actualOrderQty,
        avgDailyDemand: avgDailyDemand,
        daysLeft: actualDaysLeft,
        priority: priority ?? _computePriority(),
      );

  /// Compute priority based on days_left if not provided by RPC
  String _computePriority() {
    if (actualDaysLeft <= 0) return 'Critical';
    if (actualDaysLeft <= 7) return 'Warning';
    return 'Normal';
  }
}

/// Inventory optimization metrics Model
@JsonSerializable(fieldRename: FieldRename.snake)
class OptimizationMetricsModel {
  @JsonKey(name: 'stockout_rate')
  final num stockoutRate;
  @JsonKey(name: 'overstock_rate')
  final num overstockRate;
  @JsonKey(name: 'avg_turnover')
  final num avgTurnover;
  @JsonKey(name: 'reorder_needed')
  final int reorderNeeded;

  OptimizationMetricsModel({
    required this.stockoutRate,
    required this.overstockRate,
    required this.avgTurnover,
    required this.reorderNeeded,
  });

  factory OptimizationMetricsModel.fromJson(Map<String, dynamic> json) =>
      _$OptimizationMetricsModelFromJson(json);

  Map<String, dynamic> toJson() => _$OptimizationMetricsModelToJson(this);

  OptimizationMetrics toEntity() => OptimizationMetrics(
        stockoutRate: stockoutRate,
        overstockRate: overstockRate,
        avgTurnover: avgTurnover,
        reorderNeeded: reorderNeeded,
      );
}

/// Inventory optimization dashboard Model
/// RPC: get_inventory_optimization_dashboard response
@JsonSerializable(fieldRename: FieldRename.snake)
class InventoryOptimizationModel {
  @JsonKey(name: 'overall_score')
  final int overallScore;
  final OptimizationMetricsModel metrics;
  @JsonKey(name: 'urgent_orders')
  final List<ReorderProductModel> urgentOrders;

  InventoryOptimizationModel({
    required this.overallScore,
    required this.metrics,
    required this.urgentOrders,
  });

  factory InventoryOptimizationModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryOptimizationModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryOptimizationModelToJson(this);

  InventoryOptimization toEntity() => InventoryOptimization(
        overallScore: overallScore,
        metrics: metrics.toEntity(),
        urgentOrders: urgentOrders.map((o) => o.toEntity()).toList(),
      );
}
