import 'package:freezed_annotation/freezed_annotation.dart';

part 'discrepancy_overview.freezed.dart';

/// 매장별 재고 불일치 데이터
@freezed
class StoreDiscrepancy with _$StoreDiscrepancy {
  const StoreDiscrepancy._();

  const factory StoreDiscrepancy({
    required String storeId,
    required String storeName,
    required int totalEvents,
    required int increaseCount,
    required int decreaseCount,
    required num increaseValue,
    required num decreaseValue,
    required num netValue,
    String? status, // 'abnormal', 'warning', 'normal' (통계 검정 결과)
  }) = _StoreDiscrepancy;

  /// 증가/감소 비율 (증가 건수 / 전체 건수)
  num get increaseRatio =>
      totalEvents > 0 ? increaseCount / totalEvents : 0;

  /// 순손익 비율 (순손익 / 감소금액)
  num? get netRatio =>
      decreaseValue != 0 ? netValue / decreaseValue * 100 : null;

  /// 상태 라벨
  String get statusLabel {
    return switch (status) {
      'abnormal' => '통계적 이상',
      'warning' => '주의',
      _ => '정상 범위',
    };
  }
}

/// 재고 불일치 종합 데이터
/// RPC: get_discrepancy_overview 응답
@freezed
class DiscrepancyOverview with _$DiscrepancyOverview {
  const DiscrepancyOverview._();

  const factory DiscrepancyOverview({
    required String status, // 'ok', 'insufficient_data'
    String? message,
    String? minRequired,
    required num totalIncreaseValue,
    required num totalDecreaseValue,
    required num netValue,
    required int totalStores,
    required int totalEvents,
    required List<StoreDiscrepancy> stores,
  }) = _DiscrepancyOverview;

  /// 데이터 부족 여부
  bool get isInsufficientData => status == 'insufficient_data';

  /// 분석 가능 여부
  bool get canAnalyze => status == 'ok';

  /// 순손익 비율
  num? get netRatio {
    if (totalDecreaseValue == 0) return null;
    return netValue / totalDecreaseValue * 100;
  }

  /// 전체 상태 판정 (분석 가능 시)
  String get analysisStatus {
    if (isInsufficientData) return 'insufficient';

    // 순손실이 10% 이상이면 critical
    if (netRatio != null && netRatio! < -10) return 'critical';
    // 순손실이 5% 이상이면 warning
    if (netRatio != null && netRatio! < -5) return 'warning';
    return 'good';
  }

  /// 이상 매장 수
  int get abnormalStoreCount =>
      stores.where((s) => s.status == 'abnormal').length;
}
