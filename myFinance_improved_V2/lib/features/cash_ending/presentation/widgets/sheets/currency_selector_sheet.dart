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
    // Separate selected and unselected currencies
    final selectedCurrencies = currencies.where((c) => c.currencyId == selectedCurrencyId).toList();
    final unselectedCurrencies = currencies.where((c) => c.currencyId != selectedCurrencyId).toList();

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
          const SizedBox(height: TossSpacing.space4),

          // Header with close button and title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Row(
              children: [
                // Close button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    size: 24,
                    color: TossColors.gray900,
                  ),
                ),
                const Spacer(),
                // Title
                Text(
                  'Choose currency',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 24), // Balance for close button
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space4),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
              decoration: BoxDecoration(
                color: TossColors.white,
                border: Border.all(
                  color: TossColors.gray100,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    size: 20,
                    color: TossColors.gray400,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    'Search currency',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space5),

          // Currency list
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: currencies.isEmpty
                ? _buildEmptyState()
                : ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: [
                      // Suggested section (selected currencies)
                      if (selectedCurrencies.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TossSpacing.space5,
                            vertical: TossSpacing.space2,
                          ),
                          child: Text(
                            'Suggested',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ...selectedCurrencies.asMap().entries.map((entry) {
                          final currency = entry.value;
                          return _buildCurrencyItem(
                            context,
                            ref,
                            currency: currency,
                            isSelected: true,
                            isLast: false,
                          );
                        }),
                        const SizedBox(height: TossSpacing.space3),
                      ],

                      // All currencies section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space5,
                          vertical: TossSpacing.space2,
                        ),
                        child: Text(
                          'All currencies',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ...unselectedCurrencies.asMap().entries.map((entry) {
                        final index = entry.key;
                        final currency = entry.value;
                        return _buildCurrencyItem(
                          context,
                          ref,
                          currency: currency,
                          isSelected: false,
                          isLast: index == unselectedCurrencies.length - 1,
                        );
                      }),
                    ],
                  ),
          ),

          // Bottom padding (32px)
          const SizedBox(height: 32),
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
            // For cash tab: add currency (supports multiple)
            ref
                .read(cashEndingProvider.notifier)
                .addCashCurrency(currency.currencyId);
            break;
          case 'bank':
            ref
                .read(cashEndingProvider.notifier)
                .setSelectedBankCurrency(currency.currencyId);
            break;
          case 'vault':
            // For vault tab: add currency (supports multiple)
            ref
                .read(cashEndingProvider.notifier)
                .addVaultCurrency(currency.currencyId);
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
            // Currency info
            Expanded(
              child: Row(
                children: [
                  Text(
                    currency.currencyCode,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    currency.currencyName,
                    style: TossTextStyles.body.copyWith(
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
