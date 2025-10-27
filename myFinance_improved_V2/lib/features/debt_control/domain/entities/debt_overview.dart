import 'package:freezed_annotation/freezed_annotation.dart';
import 'kpi_metrics.dart';
import 'aging_analysis.dart';
import 'critical_alert.dart';
import 'prioritized_debt.dart';

part 'debt_overview.freezed.dart';

/// Smart debt overview with AI-driven insights
@freezed
class DebtOverview with _$DebtOverview {
  const factory DebtOverview({
    required KpiMetrics kpiMetrics,
    required AgingAnalysis agingAnalysis,
    @Default([]) List<CriticalAlert> criticalAlerts,
    @Default([]) List<PrioritizedDebt> topRisks,
    String? viewpointDescription,
    DateTime? lastUpdated,
  }) = _DebtOverview;

  const DebtOverview._();

  /// Get unread alert count
  int get unreadAlertCount =>
      criticalAlerts.where((alert) => !alert.isRead).length;

  /// Check if overview has critical issues
  bool get hasCriticalIssues =>
      criticalAlerts.any((alert) => alert.severity == 'critical');

  /// Get total critical debt amount
  double get totalCriticalDebt =>
      topRisks.where((debt) => debt.isCritical).fold(0.0, (sum, debt) => sum + debt.amount);

  /// Check if overview is fresh (updated within last hour)
  bool get isFresh {
    if (lastUpdated == null) return false;
    return DateTime.now().difference(lastUpdated!).inHours < 1;
  }
}
