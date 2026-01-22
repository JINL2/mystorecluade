// lib/features/cash_ending/presentation/pages/cash_ending_completion/auto_balance_dialogs.dart

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/balance_summary.dart';
import 'auto_balance_type.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Shows dialog to select auto-balance type (Error or Foreign Currency)
void showAutoBalanceTypeSelection({
  required BuildContext context,
  required void Function(AutoBalanceType type) onTypeSelected,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Select Adjustment Type',
                style: TossTextStyles.dialogTitleLarge,
              ),
              const SizedBox(height: TossSpacing.space5),
              Text(
                'Choose the type of adjustment to apply',
                style: TossTextStyles.bodyGray600,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TossSpacing.space6),

              // Error Adjustment Button
              TossButton.primary(
                text: 'Error Adjustment',
                fullWidth: true,
                textStyle: TossTextStyles.bodyWhiteBold,
                padding: const EdgeInsets.symmetric(
                  vertical: TossSpacing.space3,
                ),
                borderRadius: 12,
                onPressed: () {
                  Navigator.of(context).pop();
                  onTypeSelected(AutoBalanceType.error);
                },
                leadingIcon: const Icon(
                  Icons.error_outline,
                  size: 18,
                  color: TossColors.white,
                ),
              ),
              const SizedBox(height: TossSpacing.space3),

              // Foreign Currency Translation Button
              TossButton.secondary(
                text: 'Foreign Currency Translation',
                fullWidth: true,
                textStyle: TossTextStyles.bodyMedium,
                padding: const EdgeInsets.symmetric(
                  vertical: TossSpacing.space3,
                ),
                borderRadius: 12,
                onPressed: () {
                  Navigator.of(context).pop();
                  onTypeSelected(AutoBalanceType.foreignCurrency);
                },
                leadingIcon: const Icon(
                  Icons.currency_exchange,
                  size: 18,
                  color: TossColors.gray600,
                ),
              ),
              const SizedBox(height: TossSpacing.space3),

              // Cancel button
              TossButton.textButton(
                text: 'Cancel',
                onPressed: () => Navigator.of(context).pop(),
                textStyle: TossTextStyles.bodyTertiary,
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Shows confirmation dialog before applying auto-balance
void showAutoBalanceConfirmation({
  required BuildContext context,
  required AutoBalanceType type,
  required BalanceSummary? balanceSummary,
  required double grandTotal,
  required String storeName,
  required String locationName,
  required String Function(double) formatAmount,
  required Color Function(BalanceSummary?) getPercentageColor,
  required Future<void> Function(AutoBalanceType) onConfirm,
}) {
  // Get actual values from current balance summary
  final totalJournal = balanceSummary?.totalJournal ?? 0.0;
  final totalReal = balanceSummary?.totalReal ?? grandTotal;
  final difference = balanceSummary?.difference ?? (totalReal - totalJournal);
  final isShortage = difference < 0;
  final isSurplus = difference > 0;

  // Determine difference color based on actual balance status
  final differenceColor = isShortage
      ? TossColors.error
      : isSurplus
          ? TossColors.warning
          : TossColors.success;

  // Use current balance summary formatted values (with correct currency symbol)
  final formattedTotalReal = balanceSummary?.formattedTotalReal ?? formatAmount(totalReal);
  final formattedTotalJournal = balanceSummary?.formattedTotalJournal ?? formatAmount(totalJournal);
  final formattedDifference = balanceSummary?.formattedDifference ?? formatAmount(difference);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
        ),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: TossSpacing.space2),
              // Title
              Text(
                'Confirm Auto-Balance',
                style: TossTextStyles.dialogTitleLarge,
              ),
              const SizedBox(height: TossSpacing.space5),

              // Description
              Text(
                'Review the details below before applying Auto-Balance',
                style: TossTextStyles.bodyGray600,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TossSpacing.space6),

              // Details container
              Container(
                padding: const EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.white,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  border: Border.all(
                    color: TossColors.gray200,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    _buildConfirmationRow('Location', '$storeName · $locationName'),
                    const SizedBox(height: TossSpacing.space3),
                    _buildConfirmationRow('Total Real', formattedTotalReal),
                    const SizedBox(height: TossSpacing.space3),
                    _buildConfirmationRow('Total Journal', formattedTotalJournal),
                    const SizedBox(height: TossSpacing.space4),

                    // Difference (highlighted with actual color)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Difference',
                          style: TossTextStyles.bodyMedium,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formattedDifference,
                              style: TossTextStyles.bodyBold.copyWith(
                                color: differenceColor,
                              ),
                            ),
                            // Show percentage below difference in dialog
                            if (balanceSummary != null) ...[
                              SizedBox(height: TossSpacing.space1 / 2),
                              Text(
                                balanceSummary.formattedPercentage,
                                style: TossTextStyles.smallPrimary.copyWith(
                                  color: getPercentageColor(balanceSummary),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TossSpacing.space5),

              // Explanation text
              Text(
                'This action will add a Journal entry to match the Real amount.',
                style: TossTextStyles.captionGray500,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TossSpacing.space6),

              // Buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: TossButton.secondary(
                      text: 'Cancel',
                      fullWidth: true,
                      textStyle: TossTextStyles.bodyMedium,
                      padding: const EdgeInsets.symmetric(
                        vertical: TossSpacing.space3,
                      ),
                      borderRadius: 12,
                      onPressed: () => Navigator.of(context).pop(),
                      leadingIcon: const Icon(
                        Icons.arrow_back,
                        size: 18,
                        color: TossColors.gray600,
                      ),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),

                  // Confirm button
                  Expanded(
                    child: TossButton.primary(
                      text: 'Confirm & Apply',
                      fullWidth: true,
                      textStyle: TossTextStyles.bodyWhiteBold,
                      padding: const EdgeInsets.symmetric(
                        vertical: TossSpacing.space3,
                      ),
                      borderRadius: 12,
                      onPressed: () {
                        // Close dialog first, then apply auto-balance
                        // This prevents "deactivated widget" errors when showing toast
                        Navigator.of(context).pop();
                        onConfirm(type);
                      },
                      leadingIcon: const Icon(
                        Icons.check,
                        size: 18,
                        color: TossColors.white,
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

Widget _buildConfirmationRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TossTextStyles.dialogInfoLabel,
      ),
      const SizedBox(width: TossSpacing.space2),
      Flexible(
        child: Text(
          value,
          style: TossTextStyles.listItemTitle,
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
