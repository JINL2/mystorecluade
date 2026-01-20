import 'package:freezed_annotation/freezed_annotation.dart';

import 'inventory_status.dart';

part 'inventory_product.freezed.dart';

/// 개별 상품 Entity
/// 상품별 재고 상태 정보
@freezed
class InventoryProduct with _$InventoryProduct {
  const InventoryProduct._();

  const factory InventoryProduct({
    /// 상품 ID
    required String productId,

    /// 상품명
    required String productName,

    /// 카테고리 ID
    String? categoryId,

    /// 카테고리명
    String? categoryName,

    /// 브랜드명
    String? brandName,

    /// 현재 재고
    required int currentStock,

    /// 재주문점
    required int reorderPoint,

    /// 일평균 판매량
    required double avgDailyDemand,

    /// 남은 재고일
    required double daysOfInventory,

    /// 상태 라벨 (abnormal, critical, warning, etc.)
    required String statusLabel,

    /// 우선순위
    required int priorityRank,

    /// 비정상 여부 (음수 재고)
    @Default(false) bool isAbnormal,

    /// 품절 여부
    @Default(false) bool isStockout,

    /// 긴급 여부
    @Default(false) bool isCritical,

    /// 주의 여부
    @Default(false) bool isWarning,

    /// 재주문 필요 여부
    @Default(false) bool isReorderNeeded,

    /// 과잉 여부
    @Default(false) bool isOverstock,

    /// Dead Stock 여부
    @Default(false) bool isDeadStock,
  }) = _InventoryProduct;

  /// 상태 enum
  InventoryStatus get status => InventoryStatus.fromString(statusLabel);

  /// 긴급 여부 (즉각 조치 필요)
  bool get isUrgent => isAbnormal || isStockout || isCritical;

  /// 재고일 표시 텍스트
  String get daysLeftText {
    if (isAbnormal) return '비정상';
    if (isStockout) return '품절';
    if (daysOfInventory < 0) return '${daysOfInventory.toStringAsFixed(0)}일';
    if (daysOfInventory == 0) return '오늘 소진';
    if (daysOfInventory < 1) return '${(daysOfInventory * 24).toStringAsFixed(0)}시간';
    return '${daysOfInventory.toStringAsFixed(1)}일';
  }

  /// 재고일 표시 텍스트 (영문)
  String get daysLeftTextEn {
    if (isAbnormal) return 'Abnormal';
    if (isStockout) return 'Stockout';
    if (daysOfInventory < 0) return '${daysOfInventory.toStringAsFixed(0)} days';
    if (daysOfInventory == 0) return 'Depleted today';
    if (daysOfInventory < 1) return '${(daysOfInventory * 24).toStringAsFixed(0)} hours';
    return '${daysOfInventory.toStringAsFixed(1)} days';
  }

  /// Mock 데이터 (스켈레톤용)
  static InventoryProduct mock() => const InventoryProduct(
        productId: 'mock-id',
        productName: 'Product Name',
        categoryName: 'Category',
        currentStock: 0,
        reorderPoint: 0,
        avgDailyDemand: 0,
        daysOfInventory: 0,
        statusLabel: 'normal',
        priorityRank: 7,
      );

  static List<InventoryProduct> mockList([int count = 10]) =>
      List.generate(count, (_) => mock());
}
