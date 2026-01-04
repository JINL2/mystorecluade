import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
/// Uses keepAlive to cache across navigation
@riverpod
Future<List<ExpenseAccount>> expenseAccountsOnly(
  ExpenseAccountsOnlyRef ref,
  String companyId,
) async {
  // Keep provider alive for 5 minutes to avoid re-fetching
  final keepAliveLink = ref.keepAlive();
  Future.delayed(const Duration(minutes: 5), () {
    keepAliveLink.close();
  });

  final repository = ref.watch(cashTransactionRepositoryProvider);
  final accounts = await repository.getExpenseAccountsOnly(companyId: companyId);
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
  final repository = ref.watch(cashTransactionRepositoryProvider);
  final accounts = await repository.searchExpenseAccounts(
    companyId: companyId,
    query: query,
  );
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

  final repository = ref.watch(cashTransactionRepositoryProvider);

  final allLocations = await repository.getCashLocationsForCompany(
    companyId: companyId,
  );

  // Filter by store
  final filtered = allLocations
      .where((loc) => loc.storeId == storeId)
      .toList();

  return filtered;
}

// ============================================================================
// CURRENCY PROVIDER
// ============================================================================

/// Company base currency symbol provider
/// Returns the currency symbol for the company (e.g., '₩', '$', '₫')
@riverpod
Future<String> companyCurrencySymbol(
  CompanyCurrencySymbolRef ref,
  String companyId,
) async {
  if (companyId.isEmpty) return '₩'; // Default fallback

  try {
    final client = Supabase.instance.client;

    // Get company's base currency id
    final companyResponse = await client
        .from('companies')
        .select('base_currency_id')
        .eq('company_id', companyId)
        .maybeSingle();

    if (companyResponse == null) {
      return '₩';
    }

    final baseCurrencyId = companyResponse['base_currency_id'] as String?;
    if (baseCurrencyId == null) {
      return '₩';
    }

    // Get currency symbol
    final currencyResponse = await client
        .from('currency_types')
        .select('symbol')
        .eq('currency_id', baseCurrencyId)
        .maybeSingle();

    if (currencyResponse == null) {
      return '₩';
    }

    final symbol = currencyResponse['symbol'] as String? ?? '₩';
    return symbol;
  } catch (e) {
    return '₩';
  }
}
