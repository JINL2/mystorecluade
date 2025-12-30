// Repository Interface: JournalEntryRepository
// Defines the contract for journal entry data operations

import 'package:image_picker/image_picker.dart';
import '../entities/journal_attachment.dart';
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
  /// Uses get_exchange_rate_v3 which supports store-based currency sorting
  Future<Map<String, dynamic>> getExchangeRates(
    String companyId, {
    String? storeId,
  });

  /// Submit journal entry and return the created journal ID
  Future<String> submitJournalEntry({
    required JournalEntry journalEntry,
    required String userId,
    required String companyId,
    String? storeId,
  });

  // =============================================================================
  // Attachment Operations
  // =============================================================================

  /// Upload attachments to storage and save to database
  /// Returns list of uploaded attachments with file URLs
  Future<List<JournalAttachment>> uploadAttachments({
    required String companyId,
    required String journalId,
    required String uploadedBy,
    required List<XFile> files,
  });

  /// Get all attachments for a journal entry
  Future<List<JournalAttachment>> getJournalAttachments(String journalId);

  /// Delete an attachment from storage and database
  Future<void> deleteAttachment({
    required String attachmentId,
    required String fileUrl,
  });
}
