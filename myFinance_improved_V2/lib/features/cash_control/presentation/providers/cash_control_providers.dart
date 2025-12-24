import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/cash_control_datasource.dart';
import '../../data/repositories/cash_control_repository_impl.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/counterparty.dart';
import '../../domain/entities/expense_account.dart';
import '../../domain/repositories/cash_control_repository.dart';

// Export domain entities for use in presentation
export '../../domain/entities/cash_control_enums.dart';
export '../../domain/entities/cash_location.dart';
export '../../domain/entities/counterparty.dart';
export '../../domain/entities/expense_account.dart';

const _tag = '[CashControlProviders]';

// ============================================================================
// DEPENDENCY INJECTION PROVIDERS
// ============================================================================

/// Data source provider
final cashControlDataSourceProvider = Provider<CashControlDataSource>((ref) {
  return CashControlDataSource();
});

/// Repository provider
final cashControlRepositoryProvider = Provider<CashControlRepository>((ref) {
  final dataSource = ref.watch(cashControlDataSourceProvider);
  return CashControlRepositoryImpl(dataSource: dataSource);
});

// ============================================================================
// DATA PROVIDERS
// ============================================================================

/// Expense accounts provider
/// Params: (companyId, userId)
final expenseAccountsProvider =
    FutureProvider.family<List<ExpenseAccount>, ({String companyId, String userId})>(
  (ref, params) async {
    final repository = ref.watch(cashControlRepositoryProvider);
    return repository.getExpenseAccounts(
      companyId: params.companyId,
      userId: params.userId,
    );
  },
);

/// Counterparties provider
/// Params: companyId
final counterpartiesProvider =
    FutureProvider.family<List<Counterparty>, String>(
  (ref, companyId) async {
    final repository = ref.watch(cashControlRepositoryProvider);
    return repository.getCounterparties(companyId: companyId);
  },
);

/// Cash locations provider for a company
/// Params: companyId
final cashLocationsForCompanyProvider =
    FutureProvider.family<List<CashLocation>, String>(
  (ref, companyId) async {
    final repository = ref.watch(cashControlRepositoryProvider);
    return repository.getCashLocationsForCompany(companyId: companyId);
  },
);

/// Cash locations provider for a store
/// Params: (companyId, storeId)
final cashLocationsForStoreProvider =
    FutureProvider.family<List<CashLocation>, ({String companyId, String storeId})>(
  (ref, params) async {
    debugPrint('$_tag 🏪 cashLocationsForStoreProvider called');
    debugPrint('$_tag 📋 Params - companyId: "${params.companyId}", storeId: "${params.storeId}"');
    debugPrint('$_tag 📋 companyId.isEmpty: ${params.companyId.isEmpty}, storeId.isEmpty: ${params.storeId.isEmpty}');

    final repository = ref.watch(cashControlRepositoryProvider);
    debugPrint('$_tag 📡 Calling repository.getCashLocationsForCompany...');

    final allLocations = await repository.getCashLocationsForCompany(
      companyId: params.companyId,
    );

    debugPrint('$_tag 📥 Got ${allLocations.length} locations from repository');

    for (final loc in allLocations) {
      debugPrint('$_tag   - Location: ${loc.locationName}, storeId: "${loc.storeId}", companyId: "${loc.companyId}"');
    }

    // Filter by store
    debugPrint('$_tag 🔍 Filtering by storeId: "${params.storeId}"');
    final filtered = allLocations
        .where((loc) => loc.storeId == params.storeId)
        .toList();

    debugPrint('$_tag ✅ After filter: ${filtered.length} locations');

    return filtered;
  },
);
