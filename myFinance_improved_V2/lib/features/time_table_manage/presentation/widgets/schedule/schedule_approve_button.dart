import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../domain/usecases/process_bulk_approval.dart';
import '../../providers/time_table_providers.dart';
import '../../providers/usecase/time_table_usecase_providers.dart';

/// Schedule Approve Button
///
/// Shows approve/not approve button for selected shift requests with toggle functionality
class ScheduleApproveButton extends ConsumerWidget {
  final Set<String> selectedShiftRequests;
  final Map<String, bool> selectedShiftApprovalStates;
  final Map<String, String> selectedShiftRequestIds;
  final String userId;
  final DateTime selectedDate;
  final VoidCallback onSuccess;

  const ScheduleApproveButton({
    super.key,
    required this.selectedShiftRequests,
    required this.selectedShiftApprovalStates,
    required this.selectedShiftRequestIds,
    required this.userId,
    required this.selectedDate,
    required this.onSuccess,
  });

  Future<void> _handleApprovalToggle(BuildContext context, WidgetRef ref) async {
    HapticFeedback.mediumImpact();

    if (userId.isEmpty || selectedShiftRequestIds.isEmpty) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Error',
          message: 'Missing user ID or shift request ID',
          primaryButtonText: 'OK',
        ),
      );
      return;
    }

    try {
      // ✅ FIXED: Use Repository/UseCase instead of direct Supabase call
      // Determine new approval states based on current states
      final shiftRequestIdsList = selectedShiftRequestIds.values.toList();
      final approvalStatesList = shiftRequestIdsList.map((id) {
        // Find the key (shift_id + user_name) that maps to this shift_request_id
        final key = selectedShiftRequestIds.entries
            .firstWhere((entry) => entry.value == id)
            .key;
        // Toggle the current state
        final currentState = selectedShiftApprovalStates[key] ?? false;
        return !currentState; // Toggle the state
      }).toList();

      await ref.read(processBulkApprovalUseCaseProvider).call(
        ProcessBulkApprovalParams(
          shiftRequestIds: shiftRequestIdsList,
          approvalStates: approvalStatesList,
        ),
      );

      // Determine action based on selected items - if mixed states, show generic message
      final hasApproved = selectedShiftApprovalStates.values.contains(true);
      final hasPending = selectedShiftApprovalStates.values.contains(false);
      final action = hasApproved && hasPending
          ? 'toggled'
          : hasApproved
              ? 'changed to pending'
              : 'approved';

      // Show success dialog
      if (context.mounted) {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.success(
            title: 'Success',
            message: 'Shift request(s) $action successfully',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }

      // Call success callback to refresh data
      onSuccess();
    } catch (e) {
      if (context.mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: e.toString(),
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }

  String _getButtonText() {
    if (selectedShiftRequests.length > 1) {
      return 'Toggle ${selectedShiftRequests.length} Shifts';
    }

    final hasApproved = selectedShiftApprovalStates.values.contains(true);
    final hasPending = selectedShiftApprovalStates.values.contains(false);

    if (hasApproved && !hasPending) {
      return 'Not Approve';
    }

    return 'Approve';
  }

  Color _getButtonColor() {
    if (selectedShiftRequests.isEmpty) {
      return TossColors.gray300;
    }

    final hasApproved = selectedShiftApprovalStates.values.contains(true);
    final hasPending = selectedShiftApprovalStates.values.contains(false);

    if (hasApproved && !hasPending) {
      return TossColors.warning;
    }

    return TossColors.primary;
  }

  Color _getTextColor() {
    return selectedShiftRequests.isNotEmpty
        ? TossColors.white
        : TossColors.gray500;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = selectedShiftRequests.isNotEmpty && selectedShiftRequestIds.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: InkWell(
        onTap: isEnabled ? () => _handleApprovalToggle(context, ref) : null,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: _getButtonColor(),
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          child: Center(
            child: Text(
              _getButtonText(),
              style: TossTextStyles.bodyLarge.copyWith(
                color: _getTextColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
