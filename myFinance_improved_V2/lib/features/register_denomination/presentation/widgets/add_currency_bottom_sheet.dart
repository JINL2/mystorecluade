import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_secondary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_search_field.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/currency.dart';
import '../providers/currency_providers.dart';
import '../providers/denomination_providers.dart';
import '../providers/exchange_rate_provider.dart';
// Note: availableCurrenciesToAddProvider is now defined in currency_providers.dart

class AddCurrencyBottomSheet extends ConsumerStatefulWidget {
  const AddCurrencyBottomSheet({super.key});

  @override
  ConsumerState<AddCurrencyBottomSheet> createState() => _AddCurrencyBottomSheetState();
}

class _AddCurrencyBottomSheetState extends ConsumerState<AddCurrencyBottomSheet> {
  String? selectedCurrencyId;  // Changed from Set to single selection
  bool isLoading = false;
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();
  final TextEditingController exchangeRateController = TextEditingController();
  
  // Step management
  int currentStep = 1; // 1 = Currency Selection, 2 = Exchange Rate
  CurrencyType? selectedCurrencyType;
  String? baseCurrencyId;
  String? baseCurrencySymbol;
  String? baseCurrencyCode;
  double? suggestedExchangeRate;
  bool isFetchingExchangeRate = false;

  @override
  void dispose() {
    searchController.dispose();
    exchangeRateController.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    _fetchBaseCurrency();
  }
  
  Future<void> _fetchBaseCurrency() async {
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      if (companyId.isEmpty) return;
      
      final supabase = ref.read(supabaseClientProvider);
      
      // Query companies table to get base_currency_id
      final companyResult = await supabase
          .from('companies')
          .select('base_currency_id')
          .eq('company_id', companyId)
          .maybeSingle();
      
      if (companyResult != null && companyResult['base_currency_id'] != null) {
        baseCurrencyId = companyResult['base_currency_id'] as String;
        
        // Query currency_types to get base currency symbol and code
        final currencyResult = await supabase
            .from('currency_types')
            .select('symbol, currency_code')
            .eq('currency_id', baseCurrencyId!)
            .maybeSingle();
        
        if (currencyResult != null) {
          setState(() {
            baseCurrencySymbol = currencyResult['symbol'] as String;
            baseCurrencyCode = currencyResult['currency_code'] as String;
          });
        }
      }
    } catch (e) {
      print('Error fetching base currency: $e');
    }
  }
  
  Future<void> _fetchExchangeRate() async {
    if (selectedCurrencyType == null || baseCurrencyCode == null) return;
    
    setState(() {
      isFetchingExchangeRate = true;
      suggestedExchangeRate = null;
      exchangeRateController.text = '1.0'; // Default placeholder
    });
    
    try {
      // Use the real exchange rate service
      final exchangeRateService = ref.read(exchangeRateServiceProvider);
      
      // Fetch real exchange rate from API
      // Note: API gives rate from base to target, so we need to get rate from selected currency to base currency
      final rate = await exchangeRateService.getExchangeRate(
        selectedCurrencyType!.currencyCode, 
        baseCurrencyCode!
      );
      
      if (mounted) {
        if (rate != null) {
          setState(() {
            suggestedExchangeRate = rate;
            exchangeRateController.text = rate.toStringAsFixed(4);
            isFetchingExchangeRate = false;
          });
        } else {
          // Fallback to 1.0 if API fails
          setState(() {
            suggestedExchangeRate = 1.0;
            exchangeRateController.text = '1.0';
            isFetchingExchangeRate = false;
          });
          
          // Show warning message
          await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) => TossDialog.warning(
              title: 'Exchange Rate Warning',
              message: 'Unable to fetch current exchange rates. Using default value.',
              primaryButtonText: 'OK',
            ),
          );
        }
      }
    } catch (e) {
      print('Error fetching exchange rate: $e');
      
      if (mounted) {
        setState(() {
          suggestedExchangeRate = 1.0;
          exchangeRateController.text = '1.0';
          isFetchingExchangeRate = false;
        });
        
        // Show error message
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Network Error',
            message: 'Failed to fetch exchange rates: Network error',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with title and close button
        Row(
          children: [
            if (currentStep == 2)
              IconButton(
                onPressed: () => setState(() {
                  currentStep = 1;
                }),
                icon: const Icon(Icons.arrow_back, color: TossColors.gray600),
                style: IconButton.styleFrom(
                  backgroundColor: TossColors.gray100,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.all(TossSpacing.space2 * 0.75),
                  minimumSize: const Size(28, 28),
                ),
              ),
            Expanded(
              child: Text(
                currentStep == 1 ? 'Currency' : 'Exchange Rate',
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
                padding: EdgeInsets.all(TossSpacing.space2 * 0.75),
                minimumSize: const Size(28, 28),
              ),
            ),
          ],
        ),
          
        const SizedBox(height: TossSpacing.space4),
        
        // Content based on current step
        if (currentStep == 1) _buildCurrencySelectionStep() else _buildExchangeRateStep(),
      ],
    );
  }
  
  void _goToExchangeRateStep() async {
    if (selectedCurrencyId == null) return;
    
    // Get the selected currency details
    final currencies = ref.read(availableCurrenciesToAddProvider).valueOrNull ?? [];
    selectedCurrencyType = currencies.firstWhere(
      (c) => c.currencyId == selectedCurrencyId,
      orElse: () => throw Exception('Currency not found'),
    );
    
    setState(() {
      currentStep = 2;
    });
    
    // Fetch exchange rate after transitioning
    await _fetchExchangeRate();
  }
  
  Widget _buildCurrencySelectionStep() {
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
                        if (selectedCurrencyId != null)
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
                          final isSelected = selectedCurrencyId == currency.currencyId;
                          
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == availableCurrencies.length - 1 ? 0 : TossSpacing.space2,
                            ),
                            child: CheckboxListTile(
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  // Single selection: if selecting this item, deselect others
                                  if (value ?? false) {
                                    selectedCurrencyId = currency.currencyId;
                                  } else {
                                    selectedCurrencyId = null;
                                  }
                                });
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
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space8),
                  child: TossLoadingView(),
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
                    
                    // Next/Add button
                    Expanded(
                      flex: 2,
                      child: TossPrimaryButton(
                        text: 'Next',
                        isLoading: isLoading,
                        isEnabled: selectedCurrencyId != null && !isLoading,
                        onPressed: selectedCurrencyId != null && !isLoading ? _goToExchangeRateStep : null,
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

  Widget _buildExchangeRateStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selectedCurrencyType != null) ...[
          // Currency selection display
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            margin: const EdgeInsets.only(bottom: TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Row(
              children: [
                Text(
                  selectedCurrencyType!.flagEmoji,
                  style: TossTextStyles.h3,
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedCurrencyType!.currencyCode,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                      Text(
                        selectedCurrencyType!.currencyName,
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Exchange rate configuration
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exchange Rate Configuration',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                
                // Exchange rate display
                if (baseCurrencySymbol != null) ...[
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '1 ${selectedCurrencyType!.symbol}',
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.gray900,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: TossColors.gray600,
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            Text(
                              '${exchangeRateController.text.isEmpty ? "0" : exchangeRateController.text} $baseCurrencySymbol',
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TossSpacing.space2),
                        Text(
                          'Base Currency: $baseCurrencySymbol',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                ],
                
                // Exchange rate input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exchange Rate',
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: TossColors.gray700,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    TextFormField(
                      controller: exchangeRateController,
                      enabled: !isFetchingExchangeRate && suggestedExchangeRate != null,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: isFetchingExchangeRate ? 'Fetching rate...' : 'Enter exchange rate',
                        suffixText: baseCurrencySymbol,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          borderSide: BorderSide(
                            color: isFetchingExchangeRate ? TossColors.gray300 : TossColors.gray300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          borderSide: const BorderSide(color: TossColors.primary),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          borderSide: const BorderSide(color: TossColors.gray200),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {}); // Trigger rebuild to update the exchange rate display
                      },
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    
                    // Loading state or suggested rate
                    if (isFetchingExchangeRate) ...[
                      Row(
                        children: [
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: const TossLoadingView(),
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            'Fetching current exchange rates...',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ] else if (suggestedExchangeRate != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 14,
                            color: TossColors.success,
                          ),
                          const SizedBox(width: TossSpacing.space1),
                          Text(
                            'Live rate: ${suggestedExchangeRate!.toStringAsFixed(4)} (from Exchange Rate API)',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
        
        // Bottom action buttons
        Container(
          margin: const EdgeInsets.only(top: TossSpacing.space4),
          padding: const EdgeInsets.only(top: TossSpacing.space4),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: TossColors.gray200, width: 1),
            ),
          ),
          child: Row(
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
                  text: 'Add Currency',
                  isLoading: isLoading,
                  isEnabled: !isLoading && !isFetchingExchangeRate && exchangeRateController.text.isNotEmpty && suggestedExchangeRate != null,
                  onPressed: !isLoading && !isFetchingExchangeRate && exchangeRateController.text.isNotEmpty && suggestedExchangeRate != null
                      ? _addCurrencyWithExchangeRate 
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  void _addCurrencyWithExchangeRate() async {
    if (selectedCurrencyId == null || selectedCurrencyType == null) return;
    
    final exchangeRateText = exchangeRateController.text.trim();
    if (exchangeRateText.isEmpty) return;
    
    // Validate exchange rate
    final double? exchangeRate = double.tryParse(exchangeRateText);
    if (exchangeRate == null || exchangeRate <= 0) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Validation Error',
          message: 'Please enter a valid exchange rate',
          primaryButtonText: 'OK',
        ),
      );
      return;
    }
    
    setState(() {
      isLoading = true;
    });
    
    final message = '${selectedCurrencyType!.currencyCode} currency added successfully!';
    
    try {
      // Get required data from app state
      final appState = ref.read(appStateProvider);
      final userData = ref.read(userDisplayDataProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty) {
        throw Exception('No company selected');
      }

      // Extract user_id from user data
      String? userId;
      if (userData.isNotEmpty) {
        userId = userData['user_id']?.toString();
      }
      
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found in app state');
      }
      
      final supabase = ref.read(supabaseClientProvider);
      final currentTime = DateTimeUtils.nowUtc();
      final currentDate = DateTimeUtils.toDateOnly(DateTime.now());
      
      // First check if currency is soft-deleted and reactivate if needed
      final existingCurrency = await supabase
          .from('company_currency')
          .select('company_currency_id, is_deleted')
          .eq('company_id', companyId)
          .eq('currency_id', selectedCurrencyId!)
          .maybeSingle();
      
      if (existingCurrency != null) {
        if (existingCurrency['is_deleted'] == true) {
          // Reactivate soft-deleted currency
          await supabase
              .from('company_currency')
              .update({
                'is_deleted': false,
                // Note: company_currency table only has created_at, not updated_at
              })
              .eq('company_currency_id', existingCurrency['company_currency_id'])
              .eq('company_id', companyId)
              .eq('currency_id', selectedCurrencyId!);
        } else {
          throw Exception('Currency already exists for this company');
        }
      } else {
        // 1. Insert into company_currency table
        await supabase
            .from('company_currency')
            .insert({
              'company_id': companyId,
              'currency_id': selectedCurrencyId!,
              'is_deleted': false,
              'created_at': currentTime,
            });
      }
      
      // 2. Insert into book_exchange_rates table
      await supabase
          .from('book_exchange_rates')
          .insert({
            'company_id': companyId,
            'from_currency_id': selectedCurrencyId!,
            'to_currency_id': baseCurrencyId!,
            'rate': exchangeRate,
            'rate_date': currentDate,
            'created_by': userId,
            'created_at': currentTime,
          });
      
      // Create Currency object for local state update
      final newCurrency = Currency(
        id: selectedCurrencyId!,
        code: selectedCurrencyType!.currencyCode,
        name: selectedCurrencyType!.currencyName,
        fullName: selectedCurrencyType!.currencyName,
        symbol: selectedCurrencyType!.symbol,
        flagEmoji: selectedCurrencyType!.flagEmoji,
      );
      
      // Update local state immediately for instant UI update
      ref.read(localCurrencyListProvider.notifier).optimisticallyAdd(newCurrency);
      
      // Clear any stale denomination data for this new currency
      // This ensures the denomination provider will fetch fresh data from the database
      ref.read(localDenominationListProvider.notifier).reset(selectedCurrencyId!);
      
      if (mounted) {
        Navigator.of(context).pop();

        // Show success message
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Currency Added',
            message: message,
            primaryButtonText: 'OK',
          ),
        );

        // Refresh providers after UI operations complete to sync with database
        Future.microtask(() {
          ref.invalidate(availableCurrenciesToAddProvider);
          ref.invalidate(companyCurrenciesProvider);
          ref.invalidate(companyCurrenciesStreamProvider);
        });
      }

    } catch (e) {
      print('Error adding currency with exchange rate: $e');

      // Revert optimistic update on failure
      ref.read(localCurrencyListProvider.notifier).optimisticallyRemove(selectedCurrencyId!);

      if (mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'Failed to add currency: $e',
            primaryButtonText: 'OK',
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

}