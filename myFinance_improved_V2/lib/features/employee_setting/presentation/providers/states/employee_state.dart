import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/employee_salary.dart';
import '../../extensions/employee_display_extension.dart';

part 'employee_state.freezed.dart';

/// Employee Page State - UI state for employee setting page
///
/// Unified state model for employee list page with loading,
/// error handling, filtering, sorting, and selection.
@freezed
class EmployeeState with _$EmployeeState {
  const factory EmployeeState({
    // Data
    @Default([]) List<EmployeeSalary> employees,

    // Loading states
    @Default(false) bool isLoading,
    @Default(false) bool isUpdatingSalary,
    @Default(false) bool isSyncing,

    // Error handling
    String? errorMessage,

    // Search & Filter
    @Default('') String searchQuery,
    String? selectedRoleFilter,
    String? selectedDepartmentFilter,
    String? selectedSalaryTypeFilter,

    // Sort
    @Default('name') String sortOption, // name, salary, role, recent
    @Default(true) bool sortAscending,

    // Selection
    EmployeeSalary? selectedEmployee,
  }) = _EmployeeState;

  const EmployeeState._();

  /// Get filtered and sorted employees
  List<EmployeeSalary> get filteredEmployees {
    var result = employees;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((employee) {
        return employee.fullName.toLowerCase().contains(query) ||
            employee.email.toLowerCase().contains(query) ||
            employee.roleName.toLowerCase().contains(query) ||
            employee.displayDepartment.toLowerCase().contains(query);
      }).toList();
    }

    // Apply role filter
    if (selectedRoleFilter != null && selectedRoleFilter!.isNotEmpty) {
      result = result.where((e) => e.roleName == selectedRoleFilter).toList();
    }

    // Apply department filter
    if (selectedDepartmentFilter != null && selectedDepartmentFilter!.isNotEmpty) {
      result = result.where((e) => e.displayDepartment == selectedDepartmentFilter).toList();
    }

    // Apply salary type filter
    if (selectedSalaryTypeFilter != null && selectedSalaryTypeFilter!.isNotEmpty) {
      result = result.where((e) => e.salaryType == selectedSalaryTypeFilter).toList();
    }

    // Apply sorting
    switch (sortOption) {
      case 'name':
        result.sort((a, b) {
          final comparison = a.fullName.compareTo(b.fullName);
          return sortAscending ? comparison : -comparison;
        });
        break;
      case 'salary':
        result.sort((a, b) {
          final comparison = a.salaryAmount.compareTo(b.salaryAmount);
          // For salary, default to high-to-low when ascending is true
          return sortAscending ? -comparison : comparison;
        });
        break;
      case 'role':
        result.sort((a, b) {
          final comparison = a.roleName.compareTo(b.roleName);
          return sortAscending ? comparison : -comparison;
        });
        break;
      case 'recent':
        result.sort((a, b) {
          final aDate = a.updatedAt ?? DateTime(1970);
          final bDate = b.updatedAt ?? DateTime(1970);
          final comparison = aDate.compareTo(bDate);
          // For recent, default to newest first when ascending is true
          return sortAscending ? -comparison : comparison;
        });
        break;
    }

    return result;
  }

  /// Check if any filter is active
  bool get hasActiveFilter {
    return searchQuery.isNotEmpty ||
        selectedRoleFilter != null ||
        selectedDepartmentFilter != null ||
        selectedSalaryTypeFilter != null;
  }

  /// Get active filter count
  int get activeFilterCount {
    int count = 0;
    if (searchQuery.isNotEmpty) count++;
    if (selectedRoleFilter != null && selectedRoleFilter!.isNotEmpty) count++;
    if (selectedDepartmentFilter != null && selectedDepartmentFilter!.isNotEmpty) count++;
    if (selectedSalaryTypeFilter != null && selectedSalaryTypeFilter!.isNotEmpty) count++;
    return count;
  }

  /// Check if any loading operation is in progress
  bool get isAnyLoading => isLoading || isUpdatingSalary || isSyncing;
}
