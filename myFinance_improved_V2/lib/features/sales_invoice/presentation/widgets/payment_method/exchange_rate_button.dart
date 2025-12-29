// lib/features/sales_invoice/presentation/widgets/payment_method/exchange_rate_button.dart
//
// Exchange rate toggle button extracted from payment_method_page.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Exchange rate toggle button for AppBar
class ExchangeRateButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const ExchangeRateButton({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: TossSpacing.space3),
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space2 + 2,
          vertical: TossSpacing.space1,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Exchange Rate',
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(width: TossSpacing.space1),
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 16,
              color: TossColors.gray600,
            ),
          ],
        ),
      ),
    );
  }
}
