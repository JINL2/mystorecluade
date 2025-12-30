// lib/features/cash_ending/presentation/pages/cash_ending_completion/expandable_currency_breakdown.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/currency.dart';

/// Expandable Currency Breakdown Widget
///
/// Displays denomination details for a specific currency with expand/collapse
class ExpandableCurrencyBreakdown extends StatelessWidget {
  final Currency currency;
  final Map<String, Map<String, int>>? denominationQuantities;
  final bool isExpanded;
  final VoidCallback onToggle;

  const ExpandableCurrencyBreakdown({
    super.key,
    required this.currency,
    this.denominationQuantities,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate subtotal for this currency from denominationQuantities
    double subtotal = 0.0;
    final Map<String, int> currencyDenominations = {};

    if (denominationQuantities != null &&
        denominationQuantities!.containsKey(currency.currencyId)) {
      final denominations = denominationQuantities![currency.currencyId]!;
      currencyDenominations.addAll(denominations);
      denominations.forEach((denomination, quantity) {
        final denominationValue = double.tryParse(denomination) ?? 0.0;
        subtotal += denominationValue * quantity;
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          // Currency header (clickable to expand/collapse)
          InkWell(
            onTap: currencyDenominations.isNotEmpty ? onToggle : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
              child: Row(
                children: [
                  Text(
                    '${currency.currencyCode} • ${currency.currencyName}',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (currencyDenominations.isNotEmpty)
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 20,
                      color: TossColors.gray400,
                    ),
                ],
              ),
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: TossColors.gray200,
          ),

          // Denomination details (expandable)
          if (isExpanded && currencyDenominations.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space2,
              ),
              child: Column(
                children: currencyDenominations.entries.map((entry) {
                  final denomination = double.parse(entry.key);
                  final quantity = entry.value;
                  final lineTotal = denomination * quantity;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${currency.symbol}${NumberFormat('#,##0').format(denomination)} × $quantity',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        Text(
                          NumberFormat.currency(
                            symbol: currency.symbol,
                            decimalDigits: 0,
                          ).format(lineTotal),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              height: 1,
              color: TossColors.gray200,
            ),
          ],

          // Subtotal
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal (${currency.currencyCode})',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    symbol: currency.symbol,
                    decimalDigits: 0,
                  ).format(subtotal),
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
