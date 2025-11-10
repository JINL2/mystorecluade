import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';

/// Schedule Approve Button
///
/// Shows approve/not approve button for selected shift requests with toggle functionality
class ScheduleApproveButton extends StatelessWidget {
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

  Future<void> _handleApprovalToggle(BuildContext context) async {
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
      // Use direct Supabase RPC call (same as lib_old)
      await Supabase.instance.client.rpc<void>(
        'toggle_shift_approval',
        params: {
          'p_user_id': userId,
          'p_shift_request_ids': selectedShiftRequestIds.values.toList(),
        },
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
            onPrimaryPressed: () => Navigator.of(context).pop(),
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
  Widget build(BuildContext context) {
    final isEnabled = selectedShiftRequests.isNotEmpty && selectedShiftRequestIds.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: InkWell(
        onTap: isEnabled ? () => _handleApprovalToggle(context) : null,
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
