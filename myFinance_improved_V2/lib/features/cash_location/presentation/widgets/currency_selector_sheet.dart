import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/selection_bottom_sheet_common.dart';

import '../../../register_denomination/domain/entities/currency.dart';

/// Currency Selector Bottom Sheet
/// Shows a list of currencies with search functionality
class CurrencySelectorSheet extends StatefulWidget {
  final List<CurrencyType> currencies;
  final String? selectedCurrencyId;
  final void Function(CurrencyType) onCurrencySelected;

  const CurrencySelectorSheet({
    super.key,
    required this.currencies,
    this.selectedCurrencyId,
    required this.onCurrencySelected,
  });

  @override
  State<CurrencySelectorSheet> createState() => _CurrencySelectorSheetState();

  static Future<CurrencyType?> show({
    required BuildContext context,
    required List<CurrencyType> currencies,
    String? selectedCurrencyId,
  }) {
    return _CurrencySelectorSheetContent.show(
      context: context,
      currencies: currencies,
      selectedCurrencyId: selectedCurrencyId,
    );
  }
}

/// Stateful content for currency selector using SelectionBottomSheetCommon
class _CurrencySelectorSheetContent extends StatefulWidget {
  final List<CurrencyType> currencies;
  final String? selectedCurrencyId;

  const _CurrencySelectorSheetContent({
    required this.currencies,
    this.selectedCurrencyId,
  });

  static Future<CurrencyType?> show({
    required BuildContext context,
    required List<CurrencyType> currencies,
    String? selectedCurrencyId,
  }) async {
    final TextEditingController searchController = TextEditingController();
    List<CurrencyType> filteredCurrencies = currencies;

    return showModalBottomSheet<CurrencyType>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          void onSearchChanged(String query) {
            setModalState(() {
              if (query.isEmpty) {
                filteredCurrencies = currencies;
              } else {
                filteredCurrencies = currencies.where((currency) {
                  return currency.currencyName.toLowerCase().contains(query.toLowerCase()) ||
                      currency.currencyCode.toLowerCase().contains(query.toLowerCase());
                }).toList();
              }
            });
          }

          return SelectionBottomSheetCommon(
            title: 'Select Currency',
            showSearch: true,
            searchHint: 'Search currency...',
            searchController: searchController,
            onSearchChanged: onSearchChanged,
            maxHeightRatio: 0.7,
            itemCount: filteredCurrencies.length,
            itemBuilder: (context, index) {
              final currency = filteredCurrencies[index];
              final isSelected = currency.currencyId == selectedCurrencyId;
              return _CurrencyListItem(
                currency: currency,
                isSelected: isSelected,
                onTap: () => Navigator.pop(context, currency),
              );
            },
          );
        },
      ),
    );
  }

  @override
  State<_CurrencySelectorSheetContent> createState() => _CurrencySelectorSheetContentState();
}

class _CurrencySelectorSheetContentState extends State<_CurrencySelectorSheetContent> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/// Currency list item widget
class _CurrencyListItem extends StatelessWidget {
  final CurrencyType currency;
  final bool isSelected;
  final VoidCallback onTap;

  const _CurrencyListItem({
    required this.currency,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withValues(alpha: TossOpacity.subtle) : TossColors.transparent,
        ),
        child: Row(
          children: [
            // Flag emoji
            Container(
              width: TossSpacing.space10,
              height: TossSpacing.space10,
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primary.withValues(alpha: TossOpacity.light)
                    : TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Text(
                  currency.flagEmoji,
                  style: TossTextStyles.h3,
                ),
              ),
            ),

            const SizedBox(width: TossSpacing.space3),

            // Currency info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.currencyName,
                    style: isSelected
                        ? TossTextStyles.bodyMedium.copyWith(color: TossColors.gray900)
                        : TossTextStyles.body.copyWith(color: TossColors.gray900),
                  ),
                  SizedBox(height: TossSpacing.space0),
                  Text(
                    currency.currencyCode,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),

            // Selected indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: TossColors.primary,
                size: TossSpacing.iconMD2,
              ),
          ],
        ),
      ),
    );
  }
}

class _CurrencySelectorSheetState extends State<CurrencySelectorSheet> {
  @override
  Widget build(BuildContext context) {
    // This state is no longer used - the static show method uses _CurrencySelectorSheetContent
    return const SizedBox.shrink();
  }
}
