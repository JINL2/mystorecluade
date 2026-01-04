import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/entities/stock_flow.dart';
import '../formatters/cash_location_formatters.dart';

class ActualFlowItem extends StatelessWidget {
  const ActualFlowItem({
    super.key,
    required this.flow,
    required this.showDate,
    required this.currencySymbol,
    required this.onTap,
    required this.formatBalance,
  });

  final ActualFlow flow;
  final bool showDate;
  final String currencySymbol;
  final VoidCallback onTap;
  final String Function(double amount, String currencySymbol) formatBalance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(
          left: TossSpacing.space4,
          right: TossSpacing.space4,
          top: TossSpacing.space3,
          bottom: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Date section (centered vertically, aligned left)
            Container(
              width: 42,
              padding: EdgeInsets.only(left: TossSpacing.space1),
              child: showDate
                  ? Text(
                      CashLocationFormatters.formatActualFlowDate(flow),
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
                    'Cash Count',
                    style: TossTextStyles.subtitle.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
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
                      if (CashLocationFormatters.formatActualFlowTime(flow).isNotEmpty) ...[
                        Text(
                          ' • ',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                        Text(
                          CashLocationFormatters.formatActualFlowTime(flow),
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

            // Amount and Balance for Real tab
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Flow amount (what was counted)
                Text(
                  formatBalance(flow.flowAmount, currencySymbol),
                  style: TossTextStyles.subtitle.copyWith(
                    color: flow.flowAmount >= 0
                        ? Theme.of(context).colorScheme.primary
                        : TossColors.gray900,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                // Running balance
                Text(
                  formatBalance(flow.balanceAfter, currencySymbol),
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
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
