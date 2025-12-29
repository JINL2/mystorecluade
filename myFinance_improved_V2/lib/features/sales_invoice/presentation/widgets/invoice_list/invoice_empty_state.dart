// lib/features/sales_invoice/presentation/widgets/invoice_list/invoice_empty_state.dart
//
// Extracted empty state widget from sales_invoice_page.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Invoice empty state widget
///
/// Displays an empty state when no invoices are found.
class InvoiceEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const InvoiceEmptyState({
    super.key,
    this.title = 'No invoices found',
    this.subtitle = 'Create your first invoice to get started',
    this.icon = Icons.receipt_long_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            title,
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            subtitle,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
