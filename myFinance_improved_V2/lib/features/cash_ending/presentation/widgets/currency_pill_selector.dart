// lib/features/cash_ending/presentation/widgets/currency_pill_selector.dart

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/category_chip.dart';
import '../../../../shared/widgets/toss/toss_button_1.dart';
import '../../domain/entities/currency.dart';

/// Currency pill selector with remove buttons
///
/// Shows selected currencies as pills with × buttons
class CurrencyPillSelector extends StatelessWidget {
  final List<Currency> availableCurrencies;
  final List<String> selectedCurrencyIds;
  final VoidCallback onAddCurrency;
  final Function(String)? onRemoveCurrency;

  const CurrencyPillSelector({
    super.key,
    required this.availableCurrencies,
    required this.selectedCurrencyIds,
    required this.onAddCurrency,
    this.onRemoveCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Currencies',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                letterSpacing: 0.5,
              ),
            ),
            TossButton1.textButton(
              text: 'Add currency',
              onPressed: onAddCurrency,
              leadingIcon: const Icon(Icons.add, size: 16),
              textColor: TossColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              padding: const EdgeInsets.only(right: 4),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: selectedCurrencyIds.map((currencyId) {
            final currency = availableCurrencies.firstWhere(
              (c) => c.currencyId == currencyId,
              orElse: () => availableCurrencies.first,
            );

            return CategoryChip(
              label: '${currency.currencyCode} ${currency.currencyName}',
              onRemove: selectedCurrencyIds.length > 1 && onRemoveCurrency != null
                  ? () => onRemoveCurrency!(currencyId)
                  : null,
            );
          }).toList(),
        ),
      ],
    );
  }
}

