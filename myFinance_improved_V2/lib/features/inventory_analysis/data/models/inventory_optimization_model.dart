import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/inventory_optimization.dart';

part 'inventory_optimization_model.g.dart';

/// 주문 필요 제품 Model
/// RPC: get_inventory_reorder_list 응답 item
@JsonSerializable(fieldRename: FieldRename.snake)
class ReorderProductModel {
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'product_name')
  final String productName;
  @JsonKey(name: 'category_name')
  final String? categoryName;
  @JsonKey(name: 'current_stock')
  final num currentStock;
  @JsonKey(name: 'reorder_point')
  final num reorderPoint;
  @JsonKey(name: 'order_qty')
  final num orderQty;
  @JsonKey(name: 'avg_daily_demand')
  final num avgDailyDemand;
  @JsonKey(name: 'days_left')
  final num daysLeft;
  final String priority;

  ReorderProductModel({
    required this.productId,
    required this.productName,
    this.categoryName,
    required this.currentStock,
    required this.reorderPoint,
    required this.orderQty,
    required this.avgDailyDemand,
    required this.daysLeft,
    required this.priority,
  });

  factory ReorderProductModel.fromJson(Map<String, dynamic> json) =>
      _$ReorderProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReorderProductModelToJson(this);

  ReorderProduct toEntity() => ReorderProduct(
        productId: productId,
        productName: productName,
        categoryName: categoryName,
        currentStock: currentStock,
        reorderPoint: reorderPoint,
        orderQty: orderQty,
        avgDailyDemand: avgDailyDemand,
        daysLeft: daysLeft,
        priority: priority,
      );
}

/// 재고 최적화 지표 Model
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

/// 재고 최적화 대시보드 Model
/// RPC: get_inventory_optimization_dashboard 응답
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
