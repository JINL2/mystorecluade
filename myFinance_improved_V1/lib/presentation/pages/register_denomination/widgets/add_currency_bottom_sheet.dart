import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../widgets/toss/toss_search_field.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../domain/entities/currency.dart';
import '../providers/currency_providers.dart';

// Provider to get available currencies (not yet added to company)
final availableCurrenciesToAddProvider = FutureProvider<List<CurrencyType>>((ref) async {
  try {
    // Get all currency types
    final allCurrencies = await ref.watch(availableCurrencyTypesProvider.future);
    
    // Get company's existing currencies
    final companyCurrencies = await ref.watch(companyCurrenciesProvider.future);
    
    // Filter out currencies that are already added to the company
    final existingCurrencyIds = companyCurrencies.map((c) => c.id).toSet();
    
    return allCurrencies.where((currency) => 
      !existingCurrencyIds.contains(currency.currencyId)
    ).toList();
  } catch (e) {
    throw Exception('Failed to load available currencies: $e');
  }
});

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
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedCurrencyIds.remove(currency.currencyId);
                                  } else {
                                    selectedCurrencyIds.add(currency.currencyId);
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space4,
                                  vertical: TossSpacing.space3,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected ? TossColors.primary.withOpacity(0.05) : TossColors.transparent,
                                  border: Border.all(
                                    color: isSelected ? TossColors.primary : TossColors.gray200,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    // Checkbox
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: isSelected ? TossColors.primary : TossColors.transparent,
                                        border: Border.all(
                                          color: isSelected ? TossColors.primary : TossColors.gray400,
                                          width: isSelected ? 0 : 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              color: TossColors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: TossSpacing.space3),
                                    // Flag emoji
                                    Text(
                                      currency.flagEmoji,
                                      style: TossTextStyles.h3,
                                    ),
                                    const SizedBox(width: TossSpacing.space3),
                                    // Currency details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${currency.currencyCode} - ${currency.currencyName}',
                                            style: TossTextStyles.body.copyWith(
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                              color: TossColors.gray900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
    
    setState(() => isLoading = true);
    
    try {
      // Add each selected currency to the company
      for (final currencyId in selectedCurrencyIds) {
        await ref.read(currencyOperationsProvider.notifier)
            .addCompanyCurrency(currencyId);
      }
      
      if (mounted) {
        Navigator.of(context).pop();
        
        // Get the currency details for the success message
        final currencies = ref.read(availableCurrenciesToAddProvider).valueOrNull ?? [];
        final addedCurrencies = currencies
            .where((c) => selectedCurrencyIds.contains(c.currencyId))
            .map((c) => c.currencyCode)
            .toList();
        
        final message = addedCurrencies.length == 1
            ? '${addedCurrencies.first} currency added successfully!'
            : '${addedCurrencies.length} currencies added successfully!';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add currencies: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
}