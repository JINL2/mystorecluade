// lib/features/cash_ending/presentation/extensions/balance_summary_formatting.dart

import '../../../../core/utils/number_formatter.dart';
import '../../domain/entities/balance_summary.dart';

/// Presentation layer formatting extension for BalanceSummary
///
/// Provides formatted amounts with currency symbols and thousand separators.
/// This keeps formatting logic in the presentation layer, following Clean Architecture.
extension BalanceSummaryFormatting on BalanceSummary {
  /// Get formatted total journal with currency symbol and thousand separators
  String get formattedTotalJournal =>
      NumberFormatter.formatCurrencyDecimal(totalJournal, currencySymbol);

  /// Get formatted total real with currency symbol and thousand separators
  String get formattedTotalReal =>
      NumberFormatter.formatCurrencyDecimal(totalReal, currencySymbol);

  /// Get formatted difference with sign and currency symbol
  String get formattedDifference {
    final sign = difference > 0 ? '+' : '';
    return '$sign${NumberFormatter.formatCurrencyDecimal(difference.abs(), currencySymbol)}';
  }
}
