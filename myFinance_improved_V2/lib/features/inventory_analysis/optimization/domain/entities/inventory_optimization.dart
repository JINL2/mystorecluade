import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_optimization.freezed.dart';

/// Reorder priority
enum ReorderPriority {
  critical, // days_left < 0 or out of stock
  warning,  // days_left < 7
  normal,   // days_left >= 7
}

/// Reorder product data
@freezed
class ReorderProduct with _$ReorderProduct {
  const ReorderProduct._();

  const factory ReorderProduct({
    required String productId,
    required String productName,
    required String? categoryName,
    required num currentStock,
    required num reorderPoint,
    required num orderQty,
    required num avgDailyDemand,
    required num daysLeft, // Days of inventory (can be negative)
    required String priority, // 'Critical', 'Warning', 'Normal'
  }) = _ReorderProduct;

  ReorderPriority get priorityType {
    return switch (priority.toLowerCase()) {
      'critical' => ReorderPriority.critical,
      'warning' => ReorderPriority.warning,
      _ => ReorderPriority.normal,
    };
  }

  /// Priority label
  String get priorityLabel {
    return switch (priorityType) {
      ReorderPriority.critical => 'Critical',
      ReorderPriority.warning => 'Warning',
      ReorderPriority.normal => 'Normal',
    };
  }

  /// Whether stock status is urgent
  bool get isUrgent => priorityType == ReorderPriority.critical;

  /// Days left display text
  String get daysLeftText {
    if (daysLeft < 0) return '${daysLeft.toStringAsFixed(0)} days (out of stock)';
    if (daysLeft == 0) return 'Depleted today';
    return '${daysLeft.toStringAsFixed(0)} days';
  }
}

/// Inventory optimization metrics
@freezed
class OptimizationMetrics with _$OptimizationMetrics {
  const OptimizationMetrics._();

  const factory OptimizationMetrics({
    required num stockoutRate,    // Stockout rate (%)
    required num overstockRate,   // Overstock rate (%)
    required num avgTurnover,     // Average inventory turnover
    required int reorderNeeded,   // Number of products needing reorder
  }) = _OptimizationMetrics;

  /// Stockout rate status
  String get stockoutStatus {
    if (stockoutRate <= 3) return 'good';
    if (stockoutRate <= 5) return 'warning';
    return 'critical';
  }

  /// Overstock status
  String get overstockStatus {
    if (overstockRate <= 5) return 'good';
    if (overstockRate <= 10) return 'warning';
    return 'critical';
  }

  /// Turnover status
  String get turnoverStatus {
    if (avgTurnover >= 5) return 'good';
    if (avgTurnover >= 3) return 'warning';
    return 'critical';
  }
}

/// Inventory optimization dashboard data
/// RPC: get_inventory_optimization_dashboard response
@freezed
class InventoryOptimization with _$InventoryOptimization {
  const InventoryOptimization._();

  const factory InventoryOptimization({
    required int overallScore, // 0-100
    required OptimizationMetrics metrics,
    required List<ReorderProduct> urgentOrders, // Top 10
  }) = _InventoryOptimization;

  /// Overall status
  String get status {
    if (overallScore >= 80) return 'good';
    if (overallScore >= 60) return 'warning';
    return 'critical';
  }

  /// Critical order count
  int get criticalCount =>
      urgentOrders.where((p) => p.priorityType == ReorderPriority.critical).length;

  /// Warning order count
  int get warningCount =>
      urgentOrders.where((p) => p.priorityType == ReorderPriority.warning).length;

  /// Status text
  String get statusText {
    if (metrics.reorderNeeded == 0) return 'Optimal inventory';
    return '${metrics.reorderNeeded} reorders needed';
  }
}
