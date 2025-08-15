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

// Sort Option Provider
final employeeSortOptionProvider = StateProvider<String>((ref) => 'name');

// Filtered and Sorted Employees Provider
final filteredEmployeesProvider = Provider<AsyncValue<List<EmployeeSalary>>>((ref) {
  final searchQuery = ref.watch(employeeSearchQueryProvider);
  final sortOption = ref.watch(employeeSortOptionProvider);
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
    
    // Sort employees based on selected option
    switch (sortOption) {
      case 'name':
        filtered.sort((a, b) => a.fullName.compareTo(b.fullName));
        break;
      case 'salary':
        filtered.sort((a, b) => b.salaryAmount.compareTo(a.salaryAmount));
        break;
      case 'role':
        filtered.sort((a, b) {
          final aRole = a.roleName ?? 'Employee';
          final bRole = b.roleName ?? 'Employee';
          return aRole.compareTo(bRole);
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