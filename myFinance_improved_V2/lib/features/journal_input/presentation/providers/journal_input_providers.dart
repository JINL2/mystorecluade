// lib/features/journal_input/presentation/providers/journal_input_providers.dart
//
// Presentation Providers for journal_input feature
// All providers migrated to @riverpod for Clean Architecture 2025
//
// Clean Architecture Compliance:
// ✅ Only imports from Domain layer (entities, repositories interface)
// ✅ No direct imports from Data layer
// ✅ Repository implementation is provided via centralized DI

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/journal_attachment.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/transaction_line.dart';
import 'states/journal_entry_state.dart';

// Import centralized DI providers
import '../../di/journal_input_providers.dart';

// Re-export DI providers for convenience
export '../../di/journal_input_providers.dart';

part 'journal_input_providers.g.dart';

// =============================================================================
// State Management Providers (@riverpod Notifier)
// =============================================================================

/// Journal Entry State Notifier - manages journal entry creation state
@riverpod
class JournalEntryNotifier extends _$JournalEntryNotifier {
  @override
  JournalEntryState build() => JournalEntryState.initial();

  /// Add a transaction line to the journal entry
  void addTransactionLine(TransactionLine line) {
    state = state.copyWith(
      transactionLines: [...state.transactionLines, line],
    );
  }

  /// Remove a transaction line at the specified index
  void removeTransactionLine(int index) {
    if (index >= 0 && index < state.transactionLines.length) {
      final newLines = List<TransactionLine>.from(state.transactionLines);
      newLines.removeAt(index);
      state = state.copyWith(transactionLines: newLines);
    }
  }

  /// Update a transaction line at the specified index
  void updateTransactionLine(int index, TransactionLine line) {
    if (index >= 0 && index < state.transactionLines.length) {
      final newLines = List<TransactionLine>.from(state.transactionLines);
      newLines[index] = line;
      state = state.copyWith(transactionLines: newLines);
    }
  }

  /// Set the entry date
  void setEntryDate(DateTime date) {
    state = state.copyWith(entryDate: date);
  }

  /// Set the overall description
  void setOverallDescription(String? description) {
    state = state.copyWith(overallDescription: description);
  }

  /// Set the selected company
  void setSelectedCompany(String? companyId) {
    state = state.copyWith(selectedCompanyId: companyId);
  }

  /// Set the selected store
  void setSelectedStore(String? storeId) {
    state = state.copyWith(selectedStoreId: storeId);
  }

  /// Set counterparty cash location
  void setCounterpartyCashLocation(String? cashLocationId) {
    state = state.copyWith(counterpartyCashLocationId: cashLocationId);
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Set submitting state
  void setSubmitting(bool isSubmitting) {
    state = state.copyWith(isSubmitting: isSubmitting);
  }

  /// Set error message
  void setError(String? errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  /// Set field error
  void setFieldError(String field, String error) {
    final newErrors = Map<String, String>.from(state.fieldErrors);
    newErrors[field] = error;
    state = state.copyWith(fieldErrors: newErrors);
  }

  /// Clear field error
  void clearFieldError(String field) {
    final newErrors = Map<String, String>.from(state.fieldErrors);
    newErrors.remove(field);
    state = state.copyWith(fieldErrors: newErrors);
  }

  /// Clear all errors
  void clearErrors() {
    state = state.copyWith(
      errorMessage: null,
      fieldErrors: {},
    );
  }

  /// Clear the journal entry (reset to initial state but keep company/store)
  void clear() {
    state = JournalEntryState.initial().copyWith(
      selectedCompanyId: state.selectedCompanyId,
      selectedStoreId: state.selectedStoreId,
    );
  }

  /// Reset state to initial
  void reset() {
    state = JournalEntryState.initial();
  }

  /// Get current journal entry as entity
  JournalEntry getCurrentJournalEntry() {
    return JournalEntry(
      transactionLines: state.transactionLines,
      attachments: state.pendingAttachments,
      entryDate: state.entryDate ?? DateTime.now(),
      overallDescription: state.overallDescription,
      selectedCompanyId: state.selectedCompanyId,
      selectedStoreId: state.selectedStoreId,
      counterpartyCashLocationId: state.counterpartyCashLocationId,
    );
  }

  // =============================================================================
  // Attachment Management
  // =============================================================================

  /// Add an attachment to the pending list
  void addAttachment(JournalAttachment attachment) {
    if (state.pendingAttachments.length >= JournalEntryState.maxAttachments) {
      setError('Maximum ${JournalEntryState.maxAttachments} attachments allowed');
      return;
    }

    if (attachment.exceedsSizeLimit) {
      setError('File ${attachment.fileName} exceeds 5MB limit');
      return;
    }

    state = state.copyWith(
      pendingAttachments: [...state.pendingAttachments, attachment],
    );
  }

  /// Add multiple attachments
  void addAttachments(List<JournalAttachment> attachments) {
    final availableSlots = JournalEntryState.maxAttachments - state.pendingAttachments.length;
    final validAttachments = attachments
        .where((a) => !a.exceedsSizeLimit)
        .take(availableSlots)
        .toList();

    if (validAttachments.isEmpty) return;

    state = state.copyWith(
      pendingAttachments: [...state.pendingAttachments, ...validAttachments],
    );

    // Notify if some attachments were skipped
    final skippedCount = attachments.length - validAttachments.length;
    if (skippedCount > 0) {
      setError('$skippedCount file(s) skipped (too large or limit reached)');
    }
  }

  /// Remove an attachment at the specified index
  void removeAttachment(int index) {
    if (index >= 0 && index < state.pendingAttachments.length) {
      final newAttachments = List<JournalAttachment>.from(state.pendingAttachments);
      newAttachments.removeAt(index);
      state = state.copyWith(pendingAttachments: newAttachments);
    }
  }

  /// Clear all attachments
  void clearAttachments() {
    state = state.copyWith(pendingAttachments: []);
  }

  /// Set uploading attachments state
  void setUploadingAttachments(bool isUploading) {
    state = state.copyWith(isUploadingAttachments: isUploading);
  }

  /// Get list of XFile from pending attachments (for upload)
  List<dynamic> getPendingFiles() {
    return state.pendingAttachments
        .where((a) => a.localFile != null)
        .map((a) => a.localFile!)
        .toList();
  }
}

/// Transaction Line Creation State Notifier
@riverpod
class TransactionLineCreationNotifier extends _$TransactionLineCreationNotifier {
  @override
  TransactionLineCreationState build() => TransactionLineCreationState.initial();

  /// Start creating a new transaction line
  void startCreating() {
    state = TransactionLineCreationState.initial();
  }

  /// Start editing an existing transaction line
  void startEditing(TransactionLine line, int index) {
    state = TransactionLineCreationState.initial().copyWith(
      editingLine: line,
      editingIndex: index,
    );
  }

  /// Set creating state
  void setCreating(bool isCreating) {
    state = state.copyWith(isCreating: isCreating);
  }

  /// Set validating state
  void setValidating(bool isValidating) {
    state = state.copyWith(isValidating: isValidating);
  }

  /// Set error message
  void setError(String? errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  /// Set field error
  void setFieldError(String field, String error) {
    final newErrors = Map<String, String>.from(state.fieldErrors);
    newErrors[field] = error;
    state = state.copyWith(fieldErrors: newErrors);
  }

  /// Clear field error
  void clearFieldError(String field) {
    final newErrors = Map<String, String>.from(state.fieldErrors);
    newErrors.remove(field);
    state = state.copyWith(fieldErrors: newErrors);
  }

  /// Clear all errors
  void clearErrors() {
    state = state.copyWith(
      errorMessage: null,
      fieldErrors: {},
    );
  }

  /// Reset state
  void reset() {
    state = TransactionLineCreationState.initial();
  }
}

// =============================================================================
// Computed Value Providers (@riverpod)
// =============================================================================

/// Total debits provider
@riverpod
double totalDebits(Ref ref) {
  final state = ref.watch(journalEntryNotifierProvider);
  return state.totalDebits;
}

/// Total credits provider
@riverpod
double totalCredits(Ref ref) {
  final state = ref.watch(journalEntryNotifierProvider);
  return state.totalCredits;
}

/// Difference provider
@riverpod
double difference(Ref ref) {
  final state = ref.watch(journalEntryNotifierProvider);
  return state.difference;
}

/// Is balanced provider
@riverpod
bool isBalanced(Ref ref) {
  final state = ref.watch(journalEntryNotifierProvider);
  return state.isBalanced;
}

/// Can submit provider
@riverpod
bool canSubmit(Ref ref) {
  final state = ref.watch(journalEntryNotifierProvider);
  return state.canSubmit();
}

// =============================================================================
// Data Fetch Providers (@riverpod)
// =============================================================================

/// Fetch accounts
@riverpod
Future<List<Map<String, dynamic>>> journalAccounts(Ref ref) async {
  final repository = ref.watch(journalEntryRepositoryProvider);
  return await repository.getAccounts();
}

/// Fetch counterparties (family provider for company-specific data)
@riverpod
Future<List<Map<String, dynamic>>> journalCounterparties(
  Ref ref,
  String companyId,
) async {
  if (companyId.isEmpty) return [];
  final repository = ref.watch(journalEntryRepositoryProvider);
  return await repository.getCounterparties(companyId);
}

/// Fetch counterparty stores
@riverpod
Future<List<Map<String, dynamic>>> journalCounterpartyStores(
  Ref ref,
  String? linkedCompanyId,
) async {
  if (linkedCompanyId == null || linkedCompanyId.isEmpty) return [];
  final repository = ref.watch(journalEntryRepositoryProvider);
  return await repository.getCounterpartyStores(linkedCompanyId);
}

/// Params for cash locations query
class CashLocationsParams {
  final String companyId;
  final String? storeId;

  const CashLocationsParams({
    required this.companyId,
    this.storeId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashLocationsParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId;

  @override
  int get hashCode => companyId.hashCode ^ (storeId?.hashCode ?? 0);
}

/// Fetch cash locations
@riverpod
Future<List<Map<String, dynamic>>> journalCashLocations(
  Ref ref,
  CashLocationsParams params,
) async {
  if (params.companyId.isEmpty) return [];
  final repository = ref.watch(journalEntryRepositoryProvider);
  return await repository.getCashLocations(
    companyId: params.companyId,
    storeId: params.storeId,
  );
}

/// Params for exchange rates query
class ExchangeRatesParams {
  final String companyId;
  final String? storeId;

  const ExchangeRatesParams({
    required this.companyId,
    this.storeId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExchangeRatesParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId;

  @override
  int get hashCode => companyId.hashCode ^ (storeId?.hashCode ?? 0);
}

/// Fetch exchange rates
/// Uses get_exchange_rate_v3 which supports store-based currency sorting
@riverpod
Future<Map<String, dynamic>> exchangeRates(
  Ref ref,
  ExchangeRatesParams params,
) async {
  if (params.companyId.isEmpty) {
    throw Exception('Company ID is required');
  }
  final repository = ref.watch(journalEntryRepositoryProvider);
  return await repository.getExchangeRates(
    params.companyId,
    storeId: params.storeId,
  );
}

/// Get journal attachments
@riverpod
Future<List<JournalAttachment>> journalAttachments(
  Ref ref,
  String journalId,
) async {
  if (journalId.isEmpty) return [];
  final repository = ref.watch(journalEntryRepositoryProvider);
  return await repository.getJournalAttachments(journalId);
}

// =============================================================================
// Action Notifier (@riverpod) - Handles submit, upload, delete operations
// =============================================================================

/// Journal Actions Notifier for mutations
@riverpod
class JournalActionsNotifier extends _$JournalActionsNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Submit journal entry and upload attachments
  /// Returns the created journal ID
  Future<String> submitJournalEntry({
    required JournalEntry journalEntry,
    required String userId,
    required String companyId,
    String? storeId,
  }) async {
    state = const AsyncValue.loading();
    try {
      debugPrint('🔵 [5] submitJournalEntry called');
      debugPrint('   userId: $userId, companyId: $companyId, storeId: $storeId');
      debugPrint('   lines: ${journalEntry.transactionLines.length}');

      if (!journalEntry.canSubmit()) {
        debugPrint('🔴 [5.1] canSubmit() returned false');
        throw Exception('Journal entry is not balanced or incomplete');
      }
      debugPrint('🟢 [5.2] canSubmit() passed');

      final repository = ref.read(journalEntryRepositoryProvider);
      debugPrint('🔵 [6] Got repository, calling submitJournalEntry');

      // Step 1: Create journal entry and get journal_id
      final journalId = await repository.submitJournalEntry(
        journalEntry: journalEntry,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
      );
      debugPrint('🟢 [6.1] submitJournalEntry completed, journalId: $journalId');

      // Step 2: Upload attachments if any
      final pendingFiles = journalEntry.pendingAttachments
          .where((a) => a.localFile != null)
          .map((a) => a.localFile!)
          .toList();

      if (pendingFiles.isNotEmpty) {
        debugPrint('🔵 [7] Uploading ${pendingFiles.length} attachments');
        await repository.uploadAttachments(
          companyId: companyId,
          journalId: journalId,
          uploadedBy: userId,
          files: pendingFiles,
        );
      }

      state = const AsyncValue.data(null);
      return journalId;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Upload attachments to an existing journal
  Future<List<JournalAttachment>> uploadAttachments({
    required String companyId,
    required String journalId,
    required String uploadedBy,
    required List<XFile> files,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(journalEntryRepositoryProvider);
      final result = await repository.uploadAttachments(
        companyId: companyId,
        journalId: journalId,
        uploadedBy: uploadedBy,
        files: files,
      );

      // Invalidate attachments cache
      ref.invalidate(journalAttachmentsProvider(journalId));

      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Delete an attachment
  Future<void> deleteAttachment({
    required String attachmentId,
    required String fileUrl,
    String? journalId,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(journalEntryRepositoryProvider);
      await repository.deleteAttachment(
        attachmentId: attachmentId,
        fileUrl: fileUrl,
      );

      // Invalidate attachments cache if journalId provided
      if (journalId != null) {
        ref.invalidate(journalAttachmentsProvider(journalId));
      }

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Check account mapping
  Future<Map<String, dynamic>?> checkAccountMapping({
    required String companyId,
    required String counterpartyId,
    required String accountId,
  }) async {
    final repository = ref.read(journalEntryRepositoryProvider);
    return await repository.checkAccountMapping(
      companyId: companyId,
      counterpartyId: counterpartyId,
      accountId: accountId,
    );
  }
}
