import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/sales_journal_repository.dart';
import '../models/invoice_models.dart';

// State for managing payment method page
class PaymentMethodState {
  final bool isLoading;
  final String? error;
  final BaseCurrencyResponse? currencyResponse;
  final List<CashLocation> cashLocations;
  final CashLocation? selectedCashLocation;
  final PaymentCurrency? selectedCurrency;
  final Map<String, double> currencyAmounts; // Track amounts for each currency
  final String? focusedCurrencyId; // Track which currency is being edited
  final double discountAmount; // Discount amount in base currency

  PaymentMethodState({
    this.isLoading = false,
    this.error,
    this.currencyResponse,
    this.cashLocations = const [],
    this.selectedCashLocation,
    this.selectedCurrency,
    this.currencyAmounts = const {},
    this.focusedCurrencyId,
    this.discountAmount = 0.0,
  });

  PaymentMethodState copyWith({
    bool? isLoading,
    String? error,
    BaseCurrencyResponse? currencyResponse,
    List<CashLocation>? cashLocations,
    CashLocation? selectedCashLocation,
    PaymentCurrency? selectedCurrency,
    Map<String, double>? currencyAmounts,
    String? focusedCurrencyId,
    bool clearFocusedCurrencyId = false,
    double? discountAmount,
  }) {
    return PaymentMethodState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currencyResponse: currencyResponse ?? this.currencyResponse,
      cashLocations: cashLocations ?? this.cashLocations,
      selectedCashLocation: selectedCashLocation ?? this.selectedCashLocation,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      currencyAmounts: currencyAmounts ?? this.currencyAmounts,
      focusedCurrencyId: clearFocusedCurrencyId ? null : (focusedCurrencyId ?? this.focusedCurrencyId),
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }
}

class PaymentMethodNotifier extends StateNotifier<PaymentMethodState> {
  final Ref ref;
  final ProductRepository _productRepository;
  final SalesJournalRepository _salesJournalRepository;

  PaymentMethodNotifier(this.ref, this._productRepository, this._salesJournalRepository) : super(PaymentMethodState());

  // Load currency data and cash locations
  Future<void> loadCurrencyData() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Get company ID from app state
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) {
        throw Exception('Company not selected. Please select a company first.');
      }

      // Call repository to get currency data
      final currencyResult = await _productRepository.getCurrencyData(
        companyId: appState.companyChoosen,
      );

      // Convert CurrencyDataResult to BaseCurrencyResponse for UI
      final currencyResponse = BaseCurrencyResponse(
        baseCurrency: PaymentCurrency(
          currencyId: currencyResult.baseCurrency.currencyId,
          currencyCode: currencyResult.baseCurrency.currencyCode,
          currencyName: currencyResult.baseCurrency.currencyName,
          symbol: currencyResult.baseCurrency.symbol,
          flagEmoji: currencyResult.baseCurrency.flagEmoji,
          exchangeRateToBase: currencyResult.baseCurrency.exchangeRateToBase,
        ),
        companyCurrencies: currencyResult.companyCurrencies
            .map((c) => PaymentCurrency(
                  currencyId: c.currencyId,
                  currencyCode: c.currencyCode,
                  currencyName: c.currencyName,
                  symbol: c.symbol,
                  flagEmoji: c.flagEmoji,
                  exchangeRateToBase: c.exchangeRateToBase,
                ))
            .toList(),
      );

      // Load cash locations using repository
      List<CashLocation> cashLocations = [];

      try {
        // Get store ID from app state
        final storeId = appState.storeChoosen;
        if (storeId.isNotEmpty) {
          // Repository returns domain entities directly
          cashLocations = await _productRepository.getCashLocations(
            companyId: appState.companyChoosen,
            storeId: storeId,
          );
        }
      } catch (e) {
        // Continue with empty list - currency data is still loaded
      }

      state = state.copyWith(
        isLoading: false,
        currencyResponse: currencyResponse,
        cashLocations: cashLocations,
      );
    } catch (e) {
      String errorMessage = 'Failed to load payment data';

      if (e.toString().contains('Company not selected')) {
        errorMessage = 'Please select a company first';
      } else if (e.toString().contains('No response')) {
        errorMessage = 'No response from server. Please check your connection.';
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    }
  }

  // Update selected cash location
  void updateCashLocation(CashLocation location) {
    state = state.copyWith(selectedCashLocation: location);
  }

  // Update selected currency
  void updateCurrency(PaymentCurrency currency) {
    state = state.copyWith(
      selectedCurrency: currency,
      focusedCurrencyId: currency.currencyId,
    );
  }

  // Update currency amount
  void updateCurrencyAmount(String currencyId, double amount) {
    final updatedAmounts = Map<String, double>.from(state.currencyAmounts);
    if (amount > 0) {
      updatedAmounts[currencyId] = amount;
    } else {
      updatedAmounts.remove(currencyId);
    }
    state = state.copyWith(currencyAmounts: updatedAmounts);
  }

  // Set focused currency for input
  void setFocusedCurrency(String? currencyId) {
    state = state.copyWith(
      focusedCurrencyId: currencyId,
      clearFocusedCurrencyId: currencyId == null,
    );
  }

  // Update discount amount
  void updateDiscountAmount(double amount) {
    state = state.copyWith(discountAmount: amount);
  }

  // Select a cash location
  void selectCashLocation(CashLocation? location) {
    state = state.copyWith(
      selectedCashLocation: location,
      // Clear currency selection when cash location changes
      selectedCurrency: null,
      currencyAmounts: {},
      clearFocusedCurrencyId: true,
    );
  }

  // Select a payment currency
  void selectCurrency(PaymentCurrency? currency) {
    state = state.copyWith(selectedCurrency: currency);
  }

  // Clear selections
  void clearSelections() {
    state = state.copyWith(
      selectedCashLocation: null,
      selectedCurrency: null,
      currencyAmounts: {},
      clearFocusedCurrencyId: true,
      discountAmount: 0.0,
    );
  }

  // Refresh data
  Future<void> refresh() async {
    await loadCurrencyData();
  }

  /// Create a journal entry for cash sales transaction
  /// This is called after invoice creation to record the accounting entry
  Future<void> createSalesJournalEntry({
    required String companyId,
    required String storeId,
    required String userId,
    required double amount,
    required String description,
    required String lineDescription,
    required String cashLocationId,
  }) async {
    await _salesJournalRepository.createSalesJournalEntry(
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      amount: amount,
      description: description,
      lineDescription: lineDescription,
      cashLocationId: cashLocationId,
    );
  }
}

// Provider for payment method state
final paymentMethodProvider = StateNotifierProvider.autoDispose<PaymentMethodNotifier, PaymentMethodState>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  final salesJournalRepository = ref.read(salesJournalRepositoryProvider);
  return PaymentMethodNotifier(ref, productRepository, salesJournalRepository);
});

// Provider to auto-load currency data when company changes
final paymentMethodDataProvider = FutureProvider.autoDispose<void>((ref) async {
  final notifier = ref.watch(paymentMethodProvider.notifier);
  final appState = ref.watch(appStateProvider);

  // Watch for company changes
  if (appState.companyChoosen.isNotEmpty) {
    await notifier.loadCurrencyData();
  }
});
