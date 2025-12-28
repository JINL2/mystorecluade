// lib/features/cash_ending/presentation/pages/cash_ending_completion/auto_balance_type.dart

/// Type of auto-balance adjustment
enum AutoBalanceType {
  /// Error adjustment - for counting errors or discrepancies
  error,

  /// Foreign currency translation - for exchange rate differences
  foreignCurrency,
}
