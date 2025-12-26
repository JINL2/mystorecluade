import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/trade_remote_datasource.dart';
import '../../data/models/dashboard_summary_model.dart';
import '../../data/models/trade_alert_model.dart';
import '../../data/models/master_data_model.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/trade_alert.dart';
import '../../domain/entities/incoterm.dart';

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Trade remote datasource provider
final tradeRemoteDatasourceProvider = Provider<TradeRemoteDatasource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return TradeRemoteDatasourceImpl(supabase);
});

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
class DashboardSummaryNotifier extends StateNotifier<DashboardSummaryState> {
  final TradeRemoteDatasource _datasource;

  DashboardSummaryNotifier(this._datasource) : super(const DashboardSummaryState());

  Future<void> loadDashboardSummary({
    required String companyId,
    String? storeId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final model = await _datasource.getDashboardSummary(
        companyId: companyId,
        storeId: storeId,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      state = state.copyWith(data: model.toEntity(), isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clear() {
    state = const DashboardSummaryState();
  }
}

/// Dashboard summary provider
final dashboardSummaryProvider =
    StateNotifierProvider<DashboardSummaryNotifier, DashboardSummaryState>((ref) {
  final datasource = ref.watch(tradeRemoteDatasourceProvider);
  return DashboardSummaryNotifier(datasource);
});

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
class RecentActivitiesNotifier extends StateNotifier<RecentActivitiesState> {
  final TradeRemoteDatasource _datasource;

  RecentActivitiesNotifier(this._datasource) : super(const RecentActivitiesState());

  Future<void> loadActivities({
    required String companyId,
    String? storeId,
    String? entityType,
    String? entityId,
    int limit = 20,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final models = await _datasource.getDashboardTimeline(
        companyId: companyId,
        storeId: storeId,
        entityType: entityType,
        entityId: entityId,
        limit: limit,
      );
      state = state.copyWith(
        activities: models.map((m) => m.toEntity()).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clear() {
    state = const RecentActivitiesState();
  }
}

/// Recent activities provider
final recentActivitiesProvider =
    StateNotifierProvider<RecentActivitiesNotifier, RecentActivitiesState>((ref) {
  final datasource = ref.watch(tradeRemoteDatasourceProvider);
  return RecentActivitiesNotifier(datasource);
});

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
class TradeAlertsNotifier extends StateNotifier<TradeAlertsState> {
  final TradeRemoteDatasource _datasource;

  TradeAlertsNotifier(this._datasource) : super(const TradeAlertsState());

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
      final response = await _datasource.getAlerts(
        companyId: companyId,
        userId: userId,
        alertType: alertType,
        priority: priority,
        isRead: isRead,
        page: page,
      );

      final newAlerts = response.alerts.map((m) => m.toEntity()).toList();
      final allAlerts = refresh ? newAlerts : [...state.alerts, ...newAlerts];

      state = state.copyWith(
        alerts: allAlerts,
        totalCount: response.pagination.totalCount,
        unreadCount: response.unreadCount,
        isLoading: false,
        currentPage: page + 1,
        hasMore: page < response.pagination.totalPages,
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
      await _datasource.markAlertRead(
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
      await _datasource.markAllAlertsRead(
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
      await _datasource.dismissAlert(
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

/// Trade alerts provider
final tradeAlertsProvider =
    StateNotifierProvider<TradeAlertsNotifier, TradeAlertsState>((ref) {
  final datasource = ref.watch(tradeRemoteDatasourceProvider);
  return TradeAlertsNotifier(datasource);
});

/// Master data state
class MasterDataState {
  final List<Incoterm> incoterms;
  final List<PaymentTerm> paymentTerms;
  final List<LCType> lcTypes;
  final List<TradeDocumentType> documentTypes;
  final List<ShippingMethod> shippingMethods;
  final List<FreightTerm> freightTerms;
  final bool isLoading;
  final String? error;

  const MasterDataState({
    this.incoterms = const [],
    this.paymentTerms = const [],
    this.lcTypes = const [],
    this.documentTypes = const [],
    this.shippingMethods = const [],
    this.freightTerms = const [],
    this.isLoading = false,
    this.error,
  });

  bool get isLoaded => incoterms.isNotEmpty;

  MasterDataState copyWith({
    List<Incoterm>? incoterms,
    List<PaymentTerm>? paymentTerms,
    List<LCType>? lcTypes,
    List<TradeDocumentType>? documentTypes,
    List<ShippingMethod>? shippingMethods,
    List<FreightTerm>? freightTerms,
    bool? isLoading,
    String? error,
  }) {
    return MasterDataState(
      incoterms: incoterms ?? this.incoterms,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      lcTypes: lcTypes ?? this.lcTypes,
      documentTypes: documentTypes ?? this.documentTypes,
      shippingMethods: shippingMethods ?? this.shippingMethods,
      freightTerms: freightTerms ?? this.freightTerms,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Master data notifier
class MasterDataNotifier extends StateNotifier<MasterDataState> {
  final TradeRemoteDatasource _datasource;

  MasterDataNotifier(this._datasource) : super(const MasterDataState());

  Future<void> loadAllMasterData() async {
    if (state.isLoaded) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _datasource.getAllMasterData();
      state = state.copyWith(
        incoterms: response.incoterms.map((m) => m.toEntity()).toList(),
        paymentTerms: response.paymentTerms.map((m) => m.toEntity()).toList(),
        lcTypes: response.lcTypes.map((m) => m.toEntity()).toList(),
        documentTypes: response.documentTypes.map((m) => m.toEntity()).toList(),
        shippingMethods: response.shippingMethods.map((m) => m.toEntity()).toList(),
        freightTerms: response.freightTerms.map((m) => m.toEntity()).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clear() {
    state = const MasterDataState();
  }
}

/// Master data provider
final masterDataProvider =
    StateNotifierProvider<MasterDataNotifier, MasterDataState>((ref) {
  final datasource = ref.watch(tradeRemoteDatasourceProvider);
  return MasterDataNotifier(datasource);
});

/// Selected date range for dashboard
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
class DateRangeNotifier extends StateNotifier<DateRangeState> {
  DateRangeNotifier() : super(const DateRangeState());

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

/// Date range provider
final dateRangeProvider =
    StateNotifierProvider<DateRangeNotifier, DateRangeState>((ref) {
  return DateRangeNotifier();
});
