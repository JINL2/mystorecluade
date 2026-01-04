import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/entities/stock_flow.dart';
import '../formatters/cash_location_formatters.dart';

class JournalFlowItem extends StatelessWidget {
  const JournalFlowItem({
    super.key,
    required this.flow,
    required this.showDate,
    required this.currencySymbol,
    required this.onTap,
    required this.formatTransactionAmount,
    required this.formatBalance,
    required this.getJournalDisplayText,
  });

  final JournalFlow flow;
  final bool showDate;
  final String currencySymbol;
  final VoidCallback onTap;
  final String Function(double amount, String currencySymbol) formatTransactionAmount;
  final String Function(double amount, String currencySymbol) formatBalance;
  final String Function(JournalFlow flow) getJournalDisplayText;

  @override
  Widget build(BuildContext context) {
    final isIncome = flow.flowAmount > 0;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(
          left: TossSpacing.space4,
          right: TossSpacing.space4,
          top: TossSpacing.space2,
          bottom: TossSpacing.space2,
        ),
        child: Row(
          children: [
            // Date section (centered vertically, aligned left)
            Container(
              width: 50,
              padding: EdgeInsets.only(left: TossSpacing.space1),
              child: showDate
                  ? Text(
                      CashLocationFormatters.formatJournalFlowDate(flow),
                      style: TossTextStyles.bodyMedium.copyWith(
                        color: TossColors.gray600,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            SizedBox(width: TossSpacing.space3),

            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getJournalDisplayText(flow),
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          flow.createdBy.fullName,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (CashLocationFormatters.formatJournalFlowTime(flow).isNotEmpty) ...[
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          CashLocationFormatters.formatJournalFlowTime(flow),
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: TossSpacing.space2),

            // Amount and balance for Journal tab
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatTransactionAmount(flow.flowAmount, currencySymbol),
                  style: TossTextStyles.bodyMedium.copyWith(
                    color: isIncome
                        ? Theme.of(context).colorScheme.primary
                        : TossColors.gray900,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  formatBalance(flow.balanceAfter, currencySymbol),
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
