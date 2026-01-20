import 'package:freezed_annotation/freezed_annotation.dart';

import 'category_summary.dart';
import 'inventory_health.dart';
import 'inventory_product.dart';
import 'threshold_info.dart';

part 'inventory_dashboard.freezed.dart';

/// 대시보드 통합 Entity
/// get_inventory_health_dashboard RPC 응답
@freezed
class InventoryDashboard with _$InventoryDashboard {
  const InventoryDashboard._();

  const factory InventoryDashboard({
    /// 건강도 요약
    required InventoryHealth health,

    /// 임계값 정보
    required ThresholdInfo thresholds,

    /// Top 카테고리 (최대 5개)
    required List<CategorySummary> topCategories,

    /// 긴급 상품 목록 (최대 10개)
    required List<InventoryProduct> urgentProducts,

    /// 비정상 상품 목록 (최대 10개)
    required List<InventoryProduct> abnormalProducts,
  }) = _InventoryDashboard;

  /// 긴급 처리 필요 여부
  bool get hasUrgentItems =>
      health.abnormalCount > 0 || health.criticalCount > 0;

  /// 비정상 데이터 존재 여부
  bool get hasAbnormalData => health.abnormalCount > 0;

  /// 전체 상태 (good/warning/critical)
  String get overallStatus => health.overallStatus;

  /// Mock 데이터 (스켈레톤용)
  static InventoryDashboard mock() => InventoryDashboard(
        health: InventoryHealth.mock(),
        thresholds: ThresholdInfo.mock(),
        topCategories: CategorySummary.mockList(5),
        urgentProducts: InventoryProduct.mockList(5),
        abnormalProducts: [],
      );
}
