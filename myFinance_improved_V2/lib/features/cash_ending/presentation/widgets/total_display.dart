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

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TossColors.primary,
            TossColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: TossColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate,
                color: TossColors.white.withOpacity(0.9),
                size: 20,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                currencySymbol,
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: TossSpacing.space1),
              Expanded(
                child: Text(
                  formatter.format(totalAmount.toInt()),
                  style: TossTextStyles.display.copyWith(
                    color: TossColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
