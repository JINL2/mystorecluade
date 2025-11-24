/// Repository interface for journal entry operations
/// This defines the contract for inserting journal entries
/// Implementation will be in the data layer
abstract class JournalRepository {
  /// Insert journal entry with all details including lines
  ///
  /// This method creates a complete journal entry with:
  /// - Header information (amount, company, description, date)
  /// - Journal lines (debit/credit entries for different accounts)
  /// - Optional relationships (counterparty, cash location, store)
  ///
  /// Returns the created journal entry data from the database
  Future<Map<String, dynamic>> insertJournalWithEverything({
    required double baseAmount,
    required String companyId,
    required String createdBy,
    required String description,
    required String entryDate,
    required List<Map<String, dynamic>> lines,
    String? counterpartyId,
    String? ifCashLocationId,
    String? storeId,
  });
}
