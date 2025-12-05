// Presentation Providers
// Riverpod providers for UI state management
//
// Clean Architecture Compliance:
// ✅ Only imports from Domain layer (entities, repositories interface)
// ✅ No direct imports from Data layer
// ✅ Repository implementation is provided via dependency injection

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/journal_attachment.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/providers/repository_providers.dart';
import 'journal_entry_notifier.dart';
import 'states/journal_entry_state.dart';

// =============================================================================
// State Management Providers
// =============================================================================

/// Journal Entry State Provider
final journalEntryStateProvider = StateNotifierProvider<JournalEntryNotifier, JournalEntryState>((ref) {
  return JournalEntryNotifier();
});

/// Transaction Line Creation State Provider
final transactionLineCreationStateProvider =
    StateNotifierProvider<TransactionLineCreationNotifier, TransactionLineCreationState>((ref) {
  return TransactionLineCreationNotifier();
});

// =============================================================================
// Computed Value Providers
// =============================================================================

/// Total debits provider
final totalDebitsProvider = Provider<double>((ref) {
  final state = ref.watch(journalEntryStateProvider);
  return state.totalDebits;
});

/// Total credits provider
final totalCreditsProvider = Provider<double>((ref) {
  final state = ref.watch(journalEntryStateProvider);
  return state.totalCredits;
});

/// Difference provider
final differenceProvider = Provider<double>((ref) {
  final state = ref.watch(journalEntryStateProvider);
  return state.difference;
});

/// Is balanced provider
final isBalancedProvider = Provider<bool>((ref) {
  final state = ref.watch(journalEntryStateProvider);
  return state.isBalanced;
});

/// Can submit provider
final canSubmitProvider = Provider<bool>((ref) {
  final state = ref.watch(journalEntryStateProvider);
  return state.canSubmit();
});

// =============================================================================
// Data Fetch Providers
// =============================================================================

/// Fetch accounts
final journalAccountsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(journalEntryRepositoryProvider);
  return await repository.getAccounts();
});

/// Fetch counterparties (family provider for company-specific data)
final journalCounterpartiesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, companyId) async {
    if (companyId.isEmpty) return [];
    final repository = ref.watch(journalEntryRepositoryProvider);
    return await repository.getCounterparties(companyId);
  },
);

/// Fetch counterparty stores
final journalCounterpartyStoresProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>(
  (ref, linkedCompanyId) async {
    if (linkedCompanyId == null || linkedCompanyId.isEmpty) return [];
    final repository = ref.watch(journalEntryRepositoryProvider);
    return await repository.getCounterpartyStores(linkedCompanyId);
  },
);

/// Fetch cash locations
final journalCashLocationsProvider = FutureProvider.family<List<Map<String, dynamic>>, ({String companyId, String? storeId})>(
  (ref, params) async {
    if (params.companyId.isEmpty) return [];
    final repository = ref.watch(journalEntryRepositoryProvider);
    return await repository.getCashLocations(
      companyId: params.companyId,
      storeId: params.storeId,
    );
  },
);

/// Check account mapping
final checkAccountMappingProvider = Provider<Future<Map<String, dynamic>?> Function(String, String, String)>(
  (ref) {
    return (String companyId, String counterpartyId, String accountId) async {
      final repository = ref.read(journalEntryRepositoryProvider);
      return await repository.checkAccountMapping(
        companyId: companyId,
        counterpartyId: counterpartyId,
        accountId: accountId,
      );
    };
  },
);

/// Fetch exchange rates
final exchangeRatesProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, companyId) async {
    if (companyId.isEmpty) {
      throw Exception('Company ID is required');
    }
    final repository = ref.watch(journalEntryRepositoryProvider);
    return await repository.getExchangeRates(companyId);
  },
);

// =============================================================================
// Action Providers
// =============================================================================

/// Submit journal entry and upload attachments
/// Returns the created journal ID
final submitJournalEntryProvider = Provider<Future<String> Function(JournalEntry, String, String, String?)>(
  (ref) {
    return (JournalEntry journalEntry, String userId, String companyId, String? storeId) async {
      if (!journalEntry.canSubmit()) {
        throw Exception('Journal entry is not balanced or incomplete');
      }

      final repository = ref.read(journalEntryRepositoryProvider);

      // Step 1: Create journal entry and get journal_id
      final journalId = await repository.submitJournalEntry(
        journalEntry: journalEntry,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
      );

      // Step 2: Upload attachments if any
      final pendingFiles = journalEntry.pendingAttachments
          .where((a) => a.localFile != null)
          .map((a) => a.localFile!)
          .toList();

      if (pendingFiles.isNotEmpty) {
        await repository.uploadAttachments(
          companyId: companyId,
          journalId: journalId,
          uploadedBy: userId,
          files: pendingFiles,
        );
      }

      return journalId;
    };
  },
);

/// Upload attachments to an existing journal
final uploadAttachmentsProvider = Provider<Future<List<JournalAttachment>> Function(String, String, String, List<XFile>)>(
  (ref) {
    return (String companyId, String journalId, String uploadedBy, List<XFile> files) async {
      final repository = ref.read(journalEntryRepositoryProvider);
      return await repository.uploadAttachments(
        companyId: companyId,
        journalId: journalId,
        uploadedBy: uploadedBy,
        files: files,
      );
    };
  },
);

/// Get journal attachments
final journalAttachmentsProvider = FutureProvider.family<List<JournalAttachment>, String>(
  (ref, journalId) async {
    if (journalId.isEmpty) return [];
    final repository = ref.watch(journalEntryRepositoryProvider);
    return await repository.getJournalAttachments(journalId);
  },
);

/// Delete an attachment
final deleteAttachmentProvider = Provider<Future<void> Function(String, String)>(
  (ref) {
    return (String attachmentId, String fileUrl) async {
      final repository = ref.read(journalEntryRepositoryProvider);
      await repository.deleteAttachment(
        attachmentId: attachmentId,
        fileUrl: fileUrl,
      );
    };
  },
);
