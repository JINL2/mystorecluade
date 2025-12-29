import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../app/providers/app_state_provider.dart';
import '../../../../domain/usecases/toggle_shift_approval.dart';
import '../../../providers/time_table_providers.dart';

/// Schedule Approval Handler Mixin
///
/// Handles approve/remove operations for shift requests.
/// Uses Riverpod for state management and partial updates.
mixin ScheduleApprovalHandlerMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  /// Selected store ID - must be provided by implementing class
  String? get selectedStoreId;

  /// Selected date - must be provided by implementing class
  DateTime get selectedDate;

  /// Handle Approve button click
  ///
  /// Calls toggle_shift_approval_v3 RPC to approve a shift request.
  /// Local state is updated by ScheduleShiftCard for instant UI feedback.
  /// Uses Partial Update for cross-tab sync instead of full refresh.
  /// Returns true on success, false on failure.
  Future<bool> handleApprove(String shiftRequestId) async {
    if (shiftRequestId.isEmpty) return false;

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;

    if (userId.isEmpty) return false;

    try {
      final useCase = ref.read(toggleShiftApprovalUseCaseProvider);
      await useCase(
        ToggleShiftApprovalParams(
          shiftRequestIds: [shiftRequestId],
          userId: userId,
        ),
      );

      // Partial Update: Update only the affected card instead of full refresh
      // This is much more efficient than loading all data again
      if (selectedStoreId != null) {
        final shiftDate = DateFormat('yyyy-MM-dd').format(selectedDate);

        // Update MonthlyShiftStatus (Schedule tab data)
        ref
            .read(monthlyShiftStatusProvider(selectedStoreId!).notifier)
            .updateShiftRequestApproval(
              shiftRequestId: shiftRequestId,
              isApproved: true,
              shiftDate: shiftDate,
            );

        // Update ManagerCards (Timesheets/Problems tab data)
        ref.read(managerCardsProvider(selectedStoreId!).notifier).updateCardApproval(
              shiftRequestId: shiftRequestId,
              isApproved: true,
              shiftDate: shiftDate,
            );
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Handle Remove button click from bottom sheet
  ///
  /// Calls toggle_shift_approval_v3 RPC to unapprove a shift request.
  /// Local state is updated by ScheduleShiftCard for instant UI feedback.
  /// Uses Partial Update for cross-tab sync instead of full refresh.
  /// Returns true on success, false on failure.
  Future<bool> handleRemove(String shiftRequestId) async {
    if (shiftRequestId.isEmpty) return false;

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;

    if (userId.isEmpty) return false;

    try {
      final useCase = ref.read(toggleShiftApprovalUseCaseProvider);
      await useCase(
        ToggleShiftApprovalParams(
          shiftRequestIds: [shiftRequestId],
          userId: userId,
        ),
      );

      // Partial Update: Update only the affected card instead of full refresh
      // This is much more efficient than loading all data again
      if (selectedStoreId != null) {
        final shiftDate = DateFormat('yyyy-MM-dd').format(selectedDate);

        // Update MonthlyShiftStatus (Schedule tab data)
        ref
            .read(monthlyShiftStatusProvider(selectedStoreId!).notifier)
            .updateShiftRequestApproval(
              shiftRequestId: shiftRequestId,
              isApproved: false,
              shiftDate: shiftDate,
            );

        // Update ManagerCards (Timesheets/Problems tab data)
        ref.read(managerCardsProvider(selectedStoreId!).notifier).updateCardApproval(
              shiftRequestId: shiftRequestId,
              isApproved: false,
              shiftDate: shiftDate,
            );
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
