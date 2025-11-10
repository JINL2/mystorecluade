import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_selection_state.freezed.dart';

/// State for managing shift selections in the time table
///
/// This state is extracted from the page for better testability
/// and separation of concerns. It manages:
/// - Multi-selection of shifts
/// - Approval states tracking
/// - Shift request ID mapping
@freezed
class ShiftSelectionState with _$ShiftSelectionState {
  const factory ShiftSelectionState({
    /// Set of selected shift keys (shift_id + user_name combination)
    @Default({}) Set<String> selectedShiftKeys,

    /// Map of shift key to approval state
    @Default({}) Map<String, bool> approvalStates,

    /// Map of shift key to actual shift_request_id for RPC calls
    @Default({}) Map<String, String> shiftRequestIds,
  }) = _ShiftSelectionState;

  const ShiftSelectionState._();

  /// Check if any shifts are selected
  bool get hasSelections => selectedShiftKeys.isNotEmpty;

  /// Get count of selected shifts
  int get selectionCount => selectedShiftKeys.length;

  /// Check if all selected shifts are approved
  bool get allSelectedAreApproved {
    if (selectedShiftKeys.isEmpty) return false;
    return selectedShiftKeys.every((key) => approvalStates[key] == true);
  }

  /// Check if all selected shifts are pending
  bool get allSelectedArePending {
    if (selectedShiftKeys.isEmpty) return false;
    return selectedShiftKeys.every((key) => approvalStates[key] != true);
  }

  /// Get list of shift request IDs for bulk operations
  List<String> get selectedRequestIds {
    return selectedShiftKeys
        .map((key) => shiftRequestIds[key])
        .where((id) => id != null)
        .cast<String>()
        .toList();
  }
}
