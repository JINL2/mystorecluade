import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/invoice.dart';

/// Invoice confirmation dialogs helper class
class InvoiceConfirmationDialogs {
  static final _currencyFormat =
      NumberFormat.currency(symbol: '', decimalDigits: 0);

  /// Show refund confirmation dialog
  static void showRefundConfirmation(
    BuildContext context, {
    required Invoice invoice,
    required String currencySymbol,
    required VoidCallback onConfirm,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.replay,
                color: TossColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            const Text('Refund Invoice'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to refund this invoice?',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Column(
                children: [
                  Text(
                    'Refund Amount',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    _formatAmount(invoice.amounts.totalAmount, currencySymbol),
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Invoice: ${invoice.invoiceNumber}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            // Buttons row - Cancel and Refund side by side
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: TossColors.gray700,
                      side: const BorderSide(color: TossColors.gray300),
                      padding: const EdgeInsets.symmetric(
                        vertical: TossSpacing.space3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                // Refund button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext); // Close dialog
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.error,
                      foregroundColor: TossColors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: TossSpacing.space3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                    ),
                    child: Text(
                      'Refund',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [], // Empty actions since we have custom buttons in content
      ),
    );
  }

  /// Show delete confirmation dialog
  static void showDeleteConfirmation(
    BuildContext context, {
    required Invoice invoice,
    required VoidCallback onConfirm,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                color: TossColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            const Text('Delete Invoice'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete invoice ${invoice.invoiceNumber}? This action cannot be undone.',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.error,
              foregroundColor: TossColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static String _formatAmount(double amount, String symbol) {
    final formatted = _currencyFormat.format(amount);
    if (symbol.isEmpty || symbol == '\$') {
      return '$formattedđ';
    }
    return '$symbol$formatted';
  }
}
