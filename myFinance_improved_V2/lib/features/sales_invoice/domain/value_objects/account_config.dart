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

  /// COGS (Cost of Goods Sold) account ID for debit entries (Expense account)
  /// Increases when goods are sold (records the cost of inventory sold)
  static const String cogsAccountId = '90565fe4-5bfc-4c5e-8759-af9a64e98cae';

  /// Inventory account ID for credit entries (Asset account)
  /// Decreases when goods are sold (reduces inventory on hand)
  static const String inventoryAccountId = '8babc1b3-47b4-4982-8f50-099ab9cdcaf9';
}
