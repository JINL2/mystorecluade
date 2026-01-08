import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../domain/entities/currency.dart';

/// Currency info header widget for exchange rate sheet
class CurrencyInfoHeader extends StatelessWidget {
  final Currency currency;
  final String? baseCurrencySymbol;
  final String? baseCurrencyCode;

  const CurrencyInfoHeader({
    super.key,
    required this.currency,
    this.baseCurrencySymbol,
    this.baseCurrencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          _buildFlagContainer(),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: _buildCurrencyInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildFlagContainer() {
    return Container(
      width: TossSpacing.iconXXL,
      height: TossSpacing.iconXXL,
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Center(
        child: Text(
          currency.flagEmoji,
          style: TossTextStyles.h3,
        ),
      ),
    );
  }

  Widget _buildCurrencyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${currency.code} - ${currency.name}',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        if (baseCurrencySymbol != null) ...[
          Text(
            'Base Currency: $baseCurrencySymbol ($baseCurrencyCode)',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ],
    );
  }
}
