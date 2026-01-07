import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/cash_location.dart';
import '../../models/payment_models.dart';

part 'payment_method_state.freezed.dart';

/// Payment Method Page State
///
/// Manages payment method selection, currency data, and cash locations.
/// Uses Freezed for immutability and value equality.
@freezed
class PaymentMethodState with _$PaymentMethodState {
  const factory PaymentMethodState({
    @Default(false) bool isLoading,
    /// Whether an invoice submission is in progress (prevents duplicate clicks)
    @Default(false) bool isSubmitting,
    String? error,
    BaseCurrencyResponse? currencyResponse,
    @Default([]) List<CashLocation> cashLocations,
    CashLocation? selectedCashLocation,
    PaymentCurrency? selectedCurrency,
    @Default({}) Map<String, double> currencyAmounts,
    String? focusedCurrencyId,
    @Default(0.0) double discountAmount,
    /// Discount percentage (0-100), synced with discountAmount
    @Default(0.0) double discountPercentage,
    /// Whether discount was set as percentage mode (true) or amount mode (false)
    @Default(false) bool isPercentageMode,
    /// Tax/Fees amount in base currency (added to total)
    @Default(0.0) double taxFeesAmount,
    /// Tax/Fees percentage (0-100), synced with taxFeesAmount
    @Default(0.0) double taxFeesPercentage,
  }) = _PaymentMethodState;
}
