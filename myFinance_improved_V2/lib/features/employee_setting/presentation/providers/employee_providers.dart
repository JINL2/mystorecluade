import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/employee_salary.dart';
import '../../domain/entities/employee_setting_data.dart';
import '../../domain/entities/shift_audit_log.dart';
import '../../domain/value_objects/employee_update_request.dart';
import '../../domain/usecases/search_and_sort_employees_usecase.dart' as usecase;
import 'use_case_providers.dart';

// Re-export the notifier for easy access
export 'employee_notifier.dart';
export 'states/employee_state.dart';

part 'employee_providers.g.dart';

// ============================================================================
// Employee Data Providers (@riverpod)
// ============================================================================

/// Employee Shift Audit Logs Provider with pagination support
///
/// Uses RPC: employee_setting_get_employee_shift_audit_logs
/// Returns ShiftAuditLogsResult with logs and pagination metadata
@riverpod
Future<ShiftAuditLogsResult> employeeShiftAuditLogs(
  Ref ref,
  EmployeeAuditLogParams params,
) async {
  try {
    final repository = ref.read(employeeRepositoryProvider);

    if (params.employeeUserId.isEmpty || params.companyId.isEmpty) {
      return ShiftAuditLogsResult.empty();
    }

    return await repository.getEmployeeShiftAuditLogs(
      companyId: params.companyId,
      employeeUserId: params.employeeUserId,
      limit: params.limit,
      offset: params.offset,
    );
  } catch (e) {
    return ShiftAuditLogsResult.empty();
  }
}

// ✅ REMOVED: salaryUpdatesStreamProvider - Supabase Realtime doesn't work with VIEWs
// Use employeeSettingDataProvider + Riverpod invalidation instead

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

  /// Update a single employee in the list (Optimistic Update)
  /// This allows instant UI update without waiting for server response
  void updateEmployee(EmployeeSalary updatedEmployee) {
    if (state == null) return;
    state = state!.map((emp) =>
      emp.userId == updatedEmployee.userId ? updatedEmployee : emp
    ).toList();
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

  // Use new unified provider instead of individual employeeSalaryListProvider
  final employeesAsync = ref.watch(
    employeeSettingDataProvider(const EmployeeSettingDataParams()),
  );

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
    data: (data) {
      // Also populate the mutable list for future updates
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mutableEmployeeListProvider.notifier).update(data.employees);
      });

      return AsyncData(processEmployees(data.employees));
    },
    loading: () => const AsyncLoading(),
    error: (error, stack) => AsyncError(error, stack),
  );
}

// ============================================================================
// Work Schedule Template Assignment
// ============================================================================

/// Assign or unassign a work schedule template to an employee
///
/// Uses RPC: employee_setting_assign_work_schedule_template
/// - Owner-only permission (companies.owner_id = auth.uid())
/// - Pass null for templateId to unassign the current template
/// - Returns warning for non-monthly salary types
@riverpod
Future<WorkScheduleAssignResult> Function({
  required String employeeUserId,
  String? templateId,
}) assignWorkScheduleTemplate(Ref ref) {
  return ({
    required String employeeUserId,
    String? templateId,
  }) async {
    final repository = ref.read(employeeRepositoryProvider);
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      throw Exception('No company selected');
    }

    final result = await repository.assignWorkScheduleTemplate(
      companyId: companyId,
      employeeUserId: employeeUserId,
      templateId: templateId,
    );

    // Invalidate employee list to refresh with new template data
    ref.read(mutableEmployeeListProvider.notifier).clear();
    ref.invalidate(employeeSettingDataProvider);

    return result;
  };
}

// ============================================================================
// Helper Functions
// ============================================================================

/// Refresh employees using new unified provider
Future<void> refreshEmployees(WidgetRef ref) async {
  // Clear mutable cache first - this is critical for immediate UI update
  ref.read(mutableEmployeeListProvider.notifier).clear();
  // Then invalidate the unified provider to trigger fresh data fetch
  ref.invalidate(employeeSettingDataProvider);
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
  final String employeeUserId;
  final String companyId;
  final int limit;
  final int offset;

  const EmployeeAuditLogParams({
    required this.employeeUserId,
    required this.companyId,
    this.limit = 20,
    this.offset = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeAuditLogParams &&
          runtimeType == other.runtimeType &&
          employeeUserId == other.employeeUserId &&
          companyId == other.companyId &&
          limit == other.limit &&
          offset == other.offset;

  @override
  int get hashCode =>
      employeeUserId.hashCode ^ companyId.hashCode ^ limit.hashCode ^ offset.hashCode;
}

// ============================================================================
// Unified Employee Setting Data Provider (NEW - Single RPC)
// ============================================================================

/// Parameters for unified employee setting data provider
class EmployeeSettingDataParams {
  final String? searchQuery;
  final String? storeId;

  const EmployeeSettingDataParams({
    this.searchQuery,
    this.storeId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeSettingDataParams &&
          runtimeType == other.runtimeType &&
          searchQuery == other.searchQuery &&
          storeId == other.storeId;

  @override
  int get hashCode => searchQuery.hashCode ^ storeId.hashCode;
}

/// Unified Employee Setting Data Provider
///
/// This provider replaces 11 individual queries with a single RPC call:
/// - employees list (with optional search/filter)
/// - currencies list
/// - roles list
///
/// Note: isOwner check removed in v1.1 - use appState.isCurrentCompanyOwner
///
/// Usage:
/// ```dart
/// // Basic usage (no filters):
/// final dataAsync = ref.watch(employeeSettingDataProvider(const EmployeeSettingDataParams()));
///
/// // With search:
/// final dataAsync = ref.watch(employeeSettingDataProvider(
///   EmployeeSettingDataParams(searchQuery: 'john'),
/// ));
///
/// // Check owner status:
/// final isOwner = ref.watch(appStateProvider).isCurrentCompanyOwner;
/// ```
final employeeSettingDataProvider = FutureProvider.family<EmployeeSettingData, EmployeeSettingDataParams>(
  (ref, params) async {
    final repository = ref.read(employeeRepositoryProvider);
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      return EmployeeSettingData.empty();
    }

    return await repository.getEmployeeSettingData(
      companyId: companyId,
      searchQuery: params.searchQuery,
      storeId: params.storeId,
    );
  },
);
