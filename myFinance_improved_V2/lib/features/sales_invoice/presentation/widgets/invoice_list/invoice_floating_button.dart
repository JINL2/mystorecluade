// lib/features/sales_invoice/presentation/widgets/invoice_list/invoice_floating_button.dart
//
// Extracted floating action button from sales_invoice_page.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_dimensions.dart';
import '../../../../../shared/themes/toss_shadows.dart';
import '../../../../../shared/themes/toss_spacing.dart';

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
        width: TossDimensions.avatarXL2,
        height: TossDimensions.avatarXL2,
        decoration: BoxDecoration(
          color: TossColors.primary,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
          boxShadow: TossShadows.fab,
        ),
        child: Icon(
          Icons.add,
          size: TossSpacing.iconMD2,
          color: TossColors.white,
        ),
      ),
    );
  }
}
