import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/entities/stock_flow.dart';

class RealDetailSheet extends StatelessWidget {
  const RealDetailSheet({
    super.key,
    required this.flow,
    required this.baseCurrencySymbol,
    required this.formatBalance,
    required this.formatTransactionAmount,
    required this.formatCurrency,
  });

  final ActualFlow flow;
  final String baseCurrencySymbol;
  final String Function(double amount, String currencySymbol) formatBalance;
  final String Function(double amount, String currencySymbol) formatTransactionAmount;
  final String Function(double amount, String currencySymbol) formatCurrency;

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
        maxHeight: MediaQuery.of(context).size.height * 0.9,
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
                    'Cash Count Details',
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
                  // Balance overview
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Balance',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatBalance(flow.balanceAfter, baseCurrencySymbol),
                                  style: TossTextStyles.h1.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 32,
                            ),
                          ],
                        ),
                        const SizedBox(height: TossSpacing.space4),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Previous Balance',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray600,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    formatBalance(flow.balanceBefore, baseCurrencySymbol),
                                    style: TossTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Change',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray600,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    formatTransactionAmount(flow.flowAmount, baseCurrencySymbol),
                                    style: TossTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: flow.flowAmount >= 0 ? TossColors.success : TossColors.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Multi-currency breakdown for Bank
                  if (flow.currentDenominations.isNotEmpty &&
                      flow.currentDenominations.any((d) => d.exchangeRate != null)) ...[
                    Text(
                      'Currency Breakdown',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    ...flow.currentDenominations
                        .where((d) => d.exchangeRate != null && d.currencyCode != baseCurrencySymbol.replaceAll(RegExp(r'[^\w]'), ''))
                        .map(
                      (denomination) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          border: Border.all(color: TossColors.gray200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Currency header
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: TossColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                  ),
                                  child: Text(
                                    '${denomination.currencySymbol ?? ''}${denomination.currencyCode ?? ''}',
                                    style: TossTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: TossColors.primary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  denomination.currencyName ?? '',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: TossSpacing.space3),

                            // Amount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Amount',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '${denomination.currencySymbol ?? ''}${NumberFormat('#,###.##').format(denomination.amount ?? 0)}',
                                  style: TossTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: TossSpacing.space2),

                            // Exchange rate
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Exchange Rate',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '× ${NumberFormat('#,###.##').format(denomination.exchangeRate ?? 0)}',
                                  style: TossTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: TossColors.gray700,
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: TossSpacing.space4),

                            // Converted amount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Converted Amount',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  formatBalance(denomination.amountInBaseCurrency ?? 0, baseCurrencySymbol),
                                  style: TossTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space4),
                  ]
                  // Denomination breakdown for Cash/Vault
                  else if (flow.currentDenominations.isNotEmpty) ...[
                    Text(
                      'Denomination Breakdown',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    ...flow.currentDenominations.map(
                      (denomination) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(TossSpacing.space3),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          border: Border.all(color: TossColors.gray200),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Denomination value
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: TossColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                  ),
                                  child: Text(
                                    formatCurrency(denomination.denominationValue, denomination.currencySymbol ?? ''),
                                    style: TossTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: TossColors.primary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                                // Type badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: TossColors.gray200,
                                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                  ),
                                  child: Text(
                                    denomination.denominationType.toUpperCase(),
                                    style: TossTextStyles.caption.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: TossSpacing.space3),

                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Previous Qty',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.gray600,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        '${denomination.previousQuantity}',
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Change',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.gray600,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        '${denomination.quantityChange > 0 ? "+" : ""}${denomination.quantityChange}',
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: denomination.quantityChange > 0
                                              ? TossColors.success
                                              : denomination.quantityChange < 0
                                                  ? TossColors.error
                                                  : TossColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Current Qty',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.gray600,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        '${denomination.currentQuantity}',
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: TossSpacing.space2),

                            // Subtotal
                            Container(
                              padding: const EdgeInsets.all(TossSpacing.space2),
                              decoration: BoxDecoration(
                                color: TossColors.white,
                                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    formatBalance(denomination.subtotal, denomination.currencySymbol ?? ''),
                                    style: TossTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space4),
                  ],

                  // Transaction info
                  _buildDetailRow(context, 'Counted By', flow.createdBy.fullName),
                  _buildDetailRow(
                    context,
                    'Date',
                    DateFormat('MMM d, yyyy').format(DateTime.parse(flow.createdAt)),
                  ),
                  _buildDetailRow(context, 'Time', flow.getFormattedTime()),

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
