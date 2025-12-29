import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Current exchange rate info card
class CurrentRateInfo extends StatelessWidget {
  final String currencyCode;
  final double currentRate;
  final String? baseCurrencySymbol;

  const CurrentRateInfo({
    super.key,
    required this.currencyCode,
    required this.currentRate,
    this.baseCurrencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: TossColors.primary, size: 20),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Current Rate: 1 $currencyCode = ${currentRate.toStringAsFixed(4)} ${baseCurrencySymbol ?? ''}',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
