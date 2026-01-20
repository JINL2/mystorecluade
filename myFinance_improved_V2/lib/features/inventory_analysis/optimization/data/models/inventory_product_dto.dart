import '../../domain/entities/inventory_product.dart';

/// InventoryProduct DTO
/// RPC 응답에서 변환
class InventoryProductDto {
  final String productId;
  final String productName;
  final String? categoryId;
  final String? categoryName;
  final String? brandName;
  final int currentStock;
  final int reorderPoint;
  final double avgDailyDemand;
  final double daysOfInventory;
  final String statusLabel;
  final int priorityRank;
  final bool isAbnormal;
  final bool isStockout;
  final bool isCritical;
  final bool isWarning;
  final bool isReorderNeeded;
  final bool isOverstock;
  final bool isDeadStock;

  const InventoryProductDto({
    required this.productId,
    required this.productName,
    this.categoryId,
    this.categoryName,
    this.brandName,
    required this.currentStock,
    required this.reorderPoint,
    required this.avgDailyDemand,
    required this.daysOfInventory,
    required this.statusLabel,
    required this.priorityRank,
    this.isAbnormal = false,
    this.isStockout = false,
    this.isCritical = false,
    this.isWarning = false,
    this.isReorderNeeded = false,
    this.isOverstock = false,
    this.isDeadStock = false,
  });

  factory InventoryProductDto.fromJson(Map<String, dynamic> json) {
    return InventoryProductDto(
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? 'Unknown',
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      brandName: json['brand_name'] as String?,
      currentStock: (json['current_stock'] as num?)?.toInt() ?? 0,
      reorderPoint: (json['reorder_point'] as num?)?.toInt() ?? 0,
      avgDailyDemand: (json['avg_daily_demand'] as num?)?.toDouble() ?? 0.0,
      daysOfInventory: (json['days_of_inventory'] as num?)?.toDouble() ?? 0.0,
      statusLabel: json['status_label'] as String? ?? 'normal',
      priorityRank: (json['priority_rank'] as num?)?.toInt() ?? 7,
      isAbnormal: json['is_abnormal'] as bool? ?? false,
      isStockout: json['is_stockout'] as bool? ?? false,
      isCritical: json['is_critical'] as bool? ?? false,
      isWarning: json['is_warning'] as bool? ?? false,
      isReorderNeeded: json['is_reorder_needed'] as bool? ?? false,
      isOverstock: json['is_overstock'] as bool? ?? false,
      isDeadStock: json['is_dead_stock'] as bool? ?? false,
    );
  }

  InventoryProduct toEntity() {
    return InventoryProduct(
      productId: productId,
      productName: productName,
      categoryId: categoryId,
      categoryName: categoryName,
      brandName: brandName,
      currentStock: currentStock,
      reorderPoint: reorderPoint,
      avgDailyDemand: avgDailyDemand,
      daysOfInventory: daysOfInventory,
      statusLabel: statusLabel,
      priorityRank: priorityRank,
      isAbnormal: isAbnormal,
      isStockout: isStockout,
      isCritical: isCritical,
      isWarning: isWarning,
      isReorderNeeded: isReorderNeeded,
      isOverstock: isOverstock,
      isDeadStock: isDeadStock,
    );
  }
}
