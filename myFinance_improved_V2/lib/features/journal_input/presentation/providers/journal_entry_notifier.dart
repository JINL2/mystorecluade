import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/transaction_line.dart';
import 'states/journal_entry_state.dart';

/// Journal Entry State Notifier
///
/// Manages the state of journal entry creation including:
/// - Transaction lines management
/// - Form validation
/// - Submission state
class JournalEntryNotifier extends StateNotifier<JournalEntryState> {
  JournalEntryNotifier() : super(JournalEntryState.initial());

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
      entryDate: state.entryDate ?? DateTime.now(),
      overallDescription: state.overallDescription,
      selectedCompanyId: state.selectedCompanyId,
      selectedStoreId: state.selectedStoreId,
      counterpartyCashLocationId: state.counterpartyCashLocationId,
    );
  }
}

/// Transaction Line Creation Notifier
///
/// Manages the state of transaction line creation dialog.
class TransactionLineCreationNotifier extends StateNotifier<TransactionLineCreationState> {
  TransactionLineCreationNotifier() : super(TransactionLineCreationState.initial());

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
