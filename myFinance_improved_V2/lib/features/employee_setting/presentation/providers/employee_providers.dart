import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/datasources/employee_remote_datasource.dart';
import '../../data/datasources/role_remote_datasource.dart';
import '../../data/repositories/employee_repository_impl.dart';
import '../../data/repositories/role_repository_impl.dart';
import '../../domain/entities/currency_type.dart';
import '../../domain/entities/employee_salary.dart';
import '../../domain/entities/role.dart';
import '../../domain/repositories/employee_repository.dart';
import '../../domain/repositories/role_repository.dart';
import 'employee_notifier.dart';
import 'states/employee_state.dart';

// ============================================================================
// Data Source Providers
// ============================================================================

final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final _employeeRemoteDataSourceProvider = Provider<EmployeeRemoteDataSource>((ref) {
  final supabase = ref.watch(_supabaseClientProvider);
  return EmployeeRemoteDataSource(supabase);
});

final _roleRemoteDataSourceProvider = Provider<RoleRemoteDataSource>((ref) {
  final supabase = ref.watch(_supabaseClientProvider);
  return RoleRemoteDataSource(supabase);
});

// ============================================================================
// Repository Providers
// ============================================================================

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  final dataSource = ref.watch(_employeeRemoteDataSourceProvider);
  return EmployeeRepositoryImpl(dataSource);
});

final roleRepositoryProvider = Provider<RoleRepository>((ref) {
  final dataSource = ref.watch(_roleRemoteDataSourceProvider);
  return RoleRepositoryImpl(dataSource);
});

// ============================================================================
// Employee Data Providers
// ============================================================================

/// Employee Salary List Provider
final employeeSalaryListProvider = FutureProvider.autoDispose<List<EmployeeSalary>>((ref) async {
  try {
    final repository = ref.read(employeeRepositoryProvider);
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      return [];
    }

    final result = await repository.getEmployeeSalaries(companyId);
    return result;
  } catch (e) {
    rethrow;
  }
});

/// Currency Types Provider
final currencyTypesProvider = FutureProvider.autoDispose<List<CurrencyType>>((ref) async {
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
});

// ============================================================================
// UI State Providers
// ============================================================================

/// Search Query Provider
final employeeSearchQueryProvider = StateProvider<String>((ref) => '');

/// Sort Option Provider - tracks both field and direction
final employeeSortOptionProvider = StateProvider<String?>((ref) => 'name');

/// Sort Direction Provider - true for ascending, false for descending
final employeeSortDirectionProvider = StateProvider<bool>((ref) => true);

/// Filter Providers for centralized state management
final selectedRoleFilterProvider = StateProvider<String?>((ref) => null);
final selectedDepartmentFilterProvider = StateProvider<String?>((ref) => null);
final selectedSalaryTypeFilterProvider = StateProvider<String?>((ref) => null);

/// Mutable Employee List Provider for instant updates
final mutableEmployeeListProvider = StateProvider<List<EmployeeSalary>?>((ref) => null);

/// Loading State Provider
final isUpdatingSalaryProvider = StateProvider<bool>((ref) => false);

/// Sync State Provider
final isSyncingProvider = StateProvider<bool>((ref) => false);

/// Selected Employee Provider
final selectedEmployeeProvider = StateProvider<EmployeeSalary?>((ref) => null);

// ============================================================================
// Filtered and Sorted Employees Provider
// ============================================================================

final filteredEmployeesProvider = Provider.autoDispose<AsyncValue<List<EmployeeSalary>>>((ref) {
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
            (employee.roleName.toLowerCase().contains(query)) ||
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
          final aRole = a.roleName;
          final bRole = b.roleName;
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

// ============================================================================
// Real-time Updates Provider
// ============================================================================

final salaryUpdatesStreamProvider = StreamProvider<List<EmployeeSalary>>((ref) {
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
});

// ============================================================================
// Roles Providers
// ============================================================================

final rolesProvider = FutureProvider.autoDispose<List<Role>>((ref) async {
  try {
    final repository = ref.read(roleRepositoryProvider);
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      // If no company selected, fetch all global roles
      return await repository.getAllRoles();
    }

    // Fetch company-specific and global roles
    return await repository.getRolesByCompany(companyId);
  } catch (e) {
    rethrow;
  }
});

// ============================================================================
// ✅ NEW STANDARD: StateNotifier Pattern (Following transaction_template)
// ============================================================================

/// Employee State Provider - 메인 직원 상태 관리
///
/// ✅ This is the new standard pattern using Freezed State + StateNotifier
/// Use this provider for new code instead of individual StateProviders above
final employeeProvider = StateNotifierProvider<EmployeeNotifier, EmployeeState>((ref) {
  return EmployeeNotifier(
    repository: ref.read(employeeRepositoryProvider),
  );
});

// ============================================================================
// Helper Functions
// ============================================================================

/// Refresh employees
Future<void> refreshEmployees(WidgetRef ref) async {
  ref.invalidate(employeeSalaryListProvider);
  ref.invalidate(currencyTypesProvider);
  ref.invalidate(rolesProvider);
}
