import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/entities/stock_flow.dart';
import '../formatters/cash_location_formatters.dart';

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
    // Group denominations by currency for display
    final groupedByCurrency = _groupDenominationsByCurrency(flow.currentDenominations);

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
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
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: TossDimensions.dragHandleWidth,
            height: TossDimensions.dragHandleHeight,
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
                      fontWeight: TossFontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: TossSpacing.iconMD2),
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
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance overview
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: TossOpacity.light),
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
                                  ),
                                ),
                                const SizedBox(height: TossSpacing.space1),
                                Text(
                                  formatBalance(flow.balanceAfter, baseCurrencySymbol),
                                  style: TossTextStyles.h1.copyWith(
                                    fontWeight: TossFontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: TossSpacing.iconLG2,
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
                                    style: TossTextStyles.small.copyWith(
                                      color: TossColors.gray600,
                                    ),
                                  ),
                                  Text(
                                    formatBalance(flow.balanceBefore, baseCurrencySymbol),
                                    style: TossTextStyles.bodyMedium,
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
                                    style: TossTextStyles.small.copyWith(
                                      color: TossColors.gray600,
                                    ),
                                  ),
                                  Text(
                                    formatTransactionAmount(flow.flowAmount, baseCurrencySymbol),
                                    style: TossTextStyles.bodyMedium.copyWith(
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

                  const SizedBox(height: TossSpacing.space5),

                  // Multi-currency breakdown for Bank
                  if (flow.currentDenominations.isNotEmpty &&
                      flow.currentDenominations.any((d) => d.exchangeRate != null)) ...[
                    Text(
                      'Currency Breakdown',
                      style: TossTextStyles.subtitle,
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    ...flow.currentDenominations
                        .where((d) => d.exchangeRate != null && d.currencyCode != baseCurrencySymbol.replaceAll(RegExp(r'[^\w]'), ''))
                        .map(
                      (denomination) => Container(
                        margin: const EdgeInsets.only(bottom: TossSpacing.space3),
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
                                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
                                  decoration: BoxDecoration(
                                    color: TossColors.primary.withValues(alpha: TossOpacity.light),
                                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                  ),
                                  child: Text(
                                    '${denomination.currencySymbol ?? ''}${denomination.currencyCode ?? ''}',
                                    style: TossTextStyles.bodyMedium.copyWith(
                                      color: TossColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: TossSpacing.space2),
                                Text(
                                  denomination.currencyName ?? '',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
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
                                  ),
                                ),
                                Text(
                                  '${denomination.currencySymbol ?? ''}${NumberFormat('#,###.##').format(denomination.amount ?? 0)}',
                                  style: TossTextStyles.subtitle,
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
                                  ),
                                ),
                                Text(
                                  '× ${NumberFormat('#,###.##').format(denomination.exchangeRate ?? 0)}',
                                  style: TossTextStyles.bodyMedium.copyWith(
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
                                  ),
                                ),
                                Text(
                                  formatBalance(denomination.amountInBaseCurrency ?? 0, baseCurrencySymbol),
                                  style: TossTextStyles.subtitle.copyWith(
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
                  // Denomination breakdown for Cash/Vault - Grouped by Currency
                  else if (flow.currentDenominations.isNotEmpty) ...[
                    Text(
                      'Denomination Breakdown',
                      style: TossTextStyles.subtitle,
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    // Build currency groups
                    ...groupedByCurrency.entries.map((entry) {
                      final currencyDenominations = entry.value;
                      if (currencyDenominations.isEmpty) return const SizedBox.shrink();

                      // Get currency info from first denomination
                      final firstDenom = currencyDenominations.first;
                      final currencySymbol = firstDenom.currencySymbol ?? '';
                      final currencyCode = firstDenom.currencyCode ?? '';

                      // Calculate total stock for this currency
                      // subtotal = currentQuantity * denominationValue (현재 수량 기준)
                      final currencyTotal = currencyDenominations.fold<double>(
                        0.0,
                        (sum, d) => sum + d.subtotal,
                      );

                      // Calculate total flow (change) for this currency
                      // quantityChange = currentQuantity - previousQuantity (직전 대비 변화량)
                      final currencyFlow = currencyDenominations.fold<double>(
                        0.0,
                        (sum, d) => sum + (d.quantityChange * d.denominationValue),
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.white,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          border: Border.all(color: TossColors.gray200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Currency Header with Stock and Flow
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space4,
                                vertical: TossSpacing.space3,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: TossColors.gray200),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Currency code
                                  Text(
                                    currencyCode.isNotEmpty ? currencyCode : 'Currency',
                                    style: TossTextStyles.titleMedium,
                                  ),
                                  const Spacer(),
                                  // Total stock
                                  Text(
                                    formatBalance(currencyTotal, currencySymbol),
                                    style: TossTextStyles.titleMedium,
                                  ),
                                  // Flow indicator (if any change)
                                  if (currencyFlow != 0) ...[
                                    const SizedBox(width: TossSpacing.space2),
                                    Text(
                                      currencyFlow > 0
                                          ? '+${formatBalance(currencyFlow, currencySymbol)}'
                                          : formatBalance(currencyFlow, currencySymbol),
                                      style: TossTextStyles.bodySmall.copyWith(
                                        fontWeight: TossFontWeight.semibold,
                                        color: currencyFlow > 0
                                            ? TossColors.primary
                                            : TossColors.error,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // Table Header
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space4,
                                vertical: TossSpacing.space2,
                              ),
                              color: TossColors.gray50,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Denomination',
                                      style: TossTextStyles.small.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Qty',
                                      textAlign: TextAlign.center,
                                      style: TossTextStyles.small.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Subtotal',
                                      textAlign: TextAlign.end,
                                      style: TossTextStyles.small.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Denomination rows - Simple table style
                            ...currencyDenominations.asMap().entries.map((mapEntry) {
                              final index = mapEntry.key;
                              final denomination = mapEntry.value;
                              final isLast = index == currencyDenominations.length - 1;

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space4,
                                  vertical: TossSpacing.space3,
                                ),
                                decoration: BoxDecoration(
                                  border: isLast
                                      ? null
                                      : const Border(
                                          bottom: BorderSide(color: TossColors.gray100),
                                        ),
                                ),
                                child: Row(
                                  children: [
                                    // Denomination value
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        formatCurrency(denomination.denominationValue, currencySymbol),
                                        style: TossTextStyles.body,
                                      ),
                                    ),
                                    // Quantity with change indicator
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${denomination.currentQuantity}',
                                            style: TossTextStyles.body,
                                          ),
                                          if (denomination.quantityChange != 0) ...[
                                            const SizedBox(width: TossSpacing.space1),
                                            Text(
                                              denomination.quantityChange > 0
                                                  ? '+${denomination.quantityChange}'
                                                  : '${denomination.quantityChange}',
                                              style: TossTextStyles.labelSmall.copyWith(
                                                color: denomination.quantityChange > 0
                                                    ? TossColors.primary
                                                    : TossColors.error,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    // Subtotal
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        formatBalance(denomination.subtotal, currencySymbol),
                                        textAlign: TextAlign.end,
                                        style: TossTextStyles.body,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }),
                  ],

                  // Transaction info - Simple list style
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Column(
                      children: [
                        _buildSimpleInfoRow('Counted By', flow.createdBy.fullName),
                        const SizedBox(height: TossSpacing.space2),
                        _buildSimpleInfoRow(
                          'Date',
                          DateFormat('MMM d, yyyy').format(DateTime.parse(flow.createdAt)),
                        ),
                        const SizedBox(height: TossSpacing.space2),
                        _buildSimpleInfoRow('Time', CashLocationFormatters.formatActualFlowTime(flow)),
                      ],
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space5),
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

  Widget _buildSimpleInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.bodyMedium,
        ),
      ],
    );
  }

  /// Group denominations by currency ID
  Map<String, List<DenominationDetail>> _groupDenominationsByCurrency(
      List<DenominationDetail> denominations,
  ) {
    final Map<String, List<DenominationDetail>> grouped = {};

    for (final denom in denominations) {
      // Use currencyId as key, fallback to 'unknown' if null
      final key = denom.currencyId ?? 'unknown';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(denom);
    }

    // Sort each group by denomination value (descending)
    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) => b.denominationValue.compareTo(a.denominationValue));
    }

    return grouped;
  }
}
