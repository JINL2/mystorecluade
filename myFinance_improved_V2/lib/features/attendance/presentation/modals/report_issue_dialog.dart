import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../domain/entities/shift_card_data.dart';
import '../providers/attendance_providers.dart';

/// Dialog for reporting issues with shift attendance
///
/// Allows users to:
/// - Submit a detailed issue report for a specific shift
/// - View loading state during submission
/// - Receive success/error feedback
/// - Auto-refresh data after successful submission
class ReportIssueDialog extends ConsumerStatefulWidget {
  final String shiftRequestId;
  final ShiftCardData cardData;
  final VoidCallback onSuccess;

  const ReportIssueDialog({
    super.key,
    required this.shiftRequestId,
    required this.cardData,
    required this.onSuccess,
  });

  /// Shows the report issue dialog
  static Future<void> show({
    required BuildContext context,
    required String shiftRequestId,
    required ShiftCardData cardData,
    required VoidCallback onSuccess,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ReportIssueDialog(
        shiftRequestId: shiftRequestId,
        cardData: cardData,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  ConsumerState<ReportIssueDialog> createState() => _ReportIssueDialogState();
}

class _ReportIssueDialogState extends ConsumerState<ReportIssueDialog> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TossColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space5),
        width: MediaQuery.of(context).size.width * 0.9,
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
                  onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space5),

            // Text field for reason
            Container(
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                border: Border.all(
                  color: TossColors.gray200,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _reasonController,
                maxLines: 4,
                maxLength: 500,
                enabled: !_isSubmitting,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Enter the reason for reporting this issue...',
                  hintStyle: TossTextStyles.body.copyWith(
                    color: TossColors.gray400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(TossSpacing.space4),
                  counterStyle: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                ),
              ),
            ),

            const SizedBox(height: TossSpacing.space5),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
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
                    onPressed: _isSubmitting || _reasonController.text.trim().isEmpty
                        ? null
                        : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSubmitting || _reasonController.text.trim().isEmpty
                          ? TossColors.gray200
                          : TossColors.error,
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                    ),
                    child: _isSubmitting
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
  }

  Future<void> _handleSubmit() async {
    final reason = _reasonController.text.trim();
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

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Report shift issue via use case
      final reportShiftIssue = ref.read(reportShiftIssueProvider);
      final success = await reportShiftIssue(
        shiftRequestId: widget.shiftRequestId,
        reportReason: reason,
      );

      if (!success) {
        throw Exception('Failed to report shift issue');
      }

      if (!mounted) return;

      // Close the report dialog
      Navigator.of(context).pop();

      // Close the shift details bottom sheet
      context.pop();

      // Call success callback to refresh data
      widget.onSuccess();

      // Show success popup
      await _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      // Close the report dialog
      Navigator.of(context).pop();

      // Show error popup
      await _showErrorDialog();
    }
  }

  Future<void> _showSuccessDialog() async {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext successContext) {
        // Auto-dismiss after 2 seconds
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
                // Success icon
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
                // Success title
                Text(
                  'Report Submitted',
                  style: TossTextStyles.h4.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                // Success message
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

  Future<void> _showErrorDialog() async {
    if (!mounted) return;

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
                // Error icon
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
                // Error title
                Text(
                  'Report Failed',
                  style: TossTextStyles.h4.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                // Error message
                Text(
                  'Failed to report issue.\nPlease try again later.',
                  textAlign: TextAlign.center,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: TossSpacing.space4),
                // OK button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(errorContext).pop();
                  },
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
