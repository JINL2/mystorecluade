import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/session_providers.dart';
import '../../domain/entities/session_history_item.dart';
import 'states/session_history_filter_state.dart';

/// State for session history
class SessionHistoryState {
  final List<SessionHistoryItem> sessions;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int totalCount;
  final bool hasMore;
  final int currentOffset;
  final SessionHistoryFilterState filter;

  static const int pageSize = 15;

  const SessionHistoryState({
    this.sessions = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.totalCount = 0,
    this.hasMore = false,
    this.currentOffset = 0,
    this.filter = const SessionHistoryFilterState(),
  });

  factory SessionHistoryState.initial() {
    return SessionHistoryState(
      filter: SessionHistoryFilterState.initial(),
    );
  }

  SessionHistoryState copyWith({
    List<SessionHistoryItem>? sessions,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? totalCount,
    bool? hasMore,
    int? currentOffset,
    SessionHistoryFilterState? filter,
  }) {
    return SessionHistoryState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      currentOffset: currentOffset ?? this.currentOffset,
      filter: filter ?? this.filter,
    );
  }

  bool get hasError => error != null;
  bool get isEmpty => sessions.isEmpty && !isLoading;
}

/// Notifier for session history state management
class SessionHistoryNotifier extends StateNotifier<SessionHistoryState> {
  final Ref _ref;
  final String _companyId;

  SessionHistoryNotifier({
    required Ref ref,
    required String companyId,
  })  : _ref = ref,
        _companyId = companyId,
        super(SessionHistoryState.initial());

  /// Load sessions with current filter (initial load)
  Future<void> loadSessions() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentOffset: 0,
      sessions: [],
    );

    try {
      final getSessionHistory = _ref.read(getSessionHistoryUseCaseProvider);
      final filter = state.filter;
      final dateRange = filter.getDateRange();

      final response = await getSessionHistory(
        companyId: _companyId,
        storeId: filter.selectedStoreId,
        sessionType: filter.sessionType,
        isActive: filter.isActive,
        startDate: dateRange.start,
        endDate: dateRange.end,
        limit: SessionHistoryState.pageSize,
        offset: 0,
      );

      state = state.copyWith(
        sessions: response.sessions,
        isLoading: false,
        totalCount: response.totalCount,
        hasMore: response.hasMore,
        currentOffset: response.sessions.length,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load more sessions (pagination)
  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final getSessionHistory = _ref.read(getSessionHistoryUseCaseProvider);
      final filter = state.filter;
      final dateRange = filter.getDateRange();

      final response = await getSessionHistory(
        companyId: _companyId,
        storeId: filter.selectedStoreId,
        sessionType: filter.sessionType,
        isActive: filter.isActive,
        startDate: dateRange.start,
        endDate: dateRange.end,
        limit: SessionHistoryState.pageSize,
        offset: state.currentOffset,
      );

      state = state.copyWith(
        sessions: [...state.sessions, ...response.sessions],
        isLoadingMore: false,
        totalCount: response.totalCount,
        hasMore: response.hasMore,
        currentOffset: state.currentOffset + response.sessions.length,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Update filter and reload
  void updateFilter(SessionHistoryFilterState filter) {
    state = state.copyWith(filter: filter);
    loadSessions();
  }

  /// Update selected store
  void updateSelectedStore(String? storeId) {
    final newFilter = state.filter.copyWith(
      selectedStoreId: storeId,
      clearSelectedStoreId: storeId == null,
    );
    updateFilter(newFilter);
  }

  /// Update date range type
  void updateDateRangeType(DateRangeType type) {
    final newFilter = state.filter.copyWith(
      dateRangeType: type,
      clearCustomStartDate: type != DateRangeType.custom,
      clearCustomEndDate: type != DateRangeType.custom,
    );
    updateFilter(newFilter);
  }

  /// Update custom date range
  void updateCustomDateRange(DateTime start, DateTime end) {
    final newFilter = state.filter.copyWith(
      dateRangeType: DateRangeType.custom,
      customStartDate: start,
      customEndDate: end,
    );
    updateFilter(newFilter);
  }

  /// Update active filter
  void updateActiveFilter(bool? isActive) {
    final newFilter = state.filter.copyWith(
      isActive: isActive,
      clearIsActive: isActive == null,
    );
    updateFilter(newFilter);
  }

  /// Update session type filter
  void updateSessionTypeFilter(String? sessionType) {
    final newFilter = state.filter.copyWith(
      sessionType: sessionType,
      clearSessionType: sessionType == null,
    );
    updateFilter(newFilter);
  }

  /// Clear all filters
  void clearFilters() {
    updateFilter(SessionHistoryFilterState.initial());
  }

  /// Refresh sessions
  Future<void> refresh() async {
    state = state.copyWith(
      sessions: [],
      totalCount: 0,
      hasMore: false,
      currentOffset: 0,
    );
    await loadSessions();
  }
}

/// Provider for session history
final sessionHistoryProvider =
    StateNotifierProvider.autoDispose<SessionHistoryNotifier, SessionHistoryState>(
        (ref) {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  final notifier = SessionHistoryNotifier(
    ref: ref,
    companyId: companyId,
  );

  // Auto-load on creation
  notifier.loadSessions();

  return notifier;
});

/// Provider for filter state only (for UI)
final sessionHistoryFilterProvider = Provider<SessionHistoryFilterState>((ref) {
  return ref.watch(sessionHistoryProvider).filter;
});
