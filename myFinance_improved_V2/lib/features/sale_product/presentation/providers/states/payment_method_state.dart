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
    String? error,
    BaseCurrencyResponse? currencyResponse,
    @Default([]) List<CashLocation> cashLocations,
    CashLocation? selectedCashLocation,
    PaymentCurrency? selectedCurrency,
    @Default({}) Map<String, double> currencyAmounts,
    String? focusedCurrencyId,
    @Default(0.0) double discountAmount,
  }) = _PaymentMethodState;
}
