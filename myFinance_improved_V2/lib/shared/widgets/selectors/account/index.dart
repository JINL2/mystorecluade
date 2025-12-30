/// Account Selector
///
/// Autonomous account selector widget for selecting accounts.
/// Uses Riverpod providers internally for automatic data fetching.
///
/// ## Main Components
/// - [AccountSelector] - Main widget (single/multi selection)
/// - [AccountSelectorSheet] - Bottom sheet for single selection
/// - [AccountMultiSelectSheet] - Bottom sheet for multi selection
/// - [AccountSelectorItem] - Individual account item widget
/// - [AccountQuickAccessSection] - Quick access section widget
///
/// ## Usage Example
/// ```dart
/// import 'package:myfinance_improved/shared/widgets/selectors/account/index.dart';
///
/// AccountSelector(
///   selectedAccountId: _id,
///   onAccountSelected: (account) => setState(() => _id = account.id),
/// )
/// ```
///
/// ## Backward Compatibility
/// - [EnhancedAccountSelector] is deprecated, use [AccountSelector] instead
library;

// Main widget
export 'account_selector.dart';

// Sub-components
export 'account_selector_sheet.dart';
export 'account_selector_list.dart';
export 'account_selector_item.dart';
export 'account_quick_access.dart';
export 'account_multi_select.dart';
