/// Selector Configuration
///
/// Configuration class for selector widgets.
/// Defines common settings like label, hint, search options, etc.
library;

import 'package:flutter/material.dart';

/// Configuration for selector widgets
class SelectorConfig {
  final String label;
  final String hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final IconData icon;
  final String emptyMessage;
  final String searchHint;
  /// Custom label style (if null, uses default TossTextStyles.label)
  final TextStyle? labelStyle;
  /// Whether to hide the built-in label (useful when providing custom label externally)
  final bool hideLabel;

  const SelectorConfig({
    required this.label,
    required this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = false,
    this.icon = Icons.arrow_drop_down,
    this.emptyMessage = 'No items available',
    this.searchHint = 'Search',
    this.labelStyle,
    this.hideLabel = false,
  });
}
