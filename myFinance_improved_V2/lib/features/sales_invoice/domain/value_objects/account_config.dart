import '../../../../core/constants/account_ids.dart';

/// Account configuration for sales journal entries
///
/// DEPRECATED: Use AccountIds directly instead.
/// This class is kept for backward compatibility.
/// @see [AccountIds] for centralized account ID constants.
class AccountConfig {
  AccountConfig._();

  /// Cash account ID for debit entries (Asset account)
  /// Increases when cash is received from sales
  static String get cashAccountId => AccountIds.cash;

  /// Sales revenue account ID for credit entries (Revenue account)
  /// Increases when sales are made
  static String get salesRevenueAccountId => AccountIds.salesRevenue;

  /// COGS (Cost of Goods Sold) account ID for debit entries (Expense account)
  /// Increases when goods are sold (records the cost of inventory sold)
  static String get cogsAccountId => AccountIds.cogs;

  /// Inventory account ID for credit entries (Asset account)
  /// Decreases when goods are sold (reduces inventory on hand)
  static String get inventoryAccountId => AccountIds.inventory;
}
