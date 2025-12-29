import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';

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
              _buildActionButton(
                icon: Icons.add,
                color: TossColors.primary,
                onPressed: onAddDenomination,
              ),

              // Rate button (only for non-base currencies)
              if (!isBaseCurrency) ...[
                const SizedBox(width: TossSpacing.space4),
                _buildActionButton(
                  icon: Icons.swap_horiz,
                  color: TossColors.warning,
                  onPressed: onEditExchangeRate,
                ),
              ],

              const SizedBox(width: TossSpacing.space4),

              // Delete currency button
              _buildActionButton(
                icon: Icons.delete_outline,
                color: TossColors.error,
                onPressed: onDeleteCurrency,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Flexible(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(50, 44),
          maximumSize: const Size(80, 44),
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        ),
        child: Icon(
          icon,
          size: 20,
          color: color,
        ),
      ),
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
