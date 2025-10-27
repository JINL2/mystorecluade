import 'package:freezed_annotation/freezed_annotation.dart';

part 'aging_analysis.freezed.dart';

/// Aging analysis for debt tracking
@freezed
class AgingAnalysis with _$AgingAnalysis {
  const factory AgingAnalysis({
    @Default(0.0) double current,
    @Default(0.0) double overdue30,
    @Default(0.0) double overdue60,
    @Default(0.0) double overdue90,
    @Default([]) List<AgingTrendPoint> trend,
  }) = _AgingAnalysis;

  const AgingAnalysis._();

  /// Get total aged debt
  double get totalAgedDebt => current + overdue30 + overdue60 + overdue90;

  /// Get overdue percentage
  double get overduePercentage {
    if (totalAgedDebt == 0) return 0;
    final overdue = overdue30 + overdue60 + overdue90;
    return (overdue / totalAgedDebt) * 100;
  }

  /// Get critical overdue (90+ days) percentage
  double get criticalOverduePercentage {
    if (totalAgedDebt == 0) return 0;
    return (overdue90 / totalAgedDebt) * 100;
  }

  /// Check if aging is healthy (most debt is current)
  bool get isHealthy => current >= (totalAgedDebt * 0.7);
}

/// Aging trend data point
@freezed
class AgingTrendPoint with _$AgingTrendPoint {
  const factory AgingTrendPoint({
    required DateTime date,
    required double current,
    required double overdue30,
    required double overdue60,
    required double overdue90,
  }) = _AgingTrendPoint;
}
