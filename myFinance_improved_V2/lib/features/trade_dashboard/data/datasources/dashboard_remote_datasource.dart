import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dashboard_summary_model.dart';
import '../../../trade_shared/data/models/trade_alert_model.dart';

/// Remote datasource for dashboard functionality
abstract class DashboardRemoteDatasource {
  /// Get dashboard summary
  Future<DashboardSummaryModel> getDashboardSummary({
    required String companyId,
    String? storeId,
    DateTime? dateFrom,
    DateTime? dateTo,
  });

  /// Get dashboard timeline
  Future<List<RecentActivityModel>> getDashboardTimeline({
    required String companyId,
    String? storeId,
    String? entityType,
    String? entityId,
    int limit = 20,
  });

  /// Get alerts list
  Future<TradeAlertListResponse> getAlerts({
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

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final SupabaseClient _supabase;

  DashboardRemoteDatasourceImpl(this._supabase);

  @override
  Future<DashboardSummaryModel> getDashboardSummary({
    required String companyId,
    String? storeId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final response = await _supabase.rpc(
      'trade_dashboard_summary',
      params: {
        'p_company_id': companyId,
        if (storeId != null) 'p_store_id': storeId,
        if (dateFrom != null) 'p_date_from': dateFrom.toIso8601String().split('T')[0],
        if (dateTo != null) 'p_date_to': dateTo.toIso8601String().split('T')[0],
      },
    );

    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw Exception(responseMap['error']?['message'] ?? 'Failed to get dashboard summary');
    }

    return DashboardSummaryModel.fromJson(responseMap['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<RecentActivityModel>> getDashboardTimeline({
    required String companyId,
    String? storeId,
    String? entityType,
    String? entityId,
    int limit = 20,
  }) async {
    final response = await _supabase.rpc(
      'trade_dashboard_timeline',
      params: {
        'p_company_id': companyId,
        if (storeId != null) 'p_store_id': storeId,
        if (entityType != null) 'p_entity_type': entityType,
        if (entityId != null) 'p_entity_id': entityId,
        'p_limit': limit,
      },
    );

    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw Exception(responseMap['error']?['message'] ?? 'Failed to get timeline');
    }

    final data = responseMap['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => RecentActivityModel.fromRpcJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TradeAlertListResponse> getAlerts({
    required String companyId,
    String? userId,
    String? alertType,
    String? priority,
    bool? isRead,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _supabase.rpc(
      'trade_alert_list',
      params: {
        'p_company_id': companyId,
        if (userId != null) 'p_user_id': userId,
        if (alertType != null) 'p_alert_type': alertType,
        if (priority != null) 'p_priority': priority,
        if (isRead != null) 'p_is_read': isRead,
        'p_page': page,
        'p_page_size': pageSize,
      },
    );

    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw Exception(responseMap['error']?['message'] ?? 'Failed to get alerts');
    }

    return TradeAlertListResponse.fromJson(responseMap);
  }

  @override
  Future<void> markAlertRead({
    required String companyId,
    required String alertId,
  }) async {
    final response = await _supabase.rpc(
      'trade_alert_mark_read',
      params: {
        'p_company_id': companyId,
        'p_alert_id': alertId,
      },
    );

    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw Exception(responseMap['error']?['message'] ?? 'Failed to mark alert as read');
    }
  }

  @override
  Future<void> markAllAlertsRead({
    required String companyId,
    required String userId,
  }) async {
    final response = await _supabase.rpc(
      'trade_alert_mark_all_read',
      params: {
        'p_company_id': companyId,
        'p_user_id': userId,
      },
    );

    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw Exception(responseMap['error']?['message'] ?? 'Failed to mark all alerts as read');
    }
  }

  @override
  Future<void> dismissAlert({
    required String companyId,
    required String alertId,
  }) async {
    final response = await _supabase.rpc(
      'trade_alert_dismiss',
      params: {
        'p_company_id': companyId,
        'p_alert_id': alertId,
      },
    );

    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw Exception(responseMap['error']?['message'] ?? 'Failed to dismiss alert');
    }
  }
}
