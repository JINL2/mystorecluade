import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/utils/datetime_utils.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../providers/attendance_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Dialog for reporting shift issues
class ReportIssueDialog {
  static Future<void> show({
    required BuildContext context,
    required WidgetRef ref,
    required String shiftRequestId,
    required Map<String, dynamic> cardData,
    required VoidCallback onSuccess,
  }) async {
    final TextEditingController reasonController = TextEditingController();
    bool isSubmitting = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return Dialog(
              backgroundColor: TossColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space5,
                vertical: TossSpacing.space6,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TossSpacing.space5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(TossSpacing.space2),
                          decoration: BoxDecoration(
                            color: TossColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          child: const Icon(
                            Icons.flag_outlined,
                            color: TossColors.error,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Report Issue',
                                style: TossTextStyles.h4.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Please describe the problem',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: isSubmitting ? null : () => Navigator.of(dialogContext).pop(),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: TossSpacing.space5),

                    // Text field
                    Container(
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        border: Border.all(color: TossColors.gray200, width: 1),
                      ),
                      child: TextField(
                        controller: reasonController,
                        maxLines: 4,
                        maxLength: 500,
                        enabled: !isSubmitting,
                        onChanged: (value) => setDialogState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Enter the reason for reporting this issue...',
                          hintStyle: TossTextStyles.body.copyWith(color: TossColors.gray400),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(TossSpacing.space4),
                          counterStyle: TossTextStyles.bodySmall.copyWith(color: TossColors.gray500),
                        ),
                        style: TossTextStyles.body.copyWith(color: TossColors.gray900),
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space5),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: isSubmitting ? null : () => Navigator.of(dialogContext).pop(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isSubmitting || reasonController.text.trim().isEmpty
                                ? null
                                : () => _handleSubmit(
                                      context: context,
                                      dialogContext: dialogContext,
                                      ref: ref,
                                      shiftRequestId: shiftRequestId,
                                      cardData: cardData,
                                      reason: reasonController.text.trim(),
                                      setDialogState: setDialogState,
                                      setIsSubmitting: (value) => isSubmitting = value,
                                      onSuccess: onSuccess,
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSubmitting || reasonController.text.trim().isEmpty
                                  ? TossColors.gray200
                                  : TossColors.error,
                              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                            ),
                            child: isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(TossColors.gray400),
                                    ),
                                  )
                                : Text(
                                    'Report',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.surface,
                                      fontWeight: FontWeight.w600,
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
      },
    );
  }

  static Future<void> _handleSubmit({
    required BuildContext context,
    required BuildContext dialogContext,
    required WidgetRef ref,
    required String shiftRequestId,
    required Map<String, dynamic> cardData,
    required String reason,
    required StateSetter setDialogState,
    required void Function(bool) setIsSubmitting,
    required VoidCallback onSuccess,
  }) async {
    if (reason.isEmpty) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Validation Error',
          message: 'Please enter a reason',
          primaryButtonText: 'OK',
        ),
      );
      return;
    }

    setDialogState(() => setIsSubmitting(true));

    try {
      final reportShiftIssue = ref.read(reportShiftIssueProvider);
      final result = await reportShiftIssue(
        shiftRequestId: shiftRequestId,
        reportReason: reason,
        time: DateTimeUtils.toLocalWithOffset(DateTime.now()),
        timezone: DateTimeUtils.getLocalTimezone(),
      );

      // Either pattern: fold to get success value
      final success = result.fold(
        (failure) => false,
        (data) => data,
      );

      if (!success) {
        throw Exception('Failed to report shift issue');
      }

      // Update local card data
      final nowUtc = DateTime.now().toUtc().toIso8601String();
      cardData['is_reported'] = true;
      cardData['report_time'] = nowUtc;
      cardData['report_reason'] = reason;
      cardData['is_problem_solved'] = false;

      Navigator.of(dialogContext).pop();
      onSuccess();

      // Show success popup
      if (context.mounted) {
        _showSuccessPopup(context);
      }
    } catch (e) {
      setDialogState(() => setIsSubmitting(false));
      Navigator.of(dialogContext).pop();

      if (context.mounted) {
        _showErrorPopup(context);
      }
    }
  }

  static void _showSuccessPopup(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext successContext) {
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.of(successContext).canPop()) {
            Navigator.of(successContext).pop();
          }
        });

        return Dialog(
          backgroundColor: TossColors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
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
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: TossColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: TossColors.success,
                    size: 36,
                  ),
                ),
                const SizedBox(height: TossSpacing.space4),
                Text(
                  'Report Submitted',
                  style: TossTextStyles.h4.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Your issue has been reported\nand will be reviewed soon',
                  textAlign: TextAlign.center,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _showErrorPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext errorContext) {
        return Dialog(
          backgroundColor: TossColors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
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
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: TossColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: TossColors.error,
                    size: 36,
                  ),
                ),
                const SizedBox(height: TossSpacing.space4),
                Text(
                  'Report Failed',
                  style: TossTextStyles.h4.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Failed to report issue.\nPlease try again later.',
                  textAlign: TextAlign.center,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: TossSpacing.space4),
                ElevatedButton(
                  onPressed: () => Navigator.of(errorContext).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space6,
                      vertical: TossSpacing.space3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.surface,
                      fontWeight: FontWeight.w600,
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
}
