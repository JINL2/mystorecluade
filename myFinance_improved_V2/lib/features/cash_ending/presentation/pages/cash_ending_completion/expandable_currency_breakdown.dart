// lib/features/cash_ending/presentation/pages/cash_ending_completion/expandable_currency_breakdown.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/molecules/cards/toss_expandable_card.dart';
import '../../../domain/entities/currency.dart';

/// Expandable Currency Breakdown Widget
///
/// Uses TossExpandableCard as base for consistency
/// with other expandable cards in the app.
///
/// Displays denomination details for a specific currency with expand/collapse.
/// Used in the cash ending completion page to show a read-only summary.
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
    // Calculate subtotal and get denominations for this currency
    final (subtotal, currencyDenominations) = _calculateSubtotal();
    final hasDenominations = currencyDenominations.isNotEmpty;

    return TossExpandableCard(
      // Custom header with currency name
      headerWidget: _buildCurrencyHeader(hasDenominations),
      isExpanded: isExpanded,
      onToggle: onToggle,
      // Conditional toggle - only if has denominations
      canToggle: hasDenominations,
      showToggleIcon: hasDenominations,
      // Styling to match original
      backgroundColor: TossColors.white,
      borderColor: TossColors.gray200,
      borderRadius: TossBorderRadius.lg,
      dividerColor: TossColors.gray200,
      alwaysShowDivider: true,
      iconColor: TossColors.gray400,
      // Header padding
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      // Content padding
      contentPadding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      // Denomination breakdown content
      content: _buildDenominationContent(currencyDenominations),
      // Footer padding
      footerPadding: const EdgeInsets.all(TossSpacing.space4),
      // Always-visible subtotal footer
      footer: _buildSubtotalFooter(subtotal),
    );
  }

  /// Calculates subtotal and returns denomination map
  (double, Map<String, int>) _calculateSubtotal() {
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

    return (subtotal, currencyDenominations);
  }

  /// Builds the currency header
  Widget _buildCurrencyHeader(bool hasDenominations) {
    return Row(
      children: [
        Text(
          '${currency.currencyCode} • ${currency.currencyName}',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  /// Builds the denomination breakdown rows
  Widget _buildDenominationContent(Map<String, int> currencyDenominations) {
    if (currencyDenominations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
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
    );
  }

  /// Builds the always-visible subtotal footer
  Widget _buildSubtotalFooter(double subtotal) {
    return Row(
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
    );
  }
}
