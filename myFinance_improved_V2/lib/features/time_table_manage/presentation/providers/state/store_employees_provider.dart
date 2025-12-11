/// Store Employees Provider
///
/// Provides list of employee user IDs for a specific store.
/// Used to filter reliability leaderboard by store employees.
///
/// ✅ Clean Architecture Compliant:
/// - Uses Repository interface (Domain layer)
/// - No direct Datasource access
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../di/dependency_injection.dart';
import '../../../domain/entities/store_employee.dart';

/// Store Employees Provider
///
/// Loads employee list for a given store ID using Repository.
/// Returns list of StoreEmployee entities containing user IDs.
///
/// Usage:
/// ```dart
/// final employeesAsync = ref.watch(storeEmployeesProvider(storeId));
/// employeesAsync.when(
///   data: (employees) => Text('${employees.length} employees'),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
///
/// To refresh:
/// ```dart
/// ref.invalidate(storeEmployeesProvider(storeId));
/// ```
final storeEmployeesProvider =
    FutureProvider.family<List<StoreEmployee>, String>((ref, storeId) async {
  if (storeId.isEmpty) {
    return [];
  }

  // ✅ Use Repository instead of Datasource directly
  final repository = ref.watch(timeTableRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  return repository.getStoreEmployees(
    companyId: companyId,
    storeId: storeId,
  );
});

/// Store Employee User IDs Provider
///
/// Derived provider that returns just the user IDs as a Set for efficient filtering.
/// This is used to filter reliability leaderboard employees by store.
final storeEmployeeUserIdsProvider =
    FutureProvider.family<Set<String>, String>((ref, storeId) async {
  final employees = await ref.watch(storeEmployeesProvider(storeId).future);
  return employees.map((e) => e.userId).toSet();
});
