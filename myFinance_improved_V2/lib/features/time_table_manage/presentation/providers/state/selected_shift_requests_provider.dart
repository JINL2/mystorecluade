/// Selected Shift Requests Provider
///
/// Manages multi-selection state for shift requests.
/// Used for bulk approval operations in the manage tab.
library;

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/time_table_state.dart';

/// Selected Shift Requests Notifier
///
/// Features:
/// - Multi-selection support
/// - Approval state tracking
/// - Request ID mapping
/// - Toggle selection logic
class SelectedShiftRequestsNotifier
    extends StateNotifier<SelectedShiftRequestsState> {
  SelectedShiftRequestsNotifier() : super(const SelectedShiftRequestsState());

  /// Safely update state - avoids "setState during build" errors
  /// by deferring state updates if called during widget build phase
  void _safeSetState(SelectedShiftRequestsState newState) {
    if (!mounted) return;

    // Check if we're in the middle of a build phase
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.persistentCallbacks ||
        phase == SchedulerPhase.midFrameMicrotasks) {
      // Defer state update to after the current frame
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          state = newState;
        }
      });
    } else {
      state = newState;
    }
  }

  /// Toggle selection for a shift request
  ///
  /// Parameters:
  /// - [shiftRequestId]: ID of the shift request to toggle
  /// - [isApproved]: Current approval state of the request
  /// - [actualRequestId]: Actual request ID (may differ from shiftRequestId)
  void toggleSelection(String shiftRequestId, bool isApproved, String actualRequestId) {
    if (!mounted) return;

    final newSelectedIds = Set<String>.from(state.selectedIds);
    final newApprovalStates = Map<String, bool>.from(state.approvalStates);
    final newRequestIds = Map<String, String>.from(state.requestIds);

    if (newSelectedIds.contains(shiftRequestId)) {
      // Deselect
      newSelectedIds.remove(shiftRequestId);
      newApprovalStates.remove(shiftRequestId);
      newRequestIds.remove(shiftRequestId);
    } else {
      // Select
      newSelectedIds.add(shiftRequestId);
      newApprovalStates[shiftRequestId] = isApproved;
      newRequestIds[shiftRequestId] = actualRequestId;
    }

    _safeSetState(state.copyWith(
      selectedIds: newSelectedIds,
      approvalStates: newApprovalStates,
      requestIds: newRequestIds,
    ));
  }

  /// Clear all selections
  void clearAll() {
    if (!mounted) return;
    _safeSetState(const SelectedShiftRequestsState());
  }

  /// Check if a shift request is selected
  bool isSelected(String shiftRequestId) {
    return state.selectedIds.contains(shiftRequestId);
  }
}

/// Selected Shift Requests Provider
///
/// Usage:
/// ```dart
/// final selection = ref.watch(selectedShiftRequestsProvider);
/// ref.read(selectedShiftRequestsProvider.notifier).toggleSelection(id, isApproved, actualId);
/// ref.read(selectedShiftRequestsProvider.notifier).clearAll();
/// ```
final selectedShiftRequestsProvider = StateNotifierProvider<
    SelectedShiftRequestsNotifier,
    SelectedShiftRequestsState>((ref) {
  return SelectedShiftRequestsNotifier();
});
