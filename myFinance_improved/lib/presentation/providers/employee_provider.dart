// lib/presentation/providers/employee_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/employee_detail.dart';
import '../../domain/entities/employee_filter.dart';
import '../../data/repositories/employee_repository.dart';
import '../providers/app_state_provider.dart';

// Employee repository provider
final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  final supabase = Supabase.instance.client;
  return EmployeeRepository(supabase: supabase);
});

// Stream provider for real-time employee updates
final employeesStreamProvider = StreamProvider<List<EmployeeDetail>>((ref) {
  final repository = ref.watch(employeeRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  
  if (companyId.isEmpty) {
    return Stream.value([]);
  }
  
  return repository.streamEmployees(companyId);
});

// Employee filter state provider
final employeeFilterProvider = StateNotifierProvider<EmployeeFilterNotifier, EmployeeFilter>(
  (ref) => EmployeeFilterNotifier(),
);

class EmployeeFilterNotifier extends StateNotifier<EmployeeFilter> {
  EmployeeFilterNotifier() : super(const EmployeeFilter());

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleActiveOnly(bool value) {
    state = state.copyWith(activeOnly: value);
  }

  void toggleRoleFilter(String roleId) {
    final currentRoles = List<String>.from(state.selectedRoleIds);
    if (currentRoles.contains(roleId)) {
      currentRoles.remove(roleId);
    } else {
      currentRoles.add(roleId);
    }
    state = state.copyWith(selectedRoleIds: currentRoles);
  }
  
  void clearRoleFilters() {
    state = state.copyWith(selectedRoleIds: []);
  }

  void toggleStoreFilter(String storeId) {
    final currentStores = List<String>.from(state.selectedStoreIds);
    if (currentStores.contains(storeId)) {
      currentStores.remove(storeId);
    } else {
      currentStores.add(storeId);
    }
    state = state.copyWith(selectedStoreIds: currentStores);
  }
  
  void clearStoreFilters() {
    state = state.copyWith(selectedStoreIds: []);
  }

  void setSortBy(EmployeeSortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void toggleSortOrder() {
    state = state.copyWith(sortAscending: !state.sortAscending);
  }

  void clearFilters() {
    state = const EmployeeFilter();
  }
}

// Filtered employees provider
final filteredEmployeesProvider = Provider<List<EmployeeDetail>>((ref) {
  final employeesAsync = ref.watch(employeesStreamProvider);
  final filter = ref.watch(employeeFilterProvider);
  
  return employeesAsync.when(
    data: (employees) {
      var filtered = employees;
      
      // Apply search filter
      if (filter.searchQuery.isNotEmpty) {
        final query = filter.searchQuery.toLowerCase();
        filtered = filtered.where((e) =>
          e.fullName.toLowerCase().contains(query) ||
          (e.email?.toLowerCase().contains(query) ?? false) ||
          (e.roleName?.toLowerCase().contains(query) ?? false)
        ).toList();
      }
      
      // Apply role filter
      if (filter.selectedRoleIds.isNotEmpty) {
        filtered = filtered.where((e) => 
          e.roleId != null && filter.selectedRoleIds.contains(e.roleId)
        ).toList();
      }
      
      // Apply store filter
      if (filter.selectedStoreIds.isNotEmpty) {
        filtered = filtered.where((e) => 
          e.storeId != null && filter.selectedStoreIds.contains(e.storeId)
        ).toList();
      }
      
      // Apply sorting
      filtered.sort((a, b) {
        int comparison;
        switch (filter.sortBy) {
          case EmployeeSortBy.name:
            comparison = a.fullName.compareTo(b.fullName);
            break;
          case EmployeeSortBy.role:
            comparison = (a.roleName ?? '').compareTo(b.roleName ?? '');
            break;
          case EmployeeSortBy.salary:
            final aSalary = a.salaryAmount ?? 0;
            final bSalary = b.salaryAmount ?? 0;
            comparison = aSalary.compareTo(bSalary);
            break;
          case EmployeeSortBy.joinDate:
            final aDate = a.createdAt ?? DateTime.now();
            final bDate = b.createdAt ?? DateTime.now();
            comparison = aDate.compareTo(bDate);
            break;
        }
        return filter.sortAscending ? comparison : -comparison;
      });
      
      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Provider for fetching attendance data
final employeeAttendanceProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, userId) async {
    final repository = ref.watch(employeeRepositoryProvider);
    return repository.getEmployeeAttendance(userId);
  },
);

// Provider for fetching currencies
final currenciesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(employeeRepositoryProvider);
  return repository.getCurrencies();
});

// Provider for fetching company roles
final companyRolesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(employeeRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  
  if (companyId.isEmpty) {
    return [];
  }
  
  return repository.getCompanyRoles(companyId);
});

// Provider for fetching company stores
final companyStoresProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(employeeRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  
  if (companyId.isEmpty) {
    return [];
  }
  
  return repository.getCompanyStores(companyId);
});

// Selected employee provider for detail view
final selectedEmployeeProvider = StateProvider<EmployeeDetail?>((ref) => null);

// Legacy Employee class for backward compatibility
class Employee {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String? profileImage;
  final String? roleId;
  final String? roleName;
  final double? salary;
  final String? salaryType;
  final List<String> stores;
  final DateTime createdAt;
  final DateTime updatedAt;

  Employee({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileImage,
    this.roleId,
    this.roleName,
    this.salary,
    this.salaryType,
    required this.stores,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      userId: map['user_id'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profile_image'],
      roleId: map['role_id'],
      roleName: map['role_name'],
      salary: map['salary_amount']?.toDouble(),
      salaryType: map['salary_type'],
      stores: (map['stores'] as List<dynamic>?)
          ?.map((s) => s['store_name'] as String)
          .toList() ?? [],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'profile_image': profileImage,
      'role_id': roleId,
      'role_name': roleName,
      'salary_amount': salary,
      'salary_type': salaryType,
      'stores': stores,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Legacy providers for backward compatibility
final employeesProvider = FutureProvider<List<Employee>>((ref) async {
  final selectedCompany = ref.watch(selectedCompanyProvider);
  
  if (selectedCompany == null) {
    return [];
  }

  final supabase = Supabase.instance.client;
  
  try {
    // First, fetch all users that belong to the selected company
    final userCompaniesResponse = await supabase
        .from('user_companies')
        .select('user_id, users!inner(user_id, first_name, last_name, email, profile_image, created_at, updated_at)')
        .eq('company_id', selectedCompany['company_id'])
        .eq('is_deleted', false);

    final List<Employee> employees = [];
    
    for (final record in userCompaniesResponse as List<dynamic>) {
      final userData = record['users'];
      final userId = userData['user_id'];
      
      // Fetch role for this user
      Map<String, dynamic>? roleData;
      try {
        final roleResponse = await supabase
            .from('user_roles')
            .select('role_id, roles!inner(role_id, role_name)')
            .eq('user_id', userId)
            .eq('is_deleted', false)
            .maybeSingle();
        roleData = roleResponse;
      } catch (e) {
        print('Error fetching role for user $userId: $e');
      }
      
      // Fetch salary for this user
      Map<String, dynamic>? salaryData;
      try {
        final salaryResponse = await supabase
            .from('user_salaries')
            .select('salary_amount, salary_type')
            .eq('user_id', userId)
            .eq('company_id', selectedCompany['company_id'])
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();
        salaryData = salaryResponse;
      } catch (e) {
        print('Error fetching salary for user $userId: $e');
      }
      
      // Fetch stores for this user
      List<String> stores = [];
      try {
        final storesResponse = await supabase
            .from('user_stores')
            .select('stores!inner(store_name)')
            .eq('user_id', userId)
            .eq('is_deleted', false);
        stores = (storesResponse as List<dynamic>)
            .map((s) => s['stores']['store_name'] as String)
            .toList();
      } catch (e) {
        print('Error fetching stores for user $userId: $e');
      }
      
      final employee = Employee(
        userId: userId,
        firstName: userData['first_name'] ?? '',
        lastName: userData['last_name'] ?? '',
        email: userData['email'] ?? '',
        profileImage: userData['profile_image'],
        roleId: roleData?['role_id'],
        roleName: roleData?['roles']?['role_name'],
        salary: salaryData?['salary_amount']?.toDouble(),
        salaryType: salaryData?['salary_type'],
        stores: stores,
        createdAt: DateTime.parse(userData['created_at']),
        updatedAt: DateTime.parse(userData['updated_at']),
      );
      
      employees.add(employee);
    }
    
    return employees;
  } catch (e) {
    print('Error fetching employees: $e');
    throw Exception('Failed to load employees: $e');
  }
});

// Provider to search employees
final employeeSearchProvider = StateProvider<String>((ref) => '');

// Provider for selected role filter
final selectedRoleFilterProvider = StateProvider<String?>((ref) => null);

// Provider for selected store filter
final selectedStoreFilterProvider = StateProvider<String?>((ref) => null);

// Provider for salary range filter
final salaryRangeFilterProvider = StateProvider<(double?, double?)>((ref) => (null, null));

// Combined filtered employees with all filters (for legacy compatibility)
final fullyFilteredEmployeesProvider = Provider<AsyncValue<List<Employee>>>((ref) {
  final employeesAsync = ref.watch(employeesProvider);
  final search = ref.watch(employeeSearchProvider).toLowerCase();
  final selectedRole = ref.watch(selectedRoleFilterProvider);
  final selectedStore = ref.watch(selectedStoreFilterProvider);
  final salaryRange = ref.watch(salaryRangeFilterProvider);
  
  return employeesAsync.when(
    data: (employees) {
      var filtered = employees;
      
      // Apply search filter
      if (search.isNotEmpty) {
        filtered = filtered.where((employee) {
          return employee.fullName.toLowerCase().contains(search) ||
                 employee.email.toLowerCase().contains(search) ||
                 (employee.roleName?.toLowerCase().contains(search) ?? false) ||
                 employee.stores.any((store) => store.toLowerCase().contains(search));
        }).toList();
      }
      
      // Filter by role
      if (selectedRole != null) {
        filtered = filtered.where((e) => e.roleName == selectedRole).toList();
      }
      
      // Filter by store
      if (selectedStore != null) {
        filtered = filtered.where((e) => e.stores.contains(selectedStore)).toList();
      }
      
      // Filter by salary range
      final (minSalary, maxSalary) = salaryRange;
      if (minSalary != null || maxSalary != null) {
        filtered = filtered.where((e) {
          if (e.salary == null) return false;
          if (minSalary != null && e.salary! < minSalary) return false;
          if (maxSalary != null && e.salary! > maxSalary) return false;
          return true;
        }).toList();
      }
      
      return AsyncData(filtered);
    },
    loading: () => const AsyncLoading(),
    error: (error, stack) => AsyncError(error, stack),
  );
});