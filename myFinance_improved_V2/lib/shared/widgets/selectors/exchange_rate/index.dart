/// Exchange Rate Selector
///
/// Autonomous currency exchange calculator with internal data fetching.
///
/// ## Usage
/// ```dart
/// ExchangeRateCalculator(
///   onAmountSelected: (amount) => setState(() => _amount = amount),
/// )
///
/// // Or show as bottom sheet
/// ExchangeRateCalculator.show(
///   context: context,
///   onAmountSelected: (amount) => _handleAmount(amount),
/// );
/// ```
library;

export 'exchange_rate_calculator.dart';
export 'exchange_rate_provider.dart' show CalculatorExchangeRateParams;
