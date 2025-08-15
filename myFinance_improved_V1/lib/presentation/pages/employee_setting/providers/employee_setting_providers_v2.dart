import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/employee_salary.dart';
import '../models/currency_type.dart';
import '../providers/employee_setting_providers.dart';

// Add new providers for enhanced functionality

// Selected department filter
final selectedDepartmentProvider = StateProvider<String?>((ref) => null);

// Filter employees by department
final filteredByDepartmentProvider = Provider<List<EmployeeSalary>>((ref) {
  final employees = ref.watch(mutableEmployeeListProvider) ?? [];
  final selectedDepartment = ref.watch(selectedDepartmentProvider);
  
  if (selectedDepartment == null) {
    return employees;
  }
  
  return employees.where((emp) => 
    emp.displayDepartment == selectedDepartment
  ).toList();
});

// Combined filter provider (search + department)
final combinedFilteredEmployeesProvider = Provider<List<EmployeeSalary>>((ref) {
  final employeesByDepartment = ref.watch(filteredByDepartmentProvider);
  final searchQuery = ref.watch(employeeSearchQueryProvider).toLowerCase();
  
  if (searchQuery.isEmpty) {
    return employeesByDepartment;
  }
  
  return employeesByDepartment.where((employee) {
    return employee.fullName.toLowerCase().contains(searchQuery) ||
           employee.email.toLowerCase().contains(searchQuery) ||
           (employee.roleName?.toLowerCase().contains(searchQuery) ?? false) ||
           employee.displayDepartment.toLowerCase().contains(searchQuery);
  }).toList();
});

// Employee count by department
final employeeCountByDepartmentProvider = Provider.family<int, String>((ref, department) {
  final employees = ref.watch(mutableEmployeeListProvider) ?? [];
  return employees.where((emp) => emp.displayDepartment == department).length;
});

// Total employee count
final totalEmployeeCountProvider = Provider<int>((ref) {
  final employees = ref.watch(mutableEmployeeListProvider) ?? [];
  return employees.length;
});

// Loading states for role updates
final isUpdatingRoleProvider = StateProvider<bool>((ref) => false);

// Error handling
final employeeErrorProvider = StateProvider<String?>((ref) => null);

// Sort options
enum SortOption {
  nameAsc,
  nameDesc,
  salaryAsc,
  salaryDesc,
  departmentAsc,
  departmentDesc,
}

final sortOptionProvider = StateProvider<SortOption>((ref) => SortOption.nameAsc);

// Sorted employees provider
final sortedEmployeesProvider = Provider<List<EmployeeSalary>>((ref) {
  final employees = ref.watch(combinedFilteredEmployeesProvider);
  final sortOption = ref.watch(sortOptionProvider);
  
  final sortedList = [...employees];
  
  switch (sortOption) {
    case SortOption.nameAsc:
      sortedList.sort((a, b) => a.fullName.compareTo(b.fullName));
      break;
    case SortOption.nameDesc:
      sortedList.sort((a, b) => b.fullName.compareTo(a.fullName));
      break;
    case SortOption.salaryAsc:
      sortedList.sort((a, b) => a.salaryAmount.compareTo(b.salaryAmount));
      break;
    case SortOption.salaryDesc:
      sortedList.sort((a, b) => b.salaryAmount.compareTo(a.salaryAmount));
      break;
    case SortOption.departmentAsc:
      sortedList.sort((a, b) => a.displayDepartment.compareTo(b.displayDepartment));
      break;
    case SortOption.departmentDesc:
      sortedList.sort((a, b) => b.displayDepartment.compareTo(a.displayDepartment));
      break;
  }
  
  return sortedList;
});

// Performance metrics
final performanceMetricsProvider = Provider<Map<String, int>>((ref) {
  final employees = ref.watch(mutableEmployeeListProvider) ?? [];
  final metrics = <String, int>{
    'A+': 0,
    'A': 0,
    'B': 0,
    'C': 0,
    'Needs Improvement': 0,
  };
  
  for (final employee in employees) {
    if (employee.performanceRating != null) {
      metrics[employee.performanceRating!] = 
          (metrics[employee.performanceRating!] ?? 0) + 1;
    }
  }
  
  return metrics;
});

// Salary statistics
final salaryStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final employees = ref.watch(mutableEmployeeListProvider) ?? [];
  
  if (employees.isEmpty) {
    return {
      'average': 0.0,
      'min': 0.0,
      'max': 0.0,
      'total': 0.0,
    };
  }
  
  final salaries = employees.map((e) => e.salaryAmount).toList();
  salaries.sort();
  
  final total = salaries.reduce((a, b) => a + b);
  final average = total / salaries.length;
  
  return {
    'average': average,
    'min': salaries.first,
    'max': salaries.last,
    'total': total,
  };
});

// Department statistics
final departmentStatisticsProvider = Provider<Map<String, Map<String, dynamic>>>((ref) {
  final employees = ref.watch(mutableEmployeeListProvider) ?? [];
  final stats = <String, Map<String, dynamic>>{};
  
  for (final employee in employees) {
    final dept = employee.displayDepartment;
    if (!stats.containsKey(dept)) {
      stats[dept] = {
        'count': 0,
        'totalSalary': 0.0,
        'averageSalary': 0.0,
      };
    }
    
    stats[dept]!['count'] = (stats[dept]!['count'] as int) + 1;
    stats[dept]!['totalSalary'] = 
        (stats[dept]!['totalSalary'] as double) + employee.salaryAmount;
  }
  
  // Calculate averages
  stats.forEach((dept, data) {
    data['averageSalary'] = 
        (data['totalSalary'] as double) / (data['count'] as int);
  });
  
  return stats;
});

// Helper function to update employee in list
void updateEmployeeInList(
  WidgetRef ref,
  EmployeeSalary original,
  EmployeeSalary updated,
) {
  final currentList = ref.read(mutableEmployeeListProvider);
  if (currentList != null) {
    final updatedList = currentList.map((emp) {
      if (emp.salaryId == original.salaryId) {
        return updated;
      }
      return emp;
    }).toList();
    
    ref.read(mutableEmployeeListProvider.notifier).state = updatedList;
  }
}

// Extension for EmployeeSalary
extension EmployeeSalaryExtension on EmployeeSalary {
  EmployeeSalary copyWith({
    String? salaryId,
    String? userId,
    String? fullName,
    String? email,
    String? profileImage,
    String? roleName,
    String? companyId,
    String? storeId,
    double? salaryAmount,
    String? salaryType,
    String? currencyId,
    String? currencyName,
    String? symbol,
    DateTime? effectiveDate,
    bool? isActive,
    DateTime? updatedAt,
    String? employeeId,
    String? department,
    DateTime? hireDate,
    String? workLocation,
    String? employmentType,
    String? employmentStatus,
    String? costCenter,
    String? managerName,
    String? performanceRating,
    DateTime? lastReviewDate,
    DateTime? nextReviewDate,
    double? previousSalary,
  }) {
    return EmployeeSalary(
      salaryId: salaryId ?? this.salaryId,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      roleName: roleName ?? this.roleName,
      companyId: companyId ?? this.companyId,
      storeId: storeId ?? this.storeId,
      salaryAmount: salaryAmount ?? this.salaryAmount,
      salaryType: salaryType ?? this.salaryType,
      currencyId: currencyId ?? this.currencyId,
      currencyName: currencyName ?? this.currencyName,
      symbol: symbol ?? this.symbol,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
      employeeId: employeeId ?? this.employeeId,
      department: department ?? this.department,
      hireDate: hireDate ?? this.hireDate,
      workLocation: workLocation ?? this.workLocation,
      employmentType: employmentType ?? this.employmentType,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      costCenter: costCenter ?? this.costCenter,
      managerName: managerName ?? this.managerName,
      performanceRating: performanceRating ?? this.performanceRating,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      previousSalary: previousSalary ?? this.previousSalary,
    );
  }
}