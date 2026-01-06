import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../domain/entities/cash_location.dart';
import '../models/payment_models.dart';
import 'states/payment_method_state.dart';
import 'usecase_providers.dart';

part 'payment_providers.g.dart';

/// Payment method notifier - manages payment method selection and currency data
///
/// Uses @riverpod for auto-dispose behavior (resets when leaving payment page).
/// State is PaymentMethodState (freezed) for complex UI state management.
@riverpod
class PaymentMethodNotifier extends _$PaymentMethodNotifier {
  @override
  PaymentMethodState build() {
    return const PaymentMethodState();
  }

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
          final getCashLocationsUseCase =
              ref.read(getCashLocationsUseCaseProvider);
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

  // Update discount amount (simple update without percentage sync)
  void updateDiscountAmount(double amount) {
    state = state.copyWith(discountAmount: amount);
  }

  /// Update discount with amount and percentage sync
  /// Used when discount is set via Exchange Rate Panel "Apply as Total"
  /// [amount] - the discount amount in base currency
  /// [percentage] - the calculated percentage (0-100)
  /// [isPercentageMode] - whether the user is in percentage input mode
  void updateDiscountWithSync({
    required double amount,
    required double percentage,
    required bool isPercentageMode,
  }) {
    state = state.copyWith(
      discountAmount: amount,
      discountPercentage: percentage,
      isPercentageMode: isPercentageMode,
    );
  }

  /// Update tax/fees amount with percentage sync
  /// [amount] - the tax/fees amount in base currency
  /// [percentage] - the calculated percentage (0-100)
  void updateTaxFeesAmount({
    required double amount,
    required double percentage,
  }) {
    state = state.copyWith(
      taxFeesAmount: amount,
      taxFeesPercentage: percentage,
    );
  }

  // Set preloaded cash locations (from SaleProductPage)
  void setCashLocations(List<CashLocation> locations) {
    state = state.copyWith(
      isLoading: false,
      cashLocations: locations,
    );
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
      discountPercentage: 0.0,
      isPercentageMode: false,
      taxFeesAmount: 0.0,
      taxFeesPercentage: 0.0,
      isSubmitting: false,
    );
  }

  /// Start invoice submission - prevents duplicate clicks
  /// Returns true if submission can proceed, false if already submitting
  bool startSubmitting() {
    if (state.isSubmitting) {
      return false; // Already submitting, reject this attempt
    }
    state = state.copyWith(isSubmitting: true);
    return true;
  }

  /// End invoice submission - reset submitting state
  void endSubmitting() {
    state = state.copyWith(isSubmitting: false);
  }

  // Refresh data
  Future<void> refresh() async {
    await loadCurrencyData();
  }

  /// Create a journal entry for cash sales transaction
  /// This is called after invoice creation to record the accounting entry
  /// Includes COGS (Cost of Goods Sold) entries for inventory tracking
  ///
  /// Returns: The journal_id of the created sales journal entry (for attachments)
  Future<String?> createSalesJournalEntry({
    required String companyId,
    required String storeId,
    required String userId,
    required double amount,
    required String description,
    required String lineDescription,
    required String cashLocationId,
    required double totalCost,
    required String invoiceId,
  }) async {
    final createSalesJournalUseCase =
        ref.read(createSalesJournalUseCaseProvider);
    return createSalesJournalUseCase.execute(
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      amount: amount,
      description: description,
      lineDescription: lineDescription,
      cashLocationId: cashLocationId,
      totalCost: totalCost,
      invoiceId: invoiceId,
    );
  }
}

/// Provider to auto-load currency data when company changes
@riverpod
Future<void> paymentMethodData(PaymentMethodDataRef ref) async {
  final notifier = ref.watch(paymentMethodNotifierProvider.notifier);
  final appState = ref.watch(appStateProvider);

  // Watch for company changes
  if (appState.companyChoosen.isNotEmpty) {
    await notifier.loadCurrencyData();
  }
}
