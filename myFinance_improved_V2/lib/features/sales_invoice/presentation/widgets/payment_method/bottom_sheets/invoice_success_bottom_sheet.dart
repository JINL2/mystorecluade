import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../helpers/payment_helpers.dart';

/// Dialog for showing invoice creation success (centered on screen)
class InvoiceSuccessBottomSheet extends StatelessWidget {
  final String invoiceNumber;
  final double totalAmount;
  final String warningMessage;
  final VoidCallback onDismiss;

  const InvoiceSuccessBottomSheet({
    super.key,
    required this.invoiceNumber,
    required this.totalAmount,
    this.warningMessage = '',
    required this.onDismiss,
  });

  /// Show the invoice success dialog (centered)
  static void show(
    BuildContext context, {
    required String invoiceNumber,
    required double totalAmount,
    String warningMessage = '',
    required VoidCallback onDismiss,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: TossColors.black.withValues(alpha: 0.5),
      builder: (context) => InvoiceSuccessBottomSheet(
        invoiceNumber: invoiceNumber,
        totalAmount: totalAmount,
        warningMessage: warningMessage,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSuccessIcon(),
                const SizedBox(height: TossSpacing.space4),
                _buildTitle(),
                const SizedBox(height: TossSpacing.space2),
                _buildInvoiceNumber(),
                const SizedBox(height: TossSpacing.space4),
                _buildTotalAmount(),
                const SizedBox(height: TossSpacing.space5),
                _buildOkButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: TossColors.success.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.check_rounded,
          color: TossColors.success,
          size: 36,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Invoice Created',
      style: TossTextStyles.h3.copyWith(
        color: TossColors.gray900,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildInvoiceNumber() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        invoiceNumber,
        style: TossTextStyles.bodyLarge.copyWith(
          color: TossColors.gray700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTotalAmount() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        children: [
          Text(
            'Total Amount',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            PaymentHelpers.formatNumber(totalAmount.toInt()),
            style: TossTextStyles.h2.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOkButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.pop(); // Close bottom sheet
          onDismiss();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: TossColors.primary,
          foregroundColor: TossColors.white,
          padding: const EdgeInsets.symmetric(
            vertical: TossSpacing.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          elevation: 0,
        ),
        child: Text(
          'OK',
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
