// lib/features/cash_ending/presentation/widgets/real_item_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/stock_flow.dart';
import '../extensions/stock_flow_presentation_extension.dart';

/// Widget for displaying a single actual flow item in the Real section
class RealItemWidget extends StatelessWidget {
  final ActualFlow flow;
  final bool showDate;
  final LocationSummary? locationSummary;
  final String baseCurrencySymbol;
  final VoidCallback onTap;

  const RealItemWidget({
    super.key,
    required this.flow,
    required this.showDate,
    required this.locationSummary,
    required this.baseCurrencySymbol,
    required this.onTap,
  });

  /// Format balance with currency symbol
  String _formatBalance(double amount, String symbol) {
    final formatter = NumberFormat('#,###');
    final formattedAmount = formatter.format(amount.abs());
    final sign = amount < 0 ? '-' : '';
    return '$sign$symbol$formattedAmount';
  }

  @override
  Widget build(BuildContext context) {
    // Use base currency symbol from location summary for consistency
    final currencySymbol = locationSummary?.baseCurrencySymbol ??
        baseCurrencySymbol;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.only(
          left: TossSpacing.space4,
          right: TossSpacing.space4,
          top: TossSpacing.space3,
          bottom: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Date section
            Container(
              width: 42,
              padding: const EdgeInsets.only(left: TossSpacing.space1),
              child: showDate
                  ? Text(
                      flow.getFormattedDate(),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.2,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(width: TossSpacing.space3),

            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cash Count',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.black87,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          flow.createdBy.fullName,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                            fontSize: 13,
                            height: 1.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (flow.getFormattedTime().isNotEmpty) ...[
                        Text(
                          ' • ',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                            fontSize: 13,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          flow.getFormattedTime(),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                            fontSize: 13,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: TossSpacing.space2),

            // Flow amount and balance after
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Flow amount (the transaction amount) - blue for positive, black for negative
                Text(
                  _formatBalance(flow.flowAmount, currencySymbol),
                  style: TossTextStyles.body.copyWith(
                    color: flow.flowAmount >= 0
                        ? TossColors.primary
                        : TossColors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                // Balance after in gray
                Text(
                  _formatBalance(flow.balanceAfter, currencySymbol),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.2,
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
