// lib/features/transaction_history/presentation/widgets/detail_sheet/transaction_info_card.dart
//
// Transaction info card extracted from transaction_detail_sheet.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../core/utils/number_formatter.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/ai/index.dart';
import '../../../domain/entities/transaction.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Transaction info card showing total amount and descriptions
class TransactionInfoCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionInfoCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final hasUserDesc = transaction.description.isNotEmpty;
    final hasAiDesc = transaction.aiDescription != null &&
        transaction.aiDescription!.isNotEmpty;

    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Amount - Primary info at top
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Total Amount',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  fontWeight: TossFontWeight.medium,
                ),
              ),
              Text(
                '${transaction.currencySymbol}${_formatCurrency(transaction.totalAmount)}',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: TossFontWeight.bold,
                  color: TossColors.textPrimary,
                ),
              ),
            ],
          ),
          // Descriptions section (compact)
          if (hasUserDesc || hasAiDesc) ...[
            const SizedBox(height: TossSpacing.space3),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Description
                  if (hasUserDesc) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.edit_note,
                          size: TossSpacing.iconXXS,
                          color: TossColors.gray400,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            transaction.description,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (hasAiDesc) const SizedBox(height: TossSpacing.space2),
                  ],
                  // AI Description (summary)
                  if (hasAiDesc)
                    AiDescriptionInline(text: transaction.aiDescription!),
                ],
              ),
            ),
          ],
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
