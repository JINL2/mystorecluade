import '../../domain/entities/inventory_health.dart';

/// InventoryHealth DTO
/// RPC 응답에서 변환
class InventoryHealthDto {
  final int totalProducts;
  final int stockoutCount;
  final double stockoutRate;
  final int criticalCount;
  final double criticalRate;
  final int warningCount;
  final double warningRate;
  final int reorderNeededCount;
  final int overstockCount;
  final double overstockRate;
  final int deadStockCount;
  final double deadStockRate;
  final int abnormalCount;
  final int normalCount;

  const InventoryHealthDto({
    required this.totalProducts,
    required this.stockoutCount,
    required this.stockoutRate,
    required this.criticalCount,
    required this.criticalRate,
    required this.warningCount,
    required this.warningRate,
    required this.reorderNeededCount,
    required this.overstockCount,
    required this.overstockRate,
    required this.deadStockCount,
    required this.deadStockRate,
    required this.abnormalCount,
    required this.normalCount,
  });

  factory InventoryHealthDto.fromJson(Map<String, dynamic> json) {
    return InventoryHealthDto(
      totalProducts: (json['total_products'] as num?)?.toInt() ?? 0,
      stockoutCount: (json['stockout_count'] as num?)?.toInt() ?? 0,
      stockoutRate: (json['stockout_rate'] as num?)?.toDouble() ?? 0.0,
      criticalCount: (json['critical_count'] as num?)?.toInt() ?? 0,
      criticalRate: (json['critical_rate'] as num?)?.toDouble() ?? 0.0,
      warningCount: (json['warning_count'] as num?)?.toInt() ?? 0,
      warningRate: (json['warning_rate'] as num?)?.toDouble() ?? 0.0,
      reorderNeededCount: (json['reorder_needed_count'] as num?)?.toInt() ?? 0,
      overstockCount: (json['overstock_count'] as num?)?.toInt() ?? 0,
      overstockRate: (json['overstock_rate'] as num?)?.toDouble() ?? 0.0,
      deadStockCount: (json['dead_stock_count'] as num?)?.toInt() ?? 0,
      deadStockRate: (json['dead_stock_rate'] as num?)?.toDouble() ?? 0.0,
      abnormalCount: (json['abnormal_count'] as num?)?.toInt() ?? 0,
      normalCount: (json['normal_count'] as num?)?.toInt() ?? 0,
    );
  }

  InventoryHealth toEntity() {
    return InventoryHealth(
      totalProducts: totalProducts,
      stockoutCount: stockoutCount,
      stockoutRate: stockoutRate,
      criticalCount: criticalCount,
      criticalRate: criticalRate,
      warningCount: warningCount,
      warningRate: warningRate,
      reorderNeededCount: reorderNeededCount,
      overstockCount: overstockCount,
      overstockRate: overstockRate,
      deadStockCount: deadStockCount,
      deadStockRate: deadStockRate,
      abnormalCount: abnormalCount,
      normalCount: normalCount,
    );
  }
}
