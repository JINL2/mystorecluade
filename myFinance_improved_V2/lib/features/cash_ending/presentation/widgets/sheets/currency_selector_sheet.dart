// lib/features/cash_ending/presentation/widgets/sheets/currency_selector_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/currency.dart';
import '../../providers/cash_ending_provider.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Currency selector bottom sheet
///
/// Uses SelectionBottomSheetCommon for consistent UI with search functionality
class CurrencySelectorSheet extends ConsumerStatefulWidget {
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
    SelectionBottomSheetCommon.show(
      context: context,
      title: 'Choose currency',
      showSearch: true,
      searchHint: 'Search currency',
      maxHeightRatio: 0.8,
      itemSpacing: 4,
      children: [
        _CurrencyListContent(
          currencies: currencies,
          selectedCurrencyId: selectedCurrencyId,
          tabType: tabType,
        ),
      ],
    );
  }

  @override
  ConsumerState<CurrencySelectorSheet> createState() => _CurrencySelectorSheetState();
}

class _CurrencySelectorSheetState extends ConsumerState<CurrencySelectorSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Currency> get _filteredCurrencies {
    if (_searchQuery.isEmpty) return widget.currencies;
    final query = _searchQuery.toLowerCase();
    return widget.currencies.where((currency) {
      return currency.currencyCode.toLowerCase().contains(query) ||
          currency.currencyName.toLowerCase().contains(query);
    }).toList();
  }

  void _handleCurrencySelection(Currency currency) {
    HapticFeedback.selectionClick();
    Navigator.pop(context);

    // Update selected currency based on tab type
    switch (widget.tabType) {
      case 'cash':
        ref.read(cashEndingProvider.notifier).addCashCurrency(currency.currencyId);
        break;
      case 'bank':
        ref.read(cashEndingProvider.notifier).setSelectedBankCurrency(currency.currencyId);
        break;
      case 'vault':
        ref.read(cashEndingProvider.notifier).addVaultCurrency(currency.currencyId);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCurrencies = _filteredCurrencies;

    return SelectionBottomSheetCommon(
      title: 'Choose currency',
      showSearch: true,
      searchHint: 'Search currency',
      searchController: _searchController,
      onSearchChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      maxHeightRatio: 0.8,
      itemSpacing: 4,
      itemCount: filteredCurrencies.isEmpty ? 1 : filteredCurrencies.length,
      itemBuilder: (context, index) {
        if (filteredCurrencies.isEmpty) {
          return _buildEmptyState();
        }

        final currency = filteredCurrencies[index];
        final isSelected = currency.currencyId == widget.selectedCurrencyId;

        return _CurrencyListItem(
          currency: currency,
          isSelected: isSelected,
          onTap: () => _handleCurrencySelection(currency),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.currency_exchange,
            size: 64,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'No currencies found',
            style: TossTextStyles.emptyState,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Internal widget for currency list content (used in static show method)
class _CurrencyListContent extends ConsumerStatefulWidget {
  final List<Currency> currencies;
  final String? selectedCurrencyId;
  final String tabType;

  const _CurrencyListContent({
    required this.currencies,
    required this.selectedCurrencyId,
    required this.tabType,
  });

  @override
  ConsumerState<_CurrencyListContent> createState() => _CurrencyListContentState();
}

class _CurrencyListContentState extends ConsumerState<_CurrencyListContent> {
  void _handleCurrencySelection(Currency currency) {
    HapticFeedback.selectionClick();
    Navigator.pop(context);

    // Update selected currency based on tab type
    switch (widget.tabType) {
      case 'cash':
        ref.read(cashEndingProvider.notifier).addCashCurrency(currency.currencyId);
        break;
      case 'bank':
        ref.read(cashEndingProvider.notifier).setSelectedBankCurrency(currency.currencyId);
        break;
      case 'vault':
        ref.read(cashEndingProvider.notifier).addVaultCurrency(currency.currencyId);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currencies.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(TossSpacing.space8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.currency_exchange,
              size: 64,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No currencies found',
              style: TossTextStyles.emptyState,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.currencies.map((currency) {
        final isSelected = currency.currencyId == widget.selectedCurrencyId;
        return _CurrencyListItem(
          currency: currency,
          isSelected: isSelected,
          onTap: () => _handleCurrencySelection(currency),
        );
      }).toList(),
    );
  }
}

/// Currency list item widget
class _CurrencyListItem extends StatelessWidget {
  final Currency currency;
  final bool isSelected;
  final VoidCallback onTap;

  const _CurrencyListItem({
    required this.currency,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        color: TossColors.transparent,
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space3,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currency.currencyCode,
                        style: TossTextStyles.listItemTitle,
                      ),
                      SizedBox(height: TossSpacing.space1 / 2),
                      Text(
                        currency.currencyName,
                        style: TossTextStyles.listItemSubtitle,
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check,
                    color: TossColors.primary,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
