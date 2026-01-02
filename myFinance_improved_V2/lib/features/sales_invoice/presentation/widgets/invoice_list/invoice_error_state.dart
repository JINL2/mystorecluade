// lib/features/sales_invoice/presentation/widgets/invoice_list/invoice_error_state.dart
//
// Extracted error state widget from sales_invoice_page.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Invoice error state widget
///
/// Displays an error state with retry button when invoice loading fails.
class InvoiceErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const InvoiceErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: TossColors.error,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'Error loading invoices',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Text(
              error,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          TossButton.primary(
            text: 'Retry',
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
