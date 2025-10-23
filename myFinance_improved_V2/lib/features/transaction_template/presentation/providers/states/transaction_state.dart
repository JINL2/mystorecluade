import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/transaction_entity.dart';

part 'transaction_state.freezed.dart';

/// Transaction Creation State - UI state for transaction creation
///
/// Tracks transaction creation from template with amount,
/// note, and other required fields.
@freezed
class TransactionCreationState with _$TransactionCreationState {
  const factory TransactionCreationState({
    @Default(false) bool isCreating,
    @Default(false) bool isValidating,
    Transaction? createdTransaction,
    String? errorMessage,
    @Default({}) Map<String, String> fieldErrors,

    // Form fields
    String? selectedTemplateId,
    double? amount,
    String? note,
    String? cashLocationId,
    String? counterpartyId,
  }) = _TransactionCreationState;
}

/// Transaction List State - UI state for transaction list
///
/// Simple state for displaying transactions with basic filtering.
@freezed
class TransactionListState with _$TransactionListState {
  const factory TransactionListState({
    @Default([]) List<Transaction> transactions,
    @Default(false) bool isLoading,
    String? errorMessage,
    String? selectedTemplateId,
    @Default('all') String statusFilter, // all, pending, completed
  }) = _TransactionListState;
}

/// Transaction Operations State - UI state for transaction operations
///
/// Tracks operations like complete, update, delete on existing transactions.
@freezed
class TransactionOperationState with _$TransactionOperationState {
  const TransactionOperationState._(); // Private constructor for getters

  const factory TransactionOperationState({
    @Default(false) bool isDeleting,
    String? errorMessage,
    String? successMessage,
  }) = _TransactionOperationState;
}
