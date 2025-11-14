// lib/features/cash_ending/presentation/widgets/sheets/currency_selector_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_icons.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/currency.dart';
import '../../providers/cash_ending_provider.dart';

/// Currency selector bottom sheet
///
/// Displays a list of currencies to select from
class CurrencySelectorSheet extends ConsumerWidget {
  final List<Currency> currencies;
  final String? selectedCurrencyId;
  final String tabType; // 'cash', 'bank', 'vault'

  const CurrencySelectorSheet({
    super.key,
    required this.currencies,
    required this.selectedCurrencyId,
    required this.tabType,
  });

  /// Show currency selector bottom sheet
  static void show({
    required BuildContext context,
    required WidgetRef ref,
    required List<Currency> currencies,
    required String? selectedCurrencyId,
    required String tabType,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CurrencySelectorSheet(
        currencies: currencies,
        selectedCurrencyId: selectedCurrencyId,
        tabType: tabType,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              children: [
                Text(
                  'Select Currency',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Currency list
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: currencies.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: currencies.length,
                    itemBuilder: (context, index) {
                      final currency = currencies[index];
                      final isSelected =
                          selectedCurrencyId == currency.currencyId;

                      return _buildCurrencyItem(
                        context,
                        ref,
                        currency: currency,
                        isSelected: isSelected,
                        isLast: index == currencies.length - 1,
                      );
                    },
                  ),
          ),

          // Bottom padding
          const SizedBox(height: TossSpacing.space5),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            TossIcons.currency,
            size: 64,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'No currencies available',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyItem(
    BuildContext context,
    WidgetRef ref, {
    required Currency currency,
    required bool isSelected,
    required bool isLast,
  }) {
    // Fix VND symbol if needed
    var symbol = currency.symbol;
    if (currency.currencyCode == 'VND' &&
        (symbol == 'd' || symbol == 'đ' || symbol.isEmpty)) {
      symbol = '₫';
    }

    // Check if currency has denominations
    final hasDenominations = currency.denominations.isNotEmpty;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pop(context);

        // Update selected currency based on tab type
        switch (tabType) {
          case 'cash':
            ref
                .read(cashEndingProvider.notifier)
                .setSelectedCashCurrency(currency.currencyId);
            break;
          case 'bank':
            ref
                .read(cashEndingProvider.notifier)
                .setSelectedBankCurrency(currency.currencyId);
            break;
          case 'vault':
            ref
                .read(cashEndingProvider.notifier)
                .setSelectedVaultCurrency(currency.currencyId);
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: TossColors.gray100,
              width: isLast ? 0 : 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Currency icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primarySurface
                    : TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? TossColors.primary : TossColors.gray500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),

            // Currency info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        currency.currencyCode,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                      if (hasDenominations) ...[
                        const SizedBox(width: TossSpacing.space2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: TossColors.success.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(TossBorderRadius.sm),
                          ),
                          child: Text(
                            '${currency.denominations.length} denoms',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.success,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    currency.currencyName,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),

            // Check icon
            if (isSelected)
              const Icon(
                TossIcons.check,
                size: 20,
                color: TossColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
