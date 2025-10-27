import '../../domain/entities/aging_analysis.dart';
import '../../domain/entities/critical_alert.dart';
import '../../domain/entities/debt_overview.dart';
import '../../domain/entities/kpi_metrics.dart';
import '../../domain/entities/perspective_summary.dart';
import '../../domain/entities/prioritized_debt.dart';
import '../../domain/repositories/debt_repository.dart';
import '../datasources/supabase_debt_data_source.dart';
import '../models/debt_control_mapper.dart';

/// Implementation of DebtRepository using Supabase
class DebtRepositoryImpl implements DebtRepository {
  final SupabaseDebtDataSource _dataSource;

  DebtRepositoryImpl({SupabaseDebtDataSource? dataSource})
      : _dataSource = dataSource ?? SupabaseDebtDataSource();

  @override
  Future<KpiMetrics> getKpiMetrics({
    required String companyId,
    String? storeId,
    required String viewpoint,
  }) async {
    final dto = await _dataSource.fetchKpiMetrics(
      companyId: companyId,
      storeId: storeId,
      viewpoint: viewpoint,
    );
    return DebtControlMapper.kpiMetricsDtoToEntity(dto);
  }

  @override
  Future<AgingAnalysis> getAgingAnalysis({
    required String companyId,
    String? storeId,
    required String viewpoint,
  }) async {
    final dto = await _dataSource.fetchAgingAnalysis(
      companyId: companyId,
      storeId: storeId,
      viewpoint: viewpoint,
    );
    return DebtControlMapper.agingAnalysisDtoToEntity(dto);
  }

  @override
  Future<List<CriticalAlert>> getCriticalAlerts({
    required String companyId,
    String? storeId,
  }) async {
    final dtos = await _dataSource.fetchCriticalAlerts(
      companyId: companyId,
      storeId: storeId,
    );
    return dtos.map(DebtControlMapper.criticalAlertDtoToEntity).toList();
  }

  @override
  Future<List<PrioritizedDebt>> getTopRiskDebts({
    required String companyId,
    String? storeId,
    required int limit,
  }) async {
    final dtos = await _dataSource.fetchTopRiskDebts(
      companyId: companyId,
      storeId: storeId,
      limit: limit,
    );
    return dtos.map(DebtControlMapper.prioritizedDebtDtoToEntity).toList();
  }

  @override
  Future<DebtOverview> getSmartOverview({
    required String companyId,
    String? storeId,
    required String viewpoint,
  }) async {
    // Fetch all required data in parallel for better performance
    final results = await Future.wait([
      getKpiMetrics(companyId: companyId, storeId: storeId, viewpoint: viewpoint),
      getAgingAnalysis(companyId: companyId, storeId: storeId, viewpoint: viewpoint),
      getCriticalAlerts(companyId: companyId, storeId: storeId),
      getTopRiskDebts(companyId: companyId, storeId: storeId, limit: 5),
    ]);

    return DebtOverview(
      kpiMetrics: results[0] as KpiMetrics,
      agingAnalysis: results[1] as AgingAnalysis,
      criticalAlerts: results[2] as List<CriticalAlert>,
      topRisks: results[3] as List<PrioritizedDebt>,
      viewpointDescription: _getViewpointDescription(viewpoint),
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<List<PrioritizedDebt>> getPrioritizedDebts({
    required String companyId,
    String? storeId,
    required String viewpoint,
    required String filter,
    int limit = 50,
    int offset = 0,
  }) async {
    final dtos = await _dataSource.fetchPrioritizedDebts(
      companyId: companyId,
      storeId: storeId,
      viewpoint: viewpoint,
      filter: filter,
      limit: limit,
      offset: offset,
    );
    return dtos.map(DebtControlMapper.prioritizedDebtDtoToEntity).toList();
  }

  @override
  Future<PerspectiveSummary> getPerspectiveSummary({
    required String perspectiveType,
    required String entityId,
    required String entityName,
  }) async {
    final dto = await _dataSource.fetchPerspectiveSummary(
      perspectiveType: perspectiveType,
      entityId: entityId,
      entityName: entityName,
    );
    return DebtControlMapper.perspectiveSummaryDtoToEntity(dto);
  }

  @override
  Future<void> refreshData() async {
    await _dataSource.clearCache();
  }

  @override
  Future<void> markAlertAsRead(String alertId) async {
    await _dataSource.markAlertAsRead(alertId);
  }

  @override
  Future<List<dynamic>> getDebtCommunications(String debtId) async {
    // TODO: Implement when communication entities are ready
    return [];
  }

  @override
  Future<void> createDebtCommunication(dynamic communication) async {
    // TODO: Implement when communication entities are ready
  }

  @override
  Future<List<dynamic>> getPaymentPlans(String debtId) async {
    // TODO: Implement when payment plan entities are ready
    return [];
  }

  @override
  Future<void> createPaymentPlan(dynamic paymentPlan) async {
    // TODO: Implement when payment plan entities are ready
  }

  @override
  Future<void> updatePaymentPlanStatus(String planId, String status) async {
    // TODO: Implement when payment plan entities are ready
  }

  @override
  Future<dynamic> getDebtAnalytics({
    required String companyId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    // TODO: Implement when analytics entities are ready
    return null;
  }

  String _getViewpointDescription(String viewpoint) {
    switch (viewpoint) {
      case 'company':
        return 'Company-wide debt overview';
      case 'store':
        return 'Store-specific debt analysis';
      case 'headquarters':
        return 'Headquarters debt management';
      default:
        return 'Debt overview';
    }
  }
}
