import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/employee_salary.dart';
import '../models/currency_type.dart';
import '../services/salary_service.dart';
import '../../../providers/app_state_provider.dart';

// Salary Service Provider
final salaryServiceProvider = Provider<SalaryService>((ref) {
  final supabase = Supabase.instance.client;
  return SalaryService(supabase);
});

// Employee Salary List Provider
final employeeSalaryListProvider = FutureProvider<List<EmployeeSalary>>((ref) async {
  try {
    final service = ref.read(salaryServiceProvider);
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      print('Warning: No company selected, returning empty list');
      return [];
    }
    
    final result = await service.getEmployeeSalaries(companyId);
    return result;
  } catch (e) {
    print('Error in employeeSalaryListProvider: $e');
    rethrow;
  }
});

// Currency Types Provider
final currencyTypesProvider = FutureProvider<List<CurrencyType>>((ref) async {
  try {
    final service = ref.read(salaryServiceProvider);
    return await service.getCurrencyTypes();
  } catch (e) {
    print('Error in currencyTypesProvider: $e');
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

// Filtered Employees Provider
final filteredEmployeesProvider = Provider<AsyncValue<List<EmployeeSalary>>>((ref) {
  final searchQuery = ref.watch(employeeSearchQueryProvider);
  final mutableEmployees = ref.watch(mutableEmployeeListProvider);
  final employeesAsync = ref.watch(employeeSalaryListProvider);
  
  // Use mutable list if available, otherwise use the async provider
  if (mutableEmployees != null) {
    if (searchQuery.isEmpty) {
      return AsyncData(mutableEmployees);
    }
    
    final filtered = mutableEmployees.where((employee) {
      final query = searchQuery.toLowerCase();
      return employee.fullName.toLowerCase().contains(query) ||
             employee.roleName.toLowerCase().contains(query);
    }).toList();
    
    return AsyncData(filtered);
  }
  
  return employeesAsync.when(
    data: (employees) {
      // Also populate the mutable list for future updates
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mutableEmployeeListProvider.notifier).state = employees;
      });
      
      if (searchQuery.isEmpty) {
        return AsyncData(employees);
      }
      
      final filtered = employees.where((employee) {
        final query = searchQuery.toLowerCase();
        return employee.fullName.toLowerCase().contains(query) ||
               employee.roleName.toLowerCase().contains(query);
      }).toList();
      
      return AsyncData(filtered);
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
    print('Error in salaryUpdatesStreamProvider: $e');
    return Stream.value([]);
  }
});

// Sync State Provider
final isSyncingProvider = StateProvider<bool>((ref) => false);

// Refresh employees
Future<void> refreshEmployees(WidgetRef ref) async {
  ref.invalidate(employeeSalaryListProvider);
  ref.invalidate(currencyTypesProvider);
}