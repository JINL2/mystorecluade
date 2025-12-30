import '../entities/dashboard_summary.dart';
import '../../../trade_shared/domain/entities/trade_alert.dart';

/// Alert list response for repository
class AlertsResult {
  final List<TradeAlert> alerts;
  final int totalCount;
  final int unreadCount;
  final int totalPages;
  final bool hasMore;

  const AlertsResult({
    required this.alerts,
    required this.totalCount,
    required this.unreadCount,
    required this.totalPages,
    required this.hasMore,
  });
}

/// Repository interface for dashboard data operations
/// Domain layer - no external dependencies
abstract class DashboardRepository {
  /// Get dashboard summary
  Future<DashboardSummary> getDashboardSummary({
    required String companyId,
    String? storeId,
    DateTime? dateFrom,
    DateTime? dateTo,
  });

  /// Get recent activities for timeline
  Future<List<RecentActivity>> getRecentActivities({
    required String companyId,
    String? storeId,
    String? entityType,
    String? entityId,
    int limit = 20,
  });

  /// Get alerts list
  Future<AlertsResult> getAlerts({
    required String companyId,
    String? userId,
    String? alertType,
    String? priority,
    bool? isRead,
    int page = 1,
    int pageSize = 20,
  });

  /// Mark alert as read
  Future<void> markAlertRead({
    required String companyId,
    required String alertId,
  });

  /// Mark all alerts as read
  Future<void> markAllAlertsRead({
    required String companyId,
    required String userId,
  });

  /// Dismiss alert
  Future<void> dismissAlert({
    required String companyId,
    required String alertId,
  });
}
