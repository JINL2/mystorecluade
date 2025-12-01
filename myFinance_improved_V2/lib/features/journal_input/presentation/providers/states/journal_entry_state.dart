import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/journal_entry.dart';
import '../../../domain/entities/transaction_line.dart';

part 'journal_entry_state.freezed.dart';

/// Journal Entry Page State - UI state for journal input page
///
/// Manages the state of journal entry creation including:
/// - Transaction lines
/// - Loading states
/// - Error handling
/// - Form validation
@freezed
class JournalEntryState with _$JournalEntryState {
  const JournalEntryState._();

  const factory JournalEntryState({
    /// Current journal entry being edited
    JournalEntry? currentEntry,

    /// Transaction lines for the journal entry
    @Default([]) List<TransactionLine> transactionLines,

    /// Whether the page is currently loading data
    @Default(false) bool isLoading,

    /// Whether currently submitting the journal entry
    @Default(false) bool isSubmitting,

    /// Error message if any error occurred
    String? errorMessage,

    /// Field-specific validation errors
    @Default({}) Map<String, String> fieldErrors,

    /// Entry date for the journal
    DateTime? entryDate,

    /// Overall description for the journal entry
    String? overallDescription,

    /// Selected company ID
    String? selectedCompanyId,

    /// Selected store ID
    String? selectedStoreId,

    /// Counterparty cash location ID
    String? counterpartyCashLocationId,
  }) = _JournalEntryState;

  /// Initial state factory
  factory JournalEntryState.initial() => JournalEntryState(
    entryDate: DateTime.now(),
  );

  // Calculated values (delegated from transactionLines)
  double get totalDebits => transactionLines
      .where((line) => line.isDebit)
      .fold(0.0, (sum, line) => sum + line.amount);

  double get totalCredits => transactionLines
      .where((line) => !line.isDebit)
      .fold(0.0, (sum, line) => sum + line.amount);

  double get difference => totalDebits - totalCredits;

  bool get isBalanced => difference.abs() < 0.01; // Allow for small rounding differences

  int get debitCount => transactionLines.where((line) => line.isDebit).length;

  int get creditCount => transactionLines.where((line) => !line.isDebit).length;

  bool canSubmit() {
    return transactionLines.isNotEmpty &&
           isBalanced &&
           selectedCompanyId != null &&
           selectedCompanyId!.isNotEmpty;
  }

  // =============================================================================
  // Business Logic Methods (Delegated to Domain Entity methods)
  // =============================================================================

  /// Calculate suggested amount to balance the journal entry
  double? getSuggestedAmountForBalance() {
    final diff = difference;
    return diff.abs() > 0.01 ? diff.abs() : null;
  }

  /// Suggest whether the next transaction should be debit or credit
  bool suggestDebitOrCredit() {
    if (totalDebits < totalCredits) return true;
    if (totalCredits < totalDebits) return false;
    return true;
  }

  /// Get all cash location IDs already used in transaction lines
  Set<String> getUsedCashLocationIds() {
    return transactionLines
        .where((line) => line.categoryTag == 'cash' && line.cashLocationId != null)
        .map((line) => line.cashLocationId!)
        .toSet();
  }
}

/// Transaction Line Creation State - UI state for adding/editing transaction lines
///
/// Tracks the state of transaction line creation dialog.
@freezed
class TransactionLineCreationState with _$TransactionLineCreationState {
  const factory TransactionLineCreationState({
    @Default(false) bool isCreating,
    @Default(false) bool isValidating,
    TransactionLine? editingLine,
    int? editingIndex,
    String? errorMessage,
    @Default({}) Map<String, String> fieldErrors,
  }) = _TransactionLineCreationState;

  /// Initial state factory
  factory TransactionLineCreationState.initial() => const TransactionLineCreationState();
}
