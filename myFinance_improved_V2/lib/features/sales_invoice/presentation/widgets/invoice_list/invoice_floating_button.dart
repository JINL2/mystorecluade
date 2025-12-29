// lib/features/sales_invoice/presentation/widgets/invoice_list/invoice_floating_button.dart
//
// Extracted floating action button from sales_invoice_page.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';

/// Invoice floating add button widget
///
/// Displays a circular floating action button for creating new invoices.
class InvoiceFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const InvoiceFloatingButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: TossColors.primary,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          size: 24,
          color: TossColors.white,
        ),
      ),
    );
  }
}
