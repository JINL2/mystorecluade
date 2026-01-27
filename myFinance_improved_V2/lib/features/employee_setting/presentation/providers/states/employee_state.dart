import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/employee_salary.dart';

part 'employee_state.freezed.dart';

/// Employee Page State - UI state for employee setting page
///
/// Unified state model for employee list page with loading,
/// error handling, filtering, sorting, and selection.
///
/// Note: Filtering and sorting logic is handled by `filteredEmployeesProvider`
/// in employee_providers.dart, not in this state class.
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
}
