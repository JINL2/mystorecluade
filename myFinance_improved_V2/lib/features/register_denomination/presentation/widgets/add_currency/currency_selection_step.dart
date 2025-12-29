import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_search_field.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_secondary_button.dart';

import '../../../domain/entities/currency.dart';
import '../../providers/currency_providers.dart';

/// Currency selection step widget for add currency flow
class CurrencySelectionStep extends ConsumerStatefulWidget {
  final String? selectedCurrencyId;
  final bool isLoading;
  final ValueChanged<String?> onCurrencySelected;
  final VoidCallback onNext;

  const CurrencySelectionStep({
    super.key,
    required this.selectedCurrencyId,
    required this.isLoading,
    required this.onCurrencySelected,
    required this.onNext,
  });

  @override
  ConsumerState<CurrencySelectionStep> createState() => _CurrencySelectionStepState();
}

class _CurrencySelectionStepState extends ConsumerState<CurrencySelectionStep> {
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableCurrenciesAsync = ref.watch(availableCurrenciesToAddProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search bar
        TossSearchField(
          controller: searchController,
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          hintText: 'Search currencies...',
          prefixIcon: Icons.search,
          onClear: () {
            setState(() {
              searchController.clear();
              searchQuery = '';
            });
          },
        ),
        const SizedBox(height: TossSpacing.space4),

        // Content
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          child: availableCurrenciesAsync.when(
            data: (allCurrencies) => _buildCurrencyList(allCurrencies),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: TossSpacing.space8),
                child: TossLoadingView(),
              ),
            ),
            error: (error, _) => _buildErrorState(error),
          ),
        ),

        // Bottom action buttons
        _buildActionButtons(availableCurrenciesAsync),
      ],
    );
  }

  Widget _buildCurrencyList(List<CurrencyType> allCurrencies) {
    // Filter currencies based on search query
    final availableCurrencies = searchQuery.isEmpty
        ? allCurrencies
        : allCurrencies.where((currency) {
            final query = searchQuery.toLowerCase();
            return currency.currencyCode.toLowerCase().contains(query) ||
                currency.currencyName.toLowerCase().contains(query);
          }).toList();

    if (allCurrencies.isEmpty) {
      return _buildAllAddedState();
    }

    if (availableCurrencies.isEmpty && searchQuery.isNotEmpty) {
      return _buildNoResultsState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected count and available count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${availableCurrencies.length} options available',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
            if (widget.selectedCurrencyId != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Text(
                  '1 selected',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),

        // Currency list
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: availableCurrencies.length,
            itemBuilder: (context, index) {
              final currency = availableCurrencies[index];
              final isSelected = widget.selectedCurrencyId == currency.currencyId;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == availableCurrencies.length - 1 ? 0 : TossSpacing.space2,
                ),
                child: CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) {
                    if (value ?? false) {
                      widget.onCurrencySelected(currency.currencyId);
                    } else {
                      widget.onCurrencySelected(null);
                    }
                  },
                  secondary: Text(
                    currency.flagEmoji,
                    style: TossTextStyles.h3,
                  ),
                  title: Text(
                    '${currency.currencyCode} - ${currency.currencyName}',
                  ),
                  selected: isSelected,
                  activeColor: TossColors.primary,
                  checkColor: TossColors.white,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAllAddedState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 48,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'All currencies added',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'You have already added all available currencies',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 48,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'No currencies found',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Try searching with different keywords',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: TossColors.error,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Failed to load currencies',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              error.toString(),
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(AsyncValue<List<CurrencyType>> availableCurrenciesAsync) {
    return Container(
      margin: const EdgeInsets.only(top: TossSpacing.space4),
      padding: const EdgeInsets.only(top: TossSpacing.space4),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: TossColors.gray200, width: 1),
        ),
      ),
      child: availableCurrenciesAsync.maybeWhen(
        data: (currencies) {
          if (currencies.isEmpty) {
            return TossPrimaryButton(
              text: 'Close',
              onPressed: () => context.pop(),
            );
          }

          return Row(
            children: [
              // Cancel button
              Expanded(
                child: TossSecondaryButton(
                  text: 'Cancel',
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),

              // Next/Add button
              Expanded(
                flex: 2,
                child: TossPrimaryButton(
                  text: 'Next',
                  isLoading: widget.isLoading,
                  isEnabled: widget.selectedCurrencyId != null && !widget.isLoading,
                  onPressed: widget.selectedCurrencyId != null && !widget.isLoading
                      ? widget.onNext
                      : null,
                ),
              ),
            ],
          );
        },
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }
}
