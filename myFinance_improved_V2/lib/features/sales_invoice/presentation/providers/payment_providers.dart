// lib/features/sales_invoice/presentation/providers/payment_providers.dart
//
// Payment Method Provider migrated to @riverpod
// Following Clean Architecture 2025

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/sales_invoice_providers.dart';
import '../../domain/entities/cash_location.dart';
import '../models/invoice_models.dart';
import 'states/payment_method_state.dart';

part 'payment_providers.g.dart';

/// Payment method notifier using @riverpod
@Riverpod(keepAlive: false)
class PaymentMethodNotifier extends _$PaymentMethodNotifier {
  @override
  PaymentMethodState build() => const PaymentMethodState();

  // Load currency data and cash locations
  Future<void> loadCurrencyData() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Get company ID from app state
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) {
        throw Exception('Company not selected. Please select a company first.');
      }

      // Call UseCase to get currency data
      final getCurrencyDataUseCase = ref.read(getCurrencyDataUseCaseProvider);
      final currencyResult = await getCurrencyDataUseCase.execute(
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
            .map(
              (c) => PaymentCurrency(
                currencyId: c.currencyId,
                currencyCode: c.currencyCode,
                currencyName: c.currencyName,
                symbol: c.symbol,
                flagEmoji: c.flagEmoji,
                exchangeRateToBase: c.exchangeRateToBase,
              ),
            )
            .toList(),
      );

      // Load cash locations using repository
      List<CashLocation> cashLocations = [];

      try {
        // Get store ID from app state
        final storeId = appState.storeChoosen;
        if (storeId.isNotEmpty) {
          // UseCase returns domain entities directly
          final getCashLocationsUseCase = ref.read(getCashLocationsUseCaseProvider);
          cashLocations = await getCashLocationsUseCase.execute(
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

  // Set focused currency for input
  void setFocusedCurrency(String? currencyId) {
    state = state.copyWith(focusedCurrencyId: currencyId);
  }

  // Update discount amount
  void updateDiscountAmount(double amount) {
    state = state.copyWith(discountAmount: amount);
  }

  // Select a cash location
  void selectCashLocation(CashLocation? location) {
    state = state.copyWith(
      selectedCashLocation: location,
      selectedCurrency: null,
      currencyAmounts: const {},
      focusedCurrencyId: null,
    );
  }

  // Clear selections
  void clearSelections() {
    state = state.copyWith(
      selectedCashLocation: null,
      selectedCurrency: null,
      currencyAmounts: const {},
      focusedCurrencyId: null,
      discountAmount: 0.0,
    );
  }

  // Refresh data
  Future<void> refresh() async {
    await loadCurrencyData();
  }

  /// Create a journal entry for cash sales transaction
  /// This is called after invoice creation to record the accounting entry
  /// Includes COGS (Cost of Goods Sold) entries for inventory tracking
  Future<void> createSalesJournalEntry({
    required String companyId,
    required String storeId,
    required String userId,
    required double amount,
    required String description,
    required String lineDescription,
    required String cashLocationId,
    required double totalCost,
  }) async {
    final createSalesJournalUseCase = ref.read(createSalesJournalUseCaseProvider);
    await createSalesJournalUseCase.execute(
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      amount: amount,
      description: description,
      lineDescription: lineDescription,
      cashLocationId: cashLocationId,
      totalCost: totalCost,
    );
  }
}

// Provider to auto-load currency data when company changes
@riverpod
Future<void> paymentMethodData(Ref ref) async {
  final notifier = ref.watch(paymentMethodNotifierProvider.notifier);
  final appState = ref.watch(appStateProvider);

  // Watch for company changes
  if (appState.companyChoosen.isNotEmpty) {
    await notifier.loadCurrencyData();
  }
}
