import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

// Part directive must come after all imports and exports
part 'cash_transaction_providers.g.dart';

const _tag = '[CashControlProviders]';

// ============================================================================
// DEPENDENCY INJECTION PROVIDERS
// ============================================================================

/// Data source provider
@riverpod
CashTransactionDataSource cashTransactionDataSource(CashTransactionDataSourceRef ref) {
  return CashTransactionDataSource();
}

/// Repository provider
@riverpod
CashTransactionRepository cashTransactionRepository(CashTransactionRepositoryRef ref) {
  final dataSource = ref.watch(cashTransactionDataSourceProvider);
  return CashTransactionRepositoryImpl(dataSource: dataSource);
}

// ============================================================================
// DATA PROVIDERS
// ============================================================================

/// Quick access expense accounts provider (user's most used accounts)
/// Note: This includes ALL account types the user frequently uses
/// For expense-only accounts, use expenseAccountsOnlyProvider
@riverpod
Future<List<ExpenseAccount>> expenseAccounts(
  ExpenseAccountsRef ref, {
  required String companyId,
  required String userId,
}) async {
  final repository = ref.watch(cashTransactionRepositoryProvider);
  return repository.getExpenseAccounts(
    companyId: companyId,
    userId: userId,
  );
}

/// Expense accounts only provider (account_type = 'expense')
/// Returns only accounts where account_type = 'expense'
/// AND (is_default = TRUE OR company_id = params.companyId)
@riverpod
Future<List<ExpenseAccount>> expenseAccountsOnly(
  ExpenseAccountsOnlyRef ref,
  String companyId,
) async {
  debugPrint('$_tag expenseAccountsOnlyProvider called with companyId: $companyId');
  final repository = ref.watch(cashTransactionRepositoryProvider);
  final accounts = await repository.getExpenseAccountsOnly(companyId: companyId);
  debugPrint('$_tag Got ${accounts.length} expense-only accounts');
  return accounts;
}

/// Search expense accounts provider
/// Returns expense accounts matching the search query
@riverpod
Future<List<ExpenseAccount>> searchExpenseAccounts(
  SearchExpenseAccountsRef ref, {
  required String companyId,
  required String query,
}) async {
  debugPrint('$_tag searchExpenseAccountsProvider called - companyId: $companyId, query: $query');
  final repository = ref.watch(cashTransactionRepositoryProvider);
  final accounts = await repository.searchExpenseAccounts(
    companyId: companyId,
    query: query,
  );
  debugPrint('$_tag Found ${accounts.length} accounts matching "$query"');
  return accounts;
}

/// Counterparties provider
@riverpod
Future<List<Counterparty>> counterparties(
  CounterpartiesRef ref,
  String companyId,
) async {
  final repository = ref.watch(cashTransactionRepositoryProvider);
  return repository.getCounterparties(companyId: companyId);
}

/// Self-counterparty provider
/// Returns the counterparty where company_id = linked_company_id
/// Used for within-company transfers (same company, different stores)
@riverpod
Future<Counterparty?> selfCounterparty(
  SelfCounterpartyRef ref,
  String companyId,
) async {
  debugPrint('$_tag selfCounterpartyProvider called for companyId: $companyId');
  final repository = ref.watch(cashTransactionRepositoryProvider);
  return repository.getSelfCounterparty(companyId: companyId);
}

/// Cash locations provider for a company
@riverpod
Future<List<CashLocation>> cashLocationsForCompany(
  CashLocationsForCompanyRef ref,
  String companyId,
) async {
  final repository = ref.watch(cashTransactionRepositoryProvider);
  return repository.getCashLocationsForCompany(companyId: companyId);
}

/// Cash locations provider for a store
@riverpod
Future<List<CashLocation>> cashLocationsForStore(
  CashLocationsForStoreRef ref, {
  required String companyId,
  required String storeId,
}) async {
  debugPrint('$_tag cashLocationsForStoreProvider called');
  debugPrint('$_tag Params - companyId: "$companyId", storeId: "$storeId"');
  debugPrint('$_tag companyId.isEmpty: ${companyId.isEmpty}, storeId.isEmpty: ${storeId.isEmpty}');

  final repository = ref.watch(cashTransactionRepositoryProvider);
  debugPrint('$_tag Calling repository.getCashLocationsForCompany...');

  final allLocations = await repository.getCashLocationsForCompany(
    companyId: companyId,
  );

  debugPrint('$_tag Got ${allLocations.length} locations from repository');

  for (final loc in allLocations) {
    debugPrint('$_tag   - Location: ${loc.locationName}, storeId: "${loc.storeId}", companyId: "${loc.companyId}"');
  }

  // Filter by store
  debugPrint('$_tag Filtering by storeId: "$storeId"');
  final filtered = allLocations
      .where((loc) => loc.storeId == storeId)
      .toList();

  debugPrint('$_tag After filter: ${filtered.length} locations');

  return filtered;
}
