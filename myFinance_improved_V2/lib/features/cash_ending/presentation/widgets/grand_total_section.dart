// lib/features/cash_ending/presentation/widgets/grand_total_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

/// Grand total section displayed at the bottom
///
/// Shows the final total amount in base currency
/// Updated: Now supports multi-currency Grand Total
class GrandTotalSection extends StatelessWidget {
  final double totalAmount;
  final String currencySymbol;
  final String label;
  final bool isBaseCurrency;

  const GrandTotalSection({
    super.key,
    required this.totalAmount,
    required this.currencySymbol,
    this.label = 'Grand total',
    this.isBaseCurrency = true,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final formattedAmount = '$currencySymbol${formatter.format(totalAmount.toInt())}';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: isBaseCurrency
            ? TossColors.primary.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: isBaseCurrency ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            formattedAmount,
            style: TossTextStyles.h3.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: isBaseCurrency ? 24 : 20,
            ),
          ),
        ],
      ),
    );
  }
}
