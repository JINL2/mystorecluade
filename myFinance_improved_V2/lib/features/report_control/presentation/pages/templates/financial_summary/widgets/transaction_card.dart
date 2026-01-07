// lib/features/report_control/presentation/pages/templates/financial_summary/widgets/transaction_card.dart

import 'package:flutter/material.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../../shared/themes/toss_font_weight.dart';
import '../domain/entities/transaction_entry.dart';

/// 2줄 미니멀 거래 카드 - Toss Design System
class TransactionCard extends StatelessWidget {
  final TransactionEntry transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.marginXS),
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.paddingSM,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 첫 줄: 금액 + 계정 흐름
          Row(
            children: [
              // 금액
              Text(
                transaction.formattedAmount,
                style: TossTextStyles.bodyMedium.copyWith(
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(width: TossSpacing.gapSM),
              // 계정 흐름
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        transaction.debitAccount,
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray700,
                          fontWeight: TossFontWeight.medium,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: TossSpacing.gapXS),
                      child: Icon(
                        Icons.arrow_forward,
                        size: TossSpacing.space3,
                        color: TossColors.gray500,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        transaction.creditAccount,
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray700,
                          fontWeight: TossFontWeight.medium,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.gapXS),

          // 둘째 줄: 직원 + 설명
          Row(
            children: [
              Expanded(
                child: Text(
                  transaction.employeeName,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (transaction.description != null &&
                  transaction.description!.trim().isNotEmpty) ...[
                SizedBox(width: TossSpacing.space2),
                Flexible(
                  child: Text(
                    transaction.description!,
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.gray500,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
