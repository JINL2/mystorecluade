// lib/features/sales_invoice/presentation/widgets/payment_method/invoice_loading_dialog.dart
//
// Invoice loading dialog extracted from payment_method_page.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Loading dialog for invoice creation
class InvoiceLoadingDialog extends StatelessWidget {
  final String message;

  const InvoiceLoadingDialog({
    super.key,
    this.message = 'Creating invoice...',
  });

  /// Show the loading dialog
  static void show(BuildContext context, {String? message}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => InvoiceLoadingDialog(
        message: message ?? 'Creating invoice...',
      ),
    );
  }

  /// Hide the loading dialog
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: TossColors.primary),
              const SizedBox(height: TossSpacing.space3),
              Text(
                message,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
