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
/// Displays a list of currencies to select from
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
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => CurrencySelectorSheet(
        currencies: currencies,
        selectedCurrencyId: selectedCurrencyId,
        tabType: tabType,
      ),
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

  @override
  Widget build(BuildContext context) {
    // Filter currencies based on search query
    final filteredCurrencies = widget.currencies.where((currency) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return currency.currencyCode.toLowerCase().contains(query) ||
          currency.currencyName.toLowerCase().contains(query);
    }).toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: 200,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(
              top: TossSpacing.space3,
              bottom: TossSpacing.space4,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Text(
              'Choose currency',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space3),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4 * 2),
            child: Divider(height: 1, thickness: 1, color: TossColors.gray100),
          ),

          const SizedBox(height: TossSpacing.space4),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: TossSearchField(
              hintText: 'Search currency',
              controller: _searchController,
              prefixIcon: Icons.search,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onClear: () {
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
          ),

          const SizedBox(height: TossSpacing.space2),

          // Currency list using TossDropdown item style
          Flexible(
            child: filteredCurrencies.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
                    ),
                    itemCount: filteredCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = filteredCurrencies[index];
                      final isSelected = currency.currencyId == widget.selectedCurrencyId;

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
                            onTap: () {
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
                            },
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
                                          style: TossTextStyles.bodyLarge.copyWith(
                                            color: TossColors.textPrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: TossSpacing.space1 / 2),
                                        Text(
                                          currency.currencyName,
                                          style: TossTextStyles.bodySmall.copyWith(
                                            color: TossColors.gray600,
                                          ),
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
                    },
                  ),
          ),
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
            Icons.currency_exchange,
            size: 64,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'No currencies found',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
