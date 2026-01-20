/// Inventory Status Enum
/// 8가지 재고 상태 분류 (priority_rank 순서)
enum InventoryStatus {
  /// 비정상 (음수 재고) - priority 1
  abnormal,

  /// 품절 - priority 2
  stockout,

  /// 긴급 (P10 이하) - priority 3
  critical,

  /// 주의 (P10~P25) - priority 4
  warning,

  /// 재주문 필요 - priority 5
  reorderNeeded,

  /// Dead Stock (90일간 판매 없음) - priority 6
  deadStock,

  /// 과잉 재고 (90일+) - priority 6
  overstock,

  /// 정상 - priority 7
  normal;

  /// status_label 문자열에서 enum 변환
  static InventoryStatus fromString(String? label) {
    return switch (label?.toLowerCase()) {
      'abnormal' => InventoryStatus.abnormal,
      'stockout' => InventoryStatus.stockout,
      'critical' => InventoryStatus.critical,
      'warning' => InventoryStatus.warning,
      'reorder_needed' => InventoryStatus.reorderNeeded,
      'overstock' => InventoryStatus.overstock,
      'dead_stock' => InventoryStatus.deadStock,
      'normal' => InventoryStatus.normal,
      _ => InventoryStatus.normal,
    };
  }

  /// 우선순위 (낮을수록 높은 우선순위)
  int get priority {
    return switch (this) {
      InventoryStatus.abnormal => 1,
      InventoryStatus.stockout => 2,
      InventoryStatus.critical => 3,
      InventoryStatus.warning => 4,
      InventoryStatus.reorderNeeded => 5,
      InventoryStatus.deadStock => 6,
      InventoryStatus.overstock => 6,
      InventoryStatus.normal => 7,
    };
  }

  /// 한글 라벨
  String get label {
    return switch (this) {
      InventoryStatus.abnormal => '비정상',
      InventoryStatus.stockout => '품절',
      InventoryStatus.critical => '긴급',
      InventoryStatus.warning => '주의',
      InventoryStatus.reorderNeeded => '재주문',
      InventoryStatus.overstock => '과잉',
      InventoryStatus.deadStock => 'Dead',
      InventoryStatus.normal => '정상',
    };
  }

  /// 영문 라벨
  String get labelEn {
    return switch (this) {
      InventoryStatus.abnormal => 'Abnormal',
      InventoryStatus.stockout => 'Stockout',
      InventoryStatus.critical => 'Critical',
      InventoryStatus.warning => 'Warning',
      InventoryStatus.reorderNeeded => 'Reorder',
      InventoryStatus.overstock => 'Overstock',
      InventoryStatus.deadStock => 'Dead Stock',
      InventoryStatus.normal => 'Normal',
    };
  }

  /// 이모지
  String get emoji {
    return switch (this) {
      InventoryStatus.abnormal => '🚨',
      InventoryStatus.stockout => '📭',
      InventoryStatus.critical => '🔥',
      InventoryStatus.warning => '⚠️',
      InventoryStatus.reorderNeeded => '📦',
      InventoryStatus.overstock => '🐌',
      InventoryStatus.deadStock => '☠️',
      InventoryStatus.normal => '✅',
    };
  }

  /// 긴급 여부 (즉각 조치 필요)
  bool get isUrgent =>
      this == InventoryStatus.abnormal ||
      this == InventoryStatus.stockout ||
      this == InventoryStatus.critical;

  /// 액션 필요 여부
  bool get needsAction =>
      this != InventoryStatus.normal && this != InventoryStatus.overstock;

  /// RPC 필터용 문자열
  String get filterValue {
    return switch (this) {
      InventoryStatus.abnormal => 'abnormal',
      InventoryStatus.stockout => 'stockout',
      InventoryStatus.critical => 'critical',
      InventoryStatus.warning => 'warning',
      InventoryStatus.reorderNeeded => 'reorder_needed',
      InventoryStatus.overstock => 'overstock',
      InventoryStatus.deadStock => 'dead_stock',
      InventoryStatus.normal => 'normal',
    };
  }
}
