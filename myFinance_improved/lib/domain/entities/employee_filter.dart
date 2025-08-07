// lib/domain/entities/employee_filter.dart

enum EmployeeSortBy { name, role, salary, joinDate }

class EmployeeFilter {
  final String searchQuery;
  final bool activeOnly;
  final List<String> selectedRoleIds;
  final List<String> selectedStoreIds;
  final EmployeeSortBy sortBy;
  final bool sortAscending;

  const EmployeeFilter({
    this.searchQuery = '',
    this.activeOnly = true,
    this.selectedRoleIds = const [],
    this.selectedStoreIds = const [],
    this.sortBy = EmployeeSortBy.name,
    this.sortAscending = true,
  });

  EmployeeFilter copyWith({
    String? searchQuery,
    bool? activeOnly,
    List<String>? selectedRoleIds,
    List<String>? selectedStoreIds,
    EmployeeSortBy? sortBy,
    bool? sortAscending,
  }) {
    return EmployeeFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      activeOnly: activeOnly ?? this.activeOnly,
      selectedRoleIds: selectedRoleIds ?? this.selectedRoleIds,
      selectedStoreIds: selectedStoreIds ?? this.selectedStoreIds,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }
}