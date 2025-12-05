/// Store Employees Provider
///
/// Provides list of employee user IDs for a specific store.
/// Used to filter reliability leaderboard by store employees.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../di/dependency_injection.dart';
import '../../../domain/entities/store_employee.dart';

/// Store Employees Provider
///
/// Loads employee list for a given store ID using get_employee_info RPC.
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

  final datasource = ref.watch(timeTableDatasourceProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  final response = await datasource.getStoreEmployees(
    companyId: companyId,
    storeId: storeId,
  );

  // Convert JSON response to StoreEmployee entities
  return response
      .map((item) => StoreEmployee.fromJson(item as Map<String, dynamic>))
      .toList();
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
