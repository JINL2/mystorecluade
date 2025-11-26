import 'package:flutter/material.dart';
import '../formatters/cash_location_formatters.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/entities/stock_flow.dart';

class JournalDetailSheet extends StatelessWidget {
  const JournalDetailSheet({
    super.key,
    required this.flow,
    required this.currencySymbol,
    required this.formatTransactionAmount,
    required this.formatBalance,
  });

  final JournalFlow flow;
  final String currencySymbol;
  final String Function(double amount, String currencySymbol) formatTransactionAmount;
  final String Function(double amount, String currencySymbol) formatBalance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space6,
              TossSpacing.space5,
              TossSpacing.space5,
              TossSpacing.space4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Journal Entry Details',
                    style: TossTextStyles.h2.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          flow.journalDescription.isNotEmpty
                              ? flow.journalDescription
                              : (flow.counterAccount?.description?.isNotEmpty == true
                                  ? flow.counterAccount!.description
                                  : 'No description'),
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space4),

                  // Amount details
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: flow.flowAmount > 0
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                          : TossColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          context,
                          'Transaction Amount',
                          formatTransactionAmount(flow.flowAmount, currencySymbol),
                          isHighlighted: true,
                        ),
                        const SizedBox(height: TossSpacing.space3),
                        _buildDetailRow(
                          context,
                          'Balance Before',
                          formatBalance(flow.balanceBefore, currencySymbol),
                        ),
                        const SizedBox(height: TossSpacing.space2),
                        _buildDetailRow(
                          context,
                          'Balance After',
                          formatBalance(flow.balanceAfter, currencySymbol),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space4),

                  // Transaction details
                  _buildDetailRow(context, 'Account', flow.accountName),
                  if (flow.counterAccount != null) ...[
                    _buildDetailRow(context, 'Counter Account', flow.counterAccount!.accountName),
                    _buildDetailRow(context, 'Account Type', flow.counterAccount!.accountType),
                  ],
                  _buildDetailRow(context, 'Type', flow.journalType),
                  _buildDetailRow(context, 'Created By', flow.createdBy.fullName),
                  _buildDetailRow(
                    context,
                    'Date',
                    DateFormat('MMM d, yyyy').format(DateTime.parse(flow.createdAt)),
                  ),
                  _buildDetailRow(context, 'Time', CashLocationFormatters.formatJournalFlowTime(flow)),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TossTextStyles.body.copyWith(
                fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
                fontSize: isHighlighted ? 16 : 14,
                color: isHighlighted ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
