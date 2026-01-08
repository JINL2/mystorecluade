// lib/features/cash_ending/presentation/widgets/total_display.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

/// Total display widget
///
/// Shows the total amount calculated from denominations.
class TotalDisplay extends StatelessWidget {
  final double totalAmount;
  final String currencySymbol;
  final String label;

  const TotalDisplay({
    super.key,
    required this.totalAmount,
    required this.currencySymbol,
    this.label = 'Total',
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final formattedAmount = '$currencySymbol${formatter.format(totalAmount.toInt())}';

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            formattedAmount,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
    );
  }
}
