import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_health_dashboard.freezed.dart';

/// Inventory Health Dashboard Entity
/// inventory_analysis_get_inventory_health_dashboard RPC 응답
@freezed
class InventoryHealthDashboard with _$InventoryHealthDashboard {
  const InventoryHealthDashboard._();

  const factory InventoryHealthDashboard({
    /// 요약 통계
    required HealthSummary summary,

    /// 카테고리별 긴급도 (urgency_score 내림차순)
    required List<HealthCategory> categories,

    /// 긴급 재주문 필요 상품 (high sales velocity + low stock)
    required List<HealthProduct> urgentProducts,

    /// 일반 재주문 필요 상품 (low sales velocity + low stock)
    required List<HealthProduct> normalProducts,

    /// 과잉 재고 상품
    required List<OverstockProduct> overstockProducts,

    /// 재고 실사 필요 상품 (negative stock)
    required List<RecountProduct> recountProducts,
  }) = _InventoryHealthDashboard;

  /// 액션 필요 총 수
  int get totalActionNeeded =>
      summary.urgentCount + summary.normalCount + summary.recountCount;

  /// 전반적 상태
  String get overallStatus {
    if (summary.recountCount > 0 || summary.urgentCount > 5) return 'critical';
    if (summary.urgentCount > 0 || summary.normalCount > 10) return 'warning';
    return 'good';
  }

  /// Empty 상태
  static InventoryHealthDashboard empty() => const InventoryHealthDashboard(
        summary: HealthSummary(
          totalProducts: 0,
          urgentCount: 0,
          urgentPct: 0,
          normalCount: 0,
          normalPct: 0,
          sufficientCount: 0,
          sufficientPct: 0,
          overstockCount: 0,
          overstockPct: 0,
          recountCount: 0,
          recountPct: 0,
          totalReorderNeeded: 0,
        ),
        categories: [],
        urgentProducts: [],
        normalProducts: [],
        overstockProducts: [],
        recountProducts: [],
      );
}

/// 요약 통계
@freezed
class HealthSummary with _$HealthSummary {
  const factory HealthSummary({
    required int totalProducts,
    required int urgentCount,
    required double urgentPct,
    required int normalCount,
    required double normalPct,
    required int sufficientCount,
    required double sufficientPct,
    required int overstockCount,
    required double overstockPct,
    required int recountCount,
    required double recountPct,
    required int totalReorderNeeded,
  }) = _HealthSummary;
}

/// 카테고리별 긴급도
@freezed
class HealthCategory with _$HealthCategory {
  const HealthCategory._();

  const factory HealthCategory({
    required String categoryId,
    required String categoryName,
    required int totalProducts,
    required int urgentCount,
    required int normalCount,
    required int sufficientCount,
    required int overstockCount,
    required int recountCount,
    required int urgencyScore,
    required String urgencyLevel, // high, medium, low, none
  }) = _HealthCategory;

  /// 재주문 필요 총 수
  int get reorderNeeded => urgentCount + normalCount;
}

/// 긴급/일반 재주문 상품
@freezed
class HealthProduct with _$HealthProduct {
  const factory HealthProduct({
    required String productId,
    required String productName,
    required String? sku,
    required String? variantId,
    required String? variantName,
    required String categoryName,
    required String? brandName,
    required int currentStock,
    required double avgDailySales,
    required double daysOfInventory,
    required int leadTimeDays,
    required double daysUntilStockout,
    required DateTime? estimatedStockoutDate,
    required String urgencyReason,

    /// 주문 수량 관련 필드 (v1.2)
    required int safetyStock,
    required int reorderPoint,
    required int targetStock,
    required int recommendedOrderQty,
  }) = _HealthProduct;
}

/// 과잉 재고 상품
@freezed
class OverstockProduct with _$OverstockProduct {
  const factory OverstockProduct({
    required String productId,
    required String productName,
    required String? sku,
    required String? variantId,
    required String? variantName,
    required String categoryName,
    required String? brandName,
    required int currentStock,
    required double avgDailySales,
    required double daysOfInventory,
    required double monthsOfInventory,
    required String overstockReason,

    /// 주문 수량 관련 필드 (v1.2)
    required int safetyStock,
    required int targetStock,
    required int recommendedOrderQty,
  }) = _OverstockProduct;
}

/// 재고 실사 필요 상품
@freezed
class RecountProduct with _$RecountProduct {
  const factory RecountProduct({
    required String productId,
    required String productName,
    required String? sku,
    required String? variantId,
    required String? variantName,
    required String categoryName,
    required String? brandName,
    required int currentStock, // negative value
    required String recountReason,
  }) = _RecountProduct;
}
