import '../entities/aging_analysis.dart';
import '../entities/critical_alert.dart';
import '../entities/debt_overview.dart';
import '../entities/kpi_metrics.dart';
import '../entities/perspective_summary.dart';
import '../entities/prioritized_debt.dart';

/// Abstract repository interface for debt control operations
abstract class DebtRepository {
  /// Get KPI metrics for debt dashboard
  Future<KpiMetrics> getKpiMetrics({
    required String companyId,
    String? storeId,
    required String viewpoint,
  });

  /// Get aging analysis
  Future<AgingAnalysis> getAgingAnalysis({
    required String companyId,
    String? storeId,
    required String viewpoint,
  });

  /// Get critical alerts
  Future<List<CriticalAlert>> getCriticalAlerts({
    required String companyId,
    String? storeId,
  });

  /// Get top risk debts
  Future<List<PrioritizedDebt>> getTopRiskDebts({
    required String companyId,
    String? storeId,
    required int limit,
  });

  /// Get smart debt overview with all metrics
  Future<DebtOverview> getSmartOverview({
    required String companyId,
    String? storeId,
    required String viewpoint,
  });

  /// Get prioritized debts with filtering
  Future<List<PrioritizedDebt>> getPrioritizedDebts({
    required String companyId,
    String? storeId,
    required String viewpoint,
    required String filter,
    int limit = 50,
    int offset = 0,
  });

  /// Get perspective summary
  Future<PerspectiveSummary> getPerspectiveSummary({
    required String companyId,
    String? storeId,
    required String perspectiveType,
    required String entityName,
  });

  /// Refresh cached data
  Future<void> refreshData();

  /// Mark alert as read
  Future<void> markAlertAsRead(String alertId);

  /// Get debt communications for a specific debt
  Future<List<dynamic>> getDebtCommunications(String debtId);

  /// Create debt communication
  Future<void> createDebtCommunication(dynamic communication);

  /// Get payment plans for a specific debt
  Future<List<dynamic>> getPaymentPlans(String debtId);

  /// Create payment plan
  Future<void> createPaymentPlan(dynamic paymentPlan);

  /// Update payment plan status
  Future<void> updatePaymentPlanStatus(String planId, String status);

  /// Get debt analytics
  Future<dynamic> getDebtAnalytics({
    required String companyId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
  });
}
