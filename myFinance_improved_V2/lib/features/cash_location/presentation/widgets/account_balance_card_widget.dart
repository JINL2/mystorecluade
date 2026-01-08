import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Account detail balance card widget
/// Shows Total Journal, Total Real, and Error with Auto Mapping button
class AccountBalanceCardWidget extends StatelessWidget {
  final int totalJournal;
  final int totalReal;
  final int error;
  final String currencySymbol;
  final VoidCallback onAutoMappingTap;
  final String Function(double, String) formatCurrency;
  final String Function(double, String) formatCurrencyWithSign;

  const AccountBalanceCardWidget({
    super.key,
    required this.totalJournal,
    required this.totalReal,
    required this.error,
    required this.currencySymbol,
    required this.onAutoMappingTap,
    required this.formatCurrency,
    required this.formatCurrencyWithSign,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance title and Auto Mapping button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Balance',
                style: TossTextStyles.subtitle.copyWith(
                  color: TossColors.gray900,
                ),
              ),
              GestureDetector(
                onTap: onAutoMappingTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: TossOpacity.light),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Text(
                    'Auto Mapping',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space4),

          // Total Journal
          _buildBalanceRow(
            'Total Journal',
            formatCurrency(totalJournal.toDouble(), currencySymbol),
          ),

          SizedBox(height: TossSpacing.space3),

          // Total Real
          _buildBalanceRow(
            'Total Real',
            formatCurrency(totalReal.toDouble(), currencySymbol),
          ),

          // Divider
          Container(
            margin: EdgeInsets.symmetric(vertical: TossSpacing.space4),
            height: 1,
            color: TossColors.gray300,
          ),

          // Error
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Error',
                style: TossTextStyles.subtitle.copyWith(
                  color: TossColors.gray900,
                  fontWeight: TossFontWeight.regular,
                ),
              ),
              Text(
                formatCurrencyWithSign(error.toDouble(), currencySymbol),
                style: TossTextStyles.subtitle.copyWith(
                  color: TossColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.subtitle.copyWith(
            color: TossColors.gray700,
            fontWeight: TossFontWeight.regular,
          ),
        ),
        Text(
          amount,
          style: TossTextStyles.subtitle.copyWith(
            color: TossColors.gray900,
            fontWeight: TossFontWeight.regular,
          ),
        ),
      ],
    );
  }
}
