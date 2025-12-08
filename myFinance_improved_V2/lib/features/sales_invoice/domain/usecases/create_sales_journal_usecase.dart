import '../repositories/sales_journal_repository.dart';
import '../value_objects/account_config.dart';

/// Use case for creating sales journal entry
///
/// Orchestrates journal entry creation with business rules.
class CreateSalesJournalUseCase {
  final SalesJournalRepository _repository;

  const CreateSalesJournalUseCase({
    required SalesJournalRepository repository,
  }) : _repository = repository;

  /// Execute the use case
  ///
  /// Creates a journal entry for cash sales with COGS:
  /// - Debit: Cash account (increase asset)
  /// - Credit: Sales revenue account (increase revenue)
  /// - Debit: COGS account (increase expense)
  /// - Credit: Inventory account (decrease asset)
  ///
  /// Parameters:
  /// - [companyId]: Company ID
  /// - [storeId]: Store ID
  /// - [userId]: User ID creating the entry
  /// - [amount]: Transaction amount (sales amount)
  /// - [description]: Journal description
  /// - [lineDescription]: Line item description
  /// - [cashLocationId]: Cash location ID
  /// - [totalCost]: Total cost of goods sold
  ///
  /// Returns: Future that completes when journal is created
  Future<void> execute({
    required String companyId,
    required String storeId,
    required String userId,
    required double amount,
    required String description,
    required String lineDescription,
    required String cashLocationId,
    required double totalCost,
  }) async {
    // Validate input parameters
    if (companyId.isEmpty) {
      throw ArgumentError('Company ID cannot be empty');
    }

    if (storeId.isEmpty) {
      throw ArgumentError('Store ID cannot be empty');
    }

    if (userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }

    if (amount <= 0) {
      throw ArgumentError('Amount must be greater than 0');
    }

    if (cashLocationId.isEmpty) {
      throw ArgumentError('Cash location ID cannot be empty');
    }

    // Create journal entry with configured account IDs
    await _repository.createSalesJournalEntry(
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      amount: amount,
      description: description,
      lineDescription: lineDescription,
      cashLocationId: cashLocationId,
      cashAccountId: AccountConfig.cashAccountId,
      salesAccountId: AccountConfig.salesRevenueAccountId,
      cogsAccountId: AccountConfig.cogsAccountId,
      inventoryAccountId: AccountConfig.inventoryAccountId,
      totalCost: totalCost,
    );
  }
}
