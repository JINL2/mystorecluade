import '../models/debt_control_dto.dart';

/// Abstract data source interface for debt control
abstract class DebtDataSource {
  Future<KpiMetricsDto> fetchKpiMetrics({
    required String companyId,
    String? storeId,
    required String viewpoint,
  });

  Future<AgingAnalysisDto> fetchAgingAnalysis({
    required String companyId,
    String? storeId,
    required String viewpoint,
  });

  Future<List<CriticalAlertDto>> fetchCriticalAlerts({
    required String companyId,
    String? storeId,
  });

  Future<List<PrioritizedDebtDto>> fetchTopRiskDebts({
    required String companyId,
    String? storeId,
    required int limit,
  });

  Future<List<PrioritizedDebtDto>> fetchPrioritizedDebts({
    required String companyId,
    String? storeId,
    required String viewpoint,
    required String filter,
    int limit = 50,
    int offset = 0,
  });

  Future<PerspectiveSummaryDto> fetchPerspectiveSummary({
    required String perspectiveType,
    required String entityId,
    required String entityName,
  });

  Future<void> markAlertAsRead(String alertId);

  Future<void> clearCache();
}
