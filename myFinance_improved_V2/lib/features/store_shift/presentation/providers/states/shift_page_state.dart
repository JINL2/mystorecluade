import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/store_shift.dart';

part 'shift_page_state.freezed.dart';

/// Shift Page State - UI state for shift management page
///
/// Manages the overall state of the shift settings tab including
/// loading states, errors, and shift list data.
@freezed
class ShiftPageState with _$ShiftPageState {
  const factory ShiftPageState({
    @Default([]) List<StoreShift> shifts,
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    String? errorMessage,
    String? searchQuery,
    @Default(0) int selectedTabIndex,
  }) = _ShiftPageState;

  /// Initial state
  factory ShiftPageState.initial() => const ShiftPageState();

  /// Loading state
  factory ShiftPageState.loading() => const ShiftPageState(isLoading: true);

  /// Error state
  factory ShiftPageState.error(String message) => ShiftPageState(
        errorMessage: message,
        isLoading: false,
      );

  /// Success state with shifts
  factory ShiftPageState.success(List<StoreShift> shifts) => ShiftPageState(
        shifts: shifts,
        isLoading: false,
      );
}

/// Shift List Filter State - Filter options for shift list
///
/// Manages filtering and searching of shifts.
@freezed
class ShiftFilterState with _$ShiftFilterState {
  const ShiftFilterState._(); // Private constructor for getters

  const factory ShiftFilterState({
    @Default('') String searchText,
    @Default('all') String timeFilter, // all, morning, afternoon, evening, night
    @Default(true) bool showActiveOnly,
  }) = _ShiftFilterState;

  /// Get display name for current filter
  String get displayName {
    if (searchText.isNotEmpty) return 'Search: $searchText';
    if (timeFilter != 'all') return timeFilter.toUpperCase();
    if (!showActiveOnly) return 'All Shifts (including inactive)';
    return 'All Active Shifts';
  }

  /// Check if any filter is active
  bool get hasActiveFilter {
    return searchText.isNotEmpty || timeFilter != 'all' || !showActiveOnly;
  }
}
