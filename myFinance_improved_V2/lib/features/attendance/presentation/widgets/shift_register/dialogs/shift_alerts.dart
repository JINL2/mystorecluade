import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// Collection of alert dialogs used in shift registration/cancellation flows.
///
/// This class provides static methods to show various confirmation and information
/// dialogs with consistent Toss-style UI.
class ShiftAlerts {
  /// Shows an alert when user tries to cancel a mix of approved and pending shifts.
  ///
  /// Only pending shifts can be cancelled, so this dialog asks if the user wants
  /// to proceed with cancelling only the pending ones.
  static void showMixedShiftAlert(
    BuildContext context, {
    required List<Map<String, dynamic>> approvedShifts,
    required List<Map<String, dynamic>> pendingShifts,
    required VoidCallback onCancelPending,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: TossColors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon and Title Section
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: TossColors.warning.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: TossColors.warning,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Mixed Shift Status',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: '${approvedShifts.length} shift${approvedShifts.length > 1 ? 's' : ''}',
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.success,
                              ),
                            ),
                            const TextSpan(text: ' are approved and cannot be cancelled.\n'),
                            const TextSpan(text: 'Only '),
                            TextSpan(
                              text: '${pendingShifts.length} pending shift${pendingShifts.length > 1 ? 's' : ''}',
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.warning,
                              ),
                            ),
                            const TextSpan(text: ' can be cancelled.\n\nDo you want to cancel the pending shifts?'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  height: 1,
                  color: TossColors.gray100,
                ),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.pop();
                        },
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: TossSpacing.space4,
                          ),
                          child: Center(
                            child: Text(
                              'No',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: TossColors.gray100,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.pop();
                          onCancelPending();
                        },
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: TossSpacing.space4,
                          ),
                          child: Center(
                            child: Text(
                              'Cancel Pending',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Shows an alert when user tries to cancel a shift they haven't registered for.
  static void showNotRegisteredAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: TossColors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon and Title Section
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: TossColors.warning.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: TossColors.warning,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Not Registered',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'You have not registered for this shift.\nYou can only cancel shifts you have registered for.',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // OK Button
                InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.pop();
                  },
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: TossSpacing.space4,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: TossColors.gray200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'OK',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Shows an alert when user tries to cancel an approved shift.
  ///
  /// Approved shifts cannot be cancelled directly and require manager intervention.
  static void showApprovedShiftAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: TossColors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon and Title Section
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: TossColors.warning.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: TossColors.warning,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Cannot Cancel Approved Shift',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'This shift has already been approved.\nPlease ask your manager to cancel it.',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  height: 1,
                  color: TossColors.gray100,
                ),

                // Button
                InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.pop();
                  },
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: TossSpacing.space4,
                    ),
                    child: Center(
                      child: Text(
                        'OK',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Shows a confirmation dialog before cancelling shifts.
  ///
  /// [shiftsToCancel] - List of shift data to be cancelled
  /// [onConfirm] - Callback when user confirms cancellation
  static void showCancelConfirmationDialog(
    BuildContext context, {
    required List<Map<String, dynamic>> shiftsToCancel,
    required Future<void> Function() onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: TossColors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon and Title Section
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: TossColors.error.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          color: TossColors.error,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Cancel Shift',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'Are you sure you want to cancel ${shiftsToCancel.length} shift${shiftsToCancel.length > 1 ? 's' : ''}?',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  height: 1,
                  color: TossColors.gray100,
                ),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.pop();
                        },
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: TossSpacing.space4,
                          ),
                          child: Center(
                            child: Text(
                              'No',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: TossColors.gray100,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          HapticFeedback.mediumImpact();
                          context.pop();
                          await onConfirm();
                        },
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: TossSpacing.space4,
                          ),
                          child: Center(
                            child: Text(
                              'Yes, Cancel',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
