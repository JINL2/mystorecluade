// lib/features/transaction_history/presentation/widgets/detail_sheet/balance_check_section.dart
//
// Balance check section extracted from transaction_detail_sheet.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../core/utils/number_formatter.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Balance check indicator for transaction
class BalanceCheckSection extends StatelessWidget {
  final double totalDebit;
  final double totalCredit;

  const BalanceCheckSection({
    super.key,
    required this.totalDebit,
    required this.totalCredit,
  });

  @override
  Widget build(BuildContext context) {
    final isBalanced = (totalDebit - totalCredit).abs() < 0.01;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: TossColors.gray200,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isBalanced ? Icons.check_circle : Icons.error,
                size: 16,
                color: TossColors.gray600,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                isBalanced ? 'Balanced' : 'Unbalanced',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            'D: ${_formatCurrency(totalDebit)} | C: ${_formatCurrency(totalCredit)}',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontSize: 11,
              fontFamily: 'JetBrains Mono',
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormatter.formatCurrencyDecimal(
      amount.abs(),
      '',
      decimalPlaces: 2,
    );
  }
}
