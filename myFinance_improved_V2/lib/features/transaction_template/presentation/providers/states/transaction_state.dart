import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/template_attachment.dart';
import '../../../domain/entities/transaction_entity.dart';

part 'transaction_state.freezed.dart';

/// Transaction Creation State - UI state for transaction creation
///
/// Tracks transaction creation from template with amount,
/// note, attachments, and other required fields.
@freezed
class TransactionCreationState with _$TransactionCreationState {
  const TransactionCreationState._();

  const factory TransactionCreationState({
    @Default(false) bool isCreating,
    @Default(false) bool isValidating,
    @Default(false) bool isUploadingAttachments,
    Transaction? createdTransaction,
    String? errorMessage,
    @Default({}) Map<String, String> fieldErrors,

    // Form fields
    String? selectedTemplateId,
    double? amount,
    String? note,
    String? cashLocationId,
    String? counterpartyId,

    /// Pending attachments to be uploaded (local files)
    @Default([]) @JsonKey(includeFromJson: false, includeToJson: false)
    List<TemplateAttachment> pendingAttachments,
  }) = _TransactionCreationState;

  /// Factory for initial state
  factory TransactionCreationState.initial() => const TransactionCreationState();

  // =============================================================================
  // Attachment Helpers
  // =============================================================================

  /// Number of pending attachments
  int get attachmentCount => pendingAttachments.length;

  /// Check if there are any attachments
  bool get hasAttachments => pendingAttachments.isNotEmpty;

  /// Check if any attachment exceeds size limit (5MB)
  bool get hasOversizedAttachment =>
      pendingAttachments.any((a) => a.exceedsSizeLimit);

  /// Total size of all attachments in bytes
  int get totalAttachmentSizeBytes =>
      pendingAttachments.fold(0, (sum, a) => sum + a.fileSizeBytes);

  /// Total size in MB for display
  double get totalAttachmentSizeMB => totalAttachmentSizeBytes / (1024 * 1024);

  /// Check if more attachments can be added
  bool get canAddMoreAttachments =>
      pendingAttachments.length < TemplateAttachment.maxAttachments;
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
