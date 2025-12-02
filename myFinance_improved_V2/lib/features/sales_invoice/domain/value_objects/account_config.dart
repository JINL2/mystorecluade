/// Account configuration for sales journal entries
///
/// Contains business rules for account IDs used in sales transactions.
/// These IDs represent the chart of accounts structure.
class AccountConfig {
  AccountConfig._();

  /// Cash account ID for debit entries (Asset account)
  /// Increases when cash is received from sales
  static const String cashAccountId = 'd4a7a16e-45a1-47fe-992b-ff807c8673f0';

  /// Sales revenue account ID for credit entries (Revenue account)
  /// Increases when sales are made
  static const String salesRevenueAccountId = 'e45e7d41-7fda-43a1-ac55-9779f3e59697';
}
