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
///
/// 🎯 FOCUSED: Only template-to-transaction creation, no CRUD operations
abstract class TransactionRepository {
  /// Creates a new transaction from template
  ///
  /// Uses insert_journal_with_everything RPC with journal lines structure
  Future<void> save(Transaction transaction);

  /// ✅ Creates transaction directly from template data
  ///
  /// This method handles the full template-to-RPC conversion in the data layer
  /// following Clean Architecture: Use Case provides business logic,
  /// Repository handles data persistence details
  Future<void> saveFromTemplate(CreateFromTemplateParams params);

  /// Checks if any transactions were created using a specific template
  ///
  /// Used by DeleteTemplateUseCase to prevent deletion of templates in use
  Future<List<Transaction>> findByTemplateId(String templateId);

  /// Finds a transaction by its unique ID
  ///
  /// Used for transaction lookup and validation operations
  Future<Transaction?> findById(String transactionId);
}