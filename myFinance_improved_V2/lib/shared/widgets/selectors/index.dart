/// Selector Widgets - Autonomous data-fetching selectors
///
/// These widgets internally manage their own data fetching via Riverpod,
/// providing a "plug and play" experience for common selection patterns.
///
/// ## Architecture Pattern
/// Unlike traditional widgets that require external state management,
/// Autonomous Selectors encapsulate their Provider dependencies internally.
/// This provides:
/// - **Reusability**: Drop anywhere without Provider setup
/// - **Type Safety**: Callbacks return full entities, not just IDs
/// - **Consistency**: Same UX across all features
///
/// ## Folder Structure (Refactored 2025)
/// ```
/// selectors/
/// ├── index.dart                 # This file (barrel export)
/// ├── base/                      # Generic base selectors
/// │   ├── selector_config.dart   # Configuration class
/// │   ├── single_selector.dart   # TossSingleSelector<T>
/// │   └── multi_selector.dart    # TossMultiSelector<T>
/// ├── account/                   # Account selector (6 files)
/// │   ├── account_selector.dart  # AccountSelector (main)
/// │   ├── account_selector_sheet.dart
/// │   ├── account_selector_list.dart
/// │   ├── account_selector_item.dart
/// │   └── account_quick_access.dart
/// ├── cash_location/             # Cash location selector (5 files)
/// │   ├── cash_location_selector.dart
/// │   ├── cash_location_selector_sheet.dart
/// │   ├── cash_location_selector_list.dart
/// │   ├── cash_location_selector_item.dart
/// │   └── cash_location_tabs.dart
/// └── counterparty/              # Counterparty selector
///     └── counterparty_selector.dart
/// ```
///
/// ## Available Selectors
///
/// ### Base Selectors (Generic)
/// - [SelectorConfig] - Configuration for all selectors
/// - [TossSingleSelector] - Generic single item selector
/// - [TossMultiSelector] - Generic multi item selector
///
/// ### Domain Selectors (Autonomous)
/// - [AccountSelector] - Account selection with quick access
/// - [CashLocationSelector] - Cash location with Company/Store tabs
/// - [CounterpartySelector] - Counterparty with type filtering
/// - [CounterpartyMultiSelector] - Multi counterparty selection
///
/// ## Usage Example
/// ```dart
/// // Account selection
/// AccountSelector(
///   selectedAccountId: _selectedId,
///   onAccountSelected: (account) {
///     setState(() {
///       _selectedId = account.id;
///       _selectedName = account.name;
///     });
///   },
/// )
///
/// // Cash location selection
/// CashLocationSelector(
///   selectedLocationId: _locationId,
///   onCashLocationSelected: (location) => setState(() => _locationId = location.id),
/// )
///
/// // Counterparty selection
/// CounterpartySelector(
///   selectedCounterpartyId: _counterpartyId,
///   onCounterpartySelected: (cp) => setState(() => _counterpartyId = cp.id),
/// )
/// ```
///
/// ## Backward Compatibility
/// Old class names are still supported via typedef with @Deprecated:
/// - `EnhancedAccountSelector` -> Use `AccountSelector`
/// - `AutonomousCashLocationSelector` -> Use `CashLocationSelector`
/// - `AutonomousCounterpartySelector` -> Use `CounterpartySelector`
library;

// ═══════════════════════════════════════════════════════════════
// BASE SELECTORS (Generic)
// ═══════════════════════════════════════════════════════════════
export 'base/index.dart';

// ═══════════════════════════════════════════════════════════════
// DOMAIN SELECTORS (Autonomous)
// ═══════════════════════════════════════════════════════════════
export 'account/index.dart';
export 'cash_location/index.dart';
export 'counterparty/index.dart';
export 'exchange_rate/index.dart';

// ═══════════════════════════════════════════════════════════════
// SIMPLE SELECTORS (Static - work with raw data)
// ═══════════════════════════════════════════════════════════════
export 'simple/index.dart';
