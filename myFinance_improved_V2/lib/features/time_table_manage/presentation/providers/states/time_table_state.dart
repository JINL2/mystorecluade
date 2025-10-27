import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/manager_overview.dart';
import '../../../domain/entities/monthly_shift_status.dart';

part 'time_table_state.freezed.dart';

/// Monthly Shift Status State - UI state for monthly shift calendar
///
/// Manages monthly shift status data with caching and loading states
@freezed
class MonthlyShiftStatusState with _$MonthlyShiftStatusState {
  const factory MonthlyShiftStatusState({
    @Default({}) Map<String, List<MonthlyShiftStatus>> dataByMonth,
    @Default({}) Set<String> loadedMonths,
    @Default(false) bool isLoading,
    String? error,
  }) = _MonthlyShiftStatusState;
}

/// Manager Overview State - UI state for manager overview
///
/// Manages manager overview data with monthly caching
@freezed
class ManagerOverviewState with _$ManagerOverviewState {
  const factory ManagerOverviewState({
    @Default({}) Map<String, ManagerOverview> dataByMonth,
    @Default(false) bool isLoading,
    String? error,
  }) = _ManagerOverviewState;
}

/// Selected Shift Requests State - UI state for multi-select approval
///
/// Tracks selected shift requests for batch operations
@freezed
class SelectedShiftRequestsState with _$SelectedShiftRequestsState {
  const factory SelectedShiftRequestsState({
    @Default({}) Set<String> selectedIds,
    @Default({}) Map<String, bool> approvalStates,
  }) = _SelectedShiftRequestsState;
}
