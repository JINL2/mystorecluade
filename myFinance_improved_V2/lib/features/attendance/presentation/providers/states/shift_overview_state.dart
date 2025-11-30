import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/shift_overview.dart';

part 'shift_overview_state.freezed.dart';

/// Shift Overview Page State - UI state for shift overview
///
/// Manages the state for displaying shift overview data including
/// loading states, error handling, and shift overview entity.
@freezed
class ShiftOverviewState with _$ShiftOverviewState {
  const factory ShiftOverviewState({
    required ShiftOverview overview,
    @Default(false) bool isLoading,
    String? error,
  }) = _ShiftOverviewState;

  factory ShiftOverviewState.initial() {
    return ShiftOverviewState(
      overview: ShiftOverview.empty(''),
      isLoading: false,
    );
  }

  factory ShiftOverviewState.loading() {
    return ShiftOverviewState(
      overview: ShiftOverview.empty(''),
      isLoading: true,
    );
  }
}
