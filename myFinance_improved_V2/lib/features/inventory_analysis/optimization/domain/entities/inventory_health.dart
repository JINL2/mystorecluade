import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_health.freezed.dart';

/// 재고 건강도 Entity
/// 회사 전체 재고 현황 요약
@freezed
class InventoryHealth with _$InventoryHealth {
  const InventoryHealth._();

  const factory InventoryHealth({
    /// 전체 상품 수
    required int totalProducts,

    /// 품절 수
    required int stockoutCount,

    /// 품절률 (%)
    required double stockoutRate,

    /// 긴급 수 (P10 이하)
    required int criticalCount,

    /// 긴급률 (%)
    required double criticalRate,

    /// 주의 수 (P10~P25)
    required int warningCount,

    /// 주의율 (%)
    required double warningRate,

    /// 재주문 필요 수 (품절 제외)
    required int reorderNeededCount,

    /// 과잉 재고 수
    required int overstockCount,

    /// 과잉률 (%)
    required double overstockRate,

    /// Dead Stock 수 (90일간 판매 없음)
    required int deadStockCount,

    /// Dead Stock률 (%)
    required double deadStockRate,

    /// 비정상 수 (음수 재고)
    required int abnormalCount,

    /// 정상 수
    required int normalCount,
  }) = _InventoryHealth;

  /// 비정상률 (%)
  double get abnormalRate =>
      totalProducts > 0 ? (abnormalCount / totalProducts) * 100 : 0;

  /// 정상률 (%)
  double get normalRate =>
      totalProducts > 0 ? (normalCount / totalProducts) * 100 : 0;

  /// 재주문률 (%)
  double get reorderRate =>
      totalProducts > 0 ? (reorderNeededCount / totalProducts) * 100 : 0;

  /// 액션 필요 총 수 (abnormal + stockout + critical + warning)
  int get actionNeededCount =>
      abnormalCount + stockoutCount + criticalCount + warningCount;

  /// 전반적 건강 상태 (good/warning/critical)
  String get overallStatus {
    if (abnormalCount > 0 || stockoutRate > 50) return 'critical';
    if (criticalCount > 10 || stockoutRate > 30) return 'warning';
    return 'good';
  }

  /// 재고 있는 상품 수
  int get inStockCount => totalProducts - stockoutCount;

  /// Mock 데이터 (스켈레톤용)
  static InventoryHealth mock() => const InventoryHealth(
        totalProducts: 0,
        stockoutCount: 0,
        stockoutRate: 0,
        criticalCount: 0,
        criticalRate: 0,
        warningCount: 0,
        warningRate: 0,
        reorderNeededCount: 0,
        overstockCount: 0,
        overstockRate: 0,
        deadStockCount: 0,
        deadStockRate: 0,
        abnormalCount: 0,
        normalCount: 0,
      );
}
