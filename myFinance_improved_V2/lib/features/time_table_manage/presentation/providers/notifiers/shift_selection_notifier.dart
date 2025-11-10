import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/shift_selection_state.dart';

/// Notifier for managing shift selections
///
/// This is extracted from the page widget for better:
/// 1. Testability - Can unit test without UI
/// 2. Reusability - Can use in multiple widgets
/// 3. Separation of concerns - Business logic separate from UI
///
/// Example usage:
/// ```dart
/// // Toggle selection
/// ref.read(shiftSelectionNotifierProvider.notifier).toggleSelection(
///   shiftKey: 'shift1_john',
///   isApproved: false,
///   shiftRequestId: 'req123',
/// );
///
/// // Clear all
/// ref.read(shiftSelectionNotifierProvider.notifier).clearAll();
///
/// // Check state
/// final state = ref.watch(shiftSelectionNotifierProvider);
/// if (state.hasSelections) { ... }
/// ```
class ShiftSelectionNotifier extends StateNotifier<ShiftSelectionState> {
  ShiftSelectionNotifier() : super(const ShiftSelectionState());

  /// Toggle selection of a shift
  void toggleSelection({
    required String shiftKey,
    required bool isApproved,
    required String shiftRequestId,
  }) {
    final currentSelections = Set<String>.from(state.selectedShiftKeys);
    final currentApprovalStates = Map<String, bool>.from(state.approvalStates);
    final currentRequestIds = Map<String, String>.from(state.shiftRequestIds);

    if (currentSelections.contains(shiftKey)) {
      // Deselect
      currentSelections.remove(shiftKey);
      currentApprovalStates.remove(shiftKey);
      currentRequestIds.remove(shiftKey);
    } else {
      // Select
      currentSelections.add(shiftKey);
      currentApprovalStates[shiftKey] = isApproved;
      currentRequestIds[shiftKey] = shiftRequestId;
    }

    state = state.copyWith(
      selectedShiftKeys: currentSelections,
      approvalStates: currentApprovalStates,
      shiftRequestIds: currentRequestIds,
    );
  }

  /// Check if a shift is selected
  bool isSelected(String shiftKey) {
    return state.selectedShiftKeys.contains(shiftKey);
  }

  /// Clear all selections
  void clearAll() {
    state = const ShiftSelectionState();
  }

  /// Select multiple shifts at once (for bulk operations)
  void selectMultiple(List<ShiftSelection> selections) {
    final newSelections = Set<String>.from(state.selectedShiftKeys);
    final newApprovalStates = Map<String, bool>.from(state.approvalStates);
    final newRequestIds = Map<String, String>.from(state.shiftRequestIds);

    for (final selection in selections) {
      newSelections.add(selection.shiftKey);
      newApprovalStates[selection.shiftKey] = selection.isApproved;
      newRequestIds[selection.shiftKey] = selection.shiftRequestId;
    }

    state = state.copyWith(
      selectedShiftKeys: newSelections,
      approvalStates: newApprovalStates,
      shiftRequestIds: newRequestIds,
    );
  }

  /// Deselect multiple shifts
  void deselectMultiple(List<String> shiftKeys) {
    final newSelections = Set<String>.from(state.selectedShiftKeys);
    final newApprovalStates = Map<String, bool>.from(state.approvalStates);
    final newRequestIds = Map<String, String>.from(state.shiftRequestIds);

    for (final key in shiftKeys) {
      newSelections.remove(key);
      newApprovalStates.remove(key);
      newRequestIds.remove(key);
    }

    state = state.copyWith(
      selectedShiftKeys: newSelections,
      approvalStates: newApprovalStates,
      shiftRequestIds: newRequestIds,
    );
  }
}

/// Helper class for batch selection operations
class ShiftSelection {
  final String shiftKey;
  final bool isApproved;
  final String shiftRequestId;

  const ShiftSelection({
    required this.shiftKey,
    required this.isApproved,
    required this.shiftRequestId,
  });
}

/// Provider for shift selection notifier
final shiftSelectionNotifierProvider =
    StateNotifierProvider.autoDispose<ShiftSelectionNotifier, ShiftSelectionState>(
  (ref) => ShiftSelectionNotifier(),
);
