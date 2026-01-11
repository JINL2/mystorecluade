// lib/features/cash_ending/presentation/widgets/collapsible_currency_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/molecules/cards/toss_expandable_card.dart';
import '../../domain/entities/currency.dart';
import 'denomination_grid_header.dart';
import 'denomination_input.dart';
import 'total_display.dart';

/// Collapsible currency section with accordion behavior
///
/// Uses TossExpandableCardAnimated as base for consistency
/// with other expandable cards in the app.
///
/// Shows currency header with expand/collapse arrow, denomination inputs,
/// and always-visible subtotal footer.
class CollapsibleCurrencySection extends StatelessWidget {
  final Currency currency;
  final Map<String, TextEditingController> controllers;
  final Map<String, FocusNode> focusNodes;
  final double totalAmount;
  final VoidCallback onChanged;
  final bool isExpanded;
  final VoidCallback? onToggle;
  final String? baseCurrencySymbol;

  const CollapsibleCurrencySection({
    super.key,
    required this.currency,
    required this.controllers,
    required this.focusNodes,
    required this.totalAmount,
    required this.onChanged,
    this.isExpanded = true,
    this.onToggle,
    this.baseCurrencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return TossExpandableCardAnimated(
      // Custom header with currency name and exchange rate
      headerWidget: _buildCurrencyHeader(),
      isExpanded: isExpanded,
      onToggle: onToggle ?? () {},
      // Styling to match original
      backgroundColor: TossColors.white,
      borderColor: TossColors.gray100,
      borderRadius: TossBorderRadius.lg,
      dividerColor: TossColors.gray200,
      alwaysShowDivider: true,
      iconColor: TossColors.gray700,
      // Header padding
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      // Content padding
      contentPadding: const EdgeInsets.only(
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        top: TossSpacing.space4,
      ),
      // Denomination inputs content
      content: _buildDenominationContent(),
      // Footer padding
      footerPadding: const EdgeInsets.all(TossSpacing.space4),
      // Always-visible subtotal footer
      footer: _buildSubtotalFooter(),
    );
  }

  /// Builds the currency header with name and optional exchange rate
  Widget _buildCurrencyHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '${currency.currencyCode} • ${currency.currencyName}',
          style: TossTextStyles.cardTitle,
        ),
        // Show exchange rate for non-base currencies
        if (!currency.isBaseCurrency && currency.exchangeRateToBase != 1.0) ...[
          const SizedBox(width: TossSpacing.space2),
          Text(
            '1 ${currency.currencyCode} = ${baseCurrencySymbol ?? ''}${NumberFormat('#,##0.00').format(currency.exchangeRateToBase)}',
            style: TossTextStyles.secondaryText,
          ),
        ],
      ],
    );
  }

  /// Builds the denomination inputs section
  Widget _buildDenominationContent() {
    return Column(
      children: [
        // Grid header
        DenominationGridHeader(currencyCode: currency.currencyCode),
        const SizedBox(height: TossSpacing.space1),
        // Denomination inputs
        ...currency.denominations.map((denom) {
          final controller = controllers[denom.denominationId];
          final focusNode = focusNodes[denom.denominationId];

          if (controller == null || focusNode == null) {
            return const SizedBox.shrink();
          }

          return DenominationInput(
            denomination: denom,
            controller: controller,
            focusNode: focusNode,
            currencySymbol: currency.symbol,
            onChanged: onChanged,
          );
        }),
      ],
    );
  }

  /// Builds the always-visible subtotal footer with reactive updates
  Widget _buildSubtotalFooter() {
    return ListenableBuilder(
      listenable: Listenable.merge(controllers.values.toList()),
      builder: (context, _) {
        // Calculate subtotal from controller values
        double subtotal = 0.0;
        for (final denomination in currency.denominations) {
          final controller = controllers[denomination.denominationId];
          if (controller != null) {
            final quantity = int.tryParse(controller.text.trim()) ?? 0;
            subtotal += denomination.value * quantity;
          }
        }

        return TotalDisplay(
          totalAmount: subtotal,
          currencySymbol: currency.symbol,
          label: 'Subtotal ${currency.currencyCode}',
        );
      },
    );
  }
}
