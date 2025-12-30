import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../di/providers.dart';
import '../../domain/entities/currency.dart';
import '../providers/currency_providers.dart';
import '../providers/denomination_providers.dart';
import 'add_currency/currency_selection_step.dart';
import 'add_currency/exchange_rate_step.dart';

class AddCurrencyBottomSheet extends ConsumerStatefulWidget {
  const AddCurrencyBottomSheet({super.key});

  @override
  ConsumerState<AddCurrencyBottomSheet> createState() => _AddCurrencyBottomSheetState();
}

class _AddCurrencyBottomSheetState extends ConsumerState<AddCurrencyBottomSheet> {
  String? selectedCurrencyId;
  bool isLoading = false;
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
      debugPrint('Error fetching base currency: $e');
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
      final rate = await exchangeRateService.getExchangeRate(
        selectedCurrencyType!.currencyCode,
        baseCurrencyCode!,
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
      debugPrint('Error fetching exchange rate: $e');

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
        _buildHeader(),

        const SizedBox(height: TossSpacing.space4),

        // Content based on current step
        if (currentStep == 1)
          CurrencySelectionStep(
            selectedCurrencyId: selectedCurrencyId,
            isLoading: isLoading,
            onCurrencySelected: (currencyId) {
              setState(() {
                selectedCurrencyId = currencyId;
              });
            },
            onNext: _goToExchangeRateStep,
          )
        else if (selectedCurrencyType != null)
          ExchangeRateStep(
            selectedCurrencyType: selectedCurrencyType!,
            baseCurrencySymbol: baseCurrencySymbol,
            exchangeRateController: exchangeRateController,
            isFetchingExchangeRate: isFetchingExchangeRate,
            suggestedExchangeRate: suggestedExchangeRate,
            isLoading: isLoading,
            onAdd: _addCurrencyWithExchangeRate,
            onExchangeRateChanged: () => setState(() {}),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
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
              padding: const EdgeInsets.all(TossSpacing.space2 * 0.75),
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
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close, color: TossColors.gray600),
          style: IconButton.styleFrom(
            backgroundColor: TossColors.gray100,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(TossSpacing.space2 * 0.75),
            minimumSize: const Size(28, 28),
          ),
        ),
      ],
    );
  }

  Future<void> _goToExchangeRateStep() async {
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

  Future<void> _addCurrencyWithExchangeRate() async {
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
              })
              .eq('company_currency_id', existingCurrency['company_currency_id'] as String)
              .eq('company_id', companyId)
              .eq('currency_id', selectedCurrencyId!);
        } else {
          throw Exception('Currency already exists for this company');
        }
      } else {
        // 1. Insert into company_currency table
        await supabase.from('company_currency').insert({
          'company_id': companyId,
          'currency_id': selectedCurrencyId!,
          'is_deleted': false,
          'created_at': currentTime,
        });
      }

      // 2. Insert into book_exchange_rates table
      await supabase.from('book_exchange_rates').insert({
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
      ref.read(localDenominationListProvider.notifier).reset(selectedCurrencyId!);

      // Invalidate providers first for immediate UI update on parent page
      ref.invalidate(availableCurrenciesToAddProvider);
      ref.invalidate(companyCurrenciesProvider);
      ref.invalidate(companyCurrenciesStreamProvider);

      if (mounted) {
        context.pop();

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
      }
    } catch (e) {
      debugPrint('Error adding currency with exchange rate: $e');

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
