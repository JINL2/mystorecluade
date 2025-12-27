import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/cash_transaction_datasource.dart';
import '../../data/repositories/cash_transaction_repository_impl.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/counterparty.dart';
import '../../domain/entities/expense_account.dart';
import '../../domain/repositories/cash_transaction_repository.dart';

// Export domain entities for use in presentation
export '../../domain/entities/cash_location.dart';
export '../../domain/entities/cash_transaction_enums.dart';
export '../../domain/entities/counterparty.dart';
export '../../domain/entities/expense_account.dart';

const _tag = '[CashControlProviders]';

// ============================================================================
// DEPENDENCY INJECTION PROVIDERS
// ============================================================================

/// Data source provider
final cashTransactionDataSourceProvider = Provider<CashTransactionDataSource>((ref) {
  return CashTransactionDataSource();
});

/// Repository provider
final cashTransactionRepositoryProvider = Provider<CashTransactionRepository>((ref) {
  final dataSource = ref.watch(cashTransactionDataSourceProvider);
  return CashTransactionRepositoryImpl(dataSource: dataSource);
});

// ============================================================================
// DATA PROVIDERS
// ============================================================================

/// Quick access expense accounts provider (user's most used accounts)
/// Params: (companyId, userId)
/// Note: This includes ALL account types the user frequently uses
/// For expense-only accounts, use expenseAccountsOnlyProvider
final expenseAccountsProvider =
    FutureProvider.family<List<ExpenseAccount>, ({String companyId, String userId})>(
  (ref, params) async {
    final repository = ref.watch(cashTransactionRepositoryProvider);
    return repository.getExpenseAccounts(
      companyId: params.companyId,
      userId: params.userId,
    );
  },
);

/// Expense accounts only provider (account_type = 'expense')
/// Params: companyId
/// Returns only accounts where account_type = 'expense'
/// AND (is_default = TRUE OR company_id = params.companyId)
final expenseAccountsOnlyProvider =
    FutureProvider.family<List<ExpenseAccount>, String>(
  (ref, companyId) async {
    debugPrint('$_tag expenseAccountsOnlyProvider called with companyId: $companyId');
    final repository = ref.watch(cashTransactionRepositoryProvider);
    final accounts = await repository.getExpenseAccountsOnly(companyId: companyId);
    debugPrint('$_tag Got ${accounts.length} expense-only accounts');
    return accounts;
  },
);

/// Search expense accounts provider
/// Params: (companyId, query)
/// Returns expense accounts matching the search query
final searchExpenseAccountsProvider =
    FutureProvider.family<List<ExpenseAccount>, ({String companyId, String query})>(
  (ref, params) async {
    debugPrint('$_tag searchExpenseAccountsProvider called - companyId: ${params.companyId}, query: ${params.query}');
    final repository = ref.watch(cashTransactionRepositoryProvider);
    final accounts = await repository.searchExpenseAccounts(
      companyId: params.companyId,
      query: params.query,
    );
    debugPrint('$_tag Found ${accounts.length} accounts matching "${params.query}"');
    return accounts;
  },
);

/// Counterparties provider
/// Params: companyId
final counterpartiesProvider =
    FutureProvider.family<List<Counterparty>, String>(
  (ref, companyId) async {
    final repository = ref.watch(cashTransactionRepositoryProvider);
    return repository.getCounterparties(companyId: companyId);
  },
);

/// Self-counterparty provider
/// Returns the counterparty where company_id = linked_company_id
/// Used for within-company transfers (same company, different stores)
final selfCounterpartyProvider =
    FutureProvider.family<Counterparty?, String>(
  (ref, companyId) async {
    debugPrint('$_tag selfCounterpartyProvider called for companyId: $companyId');
    final repository = ref.watch(cashTransactionRepositoryProvider);
    return repository.getSelfCounterparty(companyId: companyId);
  },
);

/// Cash locations provider for a company
/// Params: companyId
final cashLocationsForCompanyProvider =
    FutureProvider.family<List<CashLocation>, String>(
  (ref, companyId) async {
    final repository = ref.watch(cashTransactionRepositoryProvider);
    return repository.getCashLocationsForCompany(companyId: companyId);
  },
);

/// Cash locations provider for a store
/// Params: (companyId, storeId)
final cashLocationsForStoreProvider =
    FutureProvider.family<List<CashLocation>, ({String companyId, String storeId})>(
  (ref, params) async {
    debugPrint('$_tag cashLocationsForStoreProvider called');
    debugPrint('$_tag Params - companyId: "${params.companyId}", storeId: "${params.storeId}"');
    debugPrint('$_tag companyId.isEmpty: ${params.companyId.isEmpty}, storeId.isEmpty: ${params.storeId.isEmpty}');

    final repository = ref.watch(cashTransactionRepositoryProvider);
    debugPrint('$_tag Calling repository.getCashLocationsForCompany...');

    final allLocations = await repository.getCashLocationsForCompany(
      companyId: params.companyId,
    );

    debugPrint('$_tag Got ${allLocations.length} locations from repository');

    for (final loc in allLocations) {
      debugPrint('$_tag   - Location: ${loc.locationName}, storeId: "${loc.storeId}", companyId: "${loc.companyId}"');
    }

    // Filter by store
    debugPrint('$_tag Filtering by storeId: "${params.storeId}"');
    final filtered = allLocations
        .where((loc) => loc.storeId == params.storeId)
        .toList();

    debugPrint('$_tag After filter: ${filtered.length} locations');

    return filtered;
  },
);
