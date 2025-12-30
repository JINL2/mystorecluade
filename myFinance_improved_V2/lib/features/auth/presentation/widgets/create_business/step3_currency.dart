import 'package:flutter/material.dart';

import '../../../../../shared/themes/index.dart';
import '../../../domain/value_objects/currency.dart';

/// Step 3: Currency Selection
///
/// Final step where user selects the base currency for their business.
class Step3Currency extends StatelessWidget {
  final List<Currency> currencies;
  final String? selectedCurrencyId;
  final ValueChanged<String?> onCurrencySelected;

  const Step3Currency({
    super.key,
    required this.currencies,
    required this.selectedCurrencyId,
    required this.onCurrencySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your currency',
          style: TossTextStyles.h1.copyWith(
            fontWeight: FontWeight.w800,
            color: TossColors.textPrimary,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'This will be used for all financial transactions',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space6),
        ...currencies.map((currency) => _buildCurrencyOption(currency)),
      ],
    );
  }

  Widget _buildCurrencyOption(Currency currency) {
    final isSelected = selectedCurrencyId == currency.currencyId;

    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onCurrencySelected(currency.currencyId),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? TossColors.primary : TossColors.gray300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              color: TossColors.white,
            ),
            child: Row(
              children: [
                Text(
                  currency.symbol,
                  style: TossTextStyles.h2.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.textPrimary,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currency.currencyName,
                        style: TossTextStyles.h3.copyWith(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected ? TossColors.primary : TossColors.textPrimary,
                          fontSize: TossTextStyles.h3.fontSize! * 0.7,
                        ),
                      ),
                      Text(
                        currency.currencyCode,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                          fontSize: TossTextStyles.caption.fontSize! * 0.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
