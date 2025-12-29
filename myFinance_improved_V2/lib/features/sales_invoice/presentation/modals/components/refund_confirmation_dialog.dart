// lib/features/sales_invoice/presentation/modals/components/refund_confirmation_dialog.dart
//
// Refund confirmation dialog extracted from invoice_detail_modal.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/invoice.dart';

/// Refund confirmation dialog
class RefundConfirmationDialog extends StatelessWidget {
  final Invoice invoice;
  final String currencySymbol;
  final NumberFormat? formatter;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const RefundConfirmationDialog({
    super.key,
    required this.invoice,
    required this.currencySymbol,
    this.formatter,
    this.onConfirm,
    this.onCancel,
  });

  /// Show the refund confirmation dialog
  static Future<bool?> show(
    BuildContext context, {
    required Invoice invoice,
    required String currencySymbol,
    NumberFormat? formatter,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => RefundConfirmationDialog(
        invoice: invoice,
        currencySymbol: currencySymbol,
        formatter: formatter,
        onConfirm: () => Navigator.pop(dialogContext, true),
        onCancel: () => Navigator.pop(dialogContext, false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = formatter ?? NumberFormat.currency(symbol: '', decimalDigits: 0);
    final symbol = currencySymbol;

    return AlertDialog(
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
                  '$symbol${currencyFormat.format(invoice.amounts.totalAmount)}',
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: TossColors.error,
            foregroundColor: TossColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
          ),
          child: const Text('Refund'),
        ),
      ],
    );
  }
}
