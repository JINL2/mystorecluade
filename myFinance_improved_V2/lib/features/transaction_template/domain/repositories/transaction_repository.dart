import 'package:image_picker/image_picker.dart';

import '../entities/template_attachment.dart';
import '../entities/transaction_entity.dart';

/// Parameters for creating transaction from template
class CreateFromTemplateParams {
  final Map<String, dynamic> template;
  final double amount;
  final String? description;
  final String companyId;
  final String userId;
  final String? storeId;
  final String? selectedMyCashLocationId;
  final String? selectedCounterpartyId;
  final String? selectedCounterpartyCashLocationId;
  final DateTime entryDate;

  const CreateFromTemplateParams({
    required this.template,
    required this.amount,
    this.description,
    required this.companyId,
    required this.userId,
    this.storeId,
    this.selectedMyCashLocationId,
    this.selectedCounterpartyId,
    this.selectedCounterpartyCashLocationId,
    required this.entryDate,
  });
}

/// Repository interface for transaction creation operations
///
/// Purpose: Handles transaction creation from templates
/// - Creates transactions using insert_journal_with_everything RPC
/// - Checks template usage for deletion safety
/// - Manages attachments for transactions created from templates
///
/// 🎯 FOCUSED: Only template-to-transaction creation, no CRUD operations
abstract class TransactionRepository {
  /// Creates a new transaction from template
  ///
  /// Uses insert_journal_with_everything RPC with journal lines structure
  Future<void> save(Transaction transaction);

  /// ✅ Creates transaction directly from template data
  /// Returns the created journal ID for attachment uploads
  ///
  /// This method handles the full template-to-RPC conversion in the data layer
  /// following Clean Architecture: Use Case provides business logic,
  /// Repository handles data persistence details
  Future<String> saveFromTemplate(CreateFromTemplateParams params);

  /// Checks if any transactions were created using a specific template
  ///
  /// Used by DeleteTemplateUseCase to prevent deletion of templates in use
  Future<List<Transaction>> findByTemplateId(String templateId);

  /// Finds a transaction by its unique ID
  ///
  /// Used for transaction lookup and validation operations
  Future<Transaction?> findById(String transactionId);

  // =============================================================================
  // Attachment Operations
  // =============================================================================

  /// Upload attachments to storage and save to database
  /// Returns list of uploaded attachments with file URLs
  Future<List<TemplateAttachment>> uploadAttachments({
    required String companyId,
    required String journalId,
    required String uploadedBy,
    required List<XFile> files,
  });

  /// Get all attachments for a journal entry
  Future<List<TemplateAttachment>> getJournalAttachments(String journalId);

  /// Delete an attachment from storage and database
  Future<void> deleteAttachment({
    required String attachmentId,
    required String fileUrl,
  });
}