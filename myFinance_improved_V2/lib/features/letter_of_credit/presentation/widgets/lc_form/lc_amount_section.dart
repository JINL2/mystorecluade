import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../register_denomination/domain/entities/currency.dart';
import '../../../../register_denomination/presentation/providers/currency_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Amount section for LC form (Currency, Amount, Tolerance)
class LCAmountSection extends ConsumerWidget {
  final String? currencyId;
  final String currencyCode;
  final TextEditingController amountController;
  final TextEditingController tolerancePlusController;
  final TextEditingController toleranceMinusController;
  final String? amountError;
  final ValueChanged<Currency?> onCurrencyChanged;
  final VoidCallback? onAmountChanged;

  const LCAmountSection({
    super.key,
    required this.currencyId,
    required this.currencyCode,
    required this.amountController,
    required this.tolerancePlusController,
    required this.toleranceMinusController,
    this.amountError,
    required this.onCurrencyChanged,
    this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyAsync = ref.watch(companyCurrenciesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        currencyAsync.when(
          loading: () => TossDropdown<String>(
            label: 'Currency',
            items: const [],
            isLoading: true,
          ),
          error: (e, _) => TossDropdown<String>(
            label: 'Currency',
            items: const [],
            errorText: 'Failed to load',
          ),
          data: (currencies) {
            String? currentValue;
            if (currencyId != null && currencies.any((c) => c.id == currencyId)) {
              currentValue = currencyId;
            }

            return TossDropdown<String>(
              label: 'Currency',
              value: currentValue,
              hint: 'Select currency',
              items: currencies
                  .map((c) => TossDropdownItem<String>(
                        value: c.id,
                        label: '${c.code} (${c.symbol})',
                        subtitle: c.fullName,
                      ))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                final currency = currencies.firstWhere((c) => c.id == v);
                onCurrencyChanged(currency);
              },
            );
          },
        ),
        const SizedBox(height: TossSpacing.space3),
        TossTextField.filled(
          inlineLabel: 'Amount *',
          controller: amountController,
          hintText: '',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefixText: '$currencyCode ',
          errorText: amountError,
          onChanged: (_) => onAmountChanged?.call(),
        ),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            Expanded(
              child: TossTextField.filled(
                inlineLabel: 'Tolerance +%',
                controller: tolerancePlusController,
                hintText: '',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                suffixText: '%',
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: TossTextField.filled(
                inlineLabel: 'Tolerance -%',
                controller: toleranceMinusController,
                hintText: '',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                suffixText: '%',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
