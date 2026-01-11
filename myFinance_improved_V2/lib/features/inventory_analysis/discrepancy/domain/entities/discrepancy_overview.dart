import 'package:freezed_annotation/freezed_annotation.dart';

part 'discrepancy_overview.freezed.dart';

/// Store inventory discrepancy data
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
    String? status, // 'abnormal', 'warning', 'normal' (statistical test result)
  }) = _StoreDiscrepancy;

  /// Increase/decrease ratio (increase count / total count)
  num get increaseRatio =>
      totalEvents > 0 ? increaseCount / totalEvents : 0;

  /// Net ratio (net value / decrease value)
  num? get netRatio =>
      decreaseValue != 0 ? netValue / decreaseValue * 100 : null;

  /// Status label
  String get statusLabel {
    return switch (status) {
      'abnormal' => 'Statistical anomaly',
      'warning' => 'Warning',
      _ => 'Normal range',
    };
  }
}

/// Inventory discrepancy aggregate data
/// RPC: get_discrepancy_overview response
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

  /// Whether data is insufficient
  bool get isInsufficientData => status == 'insufficient_data';

  /// Whether analysis is possible
  bool get canAnalyze => status == 'ok';

  /// Net ratio
  num? get netRatio {
    if (totalDecreaseValue == 0) return null;
    return netValue / totalDecreaseValue * 100;
  }

  /// Overall status (when analysis is possible)
  String get analysisStatus {
    if (isInsufficientData) return 'insufficient';

    // Net loss >= 10% is critical
    if (netRatio != null && netRatio! < -10) return 'critical';
    // Net loss >= 5% is warning
    if (netRatio != null && netRatio! < -5) return 'warning';
    return 'good';
  }

  /// Abnormal store count
  int get abnormalStoreCount =>
      stores.where((s) => s.status == 'abnormal').length;
}
