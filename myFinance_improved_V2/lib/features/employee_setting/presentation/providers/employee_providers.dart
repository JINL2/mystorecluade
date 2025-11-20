import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/currency_type.dart';
import '../../domain/entities/employee_salary.dart';
import '../../domain/entities/role.dart';
import '../../domain/usecases/search_and_sort_employees_usecase.dart';
import 'employee_notifier.dart';
import 'states/employee_state.dart';
import 'use_case_providers.dart';

// ============================================================================
// Repository Providers
// ============================================================================
// ✅ Moved to: data/repositories/repository_providers.dart
// - employeeRepositoryProvider
// - roleRepositoryProvider
// Import them from the new location above

// ============================================================================
// Employee Data Providers
// ============================================================================

/// Employee Salary List Provider
final employeeSalaryListProvider = FutureProvider.autoDispose<List<EmployeeSalary>>((ref) async {
  try {
    final repository = ref.read(employeeRepositoryProvider);
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      return [];
    }

    final result = await repository.getEmployeeSalaries(companyId);
    return result;
  } catch (e) {
    rethrow;
  }
});

/// Currency Types Provider
final currencyTypesProvider = FutureProvider.autoDispose<List<CurrencyType>>((ref) async {
  try {
    final repository = ref.read(employeeRepositoryProvider);
    return await repository.getCurrencyTypes();
  } catch (e) {
    // Return default currencies on error (matching actual Supabase data)
    return const [
      CurrencyType(currencyCode: 'USD', currencyName: 'US Dollar', symbol: '\$'),
      CurrencyType(currencyCode: 'EUR', currencyName: 'Euro', symbol: '€'),
      CurrencyType(currencyCode: 'VND', currencyName: 'Vietnamese Dong', symbol: '₫'),
      CurrencyType(currencyCode: 'KRW', currencyName: 'Korean Won', symbol: '₩'),
    ];
  }
});

// ============================================================================
// UI State Providers
// ============================================================================

/// Search Query Provider
final employeeSearchQueryProvider = StateProvider<String>((ref) => '');

/// Sort Option Provider - tracks both field and direction
final employeeSortOptionProvider = StateProvider<String?>((ref) => 'name');

/// Sort Direction Provider - true for ascending, false for descending
final employeeSortDirectionProvider = StateProvider<bool>((ref) => true);

/// Filter Providers for centralized state management
final selectedRoleFilterProvider = StateProvider<String?>((ref) => null);
final selectedDepartmentFilterProvider = StateProvider<String?>((ref) => null);
final selectedSalaryTypeFilterProvider = StateProvider<String?>((ref) => null);

/// Mutable Employee List Provider for instant updates
final mutableEmployeeListProvider = StateProvider<List<EmployeeSalary>?>((ref) => null);

/// Loading State Provider
final isUpdatingSalaryProvider = StateProvider<bool>((ref) => false);

/// Sync State Provider
final isSyncingProvider = StateProvider<bool>((ref) => false);

/// Selected Employee Provider
final selectedEmployeeProvider = StateProvider<EmployeeSalary?>((ref) => null);

// ============================================================================
// Filtered and Sorted Employees Provider
// ============================================================================

final filteredEmployeesProvider = Provider.autoDispose<AsyncValue<List<EmployeeSalary>>>((ref) {
  final searchQuery = ref.watch(employeeSearchQueryProvider);
  final sortOption = ref.watch(employeeSortOptionProvider);
  final sortAscending = ref.watch(employeeSortDirectionProvider);
  final mutableEmployees = ref.watch(mutableEmployeeListProvider);
  final employeesAsync = ref.watch(employeeSalaryListProvider);

  // ✅ Read UseCase once at Provider level instead of inside function
  final searchAndSortUseCase = ref.read(searchAndSortEmployeesUseCaseProvider);

  List<EmployeeSalary> processEmployees(List<EmployeeSalary> employees) {
    // Convert string sort option to enum
    final sortOptionEnum = _convertToSortOption(sortOption);
    final sortDirectionEnum = sortAscending
        ? SortDirection.ascending
        : SortDirection.descending;

    // ✅ Delegate to UseCase - Clean Architecture compliance
    return searchAndSortUseCase.execute(
      SearchAndSortParams(
        employees: employees,
        searchQuery: searchQuery,
        sortOption: sortOptionEnum,
        sortDirection: sortDirectionEnum,
      ),
    );
  }

  // Use mutable list if available, otherwise use the async provider
  if (mutableEmployees != null) {
    return AsyncData(processEmployees(mutableEmployees));
  }

  return employeesAsync.when(
    data: (employees) {
      // Also populate the mutable list for future updates
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mutableEmployeeListProvider.notifier).state = employees;
      });

      return AsyncData(processEmployees(employees));
    },
    loading: () => const AsyncLoading(),
    error: (error, stack) => AsyncError(error, stack),
  );
});

// ============================================================================
// Real-time Updates Provider
// ============================================================================

final salaryUpdatesStreamProvider = StreamProvider<List<EmployeeSalary>>((ref) {
  try {
    final repository = ref.read(employeeRepositoryProvider);
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      return Stream.value([]);
    }

    return repository.watchEmployeeSalaries(companyId);
  } catch (e) {
    return Stream.value([]);
  }
});

// ============================================================================
// Roles Providers
// ============================================================================

final rolesProvider = FutureProvider.autoDispose<List<Role>>((ref) async {
  try {
    final repository = ref.read(roleRepositoryProvider);
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      // If no company selected, fetch all global roles
      return await repository.getAllRoles();
    }

    // Fetch company-specific and global roles
    return await repository.getRolesByCompany(companyId);
  } catch (e) {
    rethrow;
  }
});

// ============================================================================
// ✅ NEW STANDARD: StateNotifier Pattern (Following transaction_template)
// ============================================================================

/// Employee State Provider - 메인 직원 상태 관리
///
/// ✅ Hybrid pattern: UseCase for complex operations, Repository for simple CRUD
final employeeProvider = StateNotifierProvider<EmployeeNotifier, EmployeeState>((ref) {
  return EmployeeNotifier(
    repository: ref.read(employeeRepositoryProvider),
    updateSalaryUseCase: ref.read(updateEmployeeSalaryUseCaseProvider),
  );
});

// ============================================================================
// Helper Functions
// ============================================================================

/// Refresh employees
Future<void> refreshEmployees(WidgetRef ref) async {
  ref.invalidate(employeeSalaryListProvider);
  ref.invalidate(currencyTypesProvider);
  ref.invalidate(rolesProvider);
}

/// Convert string sort option to enum
EmployeeSortOption _convertToSortOption(String? sortOption) {
  switch (sortOption) {
    case 'name':
      return EmployeeSortOption.name;
    case 'salary':
      return EmployeeSortOption.salary;
    case 'role':
      return EmployeeSortOption.role;
    case 'recent':
      return EmployeeSortOption.recent;
    default:
      return EmployeeSortOption.name;
  }
}
