/// Sales Journal Repository Interface
///
/// Defines the contract for creating journal entries related to sales transactions.
/// This is a simplified interface for sales-specific journal entries.
abstract class SalesJournalRepository {
  /// Create a sales journal entry for cash sales transaction
  ///
  /// Creates a double-entry journal with 4 lines:
  /// 1. Debit: Cash account (increase cash)
  /// 2. Credit: Sales revenue account (increase revenue)
  /// 3. Debit: COGS account (increase expense - cost of goods sold)
  /// 4. Credit: Inventory account (decrease asset - inventory reduced)
  ///
  /// Parameters:
  /// - [cashAccountId]: Account ID for cash (from Domain configuration)
  /// - [salesAccountId]: Account ID for sales revenue (from Domain configuration)
  /// - [cogsAccountId]: Account ID for COGS (from Domain configuration)
  /// - [inventoryAccountId]: Account ID for inventory (from Domain configuration)
  /// - [totalCost]: Total cost of goods sold (for COGS/Inventory entries)
  Future<void> createSalesJournalEntry({
    required String companyId,
    required String storeId,
    required String userId,
    required double amount,
    required String description,
    required String lineDescription,
    required String cashLocationId,
    required String cashAccountId,
    required String salesAccountId,
    required String cogsAccountId,
    required String inventoryAccountId,
    required double totalCost,
    required String invoiceId,
  });
}
