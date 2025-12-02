/// Sales Journal Repository Interface
///
/// Defines the contract for creating journal entries related to sales transactions.
/// This is a simplified interface for sales-specific journal entries.
abstract class SalesJournalRepository {
  /// Create a sales journal entry for cash sales transaction
  ///
  /// Creates a double-entry journal:
  /// - Debit: Cash account (increase cash)
  /// - Credit: Sales revenue account (increase revenue)
  ///
  /// Parameters:
  /// - [cashAccountId]: Account ID for cash (from Domain configuration)
  /// - [salesAccountId]: Account ID for sales revenue (from Domain configuration)
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
  });
}
