import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Balance verification status card widget
class BalanceVerificationCard extends StatelessWidget {
  final Map<String, dynamic> verification;
  final String currencySymbol;

  const BalanceVerificationCard({
    super.key,
    required this.verification,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final isBalanced = (verification['is_balanced'] as bool?) ?? false;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: isBalanced
            ? TossColors.success.withValues(alpha: 0.05)
            : TossColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: isBalanced
              ? TossColors.success.withValues(alpha: 0.2)
              : TossColors.error.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isBalanced ? Icons.check_circle_outline : Icons.error_outline,
            color: isBalanced ? TossColors.success : TossColors.error,
            size: 24,
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBalanced
                      ? 'Balance Sheet is Balanced'
                      : 'Balance Sheet is Not Balanced',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  'Assets: $currencySymbol${verification['total_assets_formatted']} = '
                  'Liabilities + Equity: $currencySymbol${verification['total_liabilities_and_equity_formatted']}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
