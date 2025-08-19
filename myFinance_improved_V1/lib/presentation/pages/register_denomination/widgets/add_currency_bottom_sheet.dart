import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../widgets/toss/toss_search_field.dart';
import '../../../widgets/toss/toss_checkbox.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../domain/entities/currency.dart';
import '../providers/currency_providers.dart';

// Note: availableCurrenciesToAddProvider is now defined in currency_providers.dart

class AddCurrencyBottomSheet extends ConsumerStatefulWidget {
  const AddCurrencyBottomSheet({super.key});

  @override
  ConsumerState<AddCurrencyBottomSheet> createState() => _AddCurrencyBottomSheetState();
}

class _AddCurrencyBottomSheetState extends ConsumerState<AddCurrencyBottomSheet> {
  Set<String> selectedCurrencyIds = {};
  bool isLoading = false;
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
          // Header with title and close button
          Row(
            children: [
              Expanded(
                child: Text(
                  'Currency',
                  style: TossTextStyles.h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: TossColors.gray600),
                style: IconButton.styleFrom(
                  backgroundColor: TossColors.gray100,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(6),
                  minimumSize: const Size(28, 28),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
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
              data: (allCurrencies) {
                // Filter currencies based on search query
                final availableCurrencies = searchQuery.isEmpty 
                    ? allCurrencies 
                    : allCurrencies.where((currency) {
                        final query = searchQuery.toLowerCase();
                        return currency.currencyCode.toLowerCase().contains(query) ||
                               currency.currencyName.toLowerCase().contains(query);
                      }).toList();
                
                if (allCurrencies.isEmpty) {
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

                if (availableCurrencies.isEmpty && searchQuery.isNotEmpty) {
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
                        if (selectedCurrencyIds.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${selectedCurrencyIds.length} selected',
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
                          final isSelected = selectedCurrencyIds.contains(currency.currencyId);
                          
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == availableCurrencies.length - 1 ? 0 : TossSpacing.space2,
                            ),
                            child: TossCheckboxListTile(
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (value) {
                                    selectedCurrencyIds.add(currency.currencyId);
                                  } else {
                                    selectedCurrencyIds.remove(currency.currencyId);
                                  }
                                });
                              },
                              leading: Text(
                                currency.flagEmoji,
                                style: TossTextStyles.h3,
                              ),
                              title: Text(
                                '${currency.currencyCode} - ${currency.currencyName}',
                              ),
                              enabled: true,
                              selected: isSelected,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space8),
                  child: CircularProgressIndicator(
                    color: TossColors.primary,
                  ),
                ),
              ),
              error: (error, _) => Padding(
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
              ),
            ),
          ),
          
          // Bottom action buttons
          Container(
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
                    onPressed: () => Navigator.of(context).pop(),
                  );
                }
                
                return Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: TossSecondaryButton(
                        text: 'Cancel',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    
                    // Add button
                    Expanded(
                      flex: 2,
                      child: TossPrimaryButton(
                        text: selectedCurrencyIds.isEmpty 
                            ? 'Add Currency' 
                            : 'Add ${selectedCurrencyIds.length} ${selectedCurrencyIds.length == 1 ? 'Currency' : 'Currencies'}',
                        isLoading: isLoading,
                        isEnabled: selectedCurrencyIds.isNotEmpty && !isLoading,
                        onPressed: selectedCurrencyIds.isNotEmpty && !isLoading ? _addCurrencies : null,
                      ),
                    ),
                  ],
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
          ),
        ],
    );
  }

  void _addCurrencies() async {
    if (selectedCurrencyIds.isEmpty) return;
    
    // Get the currency details for the success message before closing
    final currencies = ref.read(availableCurrenciesToAddProvider).valueOrNull ?? [];
    final addedCurrencies = currencies
        .where((c) => selectedCurrencyIds.contains(c.currencyId))
        .map((c) => c.currencyCode)
        .toList();
    
    final message = addedCurrencies.length == 1
        ? '${addedCurrencies.first} currency added successfully!'
        : '${addedCurrencies.length} currencies added successfully!';
    
    // Close bottom sheet immediately for better UX
    if (mounted) {
      Navigator.of(context).pop();
      
      // Show immediate success message (optimistic)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: TossColors.success,
        ),
      );
    }
    
    try {
      // Add each selected currency to the company (these already have optimistic updates)
      for (final currencyId in selectedCurrencyIds) {
        await ref.read(currencyOperationsProvider.notifier)
            .addCompanyCurrency(currencyId);
      }
      
      // Refresh available currencies to add provider
      ref.invalidate(availableCurrenciesToAddProvider);
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add currencies: $e. Changes reverted.'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }
}