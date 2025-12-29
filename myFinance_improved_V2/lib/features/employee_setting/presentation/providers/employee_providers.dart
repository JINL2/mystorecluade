import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/currency_type.dart';
import '../../domain/entities/employee_salary.dart';
import '../../domain/entities/role.dart';
import '../../domain/entities/shift_audit_log.dart';
import '../../domain/usecases/search_and_sort_employees_usecase.dart' as usecase;
import 'use_case_providers.dart';

// Re-export the notifier for easy access
export 'employee_notifier.dart';
export 'states/employee_state.dart';

part 'employee_providers.g.dart';

// ============================================================================
// Repository Providers
// ============================================================================
// ✅ Moved to: data/repositories/repository_providers.dart
// - employeeRepositoryProvider
// - roleRepositoryProvider
// Import them from the new location above

// ============================================================================
// Employee Data Providers (@riverpod)
// ============================================================================

/// Employee Salary List Provider
@riverpod
Future<List<EmployeeSalary>> employeeSalaryList(Ref ref) async {
  final repository = ref.read(employeeRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) {
    return [];
  }

  return await repository.getEmployeeSalaries(companyId);
}

/// Currency Types Provider
@riverpod
Future<List<CurrencyType>> currencyTypes(Ref ref) async {
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
}

/// Check if the current user is the owner of the selected company
@riverpod
Future<bool> isCurrentUserOwner(Ref ref) async {
  try {
    final repository = ref.read(employeeRepositoryProvider);
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      return false;
    }

    return await repository.isCurrentUserOwner(companyId);
  } catch (e) {
    return false;
  }
}

/// Roles Provider
@riverpod
Future<List<Role>> roles(Ref ref) async {
  final repository = ref.read(roleRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) {
    // If no company selected, fetch all global roles
    return await repository.getAllRoles();
  }

  // Fetch company-specific and global roles
  return await repository.getRolesByCompany(companyId);
}

/// Employee Shift Audit Logs Provider with pagination support
@riverpod
Future<List<ShiftAuditLog>> employeeShiftAuditLogs(
  Ref ref,
  EmployeeAuditLogParams params,
) async {
  try {
    final repository = ref.read(employeeRepositoryProvider);

    if (params.userId.isEmpty || params.companyId.isEmpty) {
      return [];
    }

    return await repository.getEmployeeShiftAuditLogs(
      userId: params.userId,
      companyId: params.companyId,
      limit: params.limit,
      offset: params.offset,
    );
  } catch (e) {
    return [];
  }
}

/// Real-time salary updates stream
@Riverpod(keepAlive: true)
Stream<List<EmployeeSalary>> salaryUpdatesStream(Ref ref) {
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
}

// ============================================================================
// UI State Notifiers (@riverpod)
// ============================================================================

/// Mutable Employee List Notifier for instant updates
@riverpod
class MutableEmployeeList extends _$MutableEmployeeList {
  @override
  List<EmployeeSalary>? build() => null;

  void update(List<EmployeeSalary>? employees) {
    state = employees;
  }

  void clear() {
    state = null;
  }
}

/// Search Query Notifier
@riverpod
class EmployeeSearchQuery extends _$EmployeeSearchQuery {
  @override
  String build() => '';

  void update(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

/// Sort Option Notifier
@riverpod
class EmployeeSortOption extends _$EmployeeSortOption {
  @override
  String build() => 'name';

  void update(String option) {
    state = option;
  }
}

/// Sort Direction Notifier - true for ascending, false for descending
@riverpod
class EmployeeSortDirection extends _$EmployeeSortDirection {
  @override
  bool build() => true;

  void toggle() {
    state = !state;
  }

  void update(bool ascending) {
    state = ascending;
  }
}

/// Role Filter Notifier
@riverpod
class SelectedRoleFilter extends _$SelectedRoleFilter {
  @override
  String? build() => null;

  void update(String? role) {
    state = role;
  }

  void clear() {
    state = null;
  }
}

/// Department Filter Notifier
@riverpod
class SelectedDepartmentFilter extends _$SelectedDepartmentFilter {
  @override
  String? build() => null;

  void update(String? department) {
    state = department;
  }

  void clear() {
    state = null;
  }
}

/// Salary Type Filter Notifier
@riverpod
class SelectedSalaryTypeFilter extends _$SelectedSalaryTypeFilter {
  @override
  String? build() => null;

  void update(String? salaryType) {
    state = salaryType;
  }

  void clear() {
    state = null;
  }
}

/// Loading State Notifier for salary updates
@riverpod
class IsUpdatingSalary extends _$IsUpdatingSalary {
  @override
  bool build() => false;

  void update(bool isUpdating) {
    state = isUpdating;
  }
}

/// Sync State Notifier
@riverpod
class IsSyncing extends _$IsSyncing {
  @override
  bool build() => false;

  void update(bool isSyncing) {
    state = isSyncing;
  }
}

/// Selected Employee Notifier
@riverpod
class SelectedEmployee extends _$SelectedEmployee {
  @override
  EmployeeSalary? build() => null;

  void select(EmployeeSalary? employee) {
    state = employee;
  }

  void clear() {
    state = null;
  }
}

// ============================================================================
// Filtered and Sorted Employees Provider
// ============================================================================

@riverpod
AsyncValue<List<EmployeeSalary>> filteredEmployees(Ref ref) {
  final searchQuery = ref.watch(employeeSearchQueryProvider);
  final sortOption = ref.watch(employeeSortOptionProvider);
  final sortAscending = ref.watch(employeeSortDirectionProvider);
  final mutableEmployees = ref.watch(mutableEmployeeListProvider);
  final employeesAsync = ref.watch(employeeSalaryListProvider);

  // Read UseCase once at Provider level
  final searchAndSortUseCase = ref.read(searchAndSortEmployeesUseCaseProvider);

  List<EmployeeSalary> processEmployees(List<EmployeeSalary> employees) {
    // Convert string sort option to enum
    final sortOptionEnum = _convertToSortOption(sortOption);
    final sortDirectionEnum = sortAscending
        ? usecase.SortDirection.ascending
        : usecase.SortDirection.descending;

    // Delegate to UseCase - Clean Architecture compliance
    return searchAndSortUseCase.execute(
      usecase.SearchAndSortParams(
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
        ref.read(mutableEmployeeListProvider.notifier).update(employees);
      });

      return AsyncData(processEmployees(employees));
    },
    loading: () => const AsyncLoading(),
    error: (error, stack) => AsyncError(error, stack),
  );
}

// ============================================================================
// Work Schedule Template Assignment
// ============================================================================

/// Assign or unassign a work schedule template to an employee
@riverpod
Future<Map<String, dynamic>> Function({
  required String userId,
  String? templateId,
}) assignWorkScheduleTemplate(Ref ref) {
  return ({
    required String userId,
    String? templateId,
  }) async {
    final repository = ref.read(employeeRepositoryProvider);
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      return {
        'success': false,
        'error': 'NO_COMPANY',
        'message': 'No company selected',
      };
    }

    final result = await repository.assignWorkScheduleTemplate(
      userId: userId,
      companyId: companyId,
      templateId: templateId,
    );

    // Invalidate employee list to refresh with new template data
    if (result['success'] == true) {
      ref.invalidate(employeeSalaryListProvider);
      // Also clear mutable list to force refresh
      ref.read(mutableEmployeeListProvider.notifier).clear();
    }

    return result;
  };
}

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
usecase.EmployeeSortOption _convertToSortOption(String? sortOption) {
  switch (sortOption) {
    case 'name':
      return usecase.EmployeeSortOption.name;
    case 'salary':
      return usecase.EmployeeSortOption.salary;
    case 'role':
      return usecase.EmployeeSortOption.role;
    case 'recent':
      return usecase.EmployeeSortOption.recent;
    default:
      return usecase.EmployeeSortOption.name;
  }
}

// ============================================================================
// Parameters Class for Family Providers
// ============================================================================

/// Parameters for shift audit log provider
class EmployeeAuditLogParams {
  final String userId;
  final String companyId;
  final int limit;
  final int offset;

  const EmployeeAuditLogParams({
    required this.userId,
    required this.companyId,
    this.limit = 20,
    this.offset = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeAuditLogParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          companyId == other.companyId &&
          limit == other.limit &&
          offset == other.offset;

  @override
  int get hashCode =>
      userId.hashCode ^ companyId.hashCode ^ limit.hashCode ^ offset.hashCode;
}
