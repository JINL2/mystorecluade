import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

/// Implementation of DashboardRepository
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource _datasource;

  DashboardRepositoryImpl(this._datasource);

  @override
  Future<DashboardSummary> getDashboardSummary({
    required String companyId,
    String? storeId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final model = await _datasource.getDashboardSummary(
      companyId: companyId,
      storeId: storeId,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
    return model.toEntity();
  }

  @override
  Future<List<RecentActivity>> getRecentActivities({
    required String companyId,
    String? storeId,
    String? entityType,
    String? entityId,
    int limit = 20,
  }) async {
    final models = await _datasource.getDashboardTimeline(
      companyId: companyId,
      storeId: storeId,
      entityType: entityType,
      entityId: entityId,
      limit: limit,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AlertsResult> getAlerts({
    required String companyId,
    String? userId,
    String? alertType,
    String? priority,
    bool? isRead,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _datasource.getAlerts(
      companyId: companyId,
      userId: userId,
      alertType: alertType,
      priority: priority,
      isRead: isRead,
      page: page,
      pageSize: pageSize,
    );
    return AlertsResult(
      alerts: response.toEntityList(),
      totalCount: response.pagination.totalCount,
      unreadCount: response.unreadCount,
      totalPages: response.pagination.totalPages,
      hasMore: response.pagination.hasNext,
    );
  }

  @override
  Future<void> markAlertRead({
    required String companyId,
    required String alertId,
  }) async {
    await _datasource.markAlertRead(
      companyId: companyId,
      alertId: alertId,
    );
  }

  @override
  Future<void> markAllAlertsRead({
    required String companyId,
    required String userId,
  }) async {
    await _datasource.markAllAlertsRead(
      companyId: companyId,
      userId: userId,
    );
  }

  @override
  Future<void> dismissAlert({
    required String companyId,
    required String alertId,
  }) async {
    await _datasource.dismissAlert(
      companyId: companyId,
      alertId: alertId,
    );
  }
}
