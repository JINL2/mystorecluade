import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
// Alert Entity는 trade_shared에서 가져옴 (공유 Entity)
import '../../../trade_shared/domain/entities/trade_alert.dart';

part 'dashboard_providers.g.dart';

/// Supabase client provider
@riverpod
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

/// Dashboard remote datasource provider
@riverpod
DashboardRemoteDatasource dashboardRemoteDatasource(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return DashboardRemoteDatasourceImpl(supabase);
}

/// Dashboard repository provider
@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  final datasource = ref.watch(dashboardRemoteDatasourceProvider);
  return DashboardRepositoryImpl(datasource);
}

/// Dashboard summary state
class DashboardSummaryState {
  final DashboardSummary? data;
  final bool isLoading;
  final String? error;

  const DashboardSummaryState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  DashboardSummaryState copyWith({
    DashboardSummary? data,
    bool? isLoading,
    String? error,
  }) {
    return DashboardSummaryState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Dashboard summary notifier
@riverpod
class DashboardSummaryNotifier extends _$DashboardSummaryNotifier {
  @override
  DashboardSummaryState build() => const DashboardSummaryState();

  Future<void> loadDashboardSummary({
    required String companyId,
    String? storeId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(dashboardRepositoryProvider);
      final summary = await repository.getDashboardSummary(
        companyId: companyId,
        storeId: storeId,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      state = state.copyWith(data: summary, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clear() {
    state = const DashboardSummaryState();
  }
}

/// Recent activities state
class RecentActivitiesState {
  final List<RecentActivity> activities;
  final bool isLoading;
  final String? error;

  const RecentActivitiesState({
    this.activities = const [],
    this.isLoading = false,
    this.error,
  });

  RecentActivitiesState copyWith({
    List<RecentActivity>? activities,
    bool? isLoading,
    String? error,
  }) {
    return RecentActivitiesState(
      activities: activities ?? this.activities,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Recent activities notifier
@riverpod
class RecentActivitiesNotifier extends _$RecentActivitiesNotifier {
  @override
  RecentActivitiesState build() => const RecentActivitiesState();

  Future<void> loadActivities({
    required String companyId,
    String? storeId,
    String? entityType,
    String? entityId,
    int limit = 20,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(dashboardRepositoryProvider);
      final activities = await repository.getRecentActivities(
        companyId: companyId,
        storeId: storeId,
        entityType: entityType,
        entityId: entityId,
        limit: limit,
      );
      state = state.copyWith(activities: activities, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clear() {
    state = const RecentActivitiesState();
  }
}

/// Date range state for filtering
class DateRangeState {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String label;

  const DateRangeState({
    this.dateFrom,
    this.dateTo,
    this.label = 'All Time',
  });

  DateRangeState copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? label,
  }) {
    return DateRangeState(
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      label: label ?? this.label,
    );
  }
}

/// Date range notifier
@riverpod
class DateRangeNotifier extends _$DateRangeNotifier {
  @override
  DateRangeState build() => const DateRangeState();

  void setDateRange(DateTime? from, DateTime? to, String label) {
    state = DateRangeState(
      dateFrom: from,
      dateTo: to,
      label: label,
    );
  }

  void setThisMonth() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    state = DateRangeState(
      dateFrom: firstDay,
      dateTo: lastDay,
      label: 'This Month',
    );
  }

  void setLastMonth() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month - 1, 1);
    final lastDay = DateTime(now.year, now.month, 0);
    state = DateRangeState(
      dateFrom: firstDay,
      dateTo: lastDay,
      label: 'Last Month',
    );
  }

  void setThisYear() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, 1, 1);
    final lastDay = DateTime(now.year, 12, 31);
    state = DateRangeState(
      dateFrom: firstDay,
      dateTo: lastDay,
      label: 'This Year',
    );
  }

  void setAllTime() {
    state = const DateRangeState(label: 'All Time');
  }

  void clear() {
    state = const DateRangeState();
  }
}

/// Trade alerts state
class TradeAlertsState {
  final List<TradeAlert> alerts;
  final int totalCount;
  final int unreadCount;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;

  const TradeAlertsState({
    this.alerts = const [],
    this.totalCount = 0,
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  TradeAlertsState copyWith({
    List<TradeAlert>? alerts,
    int? totalCount,
    int? unreadCount,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return TradeAlertsState(
      alerts: alerts ?? this.alerts,
      totalCount: totalCount ?? this.totalCount,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Trade alerts notifier
@riverpod
class TradeAlertsNotifier extends _$TradeAlertsNotifier {
  @override
  TradeAlertsState build() => const TradeAlertsState();

  Future<void> loadAlerts({
    required String companyId,
    String? userId,
    String? alertType,
    String? priority,
    bool? isRead,
    bool refresh = false,
  }) async {
    if (state.isLoading) return;

    final page = refresh ? 1 : state.currentPage;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(dashboardRepositoryProvider);
      final result = await repository.getAlerts(
        companyId: companyId,
        userId: userId,
        alertType: alertType,
        priority: priority,
        isRead: isRead,
        page: page,
      );

      final allAlerts = refresh ? result.alerts : [...state.alerts, ...result.alerts];

      state = state.copyWith(
        alerts: allAlerts,
        totalCount: result.totalCount,
        unreadCount: result.unreadCount,
        isLoading: false,
        currentPage: page + 1,
        hasMore: result.hasMore,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> markAsRead({
    required String companyId,
    required String alertId,
  }) async {
    try {
      final repository = ref.read(dashboardRepositoryProvider);
      await repository.markAlertRead(
        companyId: companyId,
        alertId: alertId,
      );

      state = state.copyWith(
        alerts: state.alerts.map((alert) {
          if (alert.id == alertId) {
            return alert.copyWith(isRead: true);
          }
          return alert;
        }).toList(),
        unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> markAllAsRead({
    required String companyId,
    required String userId,
  }) async {
    try {
      final repository = ref.read(dashboardRepositoryProvider);
      await repository.markAllAlertsRead(
        companyId: companyId,
        userId: userId,
      );

      state = state.copyWith(
        alerts: state.alerts.map((alert) {
          return alert.copyWith(isRead: true);
        }).toList(),
        unreadCount: 0,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> dismissAlert({
    required String companyId,
    required String alertId,
  }) async {
    try {
      final repository = ref.read(dashboardRepositoryProvider);
      await repository.dismissAlert(
        companyId: companyId,
        alertId: alertId,
      );

      state = state.copyWith(
        alerts: state.alerts.where((alert) => alert.id != alertId).toList(),
        totalCount: state.totalCount > 0 ? state.totalCount - 1 : 0,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clear() {
    state = const TradeAlertsState();
  }
}
