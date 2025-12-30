// lib/features/cash_ending/presentation/widgets/currency_selector.dart

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_icons.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/currency.dart';

/// Currency selector widget
///
/// Displays a dropdown to select from available currencies.
class CurrencySelector extends StatelessWidget {
  final List<Currency> currencies;
  final String? selectedCurrencyId;
  final ValueChanged<String> onCurrencySelected;
  final String label;

  const CurrencySelector({
    super.key,
    required this.currencies,
    required this.selectedCurrencyId,
    required this.onCurrencySelected,
    this.label = 'Currency',
  });

  @override
  Widget build(BuildContext context) {
    if (currencies.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Text(
          'No currencies available',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
      );
    }

    final selectedCurrency = currencies.firstWhere(
      (c) => c.currencyId == selectedCurrencyId,
      orElse: () => currencies.first,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.white,
        border: Border.all(color: TossColors.gray200),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          const Icon(
            TossIcons.currency,
            color: TossColors.primary,
            size: 20,
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: selectedCurrency.currencyId,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: TossColors.gray700),
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
            items: currencies.map((currency) {
              return DropdownMenuItem<String>(
                value: currency.currencyId,
                child: Row(
                  children: [
                    Text(currency.symbol),
                    const SizedBox(width: TossSpacing.space1),
                    Text(currency.currencyCode),
                  ],
                ),
              );
            }).toList(),
            onChanged: (currencyId) {
              if (currencyId != null) {
                onCurrencySelected(currencyId);
              }
            },
          ),
        ],
      ),
    );
  }
}
