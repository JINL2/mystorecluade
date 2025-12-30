import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../../register_denomination/domain/entities/currency.dart';
import '../../../../register_denomination/presentation/providers/currency_providers.dart';

/// Currency selector section for PO form
class POCurrencySection extends ConsumerWidget {
  final String? currencyId;
  final String? errorText;
  final ValueChanged<Currency?> onCurrencyChanged;

  const POCurrencySection({
    super.key,
    required this.currencyId,
    this.errorText,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyAsync = ref.watch(companyCurrenciesProvider);

    return currencyAsync.when(
      loading: () => TossDropdown<String>(
        label: 'Currency',
        items: const [],
        isLoading: true,
        isRequired: true,
        hint: 'Loading...',
      ),
      error: (error, stackTrace) => TossDropdown<String>(
        label: 'Currency',
        items: const [],
        isRequired: true,
        errorText: 'Failed to load',
        hint: 'Error loading currencies',
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
          isRequired: true,
          errorText: errorText,
          items: currencies.map((c) => TossDropdownItem<String>(
            value: c.id,
            label: '${c.code} (${c.symbol})',
            subtitle: c.fullName,
          )).toList(),
          onChanged: (v) {
            if (v == null) return;
            try {
              final selected = currencies.firstWhere((c) => c.id == v);
              onCurrencyChanged(selected);
            } catch (e) {
              onCurrencyChanged(null);
            }
          },
        );
      },
    );
  }
}
