/// Use Case: Search and Sort Employees
///
/// Handles employee search and sorting business logic.
/// This UseCase encapsulates the filtering and sorting rules.
library;

import '../entities/employee_salary.dart';

/// Sort options for employees
enum EmployeeSortOption {
  name,
  salary,
  role,
  recent,
}

/// Sort direction
enum SortDirection {
  ascending,
  descending,
}

/// Search and sort parameters
class SearchAndSortParams {
  final List<EmployeeSalary> employees;
  final String searchQuery;
  final EmployeeSortOption sortOption;
  final SortDirection sortDirection;

  const SearchAndSortParams({
    required this.employees,
    this.searchQuery = '',
    this.sortOption = EmployeeSortOption.name,
    this.sortDirection = SortDirection.ascending,
  });
}

/// Use case for searching and sorting employees
///
/// This UseCase handles:
/// - Search filtering by name, email, role, department
/// - Sorting by various criteria
/// - Business rules for default sort directions
class SearchAndSortEmployeesUseCase {
  /// Execute the search and sort operation
  List<EmployeeSalary> execute(SearchAndSortParams params) {
    // Phase 1: Filter by search query
    List<EmployeeSalary> filtered = _filterEmployees(
      params.employees,
      params.searchQuery,
    );

    // Phase 2: Sort by selected option
    filtered = _sortEmployees(
      filtered,
      params.sortOption,
      params.sortDirection,
    );

    return filtered;
  }

  /// Filter employees by search query
  List<EmployeeSalary> _filterEmployees(
    List<EmployeeSalary> employees,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty) {
      return employees;
    }

    final query = searchQuery.toLowerCase();
    return employees.where((employee) {
      final department = employee.department ?? 'General';
      return employee.fullName.toLowerCase().contains(query) ||
          employee.email.toLowerCase().contains(query) ||
          employee.roleName.toLowerCase().contains(query) ||
          department.toLowerCase().contains(query);
    }).toList();
  }

  /// Sort employees by option and direction
  List<EmployeeSalary> _sortEmployees(
    List<EmployeeSalary> employees,
    EmployeeSortOption sortOption,
    SortDirection sortDirection,
  ) {
    final sorted = List<EmployeeSalary>.from(employees);

    switch (sortOption) {
      case EmployeeSortOption.name:
        sorted.sort((a, b) {
          final comparison = a.fullName.compareTo(b.fullName);
          return _applyDirection(comparison, sortDirection);
        });
        break;

      case EmployeeSortOption.salary:
        sorted.sort((a, b) {
          final comparison = a.salaryAmount.compareTo(b.salaryAmount);
          // For salary, default to high-to-low (descending)
          return sortDirection == SortDirection.ascending
              ? -comparison
              : comparison;
        });
        break;

      case EmployeeSortOption.role:
        sorted.sort((a, b) {
          final comparison = a.roleName.compareTo(b.roleName);
          return _applyDirection(comparison, sortDirection);
        });
        break;

      case EmployeeSortOption.recent:
        sorted.sort((a, b) {
          final aDate = a.updatedAt ?? DateTime.now();
          final bDate = b.updatedAt ?? DateTime.now();
          final comparison = aDate.compareTo(bDate);
          // For recent, default to newest first (descending)
          return sortDirection == SortDirection.ascending
              ? comparison
              : -comparison;
        });
        break;
    }

    return sorted;
  }

  /// Apply sort direction to comparison result
  int _applyDirection(int comparison, SortDirection direction) {
    return direction == SortDirection.ascending ? comparison : -comparison;
  }
}
