import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/session_providers.dart';
import 'states/session_history_filter_state.dart';
import 'states/session_history_state.dart';

part 'session_history_provider.g.dart';

/// Notifier for session history state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
@riverpod
class SessionHistoryNotifier extends _$SessionHistoryNotifier {
  @override
  SessionHistoryState build() {
    // Auto-load on creation
    Future.microtask(loadSessions);
    return SessionHistoryState.initial();
  }

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
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final getSessionHistory = ref.read(getSessionHistoryUseCaseProvider);
      final filter = state.filter;
      final dateRange = filter.getDateRange();

      final response = await getSessionHistory(
        companyId: companyId,
        storeId: filter.selectedStoreId,
        sessionType: filter.sessionType,
        isActive: filter.isActive,
        startDate: dateRange.start,
        endDate: dateRange.end,
        searchQuery: filter.searchQuery,
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
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final getSessionHistory = ref.read(getSessionHistoryUseCaseProvider);
      final filter = state.filter;
      final dateRange = filter.getDateRange();

      final response = await getSessionHistory(
        companyId: companyId,
        storeId: filter.selectedStoreId,
        sessionType: filter.sessionType,
        isActive: filter.isActive,
        startDate: dateRange.start,
        endDate: dateRange.end,
        searchQuery: filter.searchQuery,
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

  /// Update search query
  void updateSearchQuery(String? query) {
    final trimmedQuery = query?.trim();
    final newFilter = state.filter.copyWith(
      searchQuery: trimmedQuery,
      clearSearchQuery: trimmedQuery == null || trimmedQuery.isEmpty,
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

/// Provider for filter state only (for UI)
/// This is a simple derived provider that extracts filter from history state
@riverpod
SessionHistoryFilterState sessionHistoryFilter(Ref ref) {
  return ref.watch(sessionHistoryNotifierProvider).filter;
}
