import '../entities/cash_location.dart';
import '../entities/cash_transaction_enums.dart';
import '../entities/counterparty.dart';
import '../entities/expense_account.dart';

/// Repository interface for Cash Control operations (Domain Layer)
///
/// This is the contract that data layer must implement.
/// NO dependencies on infrastructure or external libraries.
abstract class CashTransactionRepository {
  // ==================== READ ====================

  /// Get expense accounts with user's recent usage ranking
  ///
  /// Uses RPC: get_user_quick_access_accounts
  Future<List<ExpenseAccount>> getExpenseAccounts({
    required String companyId,
    required String userId,
    int limit = 20,
  });

  /// Get all expense accounts for company (for search)
  ///
  /// Uses RPC: get_expense_accounts
  /// Returns only accounts with account_type = 'expense'
  Future<List<ExpenseAccount>> searchExpenseAccounts({
    required String companyId,
    String? query,
    int limit = 50,
  });

  /// Get only expense accounts (no user context, no search)
  ///
  /// Uses RPC: get_expense_accounts
  /// Returns accounts where account_type = 'expense' AND (is_default OR company_id matches)
  Future<List<ExpenseAccount>> getExpenseAccountsOnly({
    required String companyId,
    int limit = 50,
  });

  /// Get counterparties for company
  ///
  /// Queries: counterparties table
  Future<List<Counterparty>> getCounterparties({
    required String companyId,
    String? query,
    int limit = 50,
  });

  /// Get self-counterparty for a company
  /// This is the counterparty where company_id = linked_company_id
  /// Used for within-company transfers (same company, different stores)
  Future<Counterparty?> getSelfCounterparty({
    required String companyId,
  });

  /// Get cash locations for store
  ///
  /// Queries: cash_locations table
  Future<List<CashLocation>> getCashLocations({
    required String storeId,
  });

  /// Get cash locations for company (all stores)
  Future<List<CashLocation>> getCashLocationsForCompany({
    required String companyId,
  });

  // ==================== WRITE ====================

  /// Create expense entry
  ///
  /// Uses RPC: insert_journal_with_everything_utc
  /// Pay (isRefund=false): DR Expense Account, CR Cash Account
  /// Refund (isRefund=true): DR Cash Account, CR Expense Account
  Future<String> createExpenseEntry({
    required String companyId,
    required String? storeId,
    required String createdBy,
    required String cashLocationId,
    required String expenseAccountId,
    required double amount,
    required DateTime entryDate,
    required bool isRefund,
    String? memo,
    List<String>? attachmentUrls,
  });

  /// Create debt entry
  ///
  /// Uses RPC: insert_journal_with_everything_utc + create_debt_record
  /// Lend (receivable+): DR Receivable, CR Cash
  /// Collect (receivable-): DR Cash, CR Receivable
  /// Borrow (payable+): DR Cash, CR Payable
  /// Repay (payable-): DR Payable, CR Cash
  ///
  /// [debtCategory] determines which account to use:
  /// - account: Accounts Receivable/Payable (1100/2000)
  /// - note: Notes Receivable/Payable (1110/2010)
  Future<String> createDebtEntry({
    required String companyId,
    required String? storeId,
    required String createdBy,
    required String cashLocationId,
    required String counterpartyId,
    required DebtSubType debtSubType,
    required double amount,
    required DateTime entryDate,
    DebtCategory debtCategory = DebtCategory.account,
    String? memo,
    List<String>? attachmentUrls,
  });

  /// Create transfer entry (within store - no debt)
  ///
  /// Uses RPC: insert_journal_with_everything_utc
  /// Creates: DR To Location, CR From Location
  Future<String> createTransferWithinStore({
    required String companyId,
    required String storeId,
    required String createdBy,
    required String fromCashLocationId,
    required String toCashLocationId,
    required double amount,
    required DateTime entryDate,
    String? memo,
    List<String>? attachmentUrls,
  });

  /// Create transfer entry (between stores/companies - creates debt)
  ///
  /// Uses RPC: insert_journal_with_everything_utc with counterparty
  /// [counterpartyId] - optional, only needed for between-companies transfers
  Future<String> createTransferBetweenEntities({
    required String companyId,
    required String? storeId,
    required String createdBy,
    required String fromCashLocationId,
    required String toCashLocationId,
    required String? toStoreId,
    required String? toCompanyId,
    String? counterpartyId,
    required double amount,
    required DateTime entryDate,
    String? memo,
    List<String>? attachmentUrls,
  });
}
