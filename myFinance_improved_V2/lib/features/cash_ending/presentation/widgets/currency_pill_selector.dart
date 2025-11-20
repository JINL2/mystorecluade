// lib/features/cash_ending/presentation/widgets/currency_pill_selector.dart

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
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
            GestureDetector(
              onTap: onAddCurrency,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      size: 16,
                      color: TossColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Add currency',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
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

            return _CurrencyPill(
              currencyCode: currency.currencyCode,
              currencyName: currency.currencyName,
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

class _CurrencyPill extends StatelessWidget {
  final String currencyCode;
  final String currencyName;
  final VoidCallback? onRemove;

  const _CurrencyPill({
    required this.currencyCode,
    required this.currencyName,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$currencyCode $currencyName',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close,
                size: 14,
                color: TossColors.gray600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
