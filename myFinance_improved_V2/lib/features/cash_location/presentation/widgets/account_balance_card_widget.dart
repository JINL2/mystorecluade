import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
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
        boxShadow: TossShadows.card,
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
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
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
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Text(
                    'Auto Mapping',
                    style: TossTextStyles.caption.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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
            isJournal: true,
          ),

          SizedBox(height: TossSpacing.space3),

          // Total Real
          _buildBalanceRow(
            'Total Real',
            formatCurrency(totalReal.toDouble(), currencySymbol),
            isJournal: false,
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
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                formatCurrencyWithSign(error.toDouble(), currencySymbol),
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(String label, String amount, {required bool isJournal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            fontSize: 15,
          ),
        ),
        Text(
          amount,
          style: TossTextStyles.body.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
