import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/employee_salary.dart';
import '../models/currency_type.dart';
import '../models/role.dart';
import '../services/salary_service.dart';
import '../services/role_service.dart';
import '../../../providers/app_state_provider.dart';

// Salary Service Provider
final salaryServiceProvider = Provider<SalaryService>((ref) {
  final supabase = Supabase.instance.client;
  return SalaryService(supabase);
});

// Role Service Provider
final roleServiceProvider = Provider<RoleService>((ref) {
  final supabase = Supabase.instance.client;
  return RoleService(supabase);
});

// Employee Salary List Provider
final employeeSalaryListProvider = FutureProvider<List<EmployeeSalary>>((ref) async {
  try {
    final service = ref.read(salaryServiceProvider);
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      return [];
    }
    
    final result = await service.getEmployeeSalaries(companyId);
    return result;
  } catch (e) {
    rethrow;
  }
});

// Currency Types Provider
final currencyTypesProvider = FutureProvider<List<CurrencyType>>((ref) async {
  try {
    final service = ref.read(salaryServiceProvider);
    return await service.getCurrencyTypes();
  } catch (e) {
    // Return default currencies on error (matching actual Supabase data)
    return [
      CurrencyType(currencyCode: 'USD', currencyName: 'US Dollar', symbol: '\$'),
      CurrencyType(currencyCode: 'EUR', currencyName: 'Euro', symbol: '€'),
      CurrencyType(currencyCode: 'VND', currencyName: 'Vietnamese Dong', symbol: '₫'),
      CurrencyType(currencyCode: 'KRW', currencyName: 'Korean Won', symbol: '₩'),
    ];
  }
});

// Search Query Provider
final employeeSearchQueryProvider = StateProvider<String>((ref) => '');

// Department Filter Provider
final selectedDepartmentProvider = StateProvider<String>((ref) => 'All');

// Sort Option Provider - tracks both field and direction
final employeeSortOptionProvider = StateProvider<String?>((ref) => 'name');

// Sort Direction Provider - true for ascending, false for descending
final employeeSortDirectionProvider = StateProvider<bool>((ref) => true);

// Filter Providers for centralized state management
final selectedRoleFilterProvider = StateProvider<String?>((ref) => null);
final selectedDepartmentFilterProvider = StateProvider<String?>((ref) => null);
final selectedSalaryTypeFilterProvider = StateProvider<String?>((ref) => null);

// Filtered and Sorted Employees Provider
final filteredEmployeesProvider = Provider<AsyncValue<List<EmployeeSalary>>>((ref) {
  final searchQuery = ref.watch(employeeSearchQueryProvider);
  final sortOption = ref.watch(employeeSortOptionProvider);
  final sortAscending = ref.watch(employeeSortDirectionProvider);
  final mutableEmployees = ref.watch(mutableEmployeeListProvider);
  final employeesAsync = ref.watch(employeeSalaryListProvider);
  
  List<EmployeeSalary> _processEmployees(List<EmployeeSalary> employees) {
    // Filter employees based on search query
    List<EmployeeSalary> filtered;
    if (searchQuery.isEmpty) {
      filtered = employees;
    } else {
      final query = searchQuery.toLowerCase();
      filtered = employees.where((employee) {
        return employee.fullName.toLowerCase().contains(query) ||
               employee.email.toLowerCase().contains(query) ||
               (employee.roleName?.toLowerCase().contains(query) ?? false) ||
               employee.displayDepartment.toLowerCase().contains(query);
      }).toList();
    }
    
    // Sort employees based on selected option and direction
    switch (sortOption) {
      case 'name':
        filtered.sort((a, b) {
          final comparison = a.fullName.compareTo(b.fullName);
          return sortAscending ? comparison : -comparison;
        });
        break;
      case 'salary':
        filtered.sort((a, b) {
          final comparison = a.salaryAmount.compareTo(b.salaryAmount);
          // For salary, default to high-to-low (descending)
          return sortAscending ? -comparison : comparison;
        });
        break;
      case 'role':
        filtered.sort((a, b) {
          final aRole = a.roleName ?? 'Employee';
          final bRole = b.roleName ?? 'Employee';
          final comparison = aRole.compareTo(bRole);
          return sortAscending ? comparison : -comparison;
        });
        break;
      case 'recent':
        filtered.sort((a, b) {
          final comparison = (a.updatedAt ?? DateTime.now()).compareTo(b.updatedAt ?? DateTime.now());
          // For recent, default to newest first (descending)
          return sortAscending ? comparison : -comparison;
        });
        break;
    }
    
    return filtered;
  }
  
  // Use mutable list if available, otherwise use the async provider
  if (mutableEmployees != null) {
    return AsyncData(_processEmployees(mutableEmployees));
  }
  
  return employeesAsync.when(
    data: (employees) {
      // Also populate the mutable list for future updates
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mutableEmployeeListProvider.notifier).state = employees;
      });
      
      return AsyncData(_processEmployees(employees));
    },
    loading: () => const AsyncLoading(),
    error: (error, stack) => AsyncError(error, stack),
  );
});

// Selected Employee Provider
final selectedEmployeeProvider = StateProvider<EmployeeSalary?>((ref) => null);

// Mutable Employee List Provider for instant updates
final mutableEmployeeListProvider = StateProvider<List<EmployeeSalary>?>((ref) => null);

// Loading State Provider
final isUpdatingSalaryProvider = StateProvider<bool>((ref) => false);

// Real-time Updates Provider
final salaryUpdatesStreamProvider = StreamProvider<List<EmployeeSalary>>((ref) {
  try {
    final service = ref.read(salaryServiceProvider);
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      return Stream.value([]);
    }
    
    return service.watchEmployeeSalaries(companyId);
  } catch (e) {
    return Stream.value([]);
  }
});

// Sync State Provider
final isSyncingProvider = StateProvider<bool>((ref) => false);

// Roles Provider
final rolesProvider = FutureProvider<List<Role>>((ref) async {
  try {
    final service = ref.read(roleServiceProvider);
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      // If no company selected, fetch all global roles
      return await service.getAllRoles();
    }
    
    // Fetch company-specific and global roles
    return await service.getRolesByCompany(companyId);
  } catch (e) {
    rethrow;
  }
});

// Refresh employees
Future<void> refreshEmployees(WidgetRef ref) async {
  ref.invalidate(employeeSalaryListProvider);
  ref.invalidate(currencyTypesProvider);
  ref.invalidate(rolesProvider);
}

// Extension for EmployeeSalary copyWith method
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
    String? month,
    int? totalWorkingDay,
    double? totalWorkingHour,
    double? totalSalary,
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
      month: month ?? this.month,
      totalWorkingDay: totalWorkingDay ?? this.totalWorkingDay,
      totalWorkingHour: totalWorkingHour ?? this.totalWorkingHour,
      totalSalary: totalSalary ?? this.totalSalary,
    );
  }
}