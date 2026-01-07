import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_optimization.freezed.dart';

/// 주문 우선순위
enum ReorderPriority {
  critical, // 버틸일 < 0 또는 재고 부족
  warning,  // 버틸일 < 7
  normal,   // 버틸일 >= 7
}

/// 주문 필요 제품 데이터
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
    required num daysLeft, // 버틸 일수 (음수 가능)
    required String priority, // 'critical', 'warning', 'normal'
  }) = _ReorderProduct;

  ReorderPriority get priorityType {
    return switch (priority) {
      'critical' => ReorderPriority.critical,
      'warning' => ReorderPriority.warning,
      _ => ReorderPriority.normal,
    };
  }

  /// 우선순위 라벨
  String get priorityLabel {
    return switch (priorityType) {
      ReorderPriority.critical => '긴급',
      ReorderPriority.warning => '주의',
      ReorderPriority.normal => '보통',
    };
  }

  /// 재고 상태 긴급 여부
  bool get isUrgent => priorityType == ReorderPriority.critical;

  /// 버틸일 표시 텍스트
  String get daysLeftText {
    if (daysLeft < 0) return '${daysLeft.toStringAsFixed(0)}일 (재고 부족)';
    if (daysLeft == 0) return '오늘 소진 예정';
    return '${daysLeft.toStringAsFixed(0)}일';
  }
}

/// 재고 최적화 종합 지표
@freezed
class OptimizationMetrics with _$OptimizationMetrics {
  const OptimizationMetrics._();

  const factory OptimizationMetrics({
    required num stockoutRate,    // 품절률 (%)
    required num overstockRate,   // 과잉재고율 (%)
    required num avgTurnover,     // 평균 재고회전율
    required int reorderNeeded,   // 주문 필요 제품 수
  }) = _OptimizationMetrics;

  /// 품절률 상태
  String get stockoutStatus {
    if (stockoutRate <= 3) return 'good';
    if (stockoutRate <= 5) return 'warning';
    return 'critical';
  }

  /// 과잉재고 상태
  String get overstockStatus {
    if (overstockRate <= 5) return 'good';
    if (overstockRate <= 10) return 'warning';
    return 'critical';
  }

  /// 회전율 상태
  String get turnoverStatus {
    if (avgTurnover >= 5) return 'good';
    if (avgTurnover >= 3) return 'warning';
    return 'critical';
  }
}

/// 재고 최적화 대시보드 데이터
/// RPC: get_inventory_optimization_dashboard 응답
@freezed
class InventoryOptimization with _$InventoryOptimization {
  const InventoryOptimization._();

  const factory InventoryOptimization({
    required int overallScore, // 0-100
    required OptimizationMetrics metrics,
    required List<ReorderProduct> urgentOrders, // Top 10
  }) = _InventoryOptimization;

  /// 전체 상태 판정
  String get status {
    if (overallScore >= 80) return 'good';
    if (overallScore >= 60) return 'warning';
    return 'critical';
  }

  /// 긴급 주문 수
  int get criticalCount =>
      urgentOrders.where((p) => p.priorityType == ReorderPriority.critical).length;

  /// 주의 주문 수
  int get warningCount =>
      urgentOrders.where((p) => p.priorityType == ReorderPriority.warning).length;

  /// 상태 텍스트
  String get statusText {
    if (metrics.reorderNeeded == 0) return '재고 최적';
    return '${metrics.reorderNeeded}개 주문 필요';
  }
}
