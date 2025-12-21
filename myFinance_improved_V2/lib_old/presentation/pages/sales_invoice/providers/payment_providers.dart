import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invoice_models.dart';
import '../../../providers/app_state_provider.dart';
import '../../../../data/services/inventory_service.dart';

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
  final InventoryService _inventoryService;

  PaymentMethodNotifier(this.ref, this._inventoryService) : super(PaymentMethodState());

  // Load currency data and cash locations
  Future<void> loadCurrencyData() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Get company ID from app state
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) {
        throw Exception('Company not selected. Please select a company first.');
      }

      print('🔍 [PAYMENT_METHOD] Loading currency data for company: ${appState.companyChoosen}');

      // Call RPC function to get base currency
      final response = await _inventoryService.getBaseCurrency(
        companyId: appState.companyChoosen,
      );

      print('📥 [PAYMENT_METHOD] Response received: ${response != null}');

      if (response != null) {
        // Parse currency response
        BaseCurrencyResponse currencyResponse;
        
        // Check if response has success wrapper
        if (response.containsKey('success') && response['success'] == true) {
          currencyResponse = BaseCurrencyResponse.fromJson(response['data'] as Map<String, dynamic>? ?? {});
        } else if (!response.containsKey('success')) {
          // Direct data response
          currencyResponse = BaseCurrencyResponse.fromJson(response);
        } else {
          throw Exception(response['error']?['message'] ?? 'Failed to load currency data');
        }

        print('✅ [PAYMENT_METHOD] Currency data loaded: ${currencyResponse.companyCurrencies.length} currencies');

        // Load cash locations using RPC call
        List<CashLocation> cashLocations = [];
        
        try {
          // Get store ID from app state
          final storeId = appState.storeChoosen;
          if (storeId.isEmpty) {
            print('⚠️ [PAYMENT_METHOD] Store not selected, using empty cash locations list');
          } else {
            print('🔍 [PAYMENT_METHOD] Loading cash locations for store: $storeId');
            
            final cashLocationsResponse = await _inventoryService.getCashLocations(
              companyId: appState.companyChoosen,
              storeId: storeId,
            );

            if (cashLocationsResponse != null) {
              cashLocations = cashLocationsResponse
                  .map((location) => CashLocation.fromJson(location))
                  .toList();
              print('✅ [PAYMENT_METHOD] Cash locations loaded: ${cashLocations.length} locations');
            } else {
              print('⚠️ [PAYMENT_METHOD] No cash locations received from RPC');
            }
          }
        } catch (e) {
          print('❌ [PAYMENT_METHOD] Error loading cash locations: $e');
          // Continue with empty list - currency data is still loaded
        }

        state = state.copyWith(
          isLoading: false,
          currencyResponse: currencyResponse,
          cashLocations: cashLocations,
        );

      } else {
        throw Exception('No response received from server');
      }
    } catch (e, stackTrace) {
      print('❌ [PAYMENT_METHOD] Error loading currency data: $e');
      print('📋 [PAYMENT_METHOD] Stack trace: $stackTrace');

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
    print('🏦 [PAYMENT_METHOD] Updated cash location: ${location.name}');
  }

  // Update selected currency
  void updateCurrency(PaymentCurrency currency) {
    state = state.copyWith(
      selectedCurrency: currency,
      focusedCurrencyId: currency.currencyId,
    );
    print('💰 [PAYMENT_METHOD] Updated currency: ${currency.currencyCode}');
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
    print('💵 [PAYMENT_METHOD] Updated amount for currency $currencyId: $amount');
  }

  // Set focused currency for input
  void setFocusedCurrency(String? currencyId) {
    state = state.copyWith(
      focusedCurrencyId: currencyId,
      clearFocusedCurrencyId: currencyId == null,
    );
    print('🎯 [PAYMENT_METHOD] Set focused currency: $currencyId');
  }

  // Update discount amount
  void updateDiscountAmount(double amount) {
    state = state.copyWith(discountAmount: amount);
    print('💰 [PAYMENT_METHOD] Updated discount amount: $amount');
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
}

// Provider for payment method state
final paymentMethodProvider = StateNotifierProvider.autoDispose<PaymentMethodNotifier, PaymentMethodState>((ref) {
  final inventoryService = InventoryService();
  return PaymentMethodNotifier(ref, inventoryService);
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