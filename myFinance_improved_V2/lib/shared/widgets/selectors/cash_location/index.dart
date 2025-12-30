/// Cash Location Selector
///
/// Autonomous cash location selector widget for selecting cash locations.
/// Uses Riverpod providers internally for automatic data fetching.
///
/// ## Main Components
/// - [CashLocationSelector] - Main widget with scope awareness
/// - [CashLocationScopedSheet] - Bottom sheet with Company/Store tabs
/// - [CashLocationSimpleSheet] - Simple bottom sheet without tabs
/// - [CashLocationSelectorItem] - Individual location item widget
/// - [CashLocationScopeTabs] - Tab bar for Company/Store views
///
/// ## Usage Example
/// ```dart
/// import 'package:myfinance_improved/shared/widgets/selectors/cash_location/index.dart';
///
/// CashLocationSelector(
///   selectedLocationId: _id,
///   onCashLocationSelected: (location) => setState(() => _id = location.id),
/// )
/// ```
///
/// ## Backward Compatibility
/// - [AutonomousCashLocationSelector] is deprecated, use [CashLocationSelector] instead
library;

// Main widget
export 'cash_location_selector.dart';

// Sub-components
export 'cash_location_selector_sheet.dart';
export 'cash_location_selector_list.dart';
export 'cash_location_selector_item.dart';
export 'cash_location_tabs.dart';
