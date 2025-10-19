// =====================================================
// ACCOUNT TYPE UTILITIES
// Core utilities for account type label generation
// =====================================================

import 'package:myfinance_improved/core/utils/string_extensions.dart';

/// Account type label utilities
class AccountTypeUtils {
  /// Get account type label
  static String getAccountTypeLabel(String? accountType, String? fallbackLabel, {bool isPlural = true}) {
    if (accountType == null) return fallbackLabel ?? (isPlural ? 'Accounts' : 'Account');

    final suffix = isPlural ? 's' : '';
    switch (accountType.toLowerCase()) {
      case 'asset':
        return 'Asset Account$suffix';
      case 'liability':
        return 'Liability Account$suffix';
      case 'equity':
        return 'Equity Account$suffix';
      case 'income':
        return 'Income Account$suffix';
      case 'expense':
        return 'Expense Account$suffix';
      default:
        return '${accountType.capitalize()} Account$suffix';
    }
  }

  /// Get account type hint text
  static String getAccountTypeHint(String? accountType, String? fallbackHint, {bool isPlural = true}) {
    if (accountType == null) return fallbackHint ?? (isPlural ? 'Select Accounts' : 'Select Account');

    final label = getAccountTypeLabel(accountType, null, isPlural: isPlural);
    return 'Select ${isPlural ? label.toLowerCase() : label}';
  }
}
