// Repository Interface: JournalEntryRepository
// Defines the contract for journal entry data operations

import '../entities/journal_entry.dart';

abstract class JournalEntryRepository {
  /// Fetch all accounts
  Future<List<Map<String, dynamic>>> getAccounts();

  /// Fetch counterparties for a company
  Future<List<Map<String, dynamic>>> getCounterparties(String companyId);

  /// Fetch stores for a linked company (counterparty)
  Future<List<Map<String, dynamic>>> getCounterpartyStores(String linkedCompanyId);

  /// Fetch cash locations for a company
  Future<List<Map<String, dynamic>>> getCashLocations({
    required String companyId,
    String? storeId,
  });

  /// Check account mapping for internal transactions
  Future<Map<String, dynamic>?> checkAccountMapping({
    required String companyId,
    required String counterpartyId,
    required String accountId,
  });

  /// Fetch exchange rates for a company
  Future<Map<String, dynamic>> getExchangeRates(String companyId);

  /// Submit journal entry
  Future<void> submitJournalEntry({
    required JournalEntry journalEntry,
    required String userId,
    required String companyId,
    String? storeId,
  });
}
