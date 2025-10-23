import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/datasources/time_table_datasource.dart';
import '../../data/repositories/time_table_repository_impl.dart';
import '../../domain/entities/manager_overview.dart';
import '../../domain/entities/monthly_shift_status.dart';
import '../../domain/entities/shift_metadata.dart';
import '../../domain/repositories/time_table_repository.dart';

// ============================================================================
// Data Layer Providers
// ============================================================================

/// Supabase Client Provider
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Time Table Datasource Provider
final timeTableDatasourceProvider = Provider<TimeTableDatasource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return TimeTableDatasource(client);
});

/// Time Table Repository Provider
final timeTableRepositoryProvider = Provider<TimeTableRepository>((ref) {
  final datasource = ref.watch(timeTableDatasourceProvider);
  return TimeTableRepositoryImpl(datasource);
});

// ============================================================================
// Presentation Layer State Providers
// ============================================================================

/// Selected Date Provider
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

/// Selected Store ID Provider
final selectedStoreIdProvider = StateProvider<String?>((ref) {
  return null;
});

/// Focused Month Provider (for calendar navigation)
final focusedMonthProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

/// Tab Controller Index Provider
final tabIndexProvider = StateProvider<int>((ref) {
  return 0; // 0 = Schedule, 1 = Overview
});

// ============================================================================
// Shift Metadata Provider
// ============================================================================

/// Shift Metadata Provider
///
/// Loads shift metadata for a given store ID
final shiftMetadataProvider =
    FutureProvider.family<ShiftMetadata, String>((ref, storeId) async {
  if (storeId.isEmpty) {
    throw Exception('Store ID is required');
  }

  final repository = ref.watch(timeTableRepositoryProvider);
  return await repository.getShiftMetadata(storeId: storeId);
});

// ============================================================================
// Monthly Shift Status Provider
// ============================================================================

/// Monthly Shift Status State
class MonthlyShiftStatusState {
  final Map<String, List<MonthlyShiftStatus>> dataByMonth;
  final Set<String> loadedMonths;
  final bool isLoading;
  final String? error;

  const MonthlyShiftStatusState({
    this.dataByMonth = const {},
    this.loadedMonths = const {},
    this.isLoading = false,
    this.error,
  });

  MonthlyShiftStatusState copyWith({
    Map<String, List<MonthlyShiftStatus>>? dataByMonth,
    Set<String>? loadedMonths,
    bool? isLoading,
    String? error,
  }) {
    return MonthlyShiftStatusState(
      dataByMonth: dataByMonth ?? this.dataByMonth,
      loadedMonths: loadedMonths ?? this.loadedMonths,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Monthly Shift Status Notifier
class MonthlyShiftStatusNotifier
    extends StateNotifier<MonthlyShiftStatusState> {
  final TimeTableRepository _repository;
  final String _companyId;
  final String _storeId;

  MonthlyShiftStatusNotifier(
    this._repository,
    this._companyId,
    this._storeId,
  ) : super(const MonthlyShiftStatusState());

  /// Load monthly shift status for a specific month
  Future<void> loadMonth({
    required DateTime month,
    bool forceRefresh = false,
  }) async {
    final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';

    // Skip if already loaded (unless force refresh)
    if (!forceRefresh && state.loadedMonths.contains(monthKey)) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Format as first day of month
      final requestDate =
          '${month.year}-${month.month.toString().padLeft(2, '0')}-01';

      final data = await _repository.getMonthlyShiftStatus(
        requestDate: requestDate,
        companyId: _companyId,
        storeId: _storeId,
      );

      // Update state with new data
      final newDataByMonth = Map<String, List<MonthlyShiftStatus>>.from(state.dataByMonth);
      newDataByMonth[monthKey] = data;

      final newLoadedMonths = Set<String>.from(state.loadedMonths);
      newLoadedMonths.add(monthKey);

      // Also mark next month as loaded if RPC returns 2 months
      final nextMonth = DateTime(month.year, month.month + 1);
      final nextMonthKey =
          '${nextMonth.year}-${nextMonth.month.toString().padLeft(2, '0')}';
      newLoadedMonths.add(nextMonthKey);

      state = state.copyWith(
        dataByMonth: newDataByMonth,
        loadedMonths: newLoadedMonths,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Get data for a specific month
  List<MonthlyShiftStatus>? getMonthData(DateTime month) {
    final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';
    return state.dataByMonth[monthKey];
  }

  /// Clear all loaded data
  void clearAll() {
    state = const MonthlyShiftStatusState();
  }
}

/// Monthly Shift Status Provider
final monthlyShiftStatusProvider = StateNotifierProvider.family<
    MonthlyShiftStatusNotifier,
    MonthlyShiftStatusState,
    String>((ref, storeId) {
  final repository = ref.watch(timeTableRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  return MonthlyShiftStatusNotifier(repository, companyId, storeId);
});

// ============================================================================
// Manager Overview Provider
// ============================================================================

/// Manager Overview State
class ManagerOverviewState {
  final Map<String, ManagerOverview> dataByMonth;
  final bool isLoading;
  final String? error;

  const ManagerOverviewState({
    this.dataByMonth = const {},
    this.isLoading = false,
    this.error,
  });

  ManagerOverviewState copyWith({
    Map<String, ManagerOverview>? dataByMonth,
    bool? isLoading,
    String? error,
  }) {
    return ManagerOverviewState(
      dataByMonth: dataByMonth ?? this.dataByMonth,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Manager Overview Notifier
class ManagerOverviewNotifier extends StateNotifier<ManagerOverviewState> {
  final TimeTableRepository _repository;
  final String _companyId;
  final String _storeId;

  ManagerOverviewNotifier(
    this._repository,
    this._companyId,
    this._storeId,
  ) : super(const ManagerOverviewState());

  /// Load manager overview for a specific month
  Future<void> loadMonth({
    required DateTime month,
    bool forceRefresh = false,
  }) async {
    final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';

    // Skip if already loaded (unless force refresh)
    if (!forceRefresh && state.dataByMonth.containsKey(monthKey)) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay = DateTime(month.year, month.month + 1, 0);

      final startDate = '${firstDay.year}-${firstDay.month.toString().padLeft(2, '0')}-${firstDay.day.toString().padLeft(2, '0')}';
      final endDate = '${lastDay.year}-${lastDay.month.toString().padLeft(2, '0')}-${lastDay.day.toString().padLeft(2, '0')}';

      final data = await _repository.getManagerOverview(
        startDate: startDate,
        endDate: endDate,
        companyId: _companyId,
        storeId: _storeId,
      );

      final newDataByMonth = Map<String, ManagerOverview>.from(state.dataByMonth);
      newDataByMonth[monthKey] = data;

      state = state.copyWith(
        dataByMonth: newDataByMonth,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Get data for a specific month
  ManagerOverview? getMonthData(DateTime month) {
    final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';
    return state.dataByMonth[monthKey];
  }

  /// Clear all loaded data
  void clearAll() {
    state = const ManagerOverviewState();
  }
}

/// Manager Overview Provider
final managerOverviewProvider = StateNotifierProvider.family<
    ManagerOverviewNotifier,
    ManagerOverviewState,
    String>((ref, storeId) {
  final repository = ref.watch(timeTableRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  return ManagerOverviewNotifier(repository, companyId, storeId);
});

// ============================================================================
// Selected Shift Requests Provider (for multi-select approval)
// ============================================================================

/// Selected Shift Requests State
class SelectedShiftRequestsState {
  final Set<String> selectedIds; // shift_request_ids
  final Map<String, bool> approvalStates;

  const SelectedShiftRequestsState({
    this.selectedIds = const {},
    this.approvalStates = const {},
  });

  SelectedShiftRequestsState copyWith({
    Set<String>? selectedIds,
    Map<String, bool>? approvalStates,
  }) {
    return SelectedShiftRequestsState(
      selectedIds: selectedIds ?? this.selectedIds,
      approvalStates: approvalStates ?? this.approvalStates,
    );
  }
}

/// Selected Shift Requests Notifier
class SelectedShiftRequestsNotifier
    extends StateNotifier<SelectedShiftRequestsState> {
  SelectedShiftRequestsNotifier() : super(const SelectedShiftRequestsState());

  void toggleSelection(String shiftRequestId, bool isApproved) {
    final newSelectedIds = Set<String>.from(state.selectedIds);
    final newApprovalStates = Map<String, bool>.from(state.approvalStates);

    if (newSelectedIds.contains(shiftRequestId)) {
      newSelectedIds.remove(shiftRequestId);
      newApprovalStates.remove(shiftRequestId);
    } else {
      newSelectedIds.add(shiftRequestId);
      newApprovalStates[shiftRequestId] = isApproved;
    }

    state = state.copyWith(
      selectedIds: newSelectedIds,
      approvalStates: newApprovalStates,
    );
  }

  void clearAll() {
    state = const SelectedShiftRequestsState();
  }

  bool isSelected(String shiftRequestId) {
    return state.selectedIds.contains(shiftRequestId);
  }
}

/// Selected Shift Requests Provider
final selectedShiftRequestsProvider = StateNotifierProvider<
    SelectedShiftRequestsNotifier,
    SelectedShiftRequestsState>((ref) {
  return SelectedShiftRequestsNotifier();
});
