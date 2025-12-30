/// Base Selector Widgets
///
/// Generic selector widgets that can be used to build domain-specific selectors.
///
/// ## Available Widgets
/// - [SelectorConfig] - Configuration class for all selectors
/// - [TossSingleSelector] - Single-item selection widget
/// - [TossMultiSelector] - Multi-item selection widget
///
/// ## Callback Types
/// - [SingleSelectionCallback] - For single selection (String? id)
/// - [SingleSelectionWithNameCallback] - For selection with name
/// - [MultiSelectionCallback] - For multi selection
///
/// ## Usage Example
/// ```dart
/// import 'package:myfinance_improved/shared/widgets/selectors/base/index.dart';
///
/// TossSingleSelector<Store>(
///   items: stores,
///   selectedItem: selectedStore,
///   onChanged: (id) => handleChange(id),
///   config: SelectorConfig(label: 'Store', hint: 'Select store'),
///   itemIdBuilder: (s) => s.id,
///   itemTitleBuilder: (s) => s.name,
///   itemSubtitleBuilder: (s) => '',
/// )
/// ```
library;

export 'selector_config.dart';
export 'single_selector.dart';
export 'multi_selector.dart';
