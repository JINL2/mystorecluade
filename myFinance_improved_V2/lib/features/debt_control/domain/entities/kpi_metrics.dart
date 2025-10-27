import 'package:freezed_annotation/freezed_annotation.dart';

part 'kpi_metrics.freezed.dart';

/// KPI metrics for debt control dashboard
@freezed
class KpiMetrics with _$KpiMetrics {
  const factory KpiMetrics({
    @Default(0.0) double netPosition,
    @Default(0.0) double netPositionTrend,
    @Default(0) int avgDaysOutstanding,
    @Default(0.0) double agingTrend,
    @Default(0.0) double collectionRate,
    @Default(0.0) double collectionTrend,
    @Default(0) int criticalCount,
    @Default(0.0) double criticalTrend,
    @Default(0.0) double totalReceivable,
    @Default(0.0) double totalPayable,
    @Default(0) int transactionCount,
  }) = _KpiMetrics;

  const KpiMetrics._();

  /// Check if metrics show healthy financial position
  bool get isHealthy => netPosition >= 0 && criticalCount == 0;

  /// Get risk level based on metrics
  String get riskLevel {
    if (criticalCount > 5) return 'high';
    if (criticalCount > 2) return 'medium';
    return 'low';
  }

  /// Calculate debt coverage ratio
  double get debtCoverageRatio {
    if (totalPayable == 0) return double.infinity;
    return totalReceivable / totalPayable;
  }
}
