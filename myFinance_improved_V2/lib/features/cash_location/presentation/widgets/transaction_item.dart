import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/entities/journal_entry.dart';
import '../formatters/cash_location_formatters.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.showDate,
    required this.isRealType,
    required this.onTap,
    required this.formatDate,
    required this.formatCurrency,
    required this.formatTransactionAmount,
  });

  final TransactionDisplay transaction;
  final bool showDate;
  final bool isRealType;
  final VoidCallback onTap;
  final String Function(String date) formatDate;
  final String Function(int amount) formatCurrency;
  final String Function(int amount, bool isIncome) formatTransactionAmount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Date section
            Container(
              width: 42,
              padding: const EdgeInsets.only(left: TossSpacing.space1),
              child: showDate
                  ? Text(
                      formatDate(transaction.date),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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
                    transaction.title,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: TossColors.gray800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            // Location name
                            Flexible(
                              child: Text(
                                transaction.locationName,
                                style: TossTextStyles.caption.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (transaction.personName.isNotEmpty) ...[
                              Text(
                                ' • ',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray400,
                                  fontSize: 12,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  transaction.personName,
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray500,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            if (transaction.time.isNotEmpty) ...[
                              Text(
                                ' • ',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray400,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                transaction.time,
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: TossSpacing.space2),

            // Amount - different display for Real vs Journal
            if (isRealType)
              Text(
                formatCurrency(transaction.amount.toInt()),
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray800,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              )
            else
              Text(
                formatTransactionAmount(transaction.amount.toInt(), transaction.isIncome),
                style: TossTextStyles.body.copyWith(
                  color: transaction.isIncome
                      ? Theme.of(context).colorScheme.primary
                      : TossColors.gray800,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
