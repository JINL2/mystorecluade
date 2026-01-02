import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../di/providers.dart';
import '../../../domain/entities/currency.dart';

/// Action buttons for currency card (Add, Rate, Delete)
class CurrencyActionButtons extends ConsumerWidget {
  final Currency currency;
  final VoidCallback onAddDenomination;
  final VoidCallback onEditExchangeRate;
  final VoidCallback onDeleteCurrency;

  const CurrencyActionButtons({
    super.key,
    required this.currency,
    required this.onAddDenomination,
    required this.onEditExchangeRate,
    required this.onDeleteCurrency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: _isBaseCurrency(ref),
      builder: (context, snapshot) {
        final isBaseCurrency = snapshot.data ?? true;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Add denomination button
              Flexible(
                child: TossButton.outlinedGray(
                  text: '',
                  onPressed: onAddDenomination,
                  leadingIcon: const Icon(Icons.add, size: 20),
                ),
              ),

              // Rate button (only for non-base currencies)
              if (!isBaseCurrency) ...[
                const SizedBox(width: TossSpacing.space4),
                Flexible(
                  child: TossButton.outlinedGray(
                    text: '',
                    onPressed: onEditExchangeRate,
                    leadingIcon: const Icon(Icons.swap_horiz, size: 20),
                  ),
                ),
              ],

              const SizedBox(width: TossSpacing.space4),

              // Delete currency button
              Flexible(
                child: TossButton.outlinedGray(
                  text: '',
                  onPressed: onDeleteCurrency,
                  leadingIcon: const Icon(Icons.delete_outline, size: 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Check if the current currency is the company's base currency
  Future<bool> _isBaseCurrency(WidgetRef ref) async {
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty) return true;

      final repository = ref.read(currencyRepositoryProvider);
      return await repository.isBaseCurrency(companyId, currency.id);
    } catch (e) {
      debugPrint('Error checking base currency: $e');
      return true; // Default to true (hide Rate button) if there's an error
    }
  }
}
