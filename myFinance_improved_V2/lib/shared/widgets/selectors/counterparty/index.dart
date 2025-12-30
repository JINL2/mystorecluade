/// Counterparty Selector
///
/// Autonomous counterparty selector widget for selecting counterparties.
/// Uses Riverpod providers internally for automatic data fetching.
///
/// ## Main Components
/// - [CounterpartySelector] - Single counterparty selection
/// - [CounterpartyMultiSelector] - Multiple counterparty selection
///
/// ## Usage Example
/// ```dart
/// import 'package:myfinance_improved/shared/widgets/selectors/counterparty/index.dart';
///
/// CounterpartySelector(
///   selectedCounterpartyId: _id,
///   onCounterpartySelected: (cp) => setState(() => _id = cp.id),
/// )
/// ```
///
/// ## Backward Compatibility
/// - [AutonomousCounterpartySelector] is deprecated, use [CounterpartySelector] instead
/// - [AutonomousMultiCounterpartySelector] is deprecated, use [CounterpartyMultiSelector] instead
library;

export 'counterparty_selector.dart';
