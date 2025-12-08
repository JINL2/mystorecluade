// Repository Implementation: JournalEntryRepositoryImpl
// Implements the repository interface using the datasource

import 'package:image_picker/image_picker.dart';

import '../../domain/entities/journal_attachment.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_entry_repository.dart';
import '../datasources/journal_entry_datasource.dart';
import '../models/journal_entry_model.dart';

class JournalEntryRepositoryImpl implements JournalEntryRepository {
  final JournalEntryDataSource _dataSource;

  JournalEntryRepositoryImpl(this._dataSource);

  @override
  Future<List<Map<String, dynamic>>> getAccounts() async {
    return await _dataSource.getAccounts();
  }

  @override
  Future<List<Map<String, dynamic>>> getCounterparties(String companyId) async {
    return await _dataSource.getCounterparties(companyId);
  }

  @override
  Future<List<Map<String, dynamic>>> getCounterpartyStores(String linkedCompanyId) async {
    return await _dataSource.getCounterpartyStores(linkedCompanyId);
  }

  @override
  Future<List<Map<String, dynamic>>> getCashLocations({
    required String companyId,
    String? storeId,
  }) async {
    return await _dataSource.getCashLocations(
      companyId: companyId,
      storeId: storeId,
    );
  }

  @override
  Future<Map<String, dynamic>?> checkAccountMapping({
    required String companyId,
    required String counterpartyId,
    required String accountId,
  }) async {
    return await _dataSource.checkAccountMapping(
      companyId: companyId,
      counterpartyId: counterpartyId,
      accountId: accountId,
    );
  }

  @override
  Future<Map<String, dynamic>> getExchangeRates(String companyId) async {
    return await _dataSource.getExchangeRates(companyId);
  }

  @override
  Future<String> submitJournalEntry({
    required JournalEntry journalEntry,
    required String userId,
    required String companyId,
    String? storeId,
  }) async {
    // Convert domain entity to data model
    final journalEntryModel = JournalEntryModel.fromEntity(journalEntry);

    // Submit through datasource and return journal_id
    return await _dataSource.submitJournalEntry(
      journalEntry: journalEntryModel,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
    );
  }

  // =============================================================================
  // Attachment Operations
  // =============================================================================

  @override
  Future<List<JournalAttachment>> uploadAttachments({
    required String companyId,
    required String journalId,
    required String uploadedBy,
    required List<XFile> files,
  }) async {
    return await _dataSource.uploadAttachments(
      companyId: companyId,
      journalId: journalId,
      uploadedBy: uploadedBy,
      files: files,
    );
  }

  @override
  Future<List<JournalAttachment>> getJournalAttachments(String journalId) async {
    return await _dataSource.getJournalAttachments(journalId);
  }

  @override
  Future<void> deleteAttachment({
    required String attachmentId,
    required String fileUrl,
  }) async {
    return await _dataSource.deleteAttachment(
      attachmentId: attachmentId,
      fileUrl: fileUrl,
    );
  }
}
